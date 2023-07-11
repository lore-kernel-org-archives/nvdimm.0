Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9441DDD9
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689098294; x=1720634294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LrQ2feoJb0lTsvXApIj7daksJddOoRFr0OInB5Y1dyY=;
  b=KxOxoYZfohd5+Z77fyMUNyzR8Al758O3B5pw1f3/bcRNeJiy9tXGII8I
   QA60IsemS1CfW6N8envrzMsE7lPKCYmBjbUKviIspp1DcNfRMRYEgKdOs
   XktAiq+zHhbv1Yi/DqQcuKCHWpiF5KsHgmV/MnLcVH6L+y7zoUNW+QmhO
   2Tnx9jz6/By8QkLg+Ptit+6/84Ib9uibVjqFrDr2b80v/asS9iGKWufDX
   t8bbz8ZAU7JlEyaSaP+LSctvn/q0FBm4OLFP5O4rRvYGMaGsUgAnJFsdL
   2cF2qAbLf58K4fqHcTmyAQeNYtGCj/81oiksdhUNEcLpH90BtJ4XQtF2m
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="362159132"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="362159132"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:58:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="715255731"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="715255731"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.140.181])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:58:12 -0700
Date: Tue, 11 Jul 2023 10:58:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v4 3/4] ndctl: use strcmp for reserved word in
 monitor commands
Message-ID: <ZK2YM7nlCrEmz1+9@aschofie-mobl2>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
 <20230711115344.562823-4-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711115344.562823-4-lizhijian@fujitsu.com>

On Tue, Jul 11, 2023 at 07:53:43PM +0800, Li Zhijian wrote:
> According to the tool's documentation, when '-l standard' is specified,
> log would be output to the stdout. But since it's using strncmp(a, b, 10)
> to compare the former 10 characters, it will also wrongly detect a filename
> starting with a substring 'standard' as stdout.
> 
> For example:
> $ cxl monitor -l standard.log
> 
> User is most likely want to save log to ./standard.log instead of stdout.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V4: combine ndctl/monitor to one patch
> V3: Improve commit log # Dave
> V2: commit log updated # Dave
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  cxl/monitor.c   | 2 +-
>  ndctl/monitor.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index e83455b63d35..a85452a4dc82 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -188,7 +188,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	else
>  		monitor.ctx.log_priority = LOG_INFO;
>  
> -	if (strncmp(log, "./standard", 10) == 0)
> +	if (strcmp(log, "./standard") == 0)
>  		monitor.ctx.log_fn = log_standard;
>  	else {
>  		monitor.ctx.log_file = fopen(log, "a+");
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 89903def63d4..bd8a74863476 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -610,9 +610,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>  	if (monitor.log) {
>  		if (strncmp(monitor.log, "./", 2) != 0)
>  			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./syslog", 8) == 0)
> +		if (strcmp(monitor.log, "./syslog") == 0)
>  			monitor.ctx.log_fn = log_syslog;
> -		else if (strncmp(monitor.log, "./standard", 10) == 0)
> +		else if (strcmp(monitor.log, "./standard") == 0)
>  			monitor.ctx.log_fn = log_standard;
>  		else {
>  			monitor.ctx.log_file = fopen(monitor.log, "a+");
> -- 
> 2.29.2
> 
