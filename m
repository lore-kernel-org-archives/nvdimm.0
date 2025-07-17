Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA52BEC55
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753163; cv=none; b=VaImig54+GKuRz9UfaMp6XIhRsLW1hKYWe3idzx8XtCuo7yWqoe+CUw2W67QwI5TkaaBM4OpIJ2aFEr8VJ9e9NemPH4Fs5QIXwVkM8nwznAVD3CpFEts8M3lppIDfK3jCoGarTh+QMeDLh2PvBUsJJ4KcJClYP0lX5Dug3Sb77E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753163; c=relaxed/simple;
	bh=y0rXziOq2wAqEICCZlt2ptXV2jFozysyFYkLchieBt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Z+vHMJtgVObKB3zV37cw3LTQpsatHCQogPdjBhmweI/esGAEqoqVJe9wsceL0NELEkXJfc3E9AkXd8IzxNASiPRa0APEA2/3kEs5DusQKVE5/e2zNw1WX2IpvWUnZK16/19FFDLTPHIWMH1u63E3A5F3lHUcr9hfdmyiTKt1W0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkKYhiU1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkKYhiU1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EJnWBjNqAGa4cESjiW0EJbmUIJ/RdvXL+0h/9uaJzw=;
	b=CkKYhiU1WfKlCG7sHsi6bBqvvcbAyvvCAfD1o308FkwauImjzUfqbWaLHk44YSQkqrmnOJ
	67aUXzh3gimR+goH+DABAhNs4KVih5nPwwWUPxt4HexHV/beTmhsWHRm5G7UUlgauqLPIo
	iLlZOyeKBuDakljulG6XvlrictqFmK0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-PlW3yxZSN5-t9Msbf48i-A-1; Thu, 17 Jul 2025 07:52:38 -0400
X-MC-Unique: PlW3yxZSN5-t9Msbf48i-A-1
X-Mimecast-MFC-AGG-ID: PlW3yxZSN5-t9Msbf48i-A_1752753157
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4538a2f4212so4226055e9.2
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753157; x=1753357957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+EJnWBjNqAGa4cESjiW0EJbmUIJ/RdvXL+0h/9uaJzw=;
        b=aPst9RAdfqEozIWZCdGU4sPxAlg9YT5NlN8c3HK4rb2Y/mhgGsPU3su6A4VYfK4pGi
         Nu/UwLkCgdjz/qhOZZDiYkPJuw0QII5s65lvB/iWj7C+NAfbkH85bIGi4VFPyaN5I8+1
         Vnjj58LVKIdSng0/Mts/x+fyDgIrnX2a6X5mzxHWevYI63y1VVZhzwQAloD82dvv4bRe
         UMwiRo3QjHN9D5sDt2AWaF8pgZEME7NNvHGI/6nyg3T6bvWIPEY2SZn6b0x2ta0NJtqf
         KSlrNyIYuoIa8EGXdMk0opF52+SPr99+YXE5AN2sHGDKp9B/3KyjywRfZ5WjJfGiZike
         q+Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXo/hk/UlZeVmAyAYAtmESUF5n+/VM3YHyL/29eZz1hobSW0N1aDMxjCxdcceKIIQhuvPkeAc8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmlY6+KSQvriupST1n0QeTyyvSTgHg59oa8AyoJMik9D+d5/WK
	UQ+sY1EmYKqnX23QH9S8jTUqAHDYgGBfRFvOboX9kiKr9n6nzgY2JVl2y5FqaTSUsAieU9NQtTE
	RycZd8naHVhoHeOcFn6N3O4mjJTGWdDUFomCZH3csMLmMOvVtq2tjuECTsw==
X-Gm-Gg: ASbGncuZCUl1HebbWvwvfCI+UG2xhgAL3ueM0JdffMur5hfS2Wnh+4QvTgnX97NBrBr
	C/N4btActuKZpwO8LHQSumshtVpb+VZQK/opKmiLZAntZ2xlGRD8aUnE1xqIZWwjulRw+wxXhkn
	CqX48U4eGQYeiVvm3BpuvZF+7lvsHZG9NAxn8kLwCtqcEfSDefYup6CXg2zK4t7Jx14aMBJzkk0
	Sj+Ie7D/3ZAzHIG3BYp3/zc30m/EKzJ6bZt1atN/EDocB4tCUyIC6XmJfOhhtGtmL5pD+rB/wpm
	ZImpvBM9HucrRkzhNQdSXbHuJUM9iI+0cAh9lzJyvrUawhdvV8CQXZ+icxLQgJ9/5x3KmpOIm6n
	qSxwP2LNENpHXNPMpHdzsces=
X-Received: by 2002:a05:600c:870e:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-456352d2ab1mr20378085e9.3.1752753157351;
        Thu, 17 Jul 2025 04:52:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3Vszf6T0cq3aQuR+QDmUBqbteOugAuzaA8OTawN8Aj0cx9bUSNlZT+0u55FTlbIHJovWeIQ==
X-Received: by 2002:a05:600c:870e:b0:456:285b:db3c with SMTP id 5b1f17b1804b1-456352d2ab1mr20377615e9.3.1752753156790;
        Thu, 17 Jul 2025 04:52:36 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b5e8dc22a8sm20945546f8f.34.2025.07.17.04.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:36 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2 9/9] mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
