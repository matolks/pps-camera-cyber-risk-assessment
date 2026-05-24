# Critical Digital Asset Determination

Critical Digital Asset (CDA) determination is consequence-driven, not vulnerability-driven. A device does not become a CDA simply because it has a known vulnerability. It becomes a CDA when its compromise could adversely affect Safety, Security, Emergency Preparedness (SSEP), or related support functions.

![CDA Determination Flow](diagrams/CDA-determination-flow.png)

## SSEP Functions

SSEP refers to Safety, Security, and Emergency Preparedness functions.

### Safety

Safety functions protect the nuclear plant from conditions that could lead to radiological release.

Examples include digital systems that:

- Support reactor protection and engineered safety features
- Monitor or control safety-related systems

### Security

Security functions protect the facility from intentional adversary actions.

Examples include digital systems that:

- Support detection, alarm assessment, delay, and response
- Provide surveillance and monitoring
- Support Physical Protection System (PPS) functions

### Emergency Preparedness

Emergency Preparedness functions help protect workers and the public after an event.

Examples include digital systems that:

- Support emergency classification
- Coordinate protective actions
- Support emergency communication and response

## CDA Evaluation Criteria

The project applied a consequence-based CDA determination process aligned with 10 CFR 73.54, NEI 10-04, and Regulatory Guide 5.71.

The key questions were:

1. Does the asset perform or support an SSEP function?
2. If compromised, could the asset adversely affect an SSEP function?
3. Is the asset a digital component of a critical system?

These questions were not treated as a simple checklist. The final determination depended on the asset's function, location, connectivity, and consequence of compromise. Being connected to a critical system can increase concern, but CDA classification still requires a credible adverse impact to an SSEP function.

## System Assumptions

The evaluated system included two network-connected PPS cameras, a Network Video Recorder (NVR), and a Power-over-Ethernet (PoE) switch.

### Camera 1

- Located in the Owner-Controlled Area (OCA)
- Facing a perimeter area
- Only camera covering that area
- Supports surveillance and alarm assessment functions

### Camera 2

- Located inside the Protected Area (PA)
- Not facing the PA barrier
- Not assumed to monitor Vital Area boundaries, Target Set equipment, or Critical Interruption Points
- Provides supplemental interior surveillance

## Camera 1: OCA Perimeter Camera

Camera 1 was determined to be a CDA.

Camera 1 supports a mandatory security function by providing continuous surveillance of the Owner-Controlled Area. Under 10 CFR 73.55(i), licensees must maintain detection and assessment capabilities that support the effective implementation of the protective strategy.

Camera 1 also supports alarm assessment by providing real-time and recorded video of detected activity. If this camera were disabled, manipulated, or made unavailable, the facility would lose required surveillance coverage for that area.

### Impact of Compromise

Compromise of Camera 1 could:

- Create a surveillance gap in the OCA
- Prevent detection of unauthorized persons
- Degrade alarm assessment capability
- Delay security response
- Require compensatory measures, such as additional patrols or alternative surveillance
- Allow an adversary to approach the Protected Area with reduced chance of detection

### CDA Determination

| Question                                | Determination | Reason                                                      |
| --------------------------------------- | ------------- | ----------------------------------------------------------- |
| Performs or supports an SSEP function?  | Yes           | Provides required OCA surveillance                          |
| Could compromise adversely affect SSEP? | Yes           | Loss or manipulation would degrade detection and assessment |
| Digital component of a critical system? | Yes           | Part of the PPS assessment system                           |

**Conclusion:** Camera 1 is a CDA because its compromise could adversely affect required security monitoring and alarm assessment functions.

## Camera 2: Interior Protected Area Camera

Camera 2 was not determined to be a CDA under the project assumptions.

Although Camera 2 is part of the broader assessment system, its specific function is supplemental interior surveillance. The project assumptions state that it does not monitor the Protected Area barrier, Vital Area boundaries, Target Set equipment, or Critical Interruption Points.

Regulatory requirements emphasize detection and monitoring of protected area barriers and other security-significant locations. A general-purpose interior camera may improve situational awareness, but that does not automatically make it a CDA unless its specific function is required for SSEP performance.

### Impact of Compromise

Compromise of Camera 2 could:

- Reduce interior visibility
- Decrease defense-in-depth
- Remove supplemental recorded footage
- Potentially assist adversary activity inside the PA

However, under the stated assumptions, its compromise would not directly degrade a required SSEP surveillance function.

### CDA Determination

| Question                                | Determination                 | Reason                                                                                            |
| --------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------- |
| Performs or supports an SSEP function?  | No                            | Provides supplemental PA surveillance, not required PA barrier monitoring                         |
| Could compromise adversely affect SSEP? | No, under current assumptions | Does not monitor required security-significant areas                                              |
| Digital component of a critical system? | Yes                           | Part of the PPS assessment system, but its specific function is not required for SSEP performance |

**Conclusion:** Camera 2 is not a CDA under the current assumptions because it does not perform or support a mandatory SSEP function.

## Important Caveats

Camera 2 would need to be reclassified as a CDA if any of the following conditions apply:

- It monitors a Vital Area boundary
- It monitors Target Set equipment
- It monitors a Critical Interruption Point
- It is required by the documented Protective Strategy
- It is required by the Physical Security Plan
- It supports a license condition or formal regulatory commitment
- Its loss would require compensatory measures

This distinction matters because CDA classification depends on function and consequence, not simply location, device type, or known vulnerabilities.

## Summary

| Asset    | Location                | Function                                             | CDA Status |
| -------- | ----------------------- | ---------------------------------------------------- | ---------- |
| Camera 1 | Owner-Controlled Area   | Required perimeter surveillance and alarm assessment | CDA        |
| Camera 2 | Protected Area interior | Supplemental surveillance under current assumptions  | Not a CDA  |

Camera 1 was classified as a CDA because its compromise could directly degrade required security surveillance and alarm assessment. Camera 2 was not classified as a CDA because, under the project assumptions, it does not monitor a required security-significant area. This determination would change if Camera 2 were tied to Vital Area monitoring, Target Set protection, Critical Interruption Points, or the formal protective strategy.
