Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA1C3207E6368
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 11:08:05 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl, monitor: fix monitor can be started though no
 dimm event to monitor
Date: Thu, 19 Jul 2018 18:07:25 +0000
Message-ID: <1532023643.7574.164.camel@intel.com>
References: <20180719085427.17836-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180719085427.17836-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <704C34ACA921374EA74246F79DFC350A@intel.com>
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


On Thu, 2018-07-19 at 17:54 +0900, QI Fuli wrote:
> Currently, the monitor still can be started though there is no dimm event
> to be monitored, which is caused by the typo of uses. In this case,
> no smart event message can be logged.
> This patch is used to fix this bug. When user starts the monitor with
> invalid dimm event in [--dimm-event] option, the monitor will stop and
> output error message.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)

Looks good, applied.

> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 8300250..abab45f 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -413,7 +413,7 @@ static int monitor_event(struct ndctl_ctx *ctx,
>  	return 0;
>  }
>  
> -static int parse_monitor_event(struct monitor *_monitor)
> +static int parse_monitor_event(struct monitor *_monitor, struct ndctl_ctx *ctx)
>  {
>  	char *dimm_event, *save;
>  	const char *event;
> @@ -432,14 +432,18 @@ static int parse_monitor_event(struct monitor *_monitor)
>  		}
>  		if (strcmp(event, "dimm-spares-remaining") == 0)
>  			_monitor->event_flags |= ND_EVENT_SPARES_REMAINING;
> -		if (strcmp(event, "dimm-media-temperature") == 0)
> +		else if (strcmp(event, "dimm-media-temperature") == 0)
>  			_monitor->event_flags |= ND_EVENT_MEDIA_TEMPERATURE;
> -		if (strcmp(event, "dimm-controller-temperature") == 0)
> +		else if (strcmp(event, "dimm-controller-temperature") == 0)
>  			_monitor->event_flags |= ND_EVENT_CTRL_TEMPERATURE;
> -		if (strcmp(event, "dimm-health-state") == 0)
> +		else if (strcmp(event, "dimm-health-state") == 0)
>  			_monitor->event_flags |= ND_EVENT_HEALTH_STATE;
> -		if (strcmp(event, "dimm-unclean-shutdown") == 0)
> +		else if (strcmp(event, "dimm-unclean-shutdown") == 0)
>  			_monitor->event_flags |= ND_EVENT_UNCLEAN_SHUTDOWN;
> +		else {
> +			err(ctx, "no dimm-event named %s\n", event);
> +			return 1;
> +		}
>  	}
>  
>  	free(dimm_event);
> @@ -620,7 +624,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  		notice((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
>  	}
>  
> -	if (parse_monitor_event(&monitor))
> +	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
>  		goto out;
>  
>  	fctx.filter_bus = filter_bus;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
