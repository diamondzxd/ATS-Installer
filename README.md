# ATS Installer

## Getting started

ATS Installer is a script that automates the process of installing trafficserver. ATS Installer creates a SSL certificate using ZeroSSL and installs the cert into the traffic server.
Also ATS Installer can install and configure healthcheck plugin, the datadog agent and the datadog plugin. 
## Using ATS Installer
```
wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/ats-installer && chmod +x ats-installer && ./ats-installer
```

## Menu from ATS Installer

```

                            __,__
                   .--.  .-"     "-.  .--.
                  / .. \/  .-. .-.  \/ .. \
                 | |  '|  /   Y   \  |'  | |
                 | \   \  \ 0 | 0 /  /   / |
                  \ '- ,\.-"`` ``"-./, -' /
                   `'-' /_   ^ ^   _\ '-'`
                       |  \._   _./  |
                       \   \ `~` /   /
                        '._ '-=-' _.'
                           '~---~'
              Welcome to ATS Installer version v0.0.5
                  Choose an option from below
1.Install ATS under (root) (switching from traefik, if it is a new machine use option 2)
2.Install ATS under (root) + tweaks (use this only if it is a new install)
3.Install ATS healthcheck plugin (in order to work you need to have ATS installed already)
4.Install ATS datadog plugin + datadog agent (root access needed)
5.Uninstall ATS
6.Uninstall ATS datadog plugin + datadog agent
0.Exit
```

Option 1 is recommended if you switch from Trafeik or if you already have the tweaks done in sysctl.conf

Option 2 is recommended for any new installs (a reboot is required).

Option 3 installs the ATS healthcheck plugin and configures it (ATS needs to be installed before choosing option 3)

Option 4 installs the datadog and the datadog plugin (all datadog regions available) (ATS needs to be installed before choosing 4)

Option 5 will uninstall the ATS

Option 6 will uninstall the datadog agent and the datadog plugin from ats.

## Option 4 (datadog + datadog agent)

The script will download the datadog agent and install it for the API Key that you provide then it will setup the plugin in the ats to send the data to the datadog agent, after that it will restart both the datadog and the ats. If you provided the right region and the right api key the data should be send to your account.

You will have to manually enable the ATS Integration in the datadog using the following links:

US1 - https://app.datadoghq.com/integrations/traffic-server

EU1 - https://app.datadoghq.eu/integrations/traffic-server

US3 - https://us3.datadoghq.com/integrations/traffic-server

US5 - https://us5.datadoghq.com/integrations/traffic-server

After that you will be able to see the ATS Dashboard in your dashboard screen.

