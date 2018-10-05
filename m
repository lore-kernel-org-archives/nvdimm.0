Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1199321A09130
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 22:15:46 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 98F4AAC024D
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 14:15:39 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 2/2] ndctl, monitor: in daemon mode, exit
 successfully if no DIMMs are found
Date: Fri, 5 Oct 2018 05:15:38 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DAF8E95@g01jpexmbkw24>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
 <20181005000057.30186-2-vishal.l.verma@intel.com>
In-Reply-To: <20181005000057.30186-2-vishal.l.verma@intel.com>
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
Cc: Andreas Hasenack <andreas@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com]
> Sent: Friday, October 5, 2018 9:01 AM
> To: linux-nvdimm@lists.01.org
> Cc: Qi, Fuli/斉 福利 <qi.fuli@jp.fujitsu.com>; Andreas Hasenack
> <andreas@canonical.com>; Vishal Verma <vishal.l.verma@intel.com>; Dan
> Williams <dan.j.williams@intel.com>
> Subject: [ndctl PATCH 2/2] ndctl, monitor: in daemon mode, exit successfully if no
> DIMMs are found
> 
> When we are running as a daemon, it is preferred to exit successfully when no DIMMs
> are found. When running in the foreground, retain an error return so that the user can
> be notified that nothing was found to monitor.
> 
> In the longer term, replace this with a libudev uevent monitor that will look for DIMM
> addition/removal events, and update the running monitor(s) if the DIMMs match the
> active filter spec.
> 
> Link: https://bugs.launchpad.net/ubuntu/+source/ndctl/+bug/1781268
> Reported-by: Andreas Hasenack <andreas@canonical.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/monitor.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index b44f946..7bf2ba7 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -681,8 +681,9 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  		goto out;
> 
>  	if (!mfa.num_dimm) {
> -		err((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
> -		rc = -ENXIO;
> +		dbg((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
> +		if (!monitor.daemon)
> +			rc = -ENXIO;
>  		goto out;
>  	}
> 
> --
> 2.17.1
> 

Looks good to me.

Thank you very much,
QI Fuli

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
