Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DB38F77
	for <nvdimm@lists.linux.dev>; Sun, 21 May 2023 20:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684701666; x=1716237666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bi/+A3psGNIPp1stMfOH0avQWxfD0lsYiQ/PojOlq/U=;
  b=UPBZVI3iuTe1mybdstSTNR6vZvTyNa4T+c2ZCSj9/2SlXnTNAI3xhVnL
   izsgehYECKL2yyxjwMDNkHEfoWZ3qiTj98QUM1w74aI51wh+wWLv+3GWf
   GTKoY2qnqCr20r7ErTqNbMrLdeZK0THM3DP5j3mLpLZnK78QXX1rUoeOW
   cGaiHv6lkpk0PqEUd4xc0q6OuWQ/X6Z0vaiZpvSbxA+0ji7hz/XBr8CpW
   OyT4iAoUnXtrgS33oSsTl7s/SKgqgEV4tAfmSrBiV8QnnBot2xuBnyz5K
   v8sZ5pvtQjgrWv1M1rx2mAWUQCIrCw551oXSIwElseIYCyXKEY/7c75Y3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="342218584"
X-IronPort-AV: E=Sophos;i="6.00,182,1681196400"; 
   d="scan'208";a="342218584"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 13:41:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815421260"
X-IronPort-AV: E=Sophos;i="6.00,182,1681196400"; 
   d="scan'208";a="815421260"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.252.139.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 13:41:05 -0700
Date: Sun, 21 May 2023 13:41:03 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 3/6] cxl/monitor: Enable default_log and refactor
 sanity check
Message-ID: <ZGqB38I7hLvX+xCG@aschofie-mobl2>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-4-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230513142038.753351-4-lizhijian@fujitsu.com>

On Sat, May 13, 2023 at 10:20:35PM +0800, Li Zhijian wrote:
> The default_log is not working at all. Simply the sanity check and
> re-enable default log file so that it can be consistent with the
> document.
> 
> Please note that i also removed following addition stuff, since we have
> added this prefix if needed during parsing the FILENAME.
> if (strncmp(monitor.log, "./", 2) != 0)
>     fix_filename(prefix, (const char **)&monitor.log);

Hi Zhijian,

I reviewed the first patch, without looking at all the patches in
the set. It seems like the set touches cmd_monitor() at least 2
times, and then dives into refactoring it.

I'm confused. I think I could be less confused with a cover letter
explaining the flow of this set. Maybe the flow of the set can be
improved. It seems they are presented in the order that you discovered
an issue, and that may not be the cleanest way to present them for
merging.

Thanks,
Alison

> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  cxl/monitor.c | 41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 842e54b186ab..139506aed85a 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -163,6 +163,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	};
>  	const char *prefix ="./";
>  	int rc = 0, i;
> +	const char *log;
>  
>  	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
>  	for (i = 0; i < argc; i++)
> @@ -170,32 +171,32 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	if (argc)
>  		usage_with_options(u, options);
>  
> -	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
> -	monitor.ctx.log_fn = log_standard;
> +	// sanity check
> +	if (monitor.daemon && monitor.log && !strncmp(monitor.log, "./", 2)) {
> +		error("standard or relative path for <file> will not work for daemon mode\n");
> +		return -EINVAL;
> +	}
> +
> +	if (monitor.log)
> +		log = monitor.log;
> +	else
> +		log = monitor.daemon ? default_log : "./standard";
>  
> +	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
>  	if (monitor.verbose)
>  		monitor.ctx.log_priority = LOG_DEBUG;
>  	else
>  		monitor.ctx.log_priority = LOG_INFO;
>  
> -	if (monitor.log) {
> -		if (strncmp(monitor.log, "./", 2) != 0)
> -			fix_filename(prefix, (const char **)&monitor.log);
> -
> -		if (strcmp(monitor.log, "./standard") == 0 && !monitor.daemon) {
> -			monitor.ctx.log_fn = log_standard;
> -		} else {
> -			const char *log = monitor.log;
> -
> -			if (!monitor.log)
> -				log = default_log;
> -			monitor.ctx.log_file = fopen(log, "a+");
> -			if (!monitor.ctx.log_file) {
> -				rc = -errno;
> -				error("open %s failed: %d\n", monitor.log, rc);
> -				goto out;
> -			}
> -			monitor.ctx.log_fn = log_file;
> +	if (strcmp(log, "./standard") == 0)
> +		monitor.ctx.log_fn = log_standard;
> +	else {
> +		monitor.ctx.log_fn = log_file;
> +		monitor.ctx.log_file = fopen(log, "a+");
> +		if (!monitor.ctx.log_file) {
> +			rc = -errno;
> +			error("open %s failed: %d\n", log, rc);
> +			goto out;
>  		}
>  	}
>  
> -- 
> 2.29.2
> 
> 
