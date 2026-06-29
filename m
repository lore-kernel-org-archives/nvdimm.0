Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F0F40BCB6;
	Mon, 29 Jun 2026 12:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735888; cv=none; b=Ti9Yyiz/cmbTH2iwUppGBpRPkQ8BD4aezcQ6q7z1Lmt7BOdCDuszCtD0xCqxBB096nIuRZ4v5K8bOQtk65qnArnEmwggSW3KHdkrU5i7BjToqNhok9o+uqIGL2I3lu8Zzau0CTAMz+XY9Sw8H/QGjkw1Ir2liYStcMMDpWwLiHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735888; c=relaxed/simple;
	bh=uBBlOxrxPdV6nO2h/oBIsQjGTRzvj+5YAvbV3HR6/Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNl7mPfD86l6gWIHGJVoB/kVLbfEFF2mOxJV+ql7Di5Mb3HqNJWh6NrWTP5rbi8JUpqubNmUEWecVhMbPoMBgASktaFWRh6U2etdsYQXjeNOtXhMXphXBFn0u4oucXQYYFNS1+UU3h2J9qP+7F4QXlAmptj7VcTWC+92qyWKy58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlndaMYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlndaMYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC75F1F00A3F;
	Mon, 29 Jun 2026 12:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735886;
	bh=lsln70Nt2xZ3e+TM/n/yGo1O6uRwImQ7en0yGThaEMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlndaMYOEEDo9y/BYx1L4NafUGtOw9hv0rBUhMcjKwlZmqbjc94j2hVFLqS/KvZ+y
	 40OFrYDVSSF7T9EypqFSK6TimQk/4XGGd8umptAGTerO+BOZsNYpw3L7GtcNSfPwM7
	 SsZ0tc06chaOtQb5ZSfbU6KDl53Cw6DknS3B97eBehCTm8g9K9btYeMFOMNSygzaBK
	 EwTmsweFODQqTlA8WvspAXfk0bJC3OwLqAZuwS3SQ5sBHz4xtGlKyMP31PmgDAMTE0
	 Mluv0Zrvs/xdiEsrbn9HMSsNhic3GiJi2z1Uh7dcPNVmDO6p0HLYIghRVt2kLheU9D
	 UArLqvg1MyX8g==
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
Subject: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
Date: Mon, 29 Jun 2026 13:23:28 +0100
Message-ID: <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
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

Be consistent in using vma_start_pgoff() and vma_end_pgoff(), which clearly
indicates which part of the VMA the page offset refers to and aids
greppability.

