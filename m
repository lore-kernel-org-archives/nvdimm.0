Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15410979
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684517285; x=1716053285;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=eyxxaARhhzA9TbRwaf0PshpLPmSq3sUupL2viL0r5tQ=;
  b=gF0b8C7yeyjfWJ/s/QgVJc+0XVFB/lvBWkcSWrRtM038kb7r+iwsoz7Q
   5oA2GB6wmBIc5sPIXOhoZls8PL8AYnuS5hNdCqb4Xg6VD00kBvhhtKxQY
   Dmgj6I5r1jWgf2RAhT9q8EagZdSVQMpS+R56TZ5kYeP+yUy+6p0cX87eu
   y02lBs6l0bpDDa735XZvNPhUErk8Q7PKjBvkxNdS7VYbSGD9lOxUwU2B7
   iTwlbIgXf6iqz2fCmbpBgmdcmy+6P2lAfp1lbh1DOFg2nq5rfZleb/c20
   edMsezhXD+6JHHym61cNLsAA+Tub3ir6PXjqrAnyxCCwtL754QymExdtw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="337024154"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="337024154"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:27:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="846958804"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="846958804"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:27:56 -0700
Message-ID: <4434dadb-2b58-760c-c602-f7a347cacc2b@intel.com>
Date: Fri, 19 May 2023 10:27:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 1/6] cxl/monitor: Fix monitor not working
Content-Language: en-US
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-2-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> It looks that someone forgot to rewrite this part after
> ba5825b0b7e0 ("ndctl/monitor: move common logging functions to util/log.c")
> 
>   # build/cxl/cxl monitor -l ./monitor.log
> Segmentation fault (core dumped)
> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/monitor.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index e3469b9a4792..4043928db3ef 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -37,7 +37,6 @@ const char *default_log = "/var/log/cxl-monitor.log";
>   static struct monitor {
>   	const char *log;
>   	struct log_ctx ctx;
> -	FILE *log_file;
>   	bool human;
>   	bool verbose;
>   	bool daemon;
> @@ -189,8 +188,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   
>   			if (!monitor.log)
>   				log = default_log;
> -			monitor.log_file = fopen(log, "a+");
> -			if (!monitor.log_file) {
> +			monitor.ctx.log_file = fopen(log, "a+");
> +			if (!monitor.ctx.log_file) {
>   				rc = -errno;
>   				error("open %s failed: %d\n", monitor.log, rc);
>   				goto out;
> @@ -210,7 +209,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	rc = monitor_event(ctx);
>   
>   out:
> -	if (monitor.log_file)
> -		fclose(monitor.log_file);
> +	if (monitor.ctx.log_file)
> +		fclose(monitor.ctx.log_file);
>   	return rc;
>   }
