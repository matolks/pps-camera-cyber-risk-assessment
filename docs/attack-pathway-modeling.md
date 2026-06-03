# Attack Pathway Modeling

The analysis considered five attack pathways commonly used in nuclear cybersecurity work:

1. **Wired**
2. **Wireless**
3. **Portable Media and Mobile Devices (PMMD)**
4. **Supply Chain**
5. **Insider**

These pathways helped frame how an adversary could reach, manipulate, or degrade the Physical Protection System (PPS) camera environment.

## Attack Pathways Considered

| Pathway      | Description                                                                                                          | Project Relevance                                                                                     |
| ------------ | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Wired        | An attacker gains physical access to the internal Ethernet network.                                                  | The cameras, NVR, and switch communicate over a local wired network.                                  |
| Wireless     | An attacker gains unauthorized access through wireless proximity or wireless infrastructure.                         | Wireless access points or nearby wireless access could expose the camera system.                      |
| PMMD         | Malicious software is introduced through portable media or mobile devices connected to the NVR or network equipment. | Removable media and maintenance devices can become entry points into otherwise isolated environments. |
| Supply Chain | Hardware, firmware, or software is compromised during manufacturing, distribution, procurement, or maintenance.      | Embedded camera and NVR devices depend on vendor firmware, hardware integrity, and trusted updates.   |
| Insider      | An authorized employee or contractor misuses legitimate access privileges.                                           | Trusted access can bypass some external network defenses.                                             |

## Pathways Emulated

The lab work focused on the pathways that could be safely tested with the available equipment:

- **Wired access**
- **Wireless access**

The remaining pathways were included in the threat model but were not directly emulated.

## Vulnerabilities and Behaviors Evaluated

The team evaluated known vulnerabilities and configuration risks affecting the Hikvision camera and NVR environment.

Tested areas included:

- CVE-2017-7921 authentication bypass
- CVE-2021-36260 unauthenticated remote command execution
- Unauthorized NVR configuration changes from another same-network device
- Network-accessible configuration interfaces
- Authentication and access-control weaknesses
- Exposure of camera and NVR management interfaces

Exploit details, exact payloads, and device-specific identifiers are not included in this public repository.

## Research Sources

The vulnerability research used:

- CVE records
- National Vulnerability Database (NVD)
- Vendor security advisories
- Public security research
- Public proof-of-concept references, used only for controlled lab validation

## Key Findings

The attack-pathway analysis showed that the PPS camera environment created realistic cyber risk when vulnerable services were reachable from the same network.

Key findings included:

- Known camera and NVR vulnerabilities are publicly documented.
- Some vulnerabilities have public proof-of-concept material available.
- Patches may exist but are not always applied in operational technology environments.
- End-of-life or legacy devices may remain in service because of operational constraints.
- Same-network access can allow direct interaction with camera or NVR management interfaces.
- Unauthorized configuration changes could degrade alarm assessment, motion detection, recording, or video integrity.
- Even if a device is not classified as a CDA, it may still provide a pathway to systems that support SSEP functions.

## Consequence Considerations

Compromise of a PPS camera or NVR could affect physical security operations by:

- Blinding surveillance coverage
- Reducing alarm assessment capability
- Disabling motion detection or alerting features
- Manipulating or redirecting camera views
- Creating false confidence for security operators
- Removing or weakening forensic evidence
- Creating a foothold for lateral movement

For a camera that supports a required security function, these consequences could affect the facility's ability to detect, assess, delay, and respond to unauthorized activity.

## Mitigation Direction

The attack-pathway analysis informed the final protect-and-detect strategy. Since patching was treated as unavailable under the project constraints, the mitigation focused on compensating controls:

- Network segmentation
- Reverse proxy filtering
- Firewall enforcement
- Removal of direct access paths
- Controlled routing between the NVR side and camera side
- Logging and visibility into blocked or suspicious requests

These controls were selected to reduce exposure, limit lateral movement, and prevent known exploit traffic from directly reaching the vulnerable device.
