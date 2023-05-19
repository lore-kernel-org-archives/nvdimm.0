Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241DF12B66
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684518288; x=1716054288;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=YtCG9jHocuuNnvHAOVrIasyRr7jhniEN7xbBs6jUImE=;
  b=brONyAKGfIrh1Au0izVyjnYi6JQz7NhZ1efU4gibDbG878yXnG5DmQr5
   vE8FO84MqXuR7Knwg1SpRuDyzLL594hwNgHdEva0/l8YPqccKAg0/FmzX
   gpDbW0uOxWxNclR1VrgKjB6tFtUMLX/r4jnP4vxjpPOrhe/NXZ4sOh35Y
   guxpY/1rD7g7xPEjI/s4U5Tsz7W+mw0EcF+9YpDFUVo1q40O7batZlssd
   aOFoIoLAhl8aqnnmaA/K+5AF/bZcCCkOYy260bqmrXQpQA1TPXL5w1q8k
   870X+kFR9By8md4rM2pJ6mmTdTcA1D2zHnFQuYReNmotls+WsNABrjr2K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="380654716"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="380654716"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:44:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="876918878"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="876918878"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:44:47 -0700
Message-ID: <8980715c-f9f2-9845-7904-d8eefe0f5122@intel.com>
Date: Fri, 19 May 2023 10:44:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 6/6] ndctl/monitor: compare the whole filename with
 reserved words
Content-Language: en-US
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-7-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-7-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> For example:
> $ ndctl monitor -l standard.log
> User is most likely want to save log to ./standard.log instead of stdout.

Same comment as patch 1. Commit log does not match code change. Please 
explain.

> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>   ndctl/monitor.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 89903def63d4..bd8a74863476 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -610,9 +610,9 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>   	if (monitor.log) {
>   		if (strncmp(monitor.log, "./", 2) != 0)
>   			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./syslog", 8) == 0)
> +		if (strcmp(monitor.log, "./syslog") == 0)
>   			monitor.ctx.log_fn = log_syslog;
> -		else if (strncmp(monitor.log, "./standard", 10) == 0)
> +		else if (strcmp(monitor.log, "./standard") == 0)
>   			monitor.ctx.log_fn = log_standard;
>   		else {
>   			monitor.ctx.log_file = fopen(monitor.log, "a+");
