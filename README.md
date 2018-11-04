# nginx install

This is a sample nginx install using Salt states.  The example will install nginx on a Linux Ununtu computer.  This has been tested with Ubuntu Server 16.04.

This example also includes a state to install a second site, 'www.example.com', which is accessed via port 3200 and redirected to a localhost accessible site on port 3400.  Access to this second site is via 'http://www.example.com:3200' (through the use of your own DNS entries or '/etc/hosts').

A configuration is also provided to send all non-'www.example.com' requests on port 3200 to a custom 404 page.  For example, this site only takes requests for 'www.example.com', all others receive a custom 404 error page.

Both the default nginx install and the second site include firewall configurations enabled to allow access to nginx on port 80 (default site), 3200 (proxied www.example.com site), and ssh access on port 22.


## Requirements

Minimally `salt-minion` needs to be installed on the target Ubuntu server, refer to 'https://repo.saltstack.com/#ubuntu' installation page for specific install instructions.

Optionally you can install using these states from a `salt-master` locally on the same server or from a remote `salt-master`.  Either way, the `salt-minion` needs to be installed and configured on your Ubuntu server, and accepted by the `salt-master`.

Note: If installing via `salt-minion` installed on your Ubuntu server, `salt-minion` does not need to be configured and accepted by a `salt-master`, and also does not need to be running.

## Setup

Copy the `nginx` directory from this repo to the `salt-master` `/srv/salt` directory, or to the `/srv/salt` directory on your Ubuntu server if you are only using `salt-minion` to perform the installation.

## Installation

To install nginx from a `salt-master`:
```
salt ubuntu-minion state.apply nginx
```
where 'ubuntu-minion' is the name of the minion installed on your Ubuntu server.

To install nginx using the `salt-minion` on your Ubuntu server:
```
salt-call --local state.apply nginx
```

## Adding the second web-site (www.example.com):

To add the second web-site, make sure that the above 'ngnix' install has been done, then:

For adding from a `salt-master`:
```
salt ubuntu-minion state.apply nginx/add-example
```

Or, from the `salt-minion`:
```
salt-call --local state.apply nginx/add-example
```

