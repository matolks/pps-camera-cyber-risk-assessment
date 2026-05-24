# Mitigation Strategy

The evaluated Physical Protection System (PPS) camera system contained known vulnerabilities, but patching was treated as unavailable due to operational constraints. This reflects a common issue in operational technology environments where firmware updates may be delayed or restricted because of vendor limitations, safety qualification, system dependencies, change-control requirements, or availability concerns.

Because the vulnerability could not be removed at the device level, the mitigation strategy focused on reducing exposure and enforcing compensating controls around the vulnerable camera.

## Design Goal

The goal was to prevent untrusted or unsafe traffic from reaching the vulnerable camera while preserving normal camera/NVR functionality.

The selected mitigation used:

- Network segmentation
- Reverse proxy filtering
- Firewall enforcement
- Proxy-mediated access between the NVR and camera subnet
- Logging of allowed and blocked requests

## Segmented Architecture

The camera and NVR were separated into two different IPv4 subnets. The addresses below are sanitized private example addresses used only to explain the design:

| Network Segment     | Subnet           | Device      | Example Address | Role                                |
| ------------------- | ---------------- | ----------- | --------------- | ----------------------------------- |
| Camera-side network | `192.168.1.0/24` | Camera      | `192.168.1.101` | Vulnerable PPS camera               |
| Camera-side network | `192.168.1.0/24` | Proxy NIC 1 | `192.168.1.1`   | Proxy interface facing the camera   |
| NVR-side network    | `192.168.2.0/24` | NVR         | `192.168.2.50`  | Video recorder/operator-side device |
| NVR-side network    | `192.168.2.0/24` | Proxy NIC 2 | `192.168.2.1`   | Proxy interface facing the NVR      |

![Segmented Network Layout](diagrams/Segmented-Network-Layout.png)

The proxy VM was dual-homed, meaning it had one network interface connected to the camera-side subnet and another network interface connected to the NVR-side subnet.

```text
Camera-side subnet: 192.168.1.0/24

Camera:      192.168.1.101
Proxy NIC 1: 192.168.1.1

NVR-side subnet: 192.168.2.0/24

NVR:         192.168.2.50
Proxy NIC 2: 192.168.2.1
```

The `.1` addresses were used as proxy-interface addresses for each subnet. On the camera side, `192.168.1.1` represented the proxy interface facing the camera. On the NVR side, `192.168.2.1` represented the proxy interface facing the NVR.

This created two separate network zones instead of one flat network. The camera and NVR were no longer peers on the same local subnet.

## Why Two Subnets Matter

In the baseline architecture, the camera, NVR, and any other connected device could communicate on the same local network. That flat design created a direct path to vulnerable camera services.

The segmented architecture changed the trust boundary:

```text
Before mitigation:

NVR / client device  --->  Camera
Same subnet, direct access possible
```

```text
After mitigation:

NVR / client device  --->  Proxy  --->  Camera
Different subnets, controlled access path
```

The NVR-side network could not directly reach the camera-side network unless traffic was explicitly allowed. This matters because CVE exploitation generally requires network reachability. If an attacker cannot directly reach the vulnerable endpoint, the attack path is reduced.

## Reverse Proxy Role

The reverse proxy acted as an application-layer control point.

The NVR or client sent camera-related HTTP traffic to the proxy on the trusted side of the network:

```text
NVR-side request
192.168.2.50  --->  192.168.2.1:80
```

The proxy inspected the request. If the request was allowed, the proxy opened a separate connection to the camera on the camera-side network:

```text
Proxy-to-camera request
192.168.1.1  --->  192.168.1.101:80
```

This is the core design point: the NVR was not directly talking to the camera. The NVR talked to the proxy, and the proxy talked to the camera.

The reverse proxy enforced application-layer rules, including:

- Allowing normal camera/NVR HTTP traffic
- Blocking unsafe HTTP methods to sensitive management paths
- Blocking suspicious query patterns associated with authentication-bypass behavior
- Blocking restricted stream or snapshot-style endpoints
- Logging allowed and denied requests

The full sanitized Nginx example is provided in:

```text
configs/nginx-camera-proxy.example.conf
```

## Reverse Proxy Filtering Logic

The proxy was configured to block high-risk request patterns before they reached the camera.

At a high level, the filtering logic was:

```text
If request targets a restricted stream/snapshot-style path:
    Block request

If request targets a restricted management/API path and uses an unsafe method:
    Block request

If request contains a suspicious authentication-bypass query pattern:
    Block request

Otherwise:
    Forward allowed traffic to the camera
```

This does not fix the vulnerable firmware. It reduces exposure by preventing known dangerous request patterns from reaching the vulnerable service.

Production deployments should also account for URL encoding, request normalization, alternate HTTP methods, alternate API paths, and non-HTTP protocols.

## Firewall Role

The firewall acted as a network-layer enforcement point.

The firewall’s purpose was to make sure the proxy was the only allowed bridge between the two subnets. The safest policy was default deny.

Conceptually:

