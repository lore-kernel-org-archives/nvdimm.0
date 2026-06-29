Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B170F411691;
	Mon, 29 Jun 2026 12:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735902; cv=none; b=DlqW/DlMY1fu3WURhY1RUtPxw5XfjKCtZyLFBKtXPghM996iz/bRr/H4C+MIG2QGerOfc9Wbo66/fD1CX7PY4owhd94ozI52Vi9+CbJCDGQ9WRlLSjpmuEx2MRCRwDZGHvCIANzeaK3UeRJRrKQcG5rFbk5wprAVzkKAwBMjzfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735902; c=relaxed/simple;
	bh=qjR4XDA83umdbC0IULUsMxYMUEy8Djzf1WG7asIRisA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJTS9+rIdyP/8KAkMzcKzd6W6aqsFik6WDE/N1fMiCqIy7KlSDgGUuU/gRRk98v8hop/xSk88PQ1oX0L5UMNLS+EBE/a504nYpm2n9PeZRawtiIaabouf/XbSySn/U2ttwiauw02JLkkbDli/9bU166qoiD5C5MacSw8+0D1wWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMI2EGHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMI2EGHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8AA1F000E9;
	Mon, 29 Jun 2026 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735901;
	bh=asQRdyIkJe4bZA3XNuG6RWmjMVwJLej4ucyvaRrG1LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMI2EGHqsu61Hk3DdrG2oE/j59vfyqrUCk+WCpAW7cZQC3HRNrsq4bMIRtFfzvpE9
	 8fnoSABB2kkBYcDq+ipeOraETeJJRjPa/NVEF1214bvzOLHh1ZPNf0F00uunCOx/Xb
	 EYV66LD9bkxw3TihOv0i3XyWZjOGS+D1VauzvrvwWVFAHBVNPZTviKelkvCbHkMtve
	 QSMGA+tQ+t8R72mawPag8VZveHTVhYhVWMG0u03qBCVfQ21qWkkLbPoX3En8pnQk6N
	 Z2f9URfPzOvNfoEeESppHpb6Azn03lFpXyqzwfUDzRvNaF9WVvmAODPtAFDo2XxCi6
	 Ux3VgqH9infsg==
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
Subject: [PATCH 22/30] mm/vma: move __install_special_mapping() to vma.c
Date: Mon, 29 Jun 2026 13:23:33 +0100
Message-ID: <b3254231831037ca3e9757e3e05c90072e04a6aa.1782735110.git.ljs@kernel.org>
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

This function is operating on VMAs and rightly belongs in vma.c, where it
can be subject to VMA userland testing and allows us to isolate it from the
rest of mm.

The _install_special_mapping() function will remain in mmap.c as a wrapper,
since this is used by architecture-specific code.

Doing so allows us to isolate more functions in vma.c for the same reasons.

This forms part of work to allow for tracking MAP_PRIVATE file-backed
mappings by their anonymous virtual page offset, as doing so allows us to
isolate and keep code that interacts with this together.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c | 38 --------------------------------------
 mm/vma.c  | 38 ++++++++++++++++++++++++++++++++++++++
 mm/vma.h  |  5 +++++
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2d09a57e3620..46174e706bbe 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1447,44 +1447,6 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-static struct vm_area_struct *__install_special_mapping(
-	struct mm_struct *mm,
-	unsigned long addr, unsigned long len,
-	vm_flags_t vm_flags, void *priv,
-	const struct vm_operations_struct *ops)
-{
-	int ret;
-	struct vm_area_struct *vma;
-
-	vma = vm_area_alloc(mm);
-	if (unlikely(vma == NULL))
-		return ERR_PTR(-ENOMEM);
-
-	vma_set_range(vma, addr, addr + len, 0);
-	vm_flags |= mm->def_flags | VM_DONTEXPAND;
-	if (pgtable_supports_soft_dirty())
-		vm_flags |= VM_SOFTDIRTY;
-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-
-	vma->vm_ops = ops;
-	vma->vm_private_data = priv;
-
-	ret = insert_vm_struct(mm, vma);
-	if (ret)
-		goto out;
-
-	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
-
-	perf_event_mmap(vma);
-
-	return vma;
-
-out:
-	vm_area_free(vma);
-	return ERR_PTR(ret);
-}
-
 bool vma_is_special_mapping(const struct vm_area_struct *vma,
 	const struct vm_special_mapping *sm)
 {
diff --git a/mm/vma.c b/mm/vma.c
index cb7222e20c93..f4de706a2728 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3399,3 +3399,41 @@ __weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return vma_kernel_pagesize(vma);
 }
+
+struct vm_area_struct *__install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	vm_flags_t vm_flags, void *priv,
+	const struct vm_operations_struct *ops)
+{
+	int ret;
+	struct vm_area_struct *vma;
+
+	vma = vm_area_alloc(mm);
+	if (unlikely(vma == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	vma_set_range(vma, addr, addr + len, 0);
+	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	if (pgtable_supports_soft_dirty())
+		vm_flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	vma->vm_ops = ops;
+	vma->vm_private_data = priv;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
+
+	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
+
+	perf_event_mmap(vma);
+
+	return vma;
+
+out:
+	vm_area_free(vma);
+	return ERR_PTR(ret);
+}
diff --git a/mm/vma.h b/mm/vma.h
index 47fe35e5307e..14f026bf3be4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -775,4 +775,9 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 }
 #endif
 
+struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
+		unsigned long addr, unsigned long len,
+		vm_flags_t vm_flags, void *priv,
+		const struct vm_operations_struct *ops);
+
 #endif	/* __MM_VMA_H */
-- 
2.54.0

