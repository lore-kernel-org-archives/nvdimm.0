Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAAD0210C2D7C
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 13:32:02 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, monitor: add [--verbose] option to emit
 extra debug messages
Date: Thu, 2 Aug 2018 20:32:00 +0000
Message-ID: <1533241918.8557.66.camel@intel.com>
References: <20180802142135.12464-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180802142135.12464-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <FF608BEA2D4F814A87951331B6D9CBFA@intel.com>
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
Cc: "m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-08-02 at 23:21 +0900, QI Fuli wrote:
> In the ndctl monitor, currently the debug messages cannot be outputted to log.
> This patch is used for adding [--verbose] option to ndctl monitor to emit
> debug messages. Also, the log level of some messages are changed by this patch.
> 
> Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  Documentation/ndctl/ndctl-monitor.txt |  4 ++++
>  ndctl/monitor.c                       | 20 +++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)

Looks good, applied.

> 
> diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
> index 762073e..1cba9ea 100644
> --- a/Documentation/ndctl/ndctl-monitor.txt
> +++ b/Documentation/ndctl/ndctl-monitor.txt
> @@ -98,6 +98,10 @@ specified events.
>  	Output monitor notification as human friendly json format instead
>  	of the default machine friendly json format.
>  
> +-v::
> +--verbose::
> +	Emit extra debug messages to log.
> +
>  COPYRIGHT
>  ---------
>  Copyright (c) 2018, FUJITSU LIMITED. License GPLv2: GNU GPL version 2
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 4e5daf5..f10384b 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -22,6 +22,7 @@ static struct monitor {
>  	const char *dimm_event;
>  	bool daemon;
>  	bool human;
> +	bool verbose;
>  	unsigned int event_flags;
>  } monitor;
>  
> @@ -92,7 +93,9 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
>  	f = fopen(monitor.log, "a+");
>  	if (!f) {
>  		ndctl_set_log_fn(ctx, log_syslog);
> -		fail("open logfile %s failed\n%s", monitor.log, buf);
> +		err(ctx, "open logfile %s failed\n", monitor.log);
> +		did_fail = 1;
> +		notice(ctx, "%s\n", buf);
>  		goto end;
>  	}
>  	fprintf(f, "%s", buf);
> @@ -390,8 +393,9 @@ static int monitor_event(struct ndctl_ctx *ctx,
>  			if (util_dimm_event_filter(mdimm, monitor.event_flags)) {
>  				rc = notify_dimm_event(mdimm);
>  				if (rc) {
> -					fail("%s: notify dimm event failed\n",
> +					err(ctx, "%s: notify dimm event failed\n",
>  						ndctl_dimm_get_devname(mdimm->dimm));
> +					did_fail = 1;
>  					goto out;
>  				}
>  			}
> @@ -506,7 +510,7 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
>  
>  	f = fopen(config_file, "r");
>  	if (!f) {
> -		fail("config-file: %s cannot be opened\n", config_file);
> +		err(ctx, "config-file: %s cannot be opened\n", config_file);
>  		rc = -errno;
>  		goto out;
>  	}
> @@ -587,6 +591,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  				"run ndctl monitor as a daemon"),
>  		OPT_BOOLEAN('u', "human", &monitor.human,
>  				"use human friendly output formats"),
> +		OPT_BOOLEAN('v', "verbose", &monitor.verbose,
> +				"emit extra debug messages to log"),
>  		OPT_END(),
>  	};
>  	const char * const u[] = {
> @@ -607,7 +613,11 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  
>  	/* default to log_standard */
>  	ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
> -	ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
> +
> +	if (monitor.verbose)
> +		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
> +	else
> +		ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
>  
>  	rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
>  	if (rc)
> @@ -629,7 +639,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
>  			goto out;
>  		}
> -		notice((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> +		err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
>  	}
>  
>  	if (parse_monitor_event(&monitor, (struct ndctl_ctx *)ctx))
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
