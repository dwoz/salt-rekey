# salt-rekey

This is a script designed to quickly re-key Salt minions. It was written
originally as a part of the mitigation efforts for CVE-2020-11651 and
CVE-2020-11652 but it can be used in any scenario in which all minions
connected to a salt-master should be forced to re-generate their keys
and re-connect.

For background information on Salt's security model and the role of
keys, please see this document:

https://get.saltstack.com/rs/304-PHQ-615/images/SaltStack-Trust_Overview-of-SaltStack-security-model-white-paper.pdf

## Why

One may wish to rekey minions in any event where the key(s) of the minion
or of the master can no longer be trusted, as in the case of a security
breach.

## Disclaimer

This script is provided without any fitness or warranty. It may cause
minions to be disconnected from the Salt master and fail to reconnect,
forcing manuel intervention.

## Installation

To pull this project down for use on a Salt Master, you need `git`.
Use the following command to download the script for use:

`git clone git@github.com:cachedout/salt-rekey.git`

The above command will pull down the necessary files into a directory called
`salt-rekey`. All subsequent commands should be executed from inside that
directory.

## Configuration

This script should be run from the salt master itself. It uses the following
environment variables which may be set:

Variable name|Description|Default
-------------|-----------|-------
$FILE_ROOT_ENV|Salt file root|base
$PKI_DIR|Salt Master PKI dir|/etc/salt/pki
$MINION_RESTART_WAIT|Seconds to wait for minions to reconnect|120

## Execution

To run the script from the Salt Master, call

    ./rekey.sh 


To run it with one of the above options, set the appropriate environment
variables. 

    MINION_RESTART_WAIT=240 ./rekey.sh


## Caveats

Minions not currently connected to the master will not be able to reconnect and
may require manual regeneration via a `salt-call` and then restarting the minion

    salt-call saltutil.regen_keys


## Getting help

Issues may be filed in this repo.
