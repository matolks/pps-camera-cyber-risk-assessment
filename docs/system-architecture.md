# System Architecture

The evaluated Physical Protection System (PPS) camera environment was designed to support security monitoring in a simulated nuclear facility context. The system provided continuous surveillance and allowed operators to observe, assess, and respond to potential security events.

The integrity and availability of this system were important because compromised surveillance data could affect alarm assessment, operator decision-making, and physical security response.

## System Components

The evaluated system contained three primary components:

### IP Cameras

Camera 1: HNC303-MB  
Camera 2: HES-324-MB

![HNC303-MB Camera](diagrams/IP-Camera1.jpg)
![HES-324-MB Camera](diagrams/IP-Camera2.jpg)

### Network Video Recorder (NVR)

![Network Video Recorder](diagrams/NVR.png)

### Power-over-Ethernet Switch

![PoE Switch](diagrams/PoE-Switch.jpg)

## Component Roles

### IP Cameras

The cameras generated the video feeds used for security monitoring. Each camera operated on the local network, had its own IP address, and exposed a web-based management interface for configuration.

The cameras depended on:

- Ethernet connectivity
- Power from the PoE switch
- Network communication with the NVR
- Proper configuration of video, alarm, and access settings

### Network Video Recorder

The Network Video Recorder (NVR) acted as the central operator interface. It received video streams from the cameras, stored recordings, and allowed users to view live or recorded footage.

The NVR also supported configuration of:

- Camera settings
- Recording behavior
- Alarm settings
- Motion detection
- User access controls
- Network parameters

Because the NVR aggregated video and supported system configuration, compromise of the NVR could affect both surveillance visibility and the integrity of the camera environment.

### PoE Switch

The Power-over-Ethernet (PoE) switch connected the system components together. It provided Ethernet communication and power delivery to the cameras.

The switch enabled communication between:

- Camera 1
- Camera 2
- NVR
- Any other device connected to the same local network

## Baseline Network Layout

The original system used a centralized network topology. Both cameras were connected to the PoE switch, and the switch was connected to the NVR.

![Baseline Network Layout](diagrams/Network-Layout.png)

In the baseline design, data transmission occurred on a single subnet. This allowed IP-based communication between devices on the same local network.

This design simplified connectivity and system management, but it also created a security concern: any device with access to the same subnet could potentially communicate directly with the cameras or NVR if proper safeguards were not enforced.

## Data Flow

The cameras captured video footage and transmitted it to the NVR. The NVR stored the recordings and made them available for live viewing, playback, and assessment.

This centralized flow supported operational simplicity, but it also created dependency risk. If an attacker gained access to the camera/NVR network, they could potentially affect:

- Video availability
- Video integrity
- Camera configuration
- Recording behavior
- Alarm and motion-detection settings
- Operator confidence in the displayed feed

## Security Observations

The baseline architecture introduced several security concerns:

- Cameras and the NVR were reachable on the same local subnet.
- Management interfaces were accessible through IP-based communication.
- Direct device-to-device communication increased the attack surface.
- A compromised endpoint on the subnet could attempt to interact with camera or NVR management services.
- The NVR acted as a central dependency for viewing, recording, and configuration.
- Unauthorized configuration changes could affect surveillance and alarm assessment.

## Architecture Risk

The main architectural risk was not only that individual devices had known vulnerabilities. The larger issue was that the flat network design made vulnerable services reachable from the same local network.

An attacker with wired or wireless access to the subnet could potentially interact directly with the cameras or NVR. For a PPS camera supporting security functions, this could degrade the facility's ability to detect, assess, and respond to unauthorized activity.

## Design Implication

Understanding the baseline architecture was necessary before selecting mitigations. Since the original design allowed direct access paths between the NVR, cameras, and any same-subnet device, the final mitigation strategy focused on separating the camera and NVR into different network segments and forcing traffic through a controlled reverse proxy and firewall.

See [`mitigation-strategy.md`](mitigation-strategy.md) for the segmented architecture and compensating controls.
