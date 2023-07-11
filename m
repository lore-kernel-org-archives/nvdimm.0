Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EA81DDD9
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689098270; x=1720634270;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xWZgdq/xMsRJCt7KCxaxxP12QnJT/xRhH8wPutNIpew=;
  b=DsQYJOY9sAQW7cYfIHMewfhlwlF5ui+q4xBWECzJ+r8EtTXpDAY0llwv
   OyynldpMVsM9wQaKmEqWytG2Ts4LvIbE+LGjkgq8TKrzSR941V+80Cv8y
   xHPVIKG+885UxrAG/KrH+dIZVjCDOdLL/ASYh+kNQu15jPvNc6jZ1BpfY
   vyD/aii9AxJqLNQIL5woE9lcpFi3doRFMKcp/bHQxVt0Wnpg+o7gsllse
   zIG+HMyNKYO++IqTDqlHJzJm1b6X+GNlJ/wj29skUz1vT7YFLOFihgpJV
   pkQkOJ7KKEL/+ZmNuQbrNmUZ28OaF7a2x85qVwAKR13b99rXDkpqkcCec
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="362159060"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="362159060"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="715255663"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="715255663"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.140.181])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:57:49 -0700
Date: Tue, 11 Jul 2023 10:57:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v4 2/4] cxl/monitor: replace monitor.log_file with
 monitor.ctx.log_file
Message-ID: <ZK2YG3eol0NgNjBG@aschofie-mobl2>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
 <20230711115344.562823-3-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711115344.562823-3-lizhijian@fujitsu.com>

On Tue, Jul 11, 2023 at 07:53:42PM +0800, Li Zhijian wrote:
> Commit ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
> have replaced monitor.log_file with monitor.ctx.log_file for
> ndctl-monitor, but for cxl-monitor, it forgot to do such work.
> 
> So where user specifies its own logfile, a segmentation fault will be
> trggered like below:
> 
>  # build/cxl/cxl monitor -l ./monitor.log
> Segmentation fault (core dumped)

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V4: add reviewed tag
> V2: exchange order of previous patch1 and patch2 # Alison
>     a few commit log updated
> ---
>  cxl/monitor.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index d8245ed8d0e9..e83455b63d35 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -37,7 +37,6 @@ const char *default_log = "/var/log/cxl-monitor.log";
>  static struct monitor {
>  	const char *log;
>  	struct log_ctx ctx;
> -	FILE *log_file;
>  	bool human;
>  	bool verbose;
>  	bool daemon;
> @@ -192,8 +191,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	if (strncmp(log, "./standard", 10) == 0)
>  		monitor.ctx.log_fn = log_standard;
>  	else {
> -		monitor.log_file = fopen(log, "a+");
> -		if (!monitor.log_file) {
> +		monitor.ctx.log_file = fopen(log, "a+");
> +		if (!monitor.ctx.log_file) {
>  			rc = -errno;
>  			error("open %s failed: %d\n", log, rc);
>  			goto out;
> @@ -212,7 +211,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  	rc = monitor_event(ctx);
>  
>  out:
> -	if (monitor.log_file)
> -		fclose(monitor.log_file);
> +	if (monitor.ctx.log_file)
> +		fclose(monitor.ctx.log_file);
>  	return rc;
>  }
> -- 
> 2.29.2
> 
