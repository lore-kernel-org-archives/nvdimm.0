Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAFC7EA
	for <nvdimm@lists.linux.dev>; Sun, 21 May 2023 20:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684701102; x=1716237102;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HjxzYwgAmvLEjhmpDkyl2iV84vXQHcagtXLi2Bnh1xs=;
  b=JostGWVHQDQpw7UHt0AtHw8hOWq48vSJ+2Fzr/05RLr37kSz+UZY5Z1C
   l9ZlqrtG9SuvgqwhKLD7w8sqe/edKgak4bKYAE3hy8M5evvatBHQBwXA5
   AZVQGRMVrHPgVy66uFm/zk0X+/JHlgckylPEeUM6Hcs+T30D8UUGCG6yw
   2yAKmSAARkk2gtBdony86clPDgGTUvotde4OLQftJOQR7it3u2bUrKGhN
   1Q30XCn7aRF8998KVQG7jMTJREhHHEdSHW7wS2xHi8oekDvIIEDcptiEA
   I9OzQdvADZnSDYOqq1oQnCzPa3O5UGx3DQcSOClHTKp2hvnJkNunC+g3g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="355992592"
X-IronPort-AV: E=Sophos;i="6.00,182,1681196400"; 
   d="scan'208";a="355992592"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 13:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="703251029"
X-IronPort-AV: E=Sophos;i="6.00,182,1681196400"; 
   d="scan'208";a="703251029"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.252.139.111])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 13:31:40 -0700
Date: Sun, 21 May 2023 13:31:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Message-ID: <ZGp/rOJTXMN8ruor@aschofie-mobl2>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-2-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230513142038.753351-2-lizhijian@fujitsu.com>

On Sat, May 13, 2023 at 10:20:33PM +0800, Li Zhijian wrote:
> It looks that someone forgot to rewrite this part after
> ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
> 
>  # build/cxl/cxl monitor -l ./monitor.log
> Segmentation fault (core dumped)
> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Hi Zhijian,

A more explicit commit message would be helpful, something like:
cxl/monitor: replace monitor.log_file with monitor.ctx.log_file

I understand your "It looks that someone forgot...", and it may be
true, but that is only pertinent in the commit log if it actually
caused the problem. In this case, it didn't because it merged before
the patch in your Fixes Tag.

I'd expect this commit log to include:
1) why it's broken - inconsistent use of 'log_file'
2) impact on user
3) steps to reproduce

And, a little bit more below...


> ---
>  cxl/monitor.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index e3469b9a4792..4043928db3ef 100644
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
> @@ -189,8 +188,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>  
>  			if (!monitor.log)
>  				log = default_log;

Can the above 'if' ever happen here?  Seems we checked for monitor.log
a few lines above?

Thanks,
Alison


> -			monitor.log_file = fopen(log, "a+");
> -			if (!monitor.log_file) {
> +			monitor.ctx.log_file = fopen(log, "a+");
> +			if (!monitor.ctx.log_file) {
>  				rc = -errno;
>  				error("open %s failed: %d\n", monitor.log, rc);
>  				goto out;
> @@ -210,7 +209,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
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
> 
