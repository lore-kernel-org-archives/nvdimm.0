Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E022E7BB5
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585862; cv=none; b=UJVIuqXU5lCdg7XdGHD2PXQgoJPfWOFCrDsRxHZl8vGCLICpH6pniHj2XGlX4PlvvdWp6+M/sR32LwAufhw7BfJjSbcseZn6cAkRQgiZRE1hqVuwLrLQsRw5ag9DFK+75kiVJeTlTikNH+51WyyLmpOGIsqFrib2yHMPzzvcYqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585862; c=relaxed/simple;
	bh=KfY/V2hEUA6C7GlUCahAYYBS9gZ/TXfYbBOyKxGKtEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=sfeMmonwfL2zmc6bFgVgYqeuJK8uDHte+gbPCEc9IaZBZcxVs56kcbTPPna/1OBrTjdpsLE3NJ+K6YB+QJ4cQkNpGhYBQacWgWeQ7wu9ES0LvVYRcIgPNy6p3akcKGxVZtTjCY7oSzs8hxlbrc1d/nvvGfD9ZAlgnuvNIbnHeqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dWsygThQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dWsygThQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQduvI7D6V1Y1gj1ZwNsH+sSV4mM47HI53S/a03rEFE=;
	b=dWsygThQGM0iIwDSTRF8a3kbQR7GrvCchTv0vxVOUTAD4Xto+smwB2eC+mPE6MglWNuivW
	jX57YX0t4JZkxMuA3xGheuzFBFk7CmQwUt8/08whi9QjIYuOPqbWFMRjh4VYcmz94D9xkr
	545Ts8I1ne5VePbWQD7ZgBziKOsl3kg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-KXjyR5KcPJOJpZ00vuIdaA-1; Tue, 15 Jul 2025 09:24:15 -0400
X-MC-Unique: KXjyR5KcPJOJpZ00vuIdaA-1
X-Mimecast-MFC-AGG-ID: KXjyR5KcPJOJpZ00vuIdaA_1752585854
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so31685305e9.3
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585854; x=1753190654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQduvI7D6V1Y1gj1ZwNsH+sSV4mM47HI53S/a03rEFE=;
        b=TzF5zTVRhttbGeIO1wpcDAVXSMC70soJI1GP1oqzrtMwVfcjdVbIaK3MthQoHAtgpu
         JVsYY14NdYicowdAyh3mA1ossFdMgH3g1n0wToQD18eEmBI+16NDGKbrG/WTSZvmaN/4
         zHrWaXs4a8zbBlcnUtbYJnjUnQS4EtOPw0MhAvSqcVe5o7E01//BTT75QTMrqsAURZu2
         NF77GZANP4w0mXqbVNFulWbtVnyM6XKDcQuVheY+o5NbG2WMf1TD1gn5+IKeESgOmXn3
         81qMB/lktZOKxAe6kx+mLXen7HxVyl7TOthCmsYyOCLkHVjLMOvyKSu60xxzVwa40g6W
         QaKA==
X-Forwarded-Encrypted: i=1; AJvYcCV6lsJymyj5XqFVrFWyDBMf6GG9LDpCtvze7tsJceBQjj94JGaikqUiwSjVNfvRCtoIKFS7rXk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWnS15TX0HTTaYtwH4xDpksbC0EpJ3G16pHHF+WozSysPr4Tv6
	gTXaQhg4GxIES/4etcxbsl6McUNJw40WOl9rAyDezDNMsKljtqfRA6Z6nRlzO63si7YWoc14AHI
	I6Gf1T+LaXE6CI26pX9cjTSCrKY3v1CbkRH79ULSikDVRKLPU00LwjhB2og==
X-Gm-Gg: ASbGncubeK52RnVJvRZyCWdpEsYzfx22u0EvgjiOmFK01yEKZC7KNBp/cPYZDQmBHzM
	4N1egfVv0O7Rj4yWnlF3k/6cIv4/RoxONjv1Wg+0jb4NdULTfTebYj1KgHoQxcv85e7xPXErVZU
	FFtcdmnQLl32KNSapaqleIc89vGJWHrPi0w62GojC/FG1El0qr+fcwq35hCOgIpKv4X6vBgvPZu
	OOromlbvjjeEmRVh4lLFDyHFIQAi63bQGHMNSyZy7HWVNMnm7sn7y75DvvHNYwpAukCjwzmJiin
	O6m1C0sDetINc7nUn/Qie6J0I2stqLobxnzx20gid8IegjcI3Et1/RzDSfBSTrVU8VHH1RACTyN
	eepFvPp4JErUXNW8DOJih2AqE
X-Received: by 2002:a05:600c:4ed0:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-4561a41fd79mr64379195e9.22.1752585854246;
        Tue, 15 Jul 2025 06:24:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3r8lG85ntU3nBUSpLXqHodEZFoetPf2QpvNAGJr6E2EBer+0dRaC665FuVYarZxx4ibL6Dg==
X-Received: by 2002:a05:600c:4ed0:b0:456:1a41:f932 with SMTP id 5b1f17b1804b1-4561a41fd79mr64378845e9.22.1752585853644;
        Tue, 15 Jul 2025 06:24:13 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4560c50b7b4sm100033485e9.25.2025.07.15.06.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:24:13 -0700 (PDT)
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
Subject: [PATCH v1 9/9] mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()
Date: Tue, 15 Jul 2025 15:23:50 +0200
Message-ID: <20250715132350.2448901-10-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715132350.2448901-1-david@redhat.com>
References: <20250715132350.2448901-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fHnMdV3Zt5f-adf62OLu6zUC6cLrwQYXvR6Cl1TmmYk_1752585854
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
index 6877c894fe526..cc3322fce62f4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -646,13 +646,21 @@ struct vm_operations_struct {
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
index f1834a19a2f1e..d09f2ff4a866e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -619,6 +619,12 @@ static void print_bad_page_map(struct vm_area_struct *vma,
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
@@ -716,8 +722,10 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
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
index 991022e9e0d3b..9eecfb1dcc13f 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -465,13 +465,21 @@ struct vm_operations_struct {
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

