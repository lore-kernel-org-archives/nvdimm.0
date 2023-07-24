Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7FB101E5
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 22:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690238876; x=1721774876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/cei8Q8sF5wV/K0QAz96EaF7vEr04Wejo5x1v49LbNg=;
  b=brrFPppycutY2vGvBBCUTiuSa0L8ezy8Z/bWIGElGz+FmKjwKAu6B1PL
   YPpUn6f14CWHTzXV4l302IJXe6UJPivhH4nfkXz95nqXNZQT1BUV9w0Ty
   ag2i70Fz3nKgEErJA3/XJIaGUjStNqolaHoqX33ennBCG6WxulsgFTKe4
   1VxjY7ZvEnd6j17baT9VinyJicRW6uAy0utriF/eg7nfwO1pzHwlGZ1ux
   OugTJm4VAhCCe7D/3YkkpdAiN89te7VJKKBM1N6mJaFXICng4T06pvnTV
   9Tcc1wshUpZPPZ1EZvdXFD8tzT5m3JY3AfbJdzqyIMS3J8ANPfbZnTcWu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="352464720"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="352464720"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 15:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="1056593797"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="1056593797"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.18.188])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 15:47:55 -0700
Date: Mon, 24 Jul 2023 15:47:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] nfit: remove redundant list_for_each_entry
Message-ID: <ZL7/mctQSQ7rtK3X@aschofie-mobl2>
References: <20230719080526.2436951-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719080526.2436951-1-ruansy.fnst@fujitsu.com>

On Wed, Jul 19, 2023 at 04:05:26PM +0800, Shiyang Ruan wrote:
> The first for_each only do acpi_nfit_init_ars() for NFIT_SPA_VOLATILE
> and NFIT_SPA_PM, which can be moved to next one.

Can the result of nfit_spa_type(nfit_spa->spa) change as a result of
the first switch statement? That would be a reason why they are separate.

Alison

> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/acpi/nfit/core.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 07204d482968..4090a0a0505c 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2971,14 +2971,6 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
>  		case NFIT_SPA_VOLATILE:
>  		case NFIT_SPA_PM:
>  			acpi_nfit_init_ars(acpi_desc, nfit_spa);
> -			break;
> -		}
> -	}
> -
> -	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> -		switch (nfit_spa_type(nfit_spa->spa)) {
> -		case NFIT_SPA_VOLATILE:
> -		case NFIT_SPA_PM:
>  			/* register regions and kick off initial ARS run */
>  			rc = ars_register(acpi_desc, nfit_spa);
>  			if (rc)
> -- 
> 2.41.0
> 
