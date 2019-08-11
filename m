Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5800121959CB2
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 15:55:27 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 2/5] resource: add a not device managed
 request_free_mem_region variant
Date: Sun, 11 Aug 2019 22:52:58 +0000
Message-ID: <20190811225252.GB15116@mellanox.com>
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-3-hch@lst.de>
In-Reply-To: <20190811081247.22111-3-hch@lst.de>
Content-Language: en-US
Content-ID: <821914AB69678F44867B3E27B8469A9F@eurprd05.prod.outlook.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 11, 2019 at 10:12:44AM +0200, Christoph Hellwig wrote:
> Just add a simple macro that passes a NULL dev argument to
> dev_request_free_mem_region, and call request_mem_region in the
> function for that particular case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  include/linux/ioport.h | 2 ++
>  kernel/resource.c      | 5 ++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 0dcc48cafa80..528ae6cbb1b4 100644
> +++ b/include/linux/ioport.h
> @@ -297,6 +297,8 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
>  
>  struct resource *devm_request_free_mem_region(struct device *dev,
>  		struct resource *base, unsigned long size, const char *name);
> +#define request_free_mem_region(base, size, name) \
> +	devm_request_free_mem_region(NULL, base, size, name)
>  
>  #endif /* __ASSEMBLY__ */
>  #endif	/* _LINUX_IOPORT_H */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 0ddc558586a7..3a826b3cc883 100644
> +++ b/kernel/resource.c
> @@ -1671,7 +1671,10 @@ struct resource *devm_request_free_mem_region(struct device *dev,
>  				REGION_DISJOINT)
>  			continue;
>  
> -		res = devm_request_mem_region(dev, addr, size, name);
> +		if (dev)
> +			res = devm_request_mem_region(dev, addr, size, name);
> +		else
> +			res = request_mem_region(addr, size, name);

It is a bit jarring to have something called devm_* that doesn't
actually do the devm_ part on some paths.

Maybe this function should be called __request_free_mem_region() with
another name wrapper macro?

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
