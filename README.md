
# Hardened Nginx Configurations Against Attacks

## Overview
These Nginx configurations have been hardened according to the CIS benchmarks, making them suitable for securing critical instances of Nginx, particularly in on-premise infrastructure hosting mission-critical applications.

- **Benchmark:** CIS_NGINX_Benchmark_v1.0.0 - **02-28-2019**
- Access the benchmark [here](https://www.cisecurity.org/benchmark/nginx).

## Purpose
The purpose of these configurations is to enhance the security posture of Nginx instances by adhering to established CIS benchmarks. By implementing these configurations, organizations can mitigate the risk of various common attacks targeting Nginx servers.

## Usage
To use these configurations effectively, follow these steps:

1. **Review CIS Benchmark:** Familiarize yourself with the CIS Nginx benchmark to understand the security recommendations and requirements.
2. **Implementation:** Apply the provided configurations to your Nginx instances, ensuring that each setting aligns with the corresponding benchmark guideline.
3. **Customization:** While the provided configurations offer a solid foundation, consider customizing them based on your specific use case and security requirements.
4. **Testing:** Thoroughly test the configured Nginx instances to ensure that they function as expected while maintaining the desired security posture.
5. **Ongoing Maintenance:** Regularly review and update the configurations to address new security threats and vulnerabilities as they emerge.

## Sample Configuration
Below is an example of a configuration snippet from the provided files:

```nginx
# CIS - Nginx - 5.2.1 Ensure timeout values for reading the client header and body are set correctly (10s).
client_body_timeout 10;
```
Keep in mind, that these are the sample configuration files, and they might not be a one-size-fits-all case. So it should be configured regarding the actual requirements of your expected use case. 
