Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate14.nvidia.com (hqemgate14.nvidia.com [216.228.121.143])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6ADAF212AAB82
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 10:22:28 -0700 (PDT)
Subject: Re: [PATCH 18/22] mm: return valid info from hmm_range_unregister
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-19-hch@lst.de>
From: Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <0cc37cca-4f3a-40bb-0059-bf3880c171b8@nvidia.com>
Date: Wed, 3 Jul 2019 10:22:23 -0700
MIME-Version: 1.0
In-Reply-To: <20190701062020.19239-19-hch@lst.de>
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
> Checking range->valid is trivial and has no meaningful cost, but
> nicely simplifies the fastpath in typical callers.  Also remove the
> hmm_vma_range_done function, which now is a trivial wrapper around
> hmm_range_unregister.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>

> ---
>   drivers/gpu/drm/nouveau/nouveau_svm.c |  2 +-
>   include/linux/hmm.h                   | 11 +----------
>   mm/hmm.c                              |  6 +++++-
>   3 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
> index 8c92374afcf2..9d40114d7949 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_svm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
> @@ -652,7 +652,7 @@ nouveau_svm_fault(struct nvif_notify *notify)
>   		ret = hmm_vma_fault(&svmm->mirror, &range, true);
>   		if (ret == 0) {
>   			mutex_lock(&svmm->mutex);
> -			if (!hmm_vma_range_done(&range)) {
> +			if (!hmm_range_unregister(&range)) {
>   				mutex_unlock(&svmm->mutex);
>   				goto again;
>   			}
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index 0fa8ea34ccef..4b185d286c3b 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -465,7 +465,7 @@ int hmm_range_register(struct hmm_range *range,
>   		       unsigned long start,
>   		       unsigned long end,
>   		       unsigned page_shift);
> -void hmm_range_unregister(struct hmm_range *range);
> +bool hmm_range_unregister(struct hmm_range *range);
>   long hmm_range_snapshot(struct hmm_range *range);
>   long hmm_range_fault(struct hmm_range *range, bool block);
>   long hmm_range_dma_map(struct hmm_range *range,
> @@ -487,15 +487,6 @@ long hmm_range_dma_unmap(struct hmm_range *range,
>    */
>   #define HMM_RANGE_DEFAULT_TIMEOUT 1000
>   
> -/* This is a temporary helper to avoid merge conflict between trees. */
> -static inline bool hmm_vma_range_done(struct hmm_range *range)
> -{
> -	bool ret = hmm_range_valid(range);
> -
> -	hmm_range_unregister(range);
> -	return ret;
> -}
> -
>   /* This is a temporary helper to avoid merge conflict between trees. */
>   static inline int hmm_vma_fault(struct hmm_mirror *mirror,
>   				struct hmm_range *range, bool block)
> diff --git a/mm/hmm.c b/mm/hmm.c
> index de35289df20d..c85ed7d4e2ce 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -920,11 +920,14 @@ EXPORT_SYMBOL(hmm_range_register);
>    *
>    * Range struct is used to track updates to the CPU page table after a call to
>    * hmm_range_register(). See include/linux/hmm.h for how to use it.
> + *
> + * Returns if the range was still valid at the time of unregistering.

Since this is an exported function, we should have kernel-doc comments.
That is probably a separate patch but at least this line could be:
Return: True if the range was still valid at the time of unregistering.

>    */
> -void hmm_range_unregister(struct hmm_range *range)
> +bool hmm_range_unregister(struct hmm_range *range)
>   {
>   	struct hmm *hmm = range->hmm;
>   	unsigned long flags;
> +	bool ret = range->valid;
>   
>   	spin_lock_irqsave(&hmm->ranges_lock, flags);
>   	list_del_init(&range->list);
> @@ -941,6 +944,7 @@ void hmm_range_unregister(struct hmm_range *range)
>   	 */
>   	range->valid = false;
>   	memset(&range->hmm, POISON_INUSE, sizeof(range->hmm));
> +	return ret;
>   }
>   EXPORT_SYMBOL(hmm_range_unregister);
>   
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
