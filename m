Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa20.fujitsucc.c3s2.iphmx.com (esa20.fujitsucc.c3s2.iphmx.com
 [216.71.158.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5697B21309DD6
 for <linux-nvdimm@lists.01.org>; Thu,  1 Aug 2019 19:50:32 -0700 (PDT)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl/monitor: make the daemon exit message 'info'
 level
Date: Fri, 2 Aug 2019 02:47:56 +0000
Message-ID: <OSAPR01MB499340139C16FA180345D213F7D90@OSAPR01MB4993.jpnprd01.prod.outlook.com>
References: <20190801211908.11684-1-vishal.l.verma@intel.com>
In-Reply-To: <20190801211908.11684-1-vishal.l.verma@intel.com>
Content-Language: ja-JP
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com]
> Sent: Friday, August 2, 2019 6:19 AM
> To: linux-nvdimm@lists.01.org
> Cc: Vishal Verma <vishal.l.verma@intel.com>; Qi, Fuli/斉 福利
> <qi.fuli@fujitsu.com>; Dan Williams <dan.j.williams@intel.com>; Adam
> Borowski <kilobyte@angband.pl>
> Subject: [ndctl PATCH] ndctl/monitor: make the daemon exit message 'info'
> level
> 
> The 'ndctl monitor daemon started' message is at an 'info' log level,
> but the corresponding exit message (if no DIMMs are found for
> monitoring) was only at a 'debug' level. As a result, on a system
> without NVDIMMs, the sysadmin might see a 'monitor started' message, but
> a monitor wouldn't actually be running. Making the exit message the same
> log level ensures that no confusion arises out of this.
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 6829a6b..6e7f038 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -646,7 +646,7 @@ int cmd_monitor(int argc, const char **argv, struct
> ndctl_ctx *ctx)
>  		goto out;
> 
>  	if (!mfa.num_dimm) {
> -		dbg(&monitor, "no dimms to monitor\n");
> +		info(&monitor, "no dimms to monitor, exiting\n");
>  		if (!monitor.daemon)
>  			rc = -ENXIO;
>  		goto out;
> --
> 2.20.1

Hi Vishal,

This looks good to me.

Thank you very much.
QI Fuli

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
