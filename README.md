# PPS Camera Cyber Risk Assessment

A defensive OT cybersecurity case study on a network-connected Physical Protection System (PPS) camera and compensating controls under a no-patching constraint.

## Overview

This project was completed as a Penn State capstone sponsored by Idaho National Laboratory (INL). The work evaluated cyber risk in a PPS camera environment used for security monitoring in a simulated nuclear facility setting.

The system contained known vulnerabilities, but patching was treated as unavailable because of operational constraints. The main challenge was to assess the risk and design a mitigation strategy that reduced exploitability without disrupting camera availability.

The project focused on asset classification, vulnerability analysis, attack-pathway modeling, and compensating-control design for operational technology (OT) environments.

## System Evaluated

The evaluated PPS camera environment included:

- Two IP cameras
- A Network Video Recorder (NVR)
- A Power-over-Ethernet (PoE) switch
- Local network communication between the cameras and NVR

The cameras produced video feeds used for surveillance and alarm assessment. The NVR stored footage, provided operator viewing capability, and allowed configuration of camera and alarm settings. The PoE switch provided network connectivity and power to the cameras.

## Objectives

The project objectives were to:

- Determine whether the PPS camera qualified as a Critical Digital Asset (CDA)
- Characterize the camera, NVR, and baseline network architecture
- Assess known vulnerabilities, including CVE-2017-7921 and CVE-2021-36260
- Model realistic attack pathways, with lab focus on wired and wireless access
- Design mitigations under a no-patching constraint
- Validate a segmented, proxy-enforced network strategy

## Approach

### System Classification

The PPS camera system was evaluated using nuclear cybersecurity criteria from 10 CFR 73.54, NEI 10-04, NEI 08-09, and RG 5.71. The analysis focused on whether compromise or manipulation of the camera system could adversely affect Safety, Security, or Emergency Preparedness (SSEP) functions.

### Asset Characterization

The project documented the system architecture, component roles, communication paths, and operational dependencies of the camera/NVR environment.

### Requirements and Constraints

The assessment used nuclear cybersecurity and OT security guidance, including 10 CFR 73.54, 10 CFR 73.55, NEI 10-04, NEI 08-09, NIST SP 800-82, and RG 5.71.

A key constraint was that patching was not permitted. The system had to remain available while risk was reduced through compensating controls.

### Vulnerability Analysis

The project reviewed CVE records, vendor advisories, and public vulnerability information. The analysis focused on:

- CVE-2017-7921: authentication bypass
- CVE-2021-36260: command injection
- Same-network configuration risk
- Authentication and credential weaknesses
- Cryptographic weaknesses
- Exposed management interfaces

Exploit code, exact payloads, credentials, packet captures, real IP addresses, and device-specific identifiers are excluded from this public repository.

### Attack Pathway Modeling

The broader threat model considered five pathways:

- Wired
- Wireless
- Portable Media and Mobile Devices (PMMD)
- Supply Chain
- Insider

The lab focused on pathways that could be safely emulated with the available equipment: wired and wireless access.

### Mitigation Design

The selected mitigation used a segmented, proxy-enforced network architecture. The camera and NVR were placed on separate network segments. HTTP traffic was forced through a reverse proxy, while direct subnet-to-subnet forwarding was blocked by firewall rules.

The mitigation used:

- Network segmentation
- Reverse proxy filtering
- Firewall enforcement
- Proxy-mediated access between the NVR side and camera side
- Logging of allowed and blocked requests

## Key Findings

The CDA analysis found that the Owner-Controlled Area (OCA) perimeter camera qualified as a CDA because it supported surveillance and alarm assessment for the area it covered. The second camera, located inside the Protected Area (PA), was not classified as a CDA under the project assumptions because it provided supplemental interior surveillance rather than monitoring a required security-significant area.

The vulnerability analysis found that CVE-2017-7921 could be validated in the controlled lab environment and created an authentication-bypass risk. CVE-2021-36260 was applicable by firmware range but was not successfully exploited under the tested configuration.

The assessment showed that vulnerabilities in a PPS camera system can affect more than confidentiality. They can degrade video integrity, alarm assessment, operator trust, forensic evidence, and response timing.

## Mitigation Outcome

The final mitigation reduced risk by removing direct access paths to the vulnerable camera and forcing traffic through a controlled inspection point.

The segmented architecture:

- Reduced direct exposure of the vulnerable device
- Blocked tested unsafe request patterns before they reached the camera
- Preserved normal camera/NVR functionality
- Limited lateral movement opportunities
- Provided visibility into suspicious access attempts

This did not remove the underlying firmware vulnerability. It showed how layered compensating controls can reduce risk when immediate patching is not operationally feasible.

## Repository Contents

```text
docs/
  problem-statement.md
  system-architecture.md
  cda-determination.md
  attack-pathway-modeling.md
  vulnerability-analysis.md
  mitigation-strategy.md
  results-and-limitations.md
  references.md

configs/
  nginx-camera-proxy.example.conf
  firewall-rules.example.sh

diagrams/
  sanitized architecture and CDA determination diagrams
```

## Public Disclosure Note

This repository is a sanitized public case study. It does not include exploit code, exact payloads, credentials, packet captures, real IP addresses, serial numbers, device-specific identifiers, or raw lab configurations.

The purpose of this repository is to document defensive analysis, risk-informed decision-making, and compensating-control design for an unpatched OT security asset.

## License

MIT License.
