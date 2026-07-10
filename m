Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BC39A4C5;
	Fri, 10 Jul 2026 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715209; cv=none; b=LFBu26Hg+DHKal56VszniZCs/xw+c2Jt8VjJqgLW7eGHv7FVV9U3jo/gYE2/yXmHF6OLVGzCv34DHLTPSn3rQD1/nxYuDLuCAenFzd1gtcMEgHcvPjHLHUhuSkYUpbelbgi3Rz2vIiGmNlyqa0uzzze4Zk4YkxCOVANwu5ujYrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715209; c=relaxed/simple;
	bh=RcQMOr7okmwmrMHVS+mP4E/LNV7GZ1eHmNfHonDKIh4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j/Au2Sove0G+MiCY7yDeBif7jvCxROTeVPBEsIqFMk2y4k1LcLpiijrBNN19BNahqukm5olStkRJxFAZQWIcJZZD/xIIuPPX6siH1TMv3u2y2BS3c5Urr2XrP5r6NbIEf12ca+JpwLz1GupMb+3anS4UxeQYzNUY/YHMBTqbyYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJhYClFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJhYClFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF241F000E9;
	Fri, 10 Jul 2026 20:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715207;
	bh=8BJkMOjdL3tYxtw1Cjs8vTxoBiLW1eSUk6BqH+zEY+k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KJhYClFfxeYjHFNUJ47V90SMGBiO8cXGZT/ciRY6YGuiovsxmCZXbNG8ahV8lExKU
	 tQcg5juhIffLIZR//R2LnhwNbF2SWsLkmhBmD+P3wCCkI8has8aK417Z9gX5cPgN5N
	 O+WrgR++oi31JXVQTxnmR3S7RoF9o//OqplK+v/9t3m3KtccaKhsOrAOzBemo3Zgek
	 UChBNvQ+b/sZpnFQ0j4P6s+A3MZgRix818w+Bj62VOR3GS2+I0T/V0+ecp5+FlSWF1
	 5JFGPlM8nir+1FX9Y4JpdoDcAbLwkE2MWd4CLEAoi5F5BhiWr7r0SvrxT+zQz/LeXk
	 sNZOexe92wEtg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:05 +0100
Subject: [PATCH v2 24/33] mm/vma: move __install_special_mapping() to vma.c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-24-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3781; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RcQMOr7okmwmrMHVS+mP4E/LNV7GZ1eHmNfHonDKIh4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23TKi///r6kSOvV5xDfzfGOb6oPXXY1TXU/3FG9L
 CtbrPlZRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaiHM/wT5s1/65G5dPAPVxJ
 G8UOCEgpfvhQp5s3ie3DtArRTalMMgz/i5dGzF+52+hHxDG+v5+01R6VF9vrGkwUN0h/sfeoZfN
 PLgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

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

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c | 38 --------------------------------------
 mm/vma.c  | 38 ++++++++++++++++++++++++++++++++++++++
 mm/vma.h  |  5 +++++
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 91eaa0c9e7ee..308a43eabd83 100644
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
index bdd99ba56b4d..5308aa5a8c91 100644
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
2.55.0

