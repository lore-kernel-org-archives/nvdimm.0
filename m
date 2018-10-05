Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1ECA021962301
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:19:57 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, pmem: Fix badblocks population for 'raw'
 namespaces
Date: Fri, 5 Oct 2018 00:19:55 +0000
Message-ID: <cdba20f7ba8186862f8b3596b0766be240297162.camel@intel.com>
References: <153869739732.2904401.10895695693942634646.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153869739732.2904401.10895695693942634646.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <447E5AF6DDADFC4BBD954C7C29688426@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Zloch, Jacek" <jacek.zloch@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "Rusocki, Krzysztof" <krzysztof.rusocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-10-04 at 16:56 -0700, Dan Williams wrote:
> The driver is only initializing bb_res in the devm_memremap_pages()
> paths, but the raw namespace case is passing an uninitialized bb_res
> to
> nvdimm_badblocks_populate().
> 
> Fixes: e8d513483300 ("memremap: change devm_memremap_pages
> interface...")
> Cc: <stable@vger.kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/pmem.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 6071e2942053..2082ae01b9c8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -421,9 +421,11 @@ static int pmem_attach_disk(struct device *dev,
>  		addr = devm_memremap_pages(dev, &pmem->pgmap);
>  		pmem->pfn_flags |= PFN_MAP;
>  		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
> -	} else
> +	} else {
>  		addr = devm_memremap(dev, pmem->phys_addr,
>  				pmem->size, ARCH_MEMREMAP_PMEM);
> +		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
> +	}


Good find!
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
