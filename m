Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB9410D3B;
	Mon, 29 Jun 2026 12:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735900; cv=none; b=a7rvA1Fa/YJj/Nds7tWE6vIoxkq/hHPb8ERv/thGlnUsXIn0GHIG+1t+rjcjpM0hcRHXi9FEXGCM/qpVXBjA/kEQ1mVdRSf14MhiUpcprwt0nHs54nWPbL3TB0iaPkM7SkhewvQKlsiA1cdgCzdWDGSvZjdStIP3fOyoCIMQBNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735900; c=relaxed/simple;
	bh=izTKDlAQNVb0GolyWzbVWpzWvA9MCe9RWHqUTZaNSQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnHkqw1+Rajwkfko4tK4H72S6E2lEapm145PWQ7OqF3vr3XKrd30tNiwYq7UC4isdyspD4yM9wc72ly32TP2DFG+PRPnf47K5+n7/8JD4e0rS8vkIDWdx5HHfJQm5AQfhCve6sORGLTNqBA1KIxQ8eqC/sh25d3wFCoj9Jc2mno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LC8VtPYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LC8VtPYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A521F000E9;
	Mon, 29 Jun 2026 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735898;
	bh=n6T1iWSEXJtO4Ol/BA3gpFHV+/0gKCk1DbIlaaeu8VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC8VtPYzfBDn0IT72dDOkbWV0WRSLf9IMTrBsPoKyWemI+ySsQR91N3T+gF5VUjPk
	 vJ/A02mPxatWNByRseH/44QDY6V7GxURExlUMgpWc6Ak0sIqOgqIB89+Dhtiz3DdaG
	 0qDDEK3Kw5b+lPx1blaG9h4PjSQv6pYATJEXJn1gVoSDSzHVV2QcCkISf49YvzLmOs
	 bWKRZVJOCgN/LnWSTThp3BqEnLf6yht4HhcexHl5j948YFGHeGgOFuaos8+m9BA1RV
	 HjcHH1HvULwL911lM1Mca9m5XW5H0chyhZ42L4YjclZADCKQaoLUCEzOrF3dzZjn7A
	 Ytzbnh24BtJ6Q==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Date: Mon, 29 Jun 2026 13:23:32 +0100
Message-ID: <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers for adding or subtracting to a VMA's page offset, exposed
internally for VMA users within mm in mm/vma.h.

This is to lay the foundations for tracking anonymous page offset for
MAP_PRIVATE file-backed mappings, where adding and subtracting from this
value must be reflected in both the file and anonymous offsets.

These are used on VMA split and downward stack expansion.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/nommu.c                      |  6 ++++--
 mm/vma.c                        |  6 +++---
 mm/vma.h                        | 12 ++++++++++++
 tools/testing/vma/include/dup.h | 13 ++++++++++++-
 4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 7333d855e974..c7fafcd87c14 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -41,6 +41,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
+#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
@@ -1338,7 +1339,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		region->vm_top = region->vm_end = new->vm_end = addr;
 	} else {
 		region->vm_start = new->vm_start = addr;
-		region->vm_pgoff = new->vm_pgoff += npages;
+		vma_add_pgoff(new, npages);
+		region->vm_pgoff = vma_start_pgoff(new);
 	}
 
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
@@ -1355,7 +1357,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
 		vma->vm_region->vm_start = vma->vm_start = addr;
-		vma->vm_pgoff += npages;
+		vma_add_pgoff(vma, npages);
 		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
 	} else {
 		vma->vm_region->vm_end = vma->vm_end = addr;
diff --git a/mm/vma.c b/mm/vma.c
index 185d07397ca6..cb7222e20c93 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		new->vm_end = addr;
 	} else {
 		new->vm_start = addr;
-		new->vm_pgoff += linear_page_delta(vma, addr);
+		vma_add_pgoff(new, linear_page_delta(vma, addr));
 	}
 
 	err = -ENOMEM;
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
 	} else {
 		vma->vm_end = addr;
 	}
@@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
-				vma->vm_pgoff -= grow;
+				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
diff --git a/mm/vma.h b/mm/vma.h
index 2342516ce00e..47fe35e5307e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff += delta;
+}
+
+static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
+{
+	vma_assert_can_modify(vma);
+	vma->vm_pgoff -= delta;
+}
+
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 7ed165c8d9bc..41fea90a344d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -1170,7 +1175,13 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
+}
+
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
-- 
2.54.0

