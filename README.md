# 3G digital transfer radio installtion for raspbian

## hardware requirement

* raspberry Pi or other compatibility device with raspbian system
* 3G Adapter, model U6100

## installation

run the following command:

	setup.sh  <target_ip> <target_port> <bund_rate> [target_dir] [install-dir]

example:

	setup.sh 1.1.1.1 1234 57600 /srv/DTR-3G/ .
