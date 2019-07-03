Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34162212AB4F2
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 10:48:58 -0700 (PDT)
Subject: Re: [PATCH 20/22] mm: move hmm_vma_fault to nouveau
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-21-hch@lst.de>
From: Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <a3108540-e431-2513-650e-3bb143f7f161@nvidia.com>
Date: Wed, 3 Jul 2019 10:48:56 -0700
MIME-Version: 1.0
In-Reply-To: <20190701062020.19239-21-hch@lst.de>
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
> hmm_vma_fault is marked as a legacy API to get rid of, but quite suites
> the current nouvea flow.  Move it to the only user in preparation for

I didn't quite parse the phrase "quite suites the current nouvea flow."
s/nouvea/nouveau/

> fixing a locking bug involving caller and callee.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I see where you are going with this and it
looks like straightforward code movement so,

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

> ---
>   drivers/gpu/drm/nouveau/nouveau_svm.c | 54 ++++++++++++++++++++++++++-
>   include/linux/hmm.h                   | 54 ---------------------------
>   2 files changed, 53 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
> index 9d40114d7949..e831f4184a17 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_svm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
> @@ -36,6 +36,13 @@
>   #include <linux/sort.h>
>   #include <linux/hmm.h>
>   
> +/*
> + * When waiting for mmu notifiers we need some kind of time out otherwise we
> + * could potentialy wait for ever, 1000ms ie 1s sounds like a long time to
> + * wait already.
> + */
> +#define NOUVEAU_RANGE_FAULT_TIMEOUT 1000
> +
>   struct nouveau_svm {
>   	struct nouveau_drm *drm;
>   	struct mutex mutex;
> @@ -475,6 +482,51 @@ nouveau_svm_fault_cache(struct nouveau_svm *svm,
>   		fault->inst, fault->addr, fault->access);
>   }
>   
> +static int
> +nouveau_range_fault(struct hmm_mirror *mirror, struct hmm_range *range,
> +		    bool block)
> +{
> +	long ret;
> +
> +	/*
> +	 * With the old API the driver must set each individual entries with
> +	 * the requested flags (valid, write, ...). So here we set the mask to
> +	 * keep intact the entries provided by the driver and zero out the
> +	 * default_flags.
> +	 */
> +	range->default_flags = 0;
> +	range->pfn_flags_mask = -1UL;
> +
> +	ret = hmm_range_register(range, mirror,
> +				 range->start, range->end,
> +				 PAGE_SHIFT);
> +	if (ret)
> +		return (int)ret;
> +
> +	if (!hmm_range_wait_until_valid(range, NOUVEAU_RANGE_FAULT_TIMEOUT)) {
> +		/*
> +		 * The mmap_sem was taken by driver we release it here and
> +		 * returns -EAGAIN which correspond to mmap_sem have been
> +		 * drop in the old API.
> +		 */
> +		up_read(&range->vma->vm_mm->mmap_sem);
> +		return -EAGAIN;
> +	}
> +
> +	ret = hmm_range_fault(range, block);
> +	if (ret <= 0) {
> +		if (ret == -EBUSY || !ret) {
> +			/* Same as above, drop mmap_sem to match old API. */
> +			up_read(&range->vma->vm_mm->mmap_sem);
> +			ret = -EBUSY;
> +		} else if (ret == -EAGAIN)
> +			ret = -EBUSY;
> +		hmm_range_unregister(range);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
>   static int
>   nouveau_svm_fault(struct nvif_notify *notify)
>   {
> @@ -649,7 +701,7 @@ nouveau_svm_fault(struct nvif_notify *notify)
>   		range.values = nouveau_svm_pfn_values;
>   		range.pfn_shift = NVIF_VMM_PFNMAP_V0_ADDR_SHIFT;
>   again:
> -		ret = hmm_vma_fault(&svmm->mirror, &range, true);
> +		ret = nouveau_range_fault(&svmm->mirror, &range, true);
>   		if (ret == 0) {
>   			mutex_lock(&svmm->mutex);
>   			if (!hmm_range_unregister(&range)) {
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index 4b185d286c3b..3457cf9182e5 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -478,60 +478,6 @@ long hmm_range_dma_unmap(struct hmm_range *range,
>   			 dma_addr_t *daddrs,
>   			 bool dirty);
>   
> -/*
> - * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> - *
> - * When waiting for mmu notifiers we need some kind of time out otherwise we
> - * could potentialy wait for ever, 1000ms ie 1s sounds like a long time to
> - * wait already.
> - */
> -#define HMM_RANGE_DEFAULT_TIMEOUT 1000
> -
> -/* This is a temporary helper to avoid merge conflict between trees. */
> -static inline int hmm_vma_fault(struct hmm_mirror *mirror,
> -				struct hmm_range *range, bool block)
> -{
> -	long ret;
> -
> -	/*
> -	 * With the old API the driver must set each individual entries with
> -	 * the requested flags (valid, write, ...). So here we set the mask to
> -	 * keep intact the entries provided by the driver and zero out the
> -	 * default_flags.
> -	 */
> -	range->default_flags = 0;
> -	range->pfn_flags_mask = -1UL;
> -
> -	ret = hmm_range_register(range, mirror,
> -				 range->start, range->end,
> -				 PAGE_SHIFT);
> -	if (ret)
> -		return (int)ret;
> -
> -	if (!hmm_range_wait_until_valid(range, HMM_RANGE_DEFAULT_TIMEOUT)) {
> -		/*
> -		 * The mmap_sem was taken by driver we release it here and
> -		 * returns -EAGAIN which correspond to mmap_sem have been
> -		 * drop in the old API.
> -		 */
> -		up_read(&range->vma->vm_mm->mmap_sem);
> -		return -EAGAIN;
> -	}
> -
> -	ret = hmm_range_fault(range, block);
> -	if (ret <= 0) {
> -		if (ret == -EBUSY || !ret) {
> -			/* Same as above, drop mmap_sem to match old API. */
> -			up_read(&range->vma->vm_mm->mmap_sem);
> -			ret = -EBUSY;
> -		} else if (ret == -EAGAIN)
> -			ret = -EBUSY;
> -		hmm_range_unregister(range);
> -		return ret;
> -	}
> -	return 0;
> -}
> -
>   /* Below are for HMM internal use only! Not to be used by device driver! */
>   static inline void hmm_mm_init(struct mm_struct *mm)
>   {
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
