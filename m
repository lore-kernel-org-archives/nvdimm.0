Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC5A12097F565
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 12:10:22 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v12 4/5] ndctl, documentation: add man page for
 monitor
Date: Fri, 13 Jul 2018 19:09:47 +0000
Message-ID: <1531508985.7574.145.camel@intel.com>
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-5-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713155403.30020-5-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <8D3A0CB1C6233F449BBB834C4A9784FF@intel.com>
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
Cc: "tokunaga.keiich@jp.fujitsu.com" <tokunaga.keiich@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Sat, 2018-07-14 at 00:54 +0900, QI Fuli wrote:
> This patch is used to add man page for ndctl monitor command.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  Documentation/ndctl/Makefile.am       |   3 +-
>  Documentation/ndctl/ndctl-monitor.txt | 104 ++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+), 1 deletion(-)
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
> index 0000000..4f1803e
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-monitor.txt
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
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
> +objects and dumping the json format notifications to syslog, standard
> +output or a logfile.
> +
> +The objects to monitor and smart events to notify can be selected by
> +setting options and/or the default configuration file
> +(/etc/ndctl/monitor.conf). Both of the values in configuration file
> +and in options will work. If there is a conflict, the values in
> +options will override the values in configuration file. The changed
> +values in configuration file will work after the monitor is restarted.
> +
> +The smart threshold evnet alarm of dimm will be turned on when the
> +monitor gets started, if it is set off.
> +
> +EXAMPLES
> +--------
> +
> +Run a monitor as a daemon to monitor DIMMs on bus "nfit_test.1"
> +[verse]
> +ndctl monitor --bus nfit_test.1 --daemon
> +
> +Run a monitor as a one-shot command and output the notifications to
> +/var/log/ndctl.log
> +[verse]
> +ndctl monitor -log /var/log/ndctl.log
> +
> +Run a monitor daemon as a system service
> +[verse]
> +systemctl start ndctl-monitor.service
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
> +	monitor reference the given dimm.
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
> +-l <file | syslog | standard>::
> +--log=<file | syslog | standard>::
> +	Output notifications to <file>, syslog or standard output.
> +
> +--daemon::
> +	Run a monitor as a daemon.
> +
> +-D::
> +--dimm-event=::
> +	Name of an smart health event from the following:
> +	- "dimm-spares-remaining": Spare Blocks Remaining value has gone
> +	   below the pre-programmed threshold.
> +	- "dimm-media-temperature": NVDIMM Media temperature value has
> +	   gone above the pre-programmed threshold.
> +	- "dimm-controller-temperature": NVDIMM Controller temperature
> +	   value has gone above the pre-programmed threshold.
> +	- "dimm-health-state": NVDIMM Normal Health Status has changed
> +	- "dimm-unclean-shutdown": NVDIMM Last Shutdown Status was a
> +	   unclean shutdown.

Can you add a short note here saying something like:
"The monitor will attempt to enable the alarm control bits for all
specified events."

The rest of this looks good, thanks for the quick updates!

> +-u::
> +--human::
> +	Output monitor notification as human friendly json format instead
> +	of the default machine friendly json format.
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
> +linkndctl:ndctl-list[1], linkndctl:ndctl-inject-smart[1]
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
