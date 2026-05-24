# Results and Limitations

## Constraints and Limitations

### No Patching Permitted

No manufacturer patches or firmware updates were applied during the assessment. This constraint represented legacy operational technology (OT) systems commonly found in nuclear environments, where extended operational lifecycles and strict change-control requirements can delay or prevent routine patching.

This reflects real-world scenarios where OT systems may lag behind current patch levels because of:

- Qualification requirements
- Vendor support limitations
- Safety or availability concerns
- System interdependencies
- Risk-averse change management

### Isolated Laboratory Environment

All testing was performed in an isolated lab environment with no connection to operational nuclear systems. Exploit demonstrations were limited to controlled proof-of-concept activities intended to show vulnerability impact without causing equipment damage, persistent compromise, or operational disruption.

### Regulatory Framework Focus

CDA determinations and security analysis were performed within a nuclear cybersecurity context using NRC regulations and guidance, including:

- 10 CFR 73.54
- 10 CFR 73.55
- NEI 10-04
- RG 5.71
- NUREG/CR-7145

Findings may not directly translate to non-nuclear critical infrastructure environments because other sectors may operate under different regulatory requirements, asset classifications, and risk models.

### Equipment Scope

The technical analysis focused on Hikvision NVR and IP camera systems as representative examples of network-connected surveillance technology. Specific vulnerability findings may not apply to other manufacturers, firmware versions, or deployment configurations.

However, the broader asset management and compensating-control lessons remain applicable to similar OT and physical security environments.

### Out of Scope

The following areas were outside the project scope:

- Full network infrastructure penetration testing
- Non-surveillance security systems
- Complete compensatory-measure assessment
- Comprehensive cybersecurity program documentation beyond CDA determination
- Production deployment or validation in an operational nuclear facility

## Results

The project demonstrated a hands-on cybersecurity assessment of a Physical Protection System (PPS) camera environment in a simulated nuclear facility context.

The assessment produced several key results:

- Applied a consequence-driven CDA determination process
- Distinguished between security-critical and supplemental surveillance assets
- Validated known vulnerability risk in a controlled lab setting
- Modeled realistic attack pathways against the camera/NVR environment
- Designed and implemented compensating controls under a no-patching constraint
- Demonstrated that network-level controls can reduce exposure while preserving system functionality

## CDA Determination Result

The CDA analysis showed that asset classification depends on function and consequence, not merely device type, location, or vulnerability status.

The Owner-Controlled Area (OCA) perimeter camera was classified as a CDA because it supported required surveillance and alarm assessment functions. Its compromise could degrade the facility's ability to detect and assess unauthorized activity before an adversary reached the Protected Area.

The interior Protected Area camera was not classified as a CDA under the project assumptions because it provided supplemental surveillance rather than monitoring a required security-significant area. This conclusion would change if the camera monitored a Vital Area boundary, Target Set equipment, Critical Interruption Point, or another function explicitly required by the protective strategy.

## Vulnerability Analysis Result

The technical evaluation exposed significant risk in legacy camera and NVR firmware.

CVE-2017-7921 was successfully validated in the controlled lab environment and showed that authentication controls could be bypassed under vulnerable conditions. This created a direct risk to camera and NVR configuration integrity.

CVE-2021-36260 was applicable by firmware range but was not exploitable under the tested configuration. This still represented risk because configuration differences, firmware changes, or deployment conditions could alter exploitability.

The analysis also identified broader weakness categories across:

- Authentication
- Credential handling
- Cryptography
- Transport security
- Access control
- Input validation
- System configuration

The primary concern was not a single vulnerability in isolation. The larger issue was that multiple weaknesses could compound, creating realistic paths to degrade video integrity, alarm assessment, and operator trust.

## Mitigation Result

Because patching was treated as unavailable, the project implemented a defense-in-depth mitigation strategy using:

- Network segmentation
- Reverse proxy filtering
- Firewall enforcement
- Controlled routing between the NVR and camera subnet
- Logging of blocked or suspicious requests

This architecture reduced direct access to the camera and forced traffic through a controlled inspection point. Known unsafe request patterns could be blocked before reaching the vulnerable device.

The mitigation did not remove the underlying firmware vulnerability. Instead, it reduced exposure and limited the ability of an attacker to reach or abuse the vulnerable service.

## Security Impact

The mitigation improved the system by:

- Removing direct access paths to the vulnerable camera
- Reducing the reachable attack surface
- Blocking tested malicious request patterns
- Preserving normal camera/NVR functionality
- Limiting lateral movement opportunities
- Providing visibility into suspicious access attempts

This showed that compensating controls can meaningfully reduce risk when immediate patching is not possible.

## Remaining Limitations

The implemented mitigation reduced exposure, but it did not eliminate all risk.

Remaining limitations include:

- The vulnerable firmware remained present on the device.
- Direct access to the camera-side subnet could still bypass the proxy.
- Misconfigured routing, NAT, or firewall rules could reintroduce direct access.
- New exploit techniques may require updated filtering rules.
- The proxy itself became a critical enforcement point that must be secured and monitored.
- Non-HTTP protocols require separate review and filtering.
- The architecture was validated in a lab, not in a production nuclear facility.

## Conclusion

This project performed a hands-on cybersecurity assessment of a Physical Protection System camera environment in a simulated nuclear facility context. The assessment focused on identifying Critical Digital Assets, validating known vulnerabilities, modeling attack pathways, and designing compensating controls under realistic operational constraints.

By applying 10 CFR 73.54 and NEI 10-04, the project demonstrated a consequence-driven method for asset classification. The findings showed that a perimeter-facing camera can qualify as a CDA when it supports required surveillance and alarm assessment functions, while an interior camera may remain supplemental if it does not support a required SSEP function.

The technical evaluation showed that legacy firmware can create significant risk in network-connected physical security systems. CVE-2017-7921 demonstrated the operational impact of authentication-bypass vulnerabilities, while CVE-2021-36260 showed the risk of configuration-dependent vulnerabilities in unpatched systems.

Because nuclear operational constraints may prevent immediate patching, the project validated a layered compensating-control approach. Network segmentation, reverse proxy filtering, and firewall enforcement reduced direct exposure and helped preserve system functionality while limiting exploit paths.

Overall, the project reinforced that nuclear cybersecurity must align technical vulnerability management with regulatory expectations, operational constraints, and the physical protection mission of the facility.