```text
Allowed:
NVR ---> Proxy HTTP listener
Proxy ---> Camera HTTP service
Camera ---> Proxy response traffic

Blocked:
NVR ---> Camera direct access
Camera ---> NVR direct access
Unknown device ---> Camera direct access
Camera subnet ---> NVR subnet lateral movement
```

The firewall did not allow general forwarding between the two subnets. If general forwarding were allowed, a device on the NVR-side subnet could bypass the reverse proxy and reach the camera directly.

The full sanitized firewall example is provided in:

```text
configs/firewall-rules.example.sh
```

## Firewall Enforcement Model

The firewall model was designed around three rules of behavior:

1. Permit trusted NVR-side devices to reach the proxy listener.
2. Permit the proxy host to initiate approved traffic to the camera.
3. Drop direct routed traffic between the NVR-side and camera-side networks.

This distinction matters. Reverse proxy traffic is not the same as direct forwarding. The proxy is an application-layer intermediary, not just a router.

In the intended design, direct subnet-to-subnet forwarding remains blocked. The NVR-side device does not get a general route to the camera-side subnet. It only reaches the proxy service.

## Packet Flow Example

A normal allowed request follows this path:

```text
1. NVR sends request to proxy:
   192.168.2.50 ---> 192.168.2.1:80

2. Nginx receives and inspects the request.

3. If allowed, Nginx creates a new request to the camera:
   192.168.1.1 ---> 192.168.1.101:80

4. Camera replies to proxy:
   192.168.1.101 ---> 192.168.1.1

5. Proxy returns the response to the NVR:
   192.168.2.1 ---> 192.168.2.50
```

A blocked exploit-pattern request follows this path:

```text
1. NVR-side device sends suspicious request to proxy:
   192.168.2.x ---> 192.168.2.1:80

2. Nginx checks the method, path, and query string.

3. If the request matches a blocked pattern, Nginx returns 403.

4. The request is not forwarded to the camera.
```

A bypass attempt that tries to reach the camera directly should fail:

```text
1. NVR-side device tries direct camera access:
   192.168.2.x ---> 192.168.1.101

2. Firewall sees routed traffic between subnets.

3. Forwarding policy drops the traffic.

4. The camera never receives the request.
```

## Security Effect

This architecture does not remove the underlying firmware vulnerability. If an attacker gains direct Layer 2 access to the camera-side subnet, the camera may still be vulnerable.

However, the mitigation improves the security posture by:

- Removing direct NVR-to-camera access paths
- Separating the vulnerable camera from the operator/NVR network
- Forcing HTTP traffic through a controlled inspection point
- Blocking known unsafe request patterns before they reach the device
- Limiting lateral movement between network segments
- Reducing the usefulness of same-network access on the NVR side
- Providing logs for attempted access and blocked requests
- Preserving required functionality without patching the camera firmware

## What This Mitigates

This strategy helps mitigate:

- Same-subnet exploitation from the NVR-side network
- Direct access to vulnerable camera management endpoints
- Known authentication-bypass request patterns
- Unsafe management-plane requests
- Some opportunistic scanning and exploitation attempts
- Camera-initiated movement into the NVR-side network

## What This Does Not Fully Mitigate

This strategy does not fully mitigate:

- Direct physical access to the camera-side subnet
- A malicious device plugged into the camera-side switch
- Malware already running on a trusted NVR-side device that can generate allowed-looking traffic
- Misconfigured routing that bypasses the proxy
- Re-enabled direct NAT or port forwarding to the camera
- VLAN leaks or switch misconfiguration
- New exploit techniques that do not match the proxy filtering rules
- Non-HTTP protocols unless they are separately proxied, filtered, or tightly allowed

## Operational Notes

This mitigation should be treated as a compensating control, not a permanent replacement for remediation.

Operational requirements include:

- Verifying that the NVR uses the proxy address, not the camera address
- Confirming that direct routing between the NVR-side and camera-side subnets is blocked
- Reviewing proxy access and error logs
- Testing that normal camera/NVR functions still work
- Updating proxy rules if new exploit patterns are discovered
- Protecting the proxy VM as a critical enforcement point
- Applying firmware remediation when it becomes operationally feasible

If video streaming uses protocols other than HTTP, those protocols must be explicitly considered. For example, RTSP or vendor-specific traffic should not be broadly forwarded between subnets without review. Required non-HTTP traffic should be restricted to specific source addresses, destination addresses, ports, and directions.

## Summary

The final mitigation used defense-in-depth to compensate for the inability to patch the vulnerable device. In the example design, the camera-side network used `192.168.1.0/24`, the NVR-side network used `192.168.2.0/24`, and the proxy VM had one interface on each subnet. These are illustrative private addresses, not raw production configuration values.

The reverse proxy provided application-layer filtering, while the firewall enforced the network boundary. Together, these controls reduced direct exposure to the vulnerable camera, blocked known unsafe request patterns, limited lateral movement, and preserved operational availability.

This approach is appropriate for environments where vulnerable operational technology must remain online, but direct access to the vulnerable asset can be restricted through external controls.
