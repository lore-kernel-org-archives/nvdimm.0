Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35B1421161B0E
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 21:08:41 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D046CAC00D3
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 13:08:34 +0900 (JST)
Date: Fri, 05 Oct 2018 13:08:25 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 1/2] ndctl,
 monitor: fix the severity of the "daemon started" message
In-Reply-To: <20181005000057.30186-1-vishal.l.verma@intel.com>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
Message-Id: <20181005130821.2E72.E1E9C6FF@jp.fujitsu.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andreas Hasenack <andreas@canonical.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Vishal-san,

> The above message was printed as an error, but it is just an
> informational message. Change it to dbg().

Hmmmmmmm.

When I was a engineer for trouble-shooting of customer's Linux system,
the starting time and the ending time of any daemon was very helpful
for investigating their trouble.

So, I think it is not only for developer, but also it is essential for
trouble-shooter for custmer support. 
(It may be also same with system operator)


> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index d29e378..b44f946 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
>  			goto out;
>  		}
> -		err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> +		dbg((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");

Though I agree its message is not "error" certainly,
I would like to keep it as normal status level message.

Thanks,
---
Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
