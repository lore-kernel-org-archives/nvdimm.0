Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9488211D6729
 for <linux-nvdimm@lists.01.org>; Fri,  5 Apr 2019 08:43:44 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] libnvdimm,
 pmem: fix a possible OOB access when read and write pmem
References: <1554346681-31163-1-git-send-email-lirongqing@baidu.com>
Date: Fri, 05 Apr 2019 11:43:42 -0400
In-Reply-To: <1554346681-31163-1-git-send-email-lirongqing@baidu.com> (Li
 RongQing's message of "Thu, 4 Apr 2019 10:58:01 +0800")
Message-ID: <x49v9zsfoep.fsf@segfault.boston.devel.redhat.com>
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
To: Li RongQing <lirongqing@baidu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Li RongQing <lirongqing@baidu.com> writes:

> If offset is not zero and length is bigger than PAGE_SIZE,
> this will cause to out of boundary access to a page memory

Agreed, though I don't think this can be triggered in practice.

> Fixes: 98cc093cba1e "(block, THP: make block_device_operations.rw_page support THP)"
> Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


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
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
