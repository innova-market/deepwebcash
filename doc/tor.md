*** Warning: Do not assume Tor support does the correct thing in DeepWebCash; better Tor support is a future feature goal. ***

TOR SUPPORT IN DWCASH
====================

It is possible to run DeepWebCash as a Tor hidden service, and connect to such services.

The following directions assume you have a Tor proxy running on port 9050. Many distributions default to having a SOCKS proxy listening on port 9050, but others may not. In particular, the Tor Browser Bundle defaults to listening on a random port. See [Tor Project FAQ:TBBSocksPort](https://www.torproject.org/docs/faq.html.en#TBBSocksPort) for how to properly
configure Tor.


1. Run DeepWebCash behind a Tor proxy
-------------------------------

The first step is running DeepWebCash behind a Tor proxy. This will already make all
outgoing connections be anonymized, but more is possible.

	-proxy=ip:port  Set the proxy server. If SOCKS5 is selected (default), this proxy
	                server will be used to try to reach .onion addresses as well.

	-onion=ip:port  Set the proxy server to use for Tor hidden services. You do not
	                need to set this if it's the same as -proxy. You can use -noonion
	                to explicitly disable access to hidden service.

	-listen         When using -proxy, listening is disabled by default. If you want
	                to run a hidden service (see next section), you'll need to enable
	                it explicitly.

	-connect=X      When behind a Tor proxy, you can specify .onion addresses instead
	-addnode=X      of IP addresses or hostnames in these parameters. It requires
	-seednode=X     SOCKS5. In Tor mode, such addresses can also be exchanged with
	                other P2P nodes.

In a typical situation, this suffices to run behind a Tor proxy:

	./dwcashd -proxy=127.0.0.1:9050


2. Run a DeepWebCash hidden server
----------------------------

If you configure your Tor system accordingly, it is possible to make your node also
reachable from the Tor network. Add these lines to your /etc/tor/torrc (or equivalent
config file):

	HiddenServiceDir /var/lib/tor/dwcash-service/
	HiddenServicePort 8233 127.0.0.1:8233
	HiddenServicePort 18233 127.0.0.1:18233

The directory can be different of course, but (both) port numbers should be equal to
your dwcashd's P2P listen port (8233 by default).

	-externalip=X   You can tell DeepWebCash about its publicly reachable address using
	                this option, and this can be a .onion address. Given the above
	                configuration, you can find your onion address in
	                /var/lib/tor/dwcash-service/hostname. Onion addresses are given
	                preference for your node to advertize itself with, for connections
	                coming from unroutable addresses (such as 127.0.0.1, where the
	                Tor proxy typically runs).

	-listen         You'll need to enable listening for incoming connections, as this
	                is off by default behind a proxy.

	-discover       When -externalip is specified, no attempt is made to discover local
	                IPv4 or IPv6 addresses. If you want to run a dual stack, reachable
	                from both Tor and IPv4 (or IPv6), you'll need to either pass your
	                other addresses using -externalip, or explicitly enable -discover.
	                Note that both addresses of a dual-stack system may be easily
	                linkable using traffic analysis.

In a typical situation, where you're only reachable via Tor, this should suffice:

	./dwcashd -proxy=127.0.0.1:9050 -externalip=zctestseie6wxgio.onion -listen

(obviously, replace the Onion address with your own). If you don't care too much
about hiding your node, and want to be reachable on IPv4 as well, additionally
specify:

	./dwcashd ... -discover

and open port 8233 on your firewall (or use -upnp).

If you only want to use Tor to reach onion addresses, but not use it as a proxy
for normal IPv4/IPv6 communication, use:

	./dwcashd -onion=127.0.0.1:9050 -externalip=zctestseie6wxgio.onion -discover


3. Connect to a DeepWebCash hidden server
-----------------------------------

To test your set-up, you might want to try connecting via Tor on a different computer to just a
a single DeepWebCash hidden server. Launch dwcashd as follows:

	./dwcashd -onion=127.0.0.1:9050 -connect=zctestseie6wxgio.onion

Now use dwcash-cli to verify there is only a single peer connection.

	dwcash-cli getpeerinfo

	[
	    {
	        "id" : 1,
	        "addr" : "zctestseie6wxgio.onion:18233",
	        ...
	        "version" : 170002,
	        "subver" : "/MagicBean:1.0.0/",
	        ...
	    }
	]

To connect to multiple Tor nodes, use:

	./dwcashd -onion=127.0.0.1:9050 -addnode=zctestseie6wxgio.onion -dnsseed=0 -onlynet=onion
