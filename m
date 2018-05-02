Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2666320352138
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 13:56:43 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] pmem: fix badblocks population for raw mode
References: <20180425161125.8082-1-toshi.kani@hpe.com>
Date: Wed, 02 May 2018 16:56:41 -0400
In-Reply-To: <20180425161125.8082-1-toshi.kani@hpe.com> (Toshi Kani's message
 of "Wed, 25 Apr 2018 10:11:25 -0600")
Message-ID: <x49o9hx7p4m.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Toshi Kani <toshi.kani@hpe.com> writes:

> pmem_attach_disk() calls nvdimm_badblocks_populate() with resource
> range uninitialized in the case of raw mode.  This leads the pmem
> driver to hit MCE despite of ARS reporting the range bad.
>
> Initialize 'bb_res' for raw mode.
>
> Fixes: e8d513483300 ("memremap: change devm_memremap_pages interface to use struct dev_pagemap")
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  drivers/nvdimm/pmem.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 9d714926ecf5..2d7875209bce 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -367,9 +367,11 @@ static int pmem_attach_disk(struct device *dev,
>  		addr = devm_memremap_pages(dev, &pmem->pgmap);
>  		pmem->pfn_flags |= PFN_MAP;
>  		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
> -	} else
> +	} else {
>  		addr = devm_memremap(dev, pmem->phys_addr,
>  				pmem->size, ARCH_MEMREMAP_PMEM);
> +		memcpy(&bb_res, res, sizeof(bb_res));
> +	}
>  
>  	/*
>  	 * At release time the queue must be frozen before
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
