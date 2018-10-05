Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1466F2112944B
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 13:04:01 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl, monitor: fix the sevrity of "daemon started"
 message
Date: Fri, 5 Oct 2018 20:01:44 +0000
Message-ID: <bc76df4b87a09567c348312a7663a36bfd268adf.camel@intel.com>
References: <20181005070124.6429-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20181005070124.6429-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <42CAFC07601C3C419DB34F6705BE3C4F@intel.com>
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


On Fri, 2018-10-05 at 16:01 +0900, QI Fuli wrote:
> The "daemon started" message was printed as an error and this is improper.
> This patch is used to chang it to info() meanwhile to chang the default log
> level of monitor to "LOG_INFO".
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Qi! Applied.

> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index d29e378..17465bb 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -628,7 +628,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  	if (monitor.verbose)
>  		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
>  	else
> -		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
> +		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
>  
>  	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
>  	if (rc)
> @@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
>  			goto out;
>  		}
> -		err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> +		info((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
>  	}
>  
>  	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
