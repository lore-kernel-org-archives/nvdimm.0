Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898066;
	b=odLl1RfI0SJEB4klDH3hfw9OWaSayNLDdkgjthRJDL2eLIX1MaTQFH7CYgX91THyWJh1
	 iE+LjySMWwC5aaiz1VNzrezkrSwWG9NydhZQbPqG2y/gVmuPehxeUGMMLxg73HPsr7wnd
	 Hp5TftYDmytbcxnk4baeF7Qz1UrHXDP59H3tvvXyUQOAYq9BLAy4rq6DmcsxbzuN/4vLH
	 LMVjM4dXuXY4OKwyNgcJilTdY7FBiSVcCRoZJL66afuXmgp4RYrvsesU6IkGGR64wfzvh
	 ok9SH40VmD9aOvOT0GDuNaPwESGHhAhc2ZuEEmlYXWWApHz8wXzDoOBINkJUCevhqlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898066;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=oul5LzoTaxn4S4nj0ooYPspeFyDzR2KYL9b0OuQrBQE=;
	b=17uT9svJ62Qlpltwvhj572GlVcpv0/yaTICvzjkTOH93yfLXxd/TOkrWs414IJLyudYW
	 l7O1UoVq93BTL41e0FBzvH+1UXaSihw80rFpGtnSP/HCdER4+20nFG/yZ8LyEj2YTG+2r
	 7BAu7mLy5+e0rNa9CtQH8WtxBehoiY2M2ZOtp6GE+/1CH3J+JmnYyQmiZLO52xTx1LUrI
	 IU92k01CJh1jJSMX3rSgPixCsP98i3tDxZ32ChCI0qK0yWi+qs3EE44bWq2cSqdBYRALf
	 QMObW6z88nUHaRQoGOWJ7RayzUP5PzVZPYY/rn4vBQh5dAurTZAAnFxD3GYDa1gFRfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=psgrxQYp;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C762A606EE8C;
	Thu,  5 Nov 2026 17:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C762A606EE8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=psgrxQYp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=oul5LzoTaxn4S4nj0ooYPspeFyDzR2KYL9b0OuQrBQE=; b=psgrxQYpIsvmwAZTbTw
	mY70HdYmt/6f9iaYSvYKjrnsNWVx7DhPqT8mkYN0ALhKnaEYqNwNgNjBdAi1S/i55dt2Em2VPub4p
	IFj88LVzC7eTLI6s3U2kgOtbmtMn7dlcf0/nqsPesyex3+3WDw/SxchOzIcpthlW0ycX8ZiIedKEm
	N4Z8cUg8X9tNppGagEzTI1+zJZsPcjSnN4msCLYGeShPavmI7KTW0giCKlxuKf7ON95+opxTLrFmm
	+FqPqul5UpuMBWypUmDZYqT3AdT19G9P1lVOa22domA37hE2hezRbLgOqNbpJ69S100RBmvdTUFBG
	AsumZzIGVhJWlZw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xP0li-005CiT-1d;
	Thu, 05 Nov 2026 18:00:58 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 05 Nov 2026 18:00:55 +0100
Subject: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6089;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=bARHY+HB017mGvDOpDMt65sYbsWWieKoZi+OZ4Py+mM=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7LZLEaNBpFnwbXUorCQS3YF24tEdyvFX+Urke
 AAZFaGCigGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauy2SwAKCRBRlgpH+WFc
 KtCUEACh4LOREJ/asuuFGTmv6Fw69+jGI8H6InZvyE1AiYGOBnp2NeCV/y7ZkZRY19DEzZb1Mj5
 l2qTRhBqHVlwqe5WWbKgdyvVnOff68kalP6KpnrjAJN288t1k8c/0aEfWRMbmK/758UnDjDz88+
 tnMdJY3lV194a0PZZQDkSuAYd3ij6TdqY93LB97sESi+GfbAM04k8g9sFAu9Yvvbc4A80DmZsrw
 K6vtkYWqb7YQ0ODttwH8W/DNevcTvj/iztnJaFo4/lu2HzkZ4xd+vKSQuVBcJKYOu+mOud33v8n
 9zWHPL/dbzhyMbEPsPolaFHgdAQlKg1pDnGjaXFuFJGKkY1QJP7p64YKY9Bemxiupufrqi+vrZx
 TkUGz+e4EmWk4K0H9Nmx9bWELj2y4Gk913aCGjTaeDkYOX6mo+18aimtzoQI/9enYCsSfvzpnJe
 +HkiRD8jCbOAl6LiGdL6t8oXW0LbfhPWV9RP8ioVISLsqQEUj2ohTLDfHUwolNkYhbOHOg220pv
 Q2tYz9Kymj3SsXepcO8B/EOEGUI0GiqZQlTqbu8VB9FgObTsdXdLjGJbRwS6/ase3BEx5HseD1n
 BktX5qE56T6mISieeCFSNzgQgF/+w19utct6xCDPztOSmqgsdqIMdAQbbzjebzDMFQv0sLafKMf
 YIOgxQlf/RZYN/w==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
folio reference, adds a PUD rmap and accounts the pages to the mm.
zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
the child without taking any of them. Each child's unmap then drops
what the parent took:

- the folio is a reference short, so with two children its refcount
  drops to zero and free_zone_device_folio() runs while the parent
  still maps it;
- the child's file counter goes negative, "Bad rss-counter state" when
  its mm is freed;
- the parent's unmap drives the entire mapcount below zero.

fork copies the page tables of a device DAX mapping that has a guard
region, and commit f807123d578d ("mm: allow guard regions in file-backed
and read-only mappings") allowed MADV_GUARD_INSTALL there.

Take the reference, the rmap and the counter for a PUD that
vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
needs both VMAs, so pass only them and take the mms from them.

Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/huge_mm.h |  5 ++---
 include/linux/rmap.h    | 22 ++++++++++++++++++++++
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 4 files changed, 44 insertions(+), 14 deletions(-)

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
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..52fff8dc74213 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -564,6 +564,28 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 #endif
 }
 
+/**
+ * folio_dup_file_rmap_pud - duplicate a PUD mapping of a page range of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_pud(struct folio *folio,
+		struct page *page, struct vm_area_struct *dst_vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_dup_file_rmap(folio, page, HPAGE_PUD_NR, dst_vma,
+			      PGTABLE_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, enum pgtable_level level)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14599d0fff013..30c21e85d21bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2072,11 +2072,13 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
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
 
@@ -2089,11 +2091,20 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
+		folio_dup_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (vma_is_cow_mapping(src_vma) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index b65b56fe97148..66fbe8ed5bac0 100644
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