This is part of a broader series laying the ground to provide a virtual
page offset for MAP_PRIVATE-file backed anon folios.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 kernel/dma/coherent.c      |  7 ++++---
 kernel/dma/direct.c        |  6 ++++--
 kernel/dma/mapping.c       |  8 +++++---
 kernel/dma/ops_helpers.c   |  4 ++--
 kernel/events/core.c       | 20 +++++++++++---------
 kernel/events/uprobes.c    | 11 +++++++----
 kernel/kcov.c              |  2 +-
 kernel/trace/ring_buffer.c |  3 ++-
 8 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index bcdc0f76d2e8..2d3195eb7e83 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -236,14 +236,15 @@ static int __dma_mmap_from_coherent(struct dma_coherent_mem *mem,
 {
 	if (mem && vaddr >= mem->virt_base && vaddr + size <=
 		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT))) {
-		unsigned long off = vma->vm_pgoff;
+		const pgoff_t pgoff_start = vma_start_pgoff(vma);
+		const pgoff_t pgoff_end = vma_end_pgoff(vma);
 		int start = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 		unsigned long user_count = vma_pages(vma);
 		int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		*ret = -ENXIO;
-		if (off < count && user_count <= count - off) {
-			unsigned long pfn = mem->pfn_base + start + off;
+		if (pgoff_start < count && pgoff_end <= count) {
+			unsigned long pfn = mem->pfn_base + start + pgoff_start;
 			*ret = remap_pfn_range(vma, vma->vm_start, pfn,
 					       user_count << PAGE_SHIFT,
 					       vma->vm_page_prot);
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 4391b797d4db..436310d6e4a2 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -534,6 +534,8 @@ int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long pfn = PHYS_PFN(dma_to_phys(dev, dma_addr));
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
 	int ret = -ENXIO;
 
 	vma->vm_page_prot = dma_pgprot(dev, vma->vm_page_prot, attrs);
@@ -545,9 +547,9 @@ int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
 	if (dma_mmap_from_global_coherent(vma, cpu_addr, size, &ret))
 		return ret;
 
-	if (vma->vm_pgoff >= count || user_count > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
-	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
+	return remap_pfn_range(vma, vma->vm_start, pfn + pgoff_start,
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 }
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 4fe04669e5e6..c986639044e9 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -761,12 +761,14 @@ EXPORT_SYMBOL_GPL(dma_free_pages);
 int dma_mmap_pages(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct page *page)
 {
-	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
+	const unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (vma->vm_pgoff >= count || vma_pages(vma) > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
 	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(page) + vma->vm_pgoff,
+			       page_to_pfn(page) + pgoff_start,
 			       vma_pages(vma) << PAGE_SHIFT, vma->vm_page_prot);
 }
 EXPORT_SYMBOL_GPL(dma_mmap_pages);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 20caf9cabf69..6b5f9208d31c 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -39,7 +39,7 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long off = vma->vm_pgoff;
+	unsigned long off = vma_start_pgoff(vma);
 	struct page *page = dma_common_vaddr_to_page(cpu_addr);
 	int ret = -ENXIO;
 
@@ -52,7 +52,7 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 		return -ENXIO;
 
 	return remap_pfn_range(vma, vma->vm_start,
-			page_to_pfn(page) + vma->vm_pgoff,
+			page_to_pfn(page) + vma_start_pgoff(vma),
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 #else
 	return -ENXIO;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 954c36e28101..d6d2d557ccb8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6998,7 +6998,7 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	refcount_inc(&event->mmap_count);
 	refcount_inc(&event->rb->mmap_count);
 
-	if (vma->vm_pgoff)
+	if (vma_start_pgoff(vma))
 		refcount_inc(&event->rb->aux_mmap_count);
 
 	if (mapped)
@@ -7032,7 +7032,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 * The AUX buffer is strictly a sub-buffer, serialize using aux_mutex
 	 * to avoid complications.
 	 */
-	if (rb_has_aux(rb) && vma->vm_pgoff == rb->aux_pgoff &&
+	if (rb_has_aux(rb) && vma_start_pgoff(vma) == rb->aux_pgoff &&
 	    refcount_dec_and_mutex_lock(&rb->aux_mmap_count, &rb->aux_mutex)) {
 		/*
 		 * Stop all AUX events that are writing to this buffer,
@@ -7190,7 +7190,8 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
 	 */
 	for (pagenum = 0; pagenum < nr_pages; pagenum++) {
 		unsigned long va = vma->vm_start + PAGE_SIZE * pagenum;
-		struct page *page = perf_mmap_to_page(rb, vma->vm_pgoff + pagenum);
+		struct page *page = perf_mmap_to_page(rb,
+				vma_start_pgoff(vma) + pagenum);
 
 		if (page == NULL) {
 			err = -EINVAL;
@@ -7348,6 +7349,7 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 	u64 aux_offset, aux_size;
 	struct perf_buffer *rb;
 	int ret, rb_flags = 0;
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 
 	rb = event->rb;
 	if (!rb)
@@ -7366,11 +7368,11 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 	if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
 		return -EINVAL;
 
-	if (aux_offset != vma->vm_pgoff << PAGE_SHIFT)
+	if (aux_offset != pgoff_start << PAGE_SHIFT)
 		return -EINVAL;
 
 	/* already mapped with a different offset */
-	if (rb_has_aux(rb) && rb->aux_pgoff != vma->vm_pgoff)
+	if (rb_has_aux(rb) && rb->aux_pgoff != pgoff_start)
 		return -EINVAL;
 
 	if (aux_size != nr_pages * PAGE_SIZE)
@@ -7400,7 +7402,7 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 		if (vma->vm_flags & VM_WRITE)
 			rb_flags |= RING_BUFFER_WRITABLE;
 
-		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
+		ret = rb_alloc_aux(rb, event, pgoff_start, nr_pages,
 				   event->attr.aux_watermark, rb_flags);
 		if (ret) {
 			refcount_dec(&rb->mmap_count);
@@ -7457,7 +7459,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		if (event->state <= PERF_EVENT_STATE_REVOKED)
 			return -ENODEV;
 
-		if (vma->vm_pgoff == 0)
+		if (!vma_start_pgoff(vma))
 			ret = perf_mmap_rb(vma, event, nr_pages);
 		else
 			ret = perf_mmap_aux(vma, event, nr_pages);
@@ -9884,7 +9886,7 @@ static bool perf_addr_filter_vma_adjust(struct perf_addr_filter *filter,
 					struct perf_addr_filter_range *fr)
 {
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long off = vma_start_pgoff(vma) << PAGE_SHIFT;
 	struct file *file = vma->vm_file;
 
 	if (!perf_addr_filter_match(filter, file, off, vma_size))
@@ -9974,7 +9976,7 @@ void perf_event_mmap(struct vm_area_struct *vma)
 			/* .tid */
 			.start  = vma->vm_start,
 			.len    = vma->vm_end - vma->vm_start,
-			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
+			.pgoff  = (u64)vma_start_pgoff(vma) << PAGE_SHIFT,
 		},
 		/* .maj (attr_mmap2 only) */
 		/* .min (attr_mmap2 only) */
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f23cebacbc6d..244651380ca1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -144,12 +144,14 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
 {
-	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	return vma->vm_start + offset -
+		((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT);
 }
 
 static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
 {
-	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+	return ((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(vaddr - vma->vm_start);
 }
 
 /**
@@ -1482,7 +1484,7 @@ static int unapply_uprobe(struct uprobe *uprobe, struct mm_struct *mm)
 		    file_inode(vma->vm_file) != uprobe->inode)
 			continue;
 
-		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+		offset = (loff_t)vma_start_pgoff(vma) << PAGE_SHIFT;
 		if (uprobe->offset <  offset ||
 		    uprobe->offset >= offset + vma->vm_end - vma->vm_start)
 			continue;
@@ -2453,7 +2455,8 @@ static struct uprobe *find_active_uprobe_speculative(unsigned long bp_vaddr)
 	if (!vm_file)
 		return NULL;
 
-	offset = (loff_t)(vma->vm_pgoff << PAGE_SHIFT) + (bp_vaddr - vma->vm_start);
+	offset = (loff_t)(vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(bp_vaddr - vma->vm_start);
 	uprobe = find_uprobe_rcu(vm_file->f_inode, offset);
 	if (!uprobe)
 		return NULL;
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1df373fb562b..b19b473c366a 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -512,7 +512,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->area == NULL || vma->vm_pgoff != 0 ||
+	if (kcov->area == NULL || vma_start_pgoff(vma) ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 56a328e94395..dfa493d54ef9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7613,7 +7613,8 @@ static int __rb_inc_dec_mapped(struct ring_buffer_per_cpu *cpu_buffer,
 static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 			struct vm_area_struct *vma)
 {
-	unsigned long nr_subbufs, nr_pages, nr_vma_pages, pgoff = vma->vm_pgoff;
+	unsigned long nr_subbufs, nr_pages, nr_vma_pages;
+	pgoff_t pgoff = vma_start_pgoff(vma);
 	unsigned int subbuf_pages, subbuf_order;
 	struct page **pages __free(kfree) = NULL;
 	int p = 0, s = 0;
-- 
2.54.0

