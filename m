Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68EF1E508
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689099239; x=1720635239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Yv/cZ6RYNvsCj4aSBTsKLXR9mnOz02x1pNaZWd/vrU=;
  b=QFD+t/WdryPdFp6CTcsQgAwuDO8WKt21aueGw9DWe4gP8X3OTDSvTCv6
   76mIIw6ZlgukdYcyTHKO+w+r40HQLLYDcJrzUIl3YBShXAAAgZoZEuGJW
   p5y/xWTow3sBooqHiMJNFMMnG2hYrmKnP5nq5V8w/XQI6wzJEMQBlbFyi
   wkuDgiEfzH8R5c4xmqGLAAs2daroLYpIJjnMruYjzhzfO2uPFl1jlZHJM
   b2D+R28YTedWGuhEXn4lmu75iOfDSakhaj6N953ja+UBam6f8oCBTPBf5
   J8UlvtOCNqi8B3U/oHicqayIrA5V9kJtau6yiS4uowJ7cVZ6ChiSfpFKA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="354580631"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="354580631"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:58:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="750863490"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="750863490"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.140.181])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:58:35 -0700
Date: Tue, 11 Jul 2023 10:58:33 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v4 4/4] Documentation/cxl/cxl-monitor.txt: Fix
 inaccurate description
Message-ID: <ZK2YSQPSPbofvV7y@aschofie-mobl2>
References: <20230711115344.562823-1-lizhijian@fujitsu.com>
 <20230711115344.562823-5-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711115344.562823-5-lizhijian@fujitsu.com>

On Tue, Jul 11, 2023 at 07:53:44PM +0800, Li Zhijian wrote:
> No syslog is supported by cxl-monitor

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V2: add Reviewed-by tag
> ---
>  Documentation/cxl/cxl-monitor.txt | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-monitor.txt b/Documentation/cxl/cxl-monitor.txt
> index 3fc992e4d4d9..c284099f16c3 100644
> --- a/Documentation/cxl/cxl-monitor.txt
> +++ b/Documentation/cxl/cxl-monitor.txt
> @@ -39,8 +39,7 @@ OPTIONS
>  --log=::
>  	Send log messages to the specified destination.
>  	- "<file>":
> -	  Send log messages to specified <file>. When fopen() is not able
> -	  to open <file>, log messages will be forwarded to syslog.
> +	  Send log messages to specified <file>.
>  	- "standard":
>  	  Send messages to standard output.
>  
> -- 
> 2.29.2
> 
