Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBD0721123B73
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 10:56:37 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl, monitor: use type=simple instead of type=forking
Date: Tue, 8 Jan 2019 18:56:35 +0000
Message-ID: <8b3b082a9a03164f5b9c8cece01b141b313568b5.camel@intel.com>
References: <20190108083423.6996-1-jthumshirn@suse.de>
In-Reply-To: <20190108083423.6996-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <2002899DE40F3A448A9FDA5B9955895C@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-01-08 at 09:34 +0100, Johannes Thumshirn wrote:
> There is no need to use Type=forking for 'ndctl monitor', Type=simple is
> sufficient.
> 
> When we use Type=forking and try to run ndctl monitor on a machine without
> pmem we even get the following error in the journal:
> 
> Jan 07 13:34:54 bragi systemd[1]: Starting Ndctl Monitor Daemon...
> Jan 07 13:34:54 bragi ndctl[13776]: custom logging function 0x55ea57d60250 registered
> Jan 07 13:34:54 bragi systemd[1]: Started Ndctl Monitor Daemon.
> Jan 07 13:34:54 bragi ndctl[13777]: ndctl monitor daemon started
> Jan 07 13:34:54 bragi kill[13778]: kill: cannot find process ""
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Control process exited, code=exited status=1
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Unit entered failed state.
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Failed with result 'exit-code'.
> 
> This is because the daemon exits and systemd is not able to determine
> $MAINPID anymore.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  ndctl/ndctl-monitor.service | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Thanks, applied.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
