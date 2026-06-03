# Results and Limitations

## Constraints and Limitations

### No Patching Permitted

No manufacturer patches or firmware updates were applied during the assessment. This constraint represented a common issue in nuclear operational technology (OT) environments, where long equipment lifecycles and strict change-control processes can delay routine patching.

OT systems may remain behind current patch levels because of:

- Qualification requirements
- Vendor support limitations
- Safety or availability concerns
- System dependencies
- Risk-averse change management

### Isolated Laboratory Environment

All testing was performed in an isolated lab environment with no connection to operational nuclear systems. Exploit demonstrations were limited to controlled proof-of-concept testing intended to show impact without damaging equipment, creating persistent compromise, or disrupting operations.

### Regulatory Framework Focus

CDA determinations and security analysis were performed in a nuclear cybersecurity context using NRC regulations and guidance, including:

- 10 CFR 73.54
- 10 CFR 73.55
- NEI 10-04
- Regulatory Guide 5.71
- NUREG/CR-7141

Findings may not translate directly to non-nuclear critical infrastructure environments because other sectors use different regulatory requirements, asset classifications, and risk models.

### Equipment Scope

The technical analysis focused on Hikvision NVR and IP camera systems as representative examples of network-connected surveillance technology. Specific vulnerability findings may not apply to other manufacturers, firmware versions, or deployment configurations.

The broader lessons around asset characterization, network exposure, and compensating controls still apply to similar OT and physical security environments.

### Out of Scope

The following areas were outside the project scope:

- Full network infrastructure penetration testing
- Non-surveillance security systems
- Complete compensatory-measure assessment
- Full cybersecurity program documentation beyond CDA determination and mitigation design
- Production deployment or validation in an operational nuclear facility

## Results

The project completed a hands-on cybersecurity assessment of a Physical Protection System (PPS) camera environment.

The assessment produced several results:

- Applied a consequence-driven CDA determination process
- Distinguished between security-critical and supplemental surveillance assets
- Validated known vulnerability impact in a controlled lab setting
- Modeled realistic attack pathways against the camera/NVR environment
- Designed compensating controls under a no-patching constraint
- Demonstrated that network-level controls can reduce exposure while preserving required functionality

## CDA Determination Result

The CDA analysis showed that asset classification depends on function and consequence, not device type, location, or vulnerability status alone.

The Owner-Controlled Area (OCA) perimeter camera was classified as a CDA because it supported surveillance and alarm assessment for the area it covered. Its compromise could reduce the facility's ability to detect and assess unauthorized activity before an adversary reached the Protected Area.

The interior Protected Area camera was not classified as a CDA under the project assumptions because it provided supplemental surveillance rather than monitoring a required security-significant area. This conclusion would change if the camera monitored a Vital Area boundary, Target Set equipment, Critical Interruption Point, or another function credited by the protective strategy.

## Vulnerability Analysis Result

The technical evaluation showed risk in legacy camera and NVR firmware.

CVE-2017-7921 was successfully validated in the controlled lab environment. The test showed that authentication controls could be bypassed under vulnerable conditions, creating risk to camera and NVR configuration integrity.

CVE-2021-36260 was applicable by firmware range but was not successfully exploited under the tested configuration. This still mattered because firmware differences, configuration changes, or deployment conditions could affect exploitability.

The analysis also identified weakness categories across:

- Authentication
- Credential handling
- Cryptography
- Transport security
- Access control
- Input validation
- System configuration

The main concern was not one vulnerability by itself. The larger issue was that multiple weaknesses could compound, creating realistic paths to degrade video integrity, alarm assessment, and operator trust.

## Mitigation Result

Because patching was treated as unavailable, the project used a defense-in-depth mitigation strategy built around:

- Network segmentation
- Reverse proxy filtering
- Firewall enforcement
- Controlled routing between the NVR side and camera side
- Logging of blocked or suspicious requests

This architecture reduced direct access to the camera and forced traffic through a controlled inspection point. Known unsafe request patterns could be blocked before reaching the vulnerable device.

The mitigation did not remove the underlying firmware vulnerability. It reduced exposure and made the vulnerable service harder to reach or abuse from the NVR-side network.

## Security Impact

The mitigation improved the system by:

- Removing direct access paths to the vulnerable camera
- Reducing reachable attack surface
- Blocking tested malicious request patterns
- Preserving normal camera/NVR functionality
- Limiting lateral movement opportunities
- Providing visibility into suspicious access attempts

This showed that compensating controls can reduce risk when immediate patching is not available.

## Remaining Limitations

The implemented mitigation reduced exposure, but it did not eliminate all risk.

Remaining limitations include:

- The vulnerable firmware remained on the device.
- Direct access to the camera-side subnet could still bypass the proxy.
- Misconfigured routing, NAT, or firewall rules could reintroduce direct access.
- New exploit techniques may require updated filtering rules.
- The proxy became a critical enforcement point that must be secured and monitored.
- Non-HTTP protocols require separate review and filtering.
- The architecture was validated in a lab, not in a production nuclear facility.

## Conclusion

This project assessed a Physical Protection System camera environment using a nuclear cybersecurity framework. The work included Critical Digital Asset determination, vulnerability analysis, attack pathway modeling, and mitigation design under a no-patching constraint.

By applying 10 CFR 73.54 and NEI 10-04, the project used a consequence-driven method for asset classification. The findings showed that a perimeter-facing camera can qualify as a CDA when it supports surveillance and alarm assessment, while an interior camera may remain supplemental if it does not support a required SSEP function.

The technical evaluation showed that legacy firmware can create real risk in network-connected physical security systems. CVE-2017-7921 demonstrated the impact of authentication-bypass vulnerabilities, while CVE-2021-36260 showed why configuration-dependent vulnerabilities still matter even when exploitation is not successful in one lab setup.

Because nuclear operational constraints may prevent immediate patching, the project used a layered compensating-control approach. Network segmentation, reverse proxy filtering, and firewall enforcement reduced direct exposure while preserving camera/NVR functionality.

Overall, the project showed that nuclear cybersecurity cannot be treated as vulnerability management alone. Effective risk reduction must connect technical findings to asset function, regulatory expectations, operational constraints, and the physical protection mission of the facility.
