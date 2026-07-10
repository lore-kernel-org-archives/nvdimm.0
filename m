Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB4C3955E1;
	Fri, 10 Jul 2026 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783714862; cv=none; b=cjM/l8BVyrUDVhA4163pUjbysk2+IQxJirz3m4Xzm/WTEINDr/v0oCWTks/lkJP9OqIxu/bMX8Q9zQw/0KGQGIVeWU/gD7aoochdWBYH+PXPSbyDFIZlJ0+XtedwgbamtRGrdPPwJ4uvGH5pV4JmB9Ymf/04cwtywmia3gAi8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783714862; c=relaxed/simple;
	bh=wi2G0r+Tf1SXo7NAyf6w+thcPpRxIn45P/FeJkvlXvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=txW5Dt2n0bYZRRSLDK50wTeQetB0Kk8wXXIdgHzVbfy2DXZ2OYoub39AM6iKLTGEAbgviHLzqnbzfnDdWn0FXV7/weOSf0DREg5W3jiOXnl5Nktyp/FMwUa1vT0stpIDLvQ9J7UGEsbsgyV+ayWciTQ1QzsBhOFT0D0eyKQ8HdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+OB8juR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+OB8juR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EF31F00A3A;
	Fri, 10 Jul 2026 20:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714860;
	bh=R0tTV3BrWU6tIJ5l/Y9xEK4eNmbUwb9R0gFk9DgeDT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j+OB8juROnaYGwXLfZwFoBlv1YPzENHjDtEQkcu6v7D6M5XCrlouzYfKBbNPTK57l
	 cvMVR7x9p01YpTlj2sD7SYouV5KI3q5N8JqZ3t9uP7cbPHtgoV6F2pS496toVu9qjS
	 lZ+nD/bFg0kUcCh4cIhFV/vzZR3W0GQQZMOQiCoqLBXASzmRI6FZS3+1RKf8r/agma
	 y9qTR4W3TcNfjYX2rfIw4Pbk0yLLw1PTsPgeqKxpXoAB69AXAEsyqP4jQ9SW9aXp4U
	 ucid0ZBJvLx2AZIB48G5FV70lMXpTGTs8SO5iH5G6rkUHQBP97XHnI17hWc5f1RIPu
	 txMAUAjdf1xLQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:50 +0100
Subject: [PATCH v2 09/33] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8188; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wi2G0r+Tf1SXo7NAyf6w+thcPpRxIn45P/FeJkvlXvk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg61nzf1xcNZvTSezhx0laz3SFlw5+/6jqXrH0eVVH
 777WNhN6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBErpoyMnR+fSF54xTX95Z9
 D1abHLWVjdpcM0dZjL9w38PNaoZ6Nb4M//0ZeGwMe6a3c22SdX/vcWZFmJ6B9j+/j8mSBxI/S3X
 v5AIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Similar to what we did with mapping_rmap_tree*(), let's declare
anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.

In each case the rb tree referenced is &anon_vma->rb_root, so just pass
anon_vma and the functions can figure this out themselves.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h                | 11 ++++++-----
 mm/interval_tree.c                | 13 +++++++------
 mm/ksm.c                          |  7 ++-----
 mm/memory-failure.c               |  3 +--
 mm/rmap.c                         | 11 +++++------
 mm/vma.c                          |  4 ++--
 tools/testing/vma/include/stubs.h |  4 ++--
 7 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d4ac9dc83ddd..5d825824f7e4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4111,14 +4111,15 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 						    pgoff_last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long start, unsigned long last);
-struct anon_vma_chain *anon_vma_interval_tree_iter_next(
-	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				 unsigned long start, unsigned long last);
 #ifdef CONFIG_DEBUG_VM_RB
 void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 #endif
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 39e020555910..b82d2a0d9c4e 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -96,26 +96,27 @@ INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	node->cached_vma_start = avc_start_pgoff(node);
 	node->cached_vma_last = avc_last_pgoff(node);
 #endif
-	__anon_vma_interval_tree_insert(node, root);
+	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
 }
 
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, root);
+	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long first, unsigned long last)
 {
-	return __anon_vma_interval_tree_iter_first(root, first, last);
+	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
+						   first, last);
 }
 
 struct anon_vma_chain *
diff --git a/mm/ksm.c b/mm/ksm.c
index 41ab25aa2a82..10fccc22e5f3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3187,8 +3187,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+		anon_vma_interval_tree_foreach(vmac, anon_vma, 0, ULONG_MAX) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3249,9 +3248,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
-			{
+			anon_vma_interval_tree_foreach(vmac, av, 0, ULONG_MAX) {
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 66ae93c6d4b2..24d660c32058 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -564,8 +564,7 @@ static void collect_procs_anon(const struct folio *folio,
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
-					       pgoff, pgoff) {
+		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
diff --git a/mm/rmap.c b/mm/rmap.c
index d3d3d6cb17b8..6d4423a16c8b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	anon_vma_interval_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2988,8 +2988,7 @@ static void rmap_walk_anon(struct folio *folio,
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-			pgoff_start, pgoff_end) {
+	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
diff --git a/mm/vma.c b/mm/vma.c
index d99e2088de4e..2cd70f1d4db7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -272,7 +272,7 @@ anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, avc->anon_vma);
 }
 
 static void
@@ -281,7 +281,7 @@ anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, avc->anon_vma);
 }
 
 /*
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 37f81b11e8b7..3a11547b5bd1 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -272,12 +272,12 @@ static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 }
 
 static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
 static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 

-- 
2.55.0

