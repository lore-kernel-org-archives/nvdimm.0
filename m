Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE25B12B66
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684518193; x=1716054193;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=wJBb3qgSOtaExHqlSPzdOtDMzu/Y8ALn4VAIVnZNl8E=;
  b=I7F/jlmMBm/T6gSFUT32lFshl5TeQnpm+QmyvP8+LMLXJF6HfQJDUOLK
   81piuVk6DEzsUharo74nc60rAZMsi6SeXomJ+RUvShvIlCmhBKHy7j2oK
   1Gn7zm95B+ljxNGuIDtzJACs+PcjBcwQb/zF2utCEvQhrsAiJgLPTCm97
   dCmIEwNWwKfbeoeeTjCNRG4CKre2Ob2n2BFXszRjXE8Zprivk33Hrq6AZ
   ptEgjOeB1Y4Bipha+HIlDj8qjs9WSSNpYU8SfWz1ui+5faoLMkTR3il3w
   jwDOWSgkW5qiLvc8DBk4hRUpUYNu7H1E7ZDwGdmA7ZYjIuD2C81uvxM4A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="380653889"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="380653889"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:43:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="876918777"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="876918777"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:43:09 -0700
Message-ID: <29980935-054d-134a-88b6-b9062e8a1761@intel.com>
Date: Fri, 19 May 2023 10:43:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 4/6] cxl/monitor: always log started message
Content-Language: en-US
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-5-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-5-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> Tell people monitor is starting

Commit log terse and non-informative. Please describe what was the past 
behavior and what is the new behavior. Thank you.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>   cxl/monitor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 139506aed85a..6761f3bb97af 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -205,8 +205,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   			err(&monitor, "daemon start failed\n");
>   			goto out;
>   		}
> -		info(&monitor, "cxl monitor daemon started.\n");
>   	}
> +	info(&monitor, "cxl monitor started.\n");
>   
>   	rc = monitor_event(ctx);
>   
