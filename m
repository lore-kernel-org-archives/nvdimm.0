Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2085C207E6368
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 19:47:25 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v11 4/5] ndctl, documentation: add manpage for
 monitor
Date: Fri, 13 Jul 2018 02:47:06 +0000
Message-ID: <1531450025.7574.108.camel@intel.com>
References: <20180711030012.9186-1-qi.fuli@jp.fujitsu.com>
 <20180711030012.9186-5-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180711030012.9186-5-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <E577A0B15EF954419873CF4282A7F157@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-07-11 at 12:00 +0900, QI Fuli wrote:
> This patch is used to add manpage for ndctl monitor command.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  Documentation/ndctl/Makefile.am       |  3 +-
>  Documentation/ndctl/ndctl-monitor.txt | 96 +++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-monitor.txt
> 
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 4fd9636..a30b139 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -46,7 +46,8 @@ man1_MANS = \
>  	ndctl-inject-error.1 \
>  	ndctl-inject-smart.1 \
>  	ndctl-update-firmware.1 \
> -	ndctl-list.1
> +	ndctl-list.1 \
> +	ndctl-monitor.1
>  
>  CLEANFILES = $(man1_MANS)
>  
> diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
> new file mode 100644
> index 0000000..037fdc7
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-monitor.txt
> @@ -0,0 +1,96 @@

Missing SPDX license header

> +ndctl-monitor(1)
> +================
> +
> +NAME
> +----
> +ndctl-monitor - Monitor the smart events of nvdimm objects
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl monitor' [<options>]
> +
> +DESCRIPTION
> +-----------
> +Ndctl monitor is used for monitoring the smart events of nvdimm
> +objects and dumping the json format notifications to syslog or
> +a logfile.
> +
> +The objects to monitor and smart evnets to notify can be selected
				    ^
s/evnets/events/

> +by setting options and/or the default configuration file
> +(/etc/ndctl/monitor.conf). Both of the values in configuration file
> +and in options will work. If conflict, the values in options will
			     ^
"If there is a conflict..."

> +override the values in configuration file. The changed values in
> +configuration file will work after restart ndctl monitor.
				^
"..after the monitor is restarted."

> +
> +EXAMPLES
> +--------
> +
> +Run a monitor as a daemon to monitor DIMMs on a provider named ndbus1
> +[verse]
> +ndctl monitor -b ndbus1 -f
> +
> +Run a monitor as a one-shot command and output the notifications to
> +/var/log/ndctl.log
> +[verse]
> +ndctl monitor -l /var/log/ndctl.log
> +
> +Run a monitor daemon as a system service
> +[verse]
> +systemctl start ndctl-monitor.service

For man page examples, I prefer using the long format options as it is
easier for the user to understand what is going on. Also for examples,
perhaps use the actual bus name (such as ACPI.NFIT) instead of the
identifier libnvdimm assigns to it (since that is also what bash
completion provides)

> +
> +OPTIONS
> +-------
> +-b::
> +--bus=::
> +	Enforce that the operation only be carried on devices that are
> +	attached to the given bus. Where 'bus' can be a provider name
> +	or a bus id number.
> +
> +-d::
> +--dimm=::
> +	A 'nmemX' device name, or dimm id number. Select the devices to
> +	monitor refrerence the given dimm.
		^
s/refrerence/reference/

> +
> +-r::
> +--region=::
> +	A 'regionX' device name, or a region id number. The keyword 'all'
> +	can be specified to carry out the operation on every region in
> +	the system, optionally filtered by bus id (see --bus= option).
> +
> +-n::
> +--namespace=::
> +	A 'namespaceX.Y' device name, or namespace region plus id tuple
> +	'X.Y'.
> +
> +-l <file | syslog>::
> +--logfile=<file | syslog>::
> +	Output notifications to <file> or syslog.
> +
> +-f::

-f could be construed as --foreground, which would be the opposite of
what --daemon is trying to do. I would suggest -B for 'background'
(since 'b' is in use for bus), but -B could come in handy for a future
bus-events option..  I think I'd prefer to set the short option to
something like -x (since option parsing doesn't allow for an empty
short option), and not advertise it in the man page at all (similar to
inject-smart).

> +--daemon::
> +	Run a monitor as a daemon.
> +
> +-D::
> +--dimm-event=::
> +	A name of smart events come NVDIMM DIMMs.

s/NVDIMM DIMMs/NVDIMMs/
Also perhaps something like this makes more sense:
"Name of an smart health event from the following:"

> +	- "dimm-spares-remaining": Spare Blocks Remaining value has gone
> +	   below the pre-programmed threshold limit

in all of these: s/threshold limit/threshold/  'threshold' already
implies a limit.

> +	- "dimm-media-temperature": NVDIMM Media temperature value has
> +	   gone above the pre-programmed threshold limit
> +	- "dimm-controller-temperature": NVDIMM Controller temperature
> +	   value has gone above the pre-programmed threshold limit
> +	- "dimm-health-state": NVDIMM Normal Health Status has changed
> +	- "dimm-unclean-shutdown": NVDIMM Last Shutdown Status was a dirty
> +	   shutdown.

s/dirty/unclean/ to stay consistent with the name.

These (and some other minor details like the logfile) will need updates
to the bash completion script (contrib/ndctl). But I can do that easily
enough if you don't want to spend the time to grok how that works :)

> +
> +COPYRIGHT
> +---------
> +Copyright (c) 2018, FUJITSU LIMITED. License GPLv2: GNU GPL version 2
> +<http://gnu.org/licenses/gpl.html>. This is free software: you are
> +free to change and redistribute it. There is NO WARRANTY, to the
> +extent permitted by law.
> +
> +SEE ALSO
> +--------
> +linkndctl:ndctl-list[1]

In addition to ndctl-list, also add ndctl-inject-smart here since that
is used for setting thresholds and alarms.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
