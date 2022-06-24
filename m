Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9061FC8;
	Fri, 24 Jun 2022 03:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656041941; x=1687577941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NtFtE7qW+K5DUFG3lDhxsR2HkHFGEJGYMaA9IZdhYVk=;
  b=WHos6LBquR8+aL8pxXq4oU+e7VYZwzg73U/QMZEwa1BbiyjNEqWCG2lO
   dwojDtikFA4laFy2lBnZCddPmwz3oSkX7mqpfLe8OVj9TiITWlqA4F6Uu
   fLEUBi/ymiIj2cNQ/SNk2bsB1XWg+tB9aoQZmciDlE6NXBLNdfYBVSHxi
   bAeFVk9qrLbd0pRlRUBD1Fru47HQPIvsGNcqVmSzUpZx/PA3mcBKzNn/s
   fLAPe9F3E8ArcKUH0vRUjjzx2qksXyvtOdOxYIE5YuMYUSXhamZ29nXXC
   FvfufKI0BJJelIel4HYbvDO54zYIyX/lxmZFK3UgFXjsCyZtOeQBPgqQ7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="279679749"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="279679749"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:39:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="645080505"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 20:39:00 -0700
Date: Thu, 23 Jun 2022 20:38:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Ben Widawsky <bwidawsk@kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 03/46] cxl/hdm: Use local hdm variable
Message-ID: <20220624033824.GB1558591@alison-desk>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
 <165603872171.551046.913207574344536475.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165603872171.551046.913207574344536475.stgit@dwillia2-xfh>

On Thu, Jun 23, 2022 at 07:45:21PM -0700, Dan Williams wrote:
> From: Ben Widawsky <bwidawsk@kernel.org>
> 
> Save a few characters and use the already initialized local variable.
> 
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  drivers/cxl/core/hdm.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index bfc8ee876278..ba3d2d959c71 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -251,8 +251,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  			return PTR_ERR(cxld);
>  		}
>  
> -		rc = init_hdm_decoder(port, cxld, target_map,
> -				      cxlhdm->regs.hdm_decoder, i);
> +		rc = init_hdm_decoder(port, cxld, target_map, hdm, i);
>  		if (rc) {
>  			put_device(&cxld->dev);
>  			failed++;
> 
