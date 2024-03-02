# hardened-nginx-configurations
Nginx Hardened Configurations

Provided configurations have been hardened by following the CIS benchmarks.

CIS_NGINX_Benchmark_v1.0.0 - 02-28-2019

It should be accessible via [this link](https://www.cisecurity.org/benchmark/nginx)

If you are looking for  specific case, just search the given title in the config files.  
A sample:

`#CIS - Nginx - 5.2.1 Ensure timeout values for reading the client header and body are set correctly (10s).
client_body_timeout 10;`

Keep in mind, these are the sample configuration files, and they might not be a one-size-fit-all cases. So it should be configured by regarding the actual requirements. 