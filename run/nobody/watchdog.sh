#!/bin/bash

# while loop to check ip and port
while true; do

	# reset triggers to negative values
	privoxy_running="false"
	microsocks_running="false"
	ip_change="false"

	if [[ "${VPN_ENABLED}" == "yes" ]]; then

		# run script to get all required info
		source /home/nobody/preruncheck.sh

		# if vpn_ip is not blank then run, otherwise log warning
		if [[ ! -z "${vpn_ip}" ]]; then

			# check if privoxy is running, if not then skip shutdown of process
			if ! pgrep -fa "/usr/bin/privoxy" > /dev/null; then

				echo "[info] Privoxy not running"

			else

				# mark as privoxy as running
				privoxy_running="true"

			fi

			if [[ "${privoxy_running}" == "false" ]]; then

				# run script to start privoxy
				source /home/nobody/privoxy.sh

			fi
			
			# check if microsocks is running, if not then skip shutdown of process
			if ! pgrep -fa "/usr/local/bin/microsocks" > /dev/null; then

				echo "[info] microsocks not running"

			else

				# mark microsocks as running
				microsocks_running="true"

			fi

			if [[ "${microsocks_running}" == "false" ]]; then

				# run script to start microsocks
				source /home/nobody/microsocks.sh

			fi

		else

			echo "[warn] VPN IP not detected, VPN tunnel maybe down"

		fi

	else

		# check if privoxy is running, if not then start via privoxy.sh
		if ! pgrep -fa "/usr/bin/privoxy" > /dev/null; then

			echo "[info] Privoxy not running"

			# run script to start privoxy
			source /home/nobody/privoxy.sh

		fi

		# check if microsocks is running, if not then start via microsocks.sh
		if ! pgrep -fa "/usr/local/bin/microsocks" > /dev/null; then

			echo "[info] microsocks not running"

			# run script to start microsocks
			source /home/nobody/microsocks.sh

		fi

	fi

	if [[ "${DEBUG}" == "true" && "${VPN_ENABLED}" == "yes" ]]; then
		echo "[debug] VPN IP is ${vpn_ip}"
	fi

	sleep 30s

done
