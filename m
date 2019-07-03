Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate16.nvidia.com (hqemgate16.nvidia.com [216.228.121.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F425212AAB82
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 10:32:43 -0700 (PDT)
Subject: Re: [PATCH 19/22] mm: always return EBUSY for invalid ranges in
 hmm_range_{fault,snapshot}
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-20-hch@lst.de>
From: Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <85c88d71-2c25-38ff-a4a3-bfd66fff72b7@nvidia.com>
Date: Wed, 3 Jul 2019 10:32:39 -0700
MIME-Version: 1.0
In-Reply-To: <20190701062020.19239-20-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>


On 6/30/19 11:20 PM, Christoph Hellwig wrote:
> We should not have two different error codes for the same condition.  In
> addition this really complicates the code due to the special handling of
> EAGAIN that drops the mmap_sem due to the FAULT_FLAG_ALLOW_RETRY logic
> in the core vm.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

Probably should update the "Return:" comment above
hmm_range_snapshot() too.

> ---
>   mm/hmm.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index c85ed7d4e2ce..d125df698e2b 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -974,7 +974,7 @@ long hmm_range_snapshot(struct hmm_range *range)
>   	do {
>   		/* If range is no longer valid force retry. */
>   		if (!range->valid)
> -			return -EAGAIN;
> +			return -EBUSY;
>   
>   		vma = find_vma(hmm->mm, start);
>   		if (vma == NULL || (vma->vm_flags & device_vma))
> @@ -1069,10 +1069,8 @@ long hmm_range_fault(struct hmm_range *range, bool block)
>   
>   	do {
>   		/* If range is no longer valid force retry. */
> -		if (!range->valid) {
> -			up_read(&hmm->mm->mmap_sem);
> -			return -EAGAIN;
> -		}
> +		if (!range->valid)
> +			return -EBUSY;
>   
>   		vma = find_vma(hmm->mm, start);
>   		if (vma == NULL || (vma->vm_flags & device_vma))
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
