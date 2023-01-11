Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331817EA
	for <nvdimm@lists.linux.dev>; Wed, 11 Jan 2023 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673477161; x=1705013161;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pn+2kbMSqRmm1Q5olrfumiTZKGc1LSazcnURq8/HAyE=;
  b=XsuvDu/GajnG+o0Z97Vs816aeLWlQq9TrI68/lLxAGejALISOCrS5NaF
   +qapaF4GL0gs6RzuVAkGyOkjwSTLCoq9AGpvCljHTUElW3QBceM5Y5ba6
   l2Po1e61PD+ZRsNkQP1ZGzBdyEf+3S9IWfGwDbVuFos5zozSGpMSI2IUn
   ov1jC8fRTod6/V9MU4WKXK/lOB8b4WeRLDrh2tFg2Qzeoy3x6MTQcaN5w
   DgNUe1RZhSTQc6p6ismtvzrY4myO6FWmMR7MZ4ZcKrBTWxdK2PE9bm5Os
   pHVcRVaJ2KhhnCddVuxYhuCbyGrIIsP0cKIzsfe0C8sZmwJjQo/sPN/f2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="324794138"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="324794138"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:46:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="657573831"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="657573831"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.147.120])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 14:46:00 -0800
Date: Wed, 11 Jan 2023 14:45:59 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl 1/4] ndctl/lib: fix usage of a non NUL-terminated
 string
Message-ID: <Y788J2sr4WaE9V3i@aschofie-mobl2>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
 <20230110-vv-coverity-fixes-v1-1-c7ee6c76b200@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110-vv-coverity-fixes-v1-1-c7ee6c76b200@intel.com>

On Tue, Jan 10, 2023 at 04:09:14PM -0700, Vishal Verma wrote:
> Static analysis reports that in add_region(), a buffer from pread()
> won't have NUL-termination. Hence passing it to strtol subsequently can
> be wrong. Manually add the termination after pread() to fix this.
> 
> Fixes: c64cc150a21e ("ndctl: add support in libndctl to provide deep flush")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index f32f704..ddbdd9a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2750,6 +2750,8 @@ static void *add_region(void *parent, int id, const char *region_base)
>  		goto out;
>  	}
>  
> +	/* pread() doesn't add NUL termination */
> +	buf[1] = 0;
>  	perm = strtol(buf, NULL, 0);
>  	if (perm == 0) {
>  		close(region->flush_fd);
> 

This diff is annoying because it didn't include enough to show the
pread().  Made me open up file ;)

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> -- 
> 2.39.0
> 
