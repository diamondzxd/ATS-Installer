#!/bin/bash
# ATS Installer - KennyX
# v 0.0.5

#Colors
BLK='[1;30m'
RED='[1;31m'
YEL='[1;33m'
BLU='[1;34m'
GREE='[1;32m'
RES='[0m'
WHT='[1;37m'
DRED='[0;31m'
DBLU='[0;34m'
###########################

############Reserved for futher W##########

###########################

############Def############
sleep='sleep 2'
sleep2='sleep 10'
menu=${1:-"menu"}
version='v0.0.5'
##########################

###################Header
clear
echo "${DRED}"
cat << "EOF"
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
EOF
echo "${GREE}              Welcome to ATS Installer version" ${version}
################# End header

################# function
function goto
{
	label=$1
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}
#################


goto $menu

menu:
clear
echo "${DRED}"
cat << "EOF"
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
EOF
echo "${GREE}              Welcome to ATS Installer version" ${version}
echo "${GREE}                  Choose an option from below"

echo "${DRED}1.${GREE}Install ATS under (root) (switching from traefik, if it is a new machine use option 2)"
echo "${DRED}2.${GREE}Install ATS under (root) + tweaks (use this only if it is a new install)"
echo "${DRED}3.${GREE}Install ATS healthcheck plugin (in order to work you need to have ATS installed already)"
echo "${DRED}4.${GREE}Install ATS datadog plugin + datadog agent (root access needed)"
echo "${DRED}5.${GREE}Uninstall ATS"
echo "${DRED}6.${GREE}Uninstall ATS datadog plugin + datadog agent"
echo "${DRED}0.${GREE}Exit"
echo "${DRED}|+|Your option:"
read option

	## scanning
	if [ $option = "1" ]; then
		echo "${DRED}Starting installing"
		sleep 3
		sudo apt-get update
		sudo apt-get install software-properties-common -y
		sudo add-apt-repository ppa:hnakamur/trafficserver9 -y
		sudo apt-get update
		sudo apt-get install trafficserver -y
		echo "${DRED}Traffic Server has been installed"
		echo "${DRED}Pulling the config from git"
		rm -rf /opt/trafficserver/etc/records.config
		wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/records.config -O /opt/trafficserver/etc/records.config
		echo "${DRED}Running some command as trafficserver user"
		chsh -s /bin/bash trafficserver
		systemctl stop trafficserver
		usermod -d /opt/trafficserver trafficserver
		sudo chown -R trafficserver:trafficserver /opt/trafficserver/
		echo "${DRED}Installing ssl cert"
		echo "${YEL}ZeroSSL email address (required)"
		read zerosslemail
		runuser -l trafficserver -c "curl https://get.acme.sh | sh -s email=${zerosslemail}"
		echo "${YEL}Cloudflare email address"
		read cfemail
		echo "${YEL}Clouflare global api key"
		read cfkey
		export CF_Email="${cfemail}"
		export CF_Key="${cfkey}"
		echo "${YEL}Domain name (without www or https), example: google.com"
		read domain
		echo "${DRED}Requesting the SSL certificate"
		runuser -l trafficserver -c "CF_Email=${cfemail} CF_Key=${cfkey} bash /opt/trafficserver/.acme.sh/acme.sh --issue -d ${domain} -d "*.${domain}" --dns dns_cf"
		echo 'Installing the certificate into trafficserver'
		echo "dest_ip=* ssl_cert_name=/opt/trafficserver/.acme.sh/${domain}/fullchain.cer ssl_key_name=/opt/trafficserver/.acme.sh/${domain}/${domain}.key" >> /opt/trafficserver/etc/ssl_multicert.config
		sleep 1
		echo "${DRED}The SSL cert has been added to trafficserver"
		sleep 1
		echo "${DRED}Restarting trafficserver service"
		service trafficserver restart
		echo "${YEL}Bye!"
	elif [ $option = "2" ]; then
		echo "${DRED}Starting installing"
		sleep 3
		sudo apt-get update
		sudo apt-get install software-properties-common -y
		sudo add-apt-repository ppa:hnakamur/trafficserver9 -y
		sudo apt-get update
		sudo apt-get install trafficserver -y
		echo "${DRED}Traffic Server has been installed"
		echo "${DRED}Pulling the config from git"
		rm -rf /opt/trafficserver/etc/records.config
		wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/records.config -O /opt/trafficserver/etc/records.config
		echo "${DRED}Running some command as trafficserver user"
		chsh -s /bin/bash trafficserver
		systemctl stop trafficserver
		usermod -d /opt/trafficserver trafficserver
		sudo chown -R trafficserver:trafficserver /opt/trafficserver/
		echo "${DRED}Installing ssl cert"
		echo "${YEL}ZeroSSL email address (required)"
		read zerosslemail
		runuser -l trafficserver -c "curl https://get.acme.sh | sh -s email=${zerosslemail}"
		echo "${YEL}Cloudflare email address"
		read cfemail
		echo "${YEL}Clouflare global api key"
		read cfkey
		export CF_Email="${cfemail}"
		export CF_Key="${cfkey}"
		echo "${YEL}Domain name (without www or https), example: google.com"
		read domain
		echo "${DRED}Requesting the SSL certificate"
		runuser -l trafficserver -c "CF_Email=${cfemail} CF_Key=${cfkey} bash /opt/trafficserver/.acme.sh/acme.sh --issue -d ${domain} -d "*.${domain}" --dns dns_cf"
		echo 'Installing the certificate into trafficserver'
		echo "dest_ip=* ssl_cert_name=/opt/trafficserver/.acme.sh/${domain}/fullchain.cer ssl_key_name=/opt/trafficserver/.acme.sh/${domain}/${domain}.key" >> /opt/trafficserver/etc/ssl_multicert.config
		sleep 1
		echo "${DRED}The SSL cert has been added to trafficserver"
		sleep 1
		echo "${DRED}Restarting trafficserver service"
		service trafficserver restart
		echo "${GREE}Making the tweaks"
		echo "net.ipv4.tcp_window_scaling=1
		net.core.rmem_max=134217728
		net.core.wmem_max=134217728
		net.ipv4.tcp_rmem=4096 87380 134217728
		net.ipv4.tcp_wmem=4096 65536 134217728
		net.core.netdev_max_backlog=300000
		net.ipv4.tcp_moderate_rcvbuf =1
		net.ipv4.tcp_congestion_control=bbr
		net.ipv4.tcp_mtu_probing=1
		fs.file-max=1048576
		vm.swappiness=10
		vm.dirty_ratio=15
		vm.dirty_background_ratio=10
		net.core.somaxconn=1024
		net.ipv4.tcp_max_syn_backlog=30000
		net.ipv4.tcp_max_tw_buckets=2000000
		net.ipv4.tcp_tw_reuse=1
		net.ipv4.tcp_sack=1
		net.ipv4.tcp_adv_win_scale=2
		net.ipv4.tcp_rfc1337=1
		net.ipv4.tcp_fin_timeout=10
		net.ipv4.tcp_slow_start_after_idle=0
		net.ipv4.udp_rmem_min=8192
		net.ipv4.udp_wmem_min=8192
		net.ipv4.conf.all.accept_source_route=0
		net.ipv4.conf.all.accept_redirects=0
		net.ipv4.conf.all.secure_redirects=0
		net.core.default_qdisc=fq
		fs.inotify.max_user_watches=5240000
		net.core.netdev_budget=50000
		net.core.netdev_budget_usecs=5000" > /etc/sysctl.conf
		/sbin/sysctl -p
		echo "${YEL}In order for the tweaks to apply please reboot the server!"
		echo "${YEL}Bye!"
	elif [ $option = "3" ]; then
        echo "${DRED}Starting installing the healthcheck"
		echo "${DRED}In order for this to work the ATS needs to be installed at"
		echo "${DRED}/opt/trafficserver/etc/"
		sleep 3
		echo "healthchecks.so /opt/trafficserver/etc/healthcheck.conf" >> /opt/trafficserver/etc/plugin.config
		echo "/ping /opt/trafficserver/etc/ts-alive text/plain 200 403" >> /opt/trafficserver/etc/healthcheck.conf
		echo "OK" >> /opt/trafficserver/etc/ts-alive
		echo "Restarting the Traffic server"
		systemctl restart trafficserver
		echo "The Healthcheck plug has been installed"
		sleep 1
		echo "${YEL}The default ping message is set as OK"
		echo "${YEL}If you would like to switch it, edit the /opt/trafficserver/etc/ts-alive file"
		echo "${YEL}After that restart or reload the config using: traffic_ctl config reload"
		echo "${YEL}Bye"
	
	elif [ $option = "4" ]; then
		echo "${GREE}On which region is your datadog region/server registered on"
		echo "${DRED}1.${GREE}US1 - app.datadoghq.com"
		echo "${DRED}2.${GREE}EU1 - app.datadoghq.eu"
		echo "${DRED}3.${GREE}US3 - us3.datadoghq.com"
		echo "${DRED}4.${GREE}US5 - us5.datadoghq.com"
		echo "${DRED}|+|Your option:"
		read datadogregion
			if [ $datadogregion = "1" ]; then
				echo "${DRED}Starting installing the datadog on the US1 region"
				echo "${YEL}What is your API Key?"
				echo "${YEL}It can be found here:"
				echo "${YEL}https://app.datadoghq.com/organization-settings/api-keys"
				echo "${YEL}Make sure to grab the API Key and not the Key ID"
				read apikey
				DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${apikey} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
				echo "${DRED}Installing the config"
				wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/datadog.yaml -O /etc/datadog-agent/conf.d/traffic_server.d/conf.yaml
				echo "${DRED}Installing the plugin in ats"
				echo "stats_over_http.so O6gxQ89A9l7Q" >> /opt/trafficserver/etc/plugin.config
				echo "${DRED}Restarting the ATS server"
				echo "${DRED}Restarting the DD Agent"
				systemctl restart trafficserver
				systemctl restart datadog-agent
				echo "${YEL}If everything worked you should be able to see the statistics in your datadog dashboard"
				echo "${YEL}Bye!"
			elif [ $datadogregion = "2" ]; then
				echo "${DRED}Starting installing the datadog on the EU1 region"
				echo "${YEL}What is your API Key?"
				echo "${YEL}It can be found here:"
				echo "${YEL}https://app.datadoghq.eu/organization-settings/api-keys"
				echo "${YEL}Make sure to grab the API Key and not the Key ID"
				read apikey
				DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${apikey} DD_SITE="datadoghq.eu" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
				echo "${DRED}Installing the config"
				wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/datadog.yaml -O /etc/datadog-agent/conf.d/traffic_server.d/conf.yaml
				echo "${DRED}Installing the plugin in ats"
				echo "stats_over_http.so O6gxQ89A9l7Q" >> /opt/trafficserver/etc/plugin.config
				echo "${DRED}Restarting the ATS server"
				echo "${DRED}Restarting the DD Agent"
				systemctl restart trafficserver
				systemctl restart datadog-agent
				echo "${YEL}If everything worked you should be able to see the statistics in your datadog dashboard"
				echo "${YEL}Bye!"
			elif [ $datadogregion = "3" ]; then
				echo "${DRED}Starting installing the datadog on the US1 region"
				echo "${YEL}What is your API Key?"
				echo "${YEL}It can be found here:"
				echo "${YEL}https://us3.datadoghq.com/organization-settings/api-keys"
				echo "${YEL}Make sure to grab the API Key and not the Key ID"
				read apikey
				DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${apikey} DD_SITE="us3.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
				echo "${DRED}Installing the config"
				wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/datadog.yaml -O /etc/datadog-agent/conf.d/traffic_server.d/conf.yaml
				echo "${DRED}Installing the plugin in ats"
				echo "stats_over_http.so O6gxQ89A9l7Q" >> /opt/trafficserver/etc/plugin.config
				echo "${DRED}Restarting the ATS server"
				echo "${DRED}Restarting the DD Agent"
				systemctl restart trafficserver
				systemctl restart datadog-agent
				echo "${YEL}If everything worked you should be able to see the statistics in your datadog dashboard"
				echo "${YEL}Bye!"
			elif [ $datadogregion = "4" ]; then
				echo "${DRED}Starting installing the datadog on the US1 region"
				echo "${YEL}What is your API Key?"
				echo "${YEL}It can be found here:"
				echo "${YEL}https://us3.datadoghq.com/organization-settings/api-keys"
				echo "${YEL}Make sure to grab the API Key and not the Key ID"
				read apikey
				DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${apikey} DD_SITE="us5.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
				echo "${DRED}Installing the config"
				wget https://gitlab.zenterprise.org/kenny/ats-installer/-/raw/main/datadog.yaml -O /etc/datadog-agent/conf.d/traffic_server.d/conf.yaml
				echo "${DRED}Installing the plugin in ats"
				echo "stats_over_http.so O6gxQ89A9l7Q" >> /opt/trafficserver/etc/plugin.config
				echo "${DRED}Restarting the ATS server"
				echo "${DRED}Restarting the DD Agent"
				systemctl restart trafficserver
				systemctl restart datadog-agent
				echo "${YEL}If everything worked you should be able to see the statistics in your datadog dashboard"
				echo "${YEL}Bye!"
			else
        		echo "${DRED}|+| Invalid choice."
				exit
			fi
	elif [ $option = "5" ]; then
        echo "${DRED}This option will uninstall the ATS, if you don't want to do that Ctrl+C now, starting in 10 seconds."
		sleep 10
		systemctl stop trafficserver
		apt-get purge trafficserver -y
		rm -rf /opt/trafficserver
		echo "${DRED}ATS has been uninstalled."
		echo "${YEL}Bye!"

	elif [ $option = "6" ]; then
        echo "${DRED}This option will uninstall the Datadog agent and the datadog plugin, if you don't want to do that Ctrl+C now, starting in 10 seconds."
		sleep 10
		systemctl stop datadog-agent
		apt-get purge datadog-agent -y
		rm -rf /etc/datadog-agent
		sed -i 's/stats_over_http.so O6gxQ89A9l7Q//' /opt/trafficserver/etc/plugin.config
		echo "${DRED}Datadog agent and the datadog plugin has been uninstalled."
		echo "${YEL}Bye!"

	elif [ $option = "0" ]; then
        echo "${DRED}Exit.. Please Wait."
		${sleep}
		exit
	
	else
        echo "${DRED}|+| Invalid choice, please select a number from above."
		sleep 3
		goto $menu
	
	fi

	# // if ^ works show this ->
	# end
