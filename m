Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40B1E508
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689099171; x=1720635171;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DPDb7HE8r+eZsSUEblVddL/lb8rfKq524Dq+UggIoug=;
  b=fydCmFgmIJEW2LpT8sBGamnBRZz9PQZGEFrw8Z6Bjti9UAKwniOUBAuQ
   iN8BOZjHac1hQiJ15fhsW06gcAWsn/RPZ+THqcZV/mka37JdzelBty2nA
   3mRGwhAysp3cYnlQRxAlqyVGywWrPXYRmuQqS3Yk6rneRk9cdKnP0j2OV
   L/kSfr9Zu7ZQq6pmWuETdTACKJdWGKmreoVXLzdVPXWqned6qp4o2Xipk
   DZW+kvm6Uoj0PxzgZS7q7K3P7Hf4R+s0ZnbF/Q3cqiluHGCK7VvtKl+BQ
   NS/PXldI/neDA9zmaVcG0mKYIdiU4iDgohozT8+EEP0jdUCi5+4yAcfEX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="367297090"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="367297090"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:57:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="811287549"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="811287549"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.140.181])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:57:23 -0700
Date: Tue, 11 Jul 2023 10:57:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v4 1/4] cxl/monitor: Enable default_log and
 refactor sanity check
Message-ID: <ZK2YAbZpJXNa7dw2@aschofie-mobl2>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
 <20230711115344.562823-2-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711115344.562823-2-lizhijian@fujitsu.com>

On Tue, Jul 11, 2023 at 07:53:41PM +0800, Li Zhijian wrote:
> The default_log(/var/log/cxl-monitor.log) should be used when no '-l'
> argument is specified in daemon mode, but it was not working at all.
> 
> Simplify the sanity checks so that the default log file is assigned
> correctly, and the behavior is consistent with the documentation.
> 
> Remove the unnecessary fix_filename() for monitor.log since
> parse_options_prefix() has done similar stuff if needed.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V4: add reviewed tag and minor fixes: comment style and change log.
> V2: exchange order of previous patch1 and patch2 # Alison
>     a few commit log updated
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  cxl/monitor.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index e3469b9a4792..d8245ed8d0e9 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -164,6 +164,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	};
>  	const char *prefix ="./";
>  	int rc = 0, i;
> +	const char *log;
>  
>  	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
>  	for (i = 0; i < argc; i++)
> @@ -171,32 +172,33 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	if (argc)
>  		usage_with_options(u, options);
>  
> +	/* sanity check */
> +	if (monitor.daemon && monitor.log && !strncmp(monitor.log, "./", 2)) {
> +		error("relative path or 'standard' are not compatible with daemon mode\n");
> +		return -EINVAL;
> +	}
> +
>  	log_init(&monitor.ctx, "cxl/monitor", "CXL_MONITOR_LOG");
> -	monitor.ctx.log_fn = log_standard;
> +	if (monitor.log)
> +		log = monitor.log;
> +	else
> +		log = monitor.daemon ? default_log : "./standard";
>  
>  	if (monitor.verbose)
>  		monitor.ctx.log_priority = LOG_DEBUG;
>  	else
>  		monitor.ctx.log_priority = LOG_INFO;
>  
> -	if (monitor.log) {
> -		if (strncmp(monitor.log, "./", 2) != 0)
> -			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
> -			monitor.ctx.log_fn = log_standard;
> -		} else {
> -			const char *log = monitor.log;
> -
> -			if (!monitor.log)
> -				log = default_log;
> -			monitor.log_file = fopen(log, "a+");
> -			if (!monitor.log_file) {
> -				rc = -errno;
> -				error("open %s failed: %d\n", monitor.log, rc);
> -				goto out;
> -			}
> -			monitor.ctx.log_fn = log_file;
> +	if (strncmp(log, "./standard", 10) == 0)
> +		monitor.ctx.log_fn = log_standard;
> +	else {
> +		monitor.log_file = fopen(log, "a+");
> +		if (!monitor.log_file) {
> +			rc = -errno;
> +			error("open %s failed: %d\n", log, rc);
> +			goto out;
>  		}
> +		monitor.ctx.log_fn = log_file;
>  	}
>  
>  	if (monitor.daemon) {
> -- 
> 2.29.2
> 