Date: Thu, 17 Jul 2025 13:52:12 +0200
Message-ID: <20250717115212.1825089-10-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250717115212.1825089-1-david@redhat.com>
References: <20250717115212.1825089-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ihKqO-j-ltNScbA2hQI52cJOMDhb_lEpuuWuAp-znMc_1752753157
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

... and hide it behind a kconfig option. There is really no need for
any !xen code to perform this check.

The naming is a bit off: we want to find the "normal" page when a PTE
was marked "special". So it's really not "finding a special" page.

Improve the documentation, and add a comment in the code where XEN ends
up performing the pte_mkspecial() through a hypercall. More details can
be found in commit 923b2919e2c3 ("xen/gntdev: mark userspace PTEs as
special on x86 PV guests").

Cc: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/xen/Kconfig              |  1 +
 drivers/xen/gntdev.c             |  5 +++--
 include/linux/mm.h               | 18 +++++++++++++-----
 mm/Kconfig                       |  2 ++
 mm/memory.c                      | 12 ++++++++++--
 tools/testing/vma/vma_internal.h | 18 +++++++++++++-----
 6 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 24f485827e039..f9a35ed266ecf 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -138,6 +138,7 @@ config XEN_GNTDEV
 	depends on XEN
 	default m
 	select MMU_NOTIFIER
+	select FIND_NORMAL_PAGE
 	help
 	  Allows userspace processes to use grants.
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 61faea1f06630..d1bc0dae2cdf9 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -309,6 +309,7 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 	BUG_ON(pgnr >= map->count);
 	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
 
+	/* Note: this will perform a pte_mkspecial() through the hypercall. */
 	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, flags,
 			  map->grants[pgnr].ref,
 			  map->grants[pgnr].domid);
@@ -516,7 +517,7 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 	gntdev_put_map(priv, map);
 }
 
-static struct page *gntdev_vma_find_special_page(struct vm_area_struct *vma,
+static struct page *gntdev_vma_find_normal_page(struct vm_area_struct *vma,
 						 unsigned long addr)
 {
 	struct gntdev_grant_map *map = vma->vm_private_data;
@@ -527,7 +528,7 @@ static struct page *gntdev_vma_find_special_page(struct vm_area_struct *vma,
 static const struct vm_operations_struct gntdev_vmops = {
 	.open = gntdev_vma_open,
 	.close = gntdev_vma_close,
-	.find_special_page = gntdev_vma_find_special_page,
+	.find_normal_page = gntdev_vma_find_normal_page,
 };
 
 /* ------------------------------------------------------------------ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0eb991262fbbf..036800514aa90 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -648,13 +648,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/mm/Kconfig b/mm/Kconfig
index 0287e8d94aea7..82c281b4f6937 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1397,6 +1397,8 @@ config PT_RECLAIM
 
 	  Note: now only empty user PTE page table pages will be reclaimed.
 
+config FIND_NORMAL_PAGE
+	def_bool n
 
 source "mm/damon/Kconfig"
 
diff --git a/mm/memory.c b/mm/memory.c
index 00a0d7ae3ba4a..52804ca343261 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -613,6 +613,12 @@ static void print_bad_page_map(struct vm_area_struct *vma,
  * trivial. Secondly, an architecture may not have a spare page table
  * entry bit, which requires a more complicated scheme, described below.
  *
+ * With CONFIG_FIND_NORMAL_PAGE, we might have the "special" bit set on
+ * page table entries that actually map "normal" pages: however, that page
+ * cannot be looked up through the PFN stored in the page table entry, but
+ * instead will be looked up through vm_ops->find_normal_page(). So far, this
+ * only applies to PTEs.
+ *
  * A raw VM_PFNMAP mapping (ie. one that is not COWed) is always considered a
  * special mapping (even if there are underlying and valid "struct pages").
  * COWed pages of a VM_PFNMAP are always normal.
@@ -710,8 +716,10 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pfn = pte_pfn(pte);
 
 	if (unlikely(pte_special(pte))) {
-		if (vma->vm_ops && vma->vm_ops->find_special_page)
-			return vma->vm_ops->find_special_page(vma, addr);
+#ifdef CONFIG_FIND_NORMAL_PAGE
+		if (vma->vm_ops && vma->vm_ops->find_normal_page)
+			return vma->vm_ops->find_normal_page(vma, addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
 		if (is_zero_pfn(pfn))
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 0fe52fd6782bf..8646af15a5fc0 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -467,13 +467,21 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr, pgoff_t *ilx);
 #endif
+#ifdef CONFIG_FIND_NORMAL_PAGE
 	/*
-	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
-	 * (using pte_page()) would not find the correct page.
+	 * Called by vm_normal_page() for special PTEs in @vma at @addr. This
+	 * allows for returning a "normal" page from vm_normal_page() even
+	 * though the PTE indicates that the "struct page" either does not exist
+	 * or should not be touched: "special".
+	 *
+	 * Do not add new users: this really only works when a "normal" page
+	 * was mapped, but then the PTE got changed to something weird (+
+	 * marked special) that would not make pte_pfn() identify the originally
+	 * inserted page.
 	 */
-	struct page *(*find_special_page)(struct vm_area_struct *vma,
-					  unsigned long addr);
+	struct page *(*find_normal_page)(struct vm_area_struct *vma,
+					 unsigned long addr);
+#endif /* CONFIG_FIND_NORMAL_PAGE */
 };
 
 struct vm_unmapped_area_info {
-- 
2.50.1

