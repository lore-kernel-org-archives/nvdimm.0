Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1DEB21962301
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 09:54:44 -0700 (PDT)
Date: Thu, 4 Apr 2019 09:54:31 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] libnvdimm, pmem: fix a possible OOB access when read and
 write pmem
Message-ID: <20190404165431.GC1857@iweiny-DESK2.sc.intel.com>
References: <1554346681-31163-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1554346681-31163-1-git-send-email-lirongqing@baidu.com>
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
To: Li RongQing <lirongqing@baidu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 04, 2019 at 10:58:01AM +0800, Li RongQing wrote:
> If offset is not zero and length is bigger than PAGE_SIZE,
> this will cause to out of boundary access to a page memory
> 
> Fixes: 98cc093cba1e "(block, THP: make block_device_operations.rw_page support THP)"
> Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/pmem.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index bc2f700feef8..0279eb1da3ef 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -113,13 +113,13 @@ static void write_pmem(void *pmem_addr, struct page *page,
>  
>  	while (len) {
>  		mem = kmap_atomic(page);
> -		chunk = min_t(unsigned int, len, PAGE_SIZE);
> +		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		memcpy_flushcache(pmem_addr, mem + off, chunk);
>  		kunmap_atomic(mem);
>  		len -= chunk;
>  		off = 0;
>  		page++;
> -		pmem_addr += PAGE_SIZE;
> +		pmem_addr += chunk;
>  	}
>  }
>  
> @@ -132,7 +132,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
>  
>  	while (len) {
>  		mem = kmap_atomic(page);
> -		chunk = min_t(unsigned int, len, PAGE_SIZE);
> +		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
>  		kunmap_atomic(mem);
>  		if (rem)
> @@ -140,7 +140,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
>  		len -= chunk;
>  		off = 0;
>  		page++;
> -		pmem_addr += PAGE_SIZE;
> +		pmem_addr += chunk;
>  	}
>  	return BLK_STS_OK;
>  }
> -- 
> 2.16.2
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
