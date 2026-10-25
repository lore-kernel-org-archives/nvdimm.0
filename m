Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007696;
	b=iwEQ13V5A7ml4KgEcvQbCjtLLSSTNGAoM1UweypUig1+4pVTQC+eZUAJBJGbCeQ9ocIn
	 GK9yDXqpqK23NXMtgA6nF8DjJsiqVVQ4R/01FOSL0jvI4963XkDv+RbO9RdOqYhEnmRvv
	 wapLKLU+DQt+qqvCBtoci7+lc3tlv1s/DljKyc0vUkwd6H3k4EVEj06Hy1MZizhP0ig5G
	 wyghIjWWa2li06jfrNrrk0ACwE+Vydtedl+eRntewbD6gucXYvaTIWyzHw3jn/BCGizkh
	 cyujxLm2EjKH22mvVxbmUSAsMOvh6Ae+awfD44E0L/niHSE4Tcs0Rl8yxMfKrRGyLsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007696;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=3AonB/2boXWPC85DIlIend/xKkrxNGnImZgBKSxz4gQ=;
	b=ebzdiBSFZ31ohEAvg3sm5mj6ntSdcqykeHZcy0rKzmxCEeimioFYP/yjvoFnI7nYN+2h
	 pu+PKhk0z3KuXo3fctdXeX/ecuaeyegCPvICrPwcFPfzei1R2bVjHLGSXbjhjWP7FoDa7
	 UhosANoB5EQA5bXQ1bD3J0SYjSoy8DCnG1cRZSWXSD34iYSqIOnROSDGBBxBKT9P6ypof
	 EVAuQqRZUREsoy4tLtA9UmzuFyFhDwZKKFN3Xvvf7J5SX9XbeboCNbHG7268/ADxi41Bl
	 pNCAtBbSEQuxp24C/8tTEn0ASE7WtLy9noPK/x9DT3yoZqfYuJIS7pa2kaXhNXtg1Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PR+eEmO9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF2606A328;
	Mon, 26 Oct 2026 09:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PR+eEmO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F51F031E2;
	Mon, 26 Oct 2026 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007695;
	bh=3AonB/2boXWPC85DIlIend/xKkrxNGnImZgBKSxz4gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PR+eEmO9h/aowxwnZM5851O3SR95bB9whyNXNRkh2zIPwtYLYsIo969wWhc+cetMe
	 laO3wYfUt4YhOm/5+NifNvKJuN2NC5r3OeieQj1jtO78USAIxVOaS7wfTFsI0Uvp5a
	 Et3jGtAklQH5p9OJDb0PM6TlHDNzBeswdmFB4B+omPVp6g9quDH20hAQYy6NyrZQ6A
	 bdVvqwH5vxMvOqmluxOzT5zaOLs3rlBmWQ6v935PUQUNYbi0tE85ux4Xw54bbZWpp3
	 R7sc7B+Ij+HNegyLtKqPfirudCJCjtJPpwWb5Ud1YzP1mdt9dHlNPf0wFtcQcz8ZLL
	 nz6aXSquIvkAA==
Message-ID: <26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org>
Date: Sun, 25 Oct 2026 13:52:26 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
 <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-1-8bd88551f9be@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-1-8bd88551f9be@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/26 20:10, Konstantin Khorenko wrote:
> Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
> folio reference, adds a PUD rmap and accounts the pages to the mm.
> zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
> the child without taking any of them. Each child's unmap then drops
> what the parent took:
> 
> - the folio is a reference short, so with two children its refcount
>   drops to zero and free_zone_device_folio() runs while the parent
>   still maps it;
> - the child's file counter goes negative, "Bad rss-counter state" when
>   its mm is freed;
> - the parent's unmap drives the entire mapcount below zero.
> 
> fork copies the page tables of a device DAX mapping that has a guard
> region: commit f807123d578d ("mm: allow guard regions in file-backed and
> read-only mappings") allowed MADV_GUARD_INSTALL there, and it makes fork
> copy the VMA.
> 
> Take the reference, the rmap and the counter for a PUD that
> vm_normal_page_pud() resolves to a page, as copy_huge_pmd() does for a
> PMD, with a new folio_dup_file_rmap_pud() helper.
> 
> Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  include/linux/huge_mm.h |  2 +-
>  include/linux/rmap.h    | 22 ++++++++++++++++++++++
>  mm/huge_memory.c        | 13 +++++++++++--
>  mm/memory.c             |  4 ++--
>  4 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c745f7ad22987..c5094f9d95ba9 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -14,7 +14,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  bool huge_pmd_set_accessed(struct vm_fault *vmf);
>  int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
> -		  struct vm_area_struct *vma);
> +		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
>  
>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>  void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 0b332770abeed..3c9ed8e27f0e4 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -564,6 +564,28 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
>  #endif
>  }
>  
> +/**
> + * folio_dup_file_rmap_pud - duplicate a PUD mapping of a page range of a folio
> + * @folio:	The folio to duplicate the mapping of
> + * @page:	The first page to duplicate the mapping of
> + * @dst_vma:	The destination vm area
> + *
> + * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
> + *
> + * The caller needs to hold the page table lock.
> + */
> +static inline void folio_dup_file_rmap_pud(struct folio *folio,
> +		struct page *page, struct vm_area_struct *dst_vma)
> +{
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
> +	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +	__folio_dup_file_rmap(folio, page, HPAGE_PUD_NR, dst_vma,
> +			      PGTABLE_LEVEL_PUD);
> +#else
> +	WARN_ON_ONCE(true);
> +#endif
> +}
> +
>  static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
>  		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
>  		struct vm_area_struct *src_vma, enum pgtable_level level)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5d68acf62a5..7e8b41f293a49 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2075,9 +2075,10 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
>  
>  int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
> -		  struct vm_area_struct *vma)
> +		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>  {
>  	spinlock_t *dst_ptl, *src_ptl;
> +	struct page *page;
>  	pud_t pud;
>  	int ret;
>  
> @@ -2094,7 +2095,15 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	 * TODO: once we support anonymous pages, use
>  	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
>  	 */
> -	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
> +	page = vm_normal_page_pud(src_vma, addr, pud);
> +	if (page) {
> +		struct folio *folio = page_folio(page);
> +
> +		folio_get(folio);
> +		folio_dup_file_rmap_pud(folio, page, dst_vma);
> +		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
> +	}
> +	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
>  		pudp_set_wrprotect(src_mm, addr, src_pud);
>  		pud = pud_wrprotect(pud);
>  	}
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3de..8acd4d5bb2310 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1514,8 +1514,8 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
>  			int err;
>  
>  			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
> -			err = copy_huge_pud(dst_mm, src_mm,
> -					    dst_pud, src_pud, addr, src_vma);
> +			err = copy_huge_pud(dst_mm, src_mm, dst_pud, src_pud,
> +					    addr, dst_vma, src_vma);
>  			if (err == -ENOMEM)
>  				return -ENOMEM;
>  			if (!err)
> 

I have the following fix lying around here.

Introducing folio_dup_file_rmap_pud() is better. But please see how I move the comment and
how passing mm+vma to the helper is not really reasonable.


Subject: [PATCH 01/36] mm/huge_memory: properly handle refcounted PUD mappings
 on fork

copy_huge_pud() copies device-DAX entries without taking a folio reference
or updating mapcounts and the child's RSS.

For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
huge PUDs are then copied without accounting for the new mappings.
Unmapping them in the child decrements accounting that was never added.

Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
reference and add the child's PUD rmap and RSS accounting before installing
the copied entry. Pass src and dst VMAs consistently instead of src and
dst MM. Move the TODO.

Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad22987..fac05120ab774 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -12,9 +12,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 bool huge_pmd_set_accessed(struct vm_fault *vmf);
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma);
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 766ea4d458bc2..8cfaad8168948 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2078,11 +2078,13 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma)
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	spinlock_t *dst_ptl, *src_ptl;
+	struct page *page;
 	pud_t pud;
 	int ret;
 
@@ -2095,11 +2097,20 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pud_trans_huge(pud)))
 		goto out_unlock;
 
-	/*
-	 * TODO: once we support anonymous pages, use
-	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
-	 */
-	if (vma_is_cow_mapping(vma) && pud_write(pud)) {
+	page = vm_normal_page_pud(src_vma, addr, pud);
+	if (page) {
+		struct folio *folio = page_folio(page);
+
+		folio_get(folio);
+		/*
+		 * TODO: once we support anonymous pages, use
+		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
+		 */
+		folio_add_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index 797d39572a09d..8a673b411c197 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,7 +1463,6 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	       unsigned long end)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1477,8 +1476,7 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
-			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, src_vma);
+			err = copy_huge_pud(dst_vma, src_vma, dst_pud, src_pud, addr);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
-- 
2.43.0


-- 
Cheers,

David
