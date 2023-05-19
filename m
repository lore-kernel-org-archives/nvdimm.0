Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014EA3D3A1
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684517497; x=1716053497;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=E3CvmldCuHcmJjnfAv6jMo0pQKuYfvKlqJ2c1Yv2oYg=;
  b=kfu55ElYQJJdeevSF55zbRv335GDR0EUPZdmi9SKck0IzDetq4/IHV3v
   ++tcoyJFem5vBnpKmPJMYa1dHEbh9lXFAaslQSwjAi+sFXMTnHku1u3KT
   ThVkEIziC9sXESLR9OXmiPz28iZ3CDnDbkqhRDCTZVqV6EsrCRAZAydzD
   wW98IWIRLnaarbays/0diKbXFQgTJH1vgNwI9Fl41FVt6LcrPOjOUw5C3
   y9QmIRtOICz/HCi3a0OZ7mWC4lw/kIs1ooZ/yoigynkqCae0VVBdId6g1
   Et6QSJjLAA0uZhEVfSHUsobPOophCmegn6ZaVCtPJo/pZJ9n0W6ljjH7a
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="351275322"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="351275322"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:31:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="767683626"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="767683626"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:31:18 -0700
Message-ID: <e4ebdde3-e51a-be42-135f-f0b3d78259b0@intel.com>
Date: Fri, 19 May 2023 10:31:17 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 2/6] cxl/monitor: compare the whole filename with
 reserved words
Content-Language: en-US
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-3-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-3-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> For example:
> $ cxl monitor -l standard.log
> 
> User is most likely want to save log to ./standard.log instead of stdout.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>   cxl/monitor.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 4043928db3ef..842e54b186ab 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -181,7 +181,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>   	if (monitor.log) {
>   		if (strncmp(monitor.log, "./", 2) != 0)
>   			fix_filename(prefix, (const char **)&monitor.log);
> -		if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
> +
> +		if (strcmp(monitor.log, "./standard") == 0 && !monitor.daemon) {

The code change doesn't match the commit log. Here it just changed from 
strncmp() to strcmp(). Please explain what's going on here.

>   			monitor.ctx.log_fn = log_standard;
>   		} else {
>   			const char *log = monitor.log;
