Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB666FAB
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676997904; x=1708533904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=511FxfavKLa+zYcbLl4LtR0A/68N+zMevCnXerlbW5g=;
  b=lVH/zlvF6GvuYfutmSeA8XAGvBNkjLW1fPFMlF4h25aGpv3jIWTewEsO
   5aDVjn4LrCraL20N7/UvY4ktLQmPNntYGOVzm5InS7Hjrzyl3tdc2Ks/e
   i3AJh0qbWJ4igkgP+DrjQFaWh+XugM+D8UKj7FP/AbRz92WDJ18JwSnLm
   S7UR8L14OnSNjnBdEDH4SH4UjRgG2TQMdGrx+wpdGmxrs/SHWXNmHiPyq
   mgZMz6YznYU/sOoVi9V8wzAxBljNFR+yyQoZoB15vSDTYw2IrvZr7lNDD
   VQMRz8JfCUIdDigAqe5PulYsTJD6gksvK9Dmu9nHd6QROp1vLqrqcIijU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="334880012"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="334880012"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:45:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="845740832"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="845740832"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.184.163]) ([10.213.184.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:45:03 -0800
Message-ID: <558347b8-2843-bed3-6544-5b0cd105a868@intel.com>
Date: Tue, 21 Feb 2023 09:45:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl 2/3] cxl/monitor: retain error code in
 monitor_event()
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/17/23 5:40 PM, Vishal Verma wrote:
> Static analysis reports that the error unwinding path in monitor_event()
> overwrites 'rc' with the return from cxl_event_tracing_disable(). This
> masks the actual error code from either epoll_wait() or
> cxl_parse_events() which is the one that should be propagated.
> 
> Print a spot error in case there's an error while disabling tracing, but
> otherwise retain the rc from the main body of the function.
> 
> Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/monitor.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/monitor.c b/cxl/monitor.c
> index 31e6f98..749f472 100644
> --- a/cxl/monitor.c
> +++ b/cxl/monitor.c
> @@ -130,7 +130,8 @@ static int monitor_event(struct cxl_ctx *ctx)
>   	}
>   
>   parse_err:
> -	rc = cxl_event_tracing_disable(inst);
> +	if (cxl_event_tracing_disable(inst) < 0)
> +		err(&monitor, "failed to disable tracing\n");
>   event_en_err:
>   epoll_ctl_err:
>   	close(fd);
> 
