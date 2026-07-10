Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13E39FCCC;
	Fri, 10 Jul 2026 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715255; cv=none; b=rBQCAQ7q3IrcR5X2d4t3IRgn6mluKo2WkGfYz8/15plyT7yDDEK4izOR9dHFKUcFjJDVT8FwyJH+e9TEIaGRpi+HCNjIrKtBovnFiy2PTvUU5g83EFhZkbb6pxrUXIA1LIH9KV/gNz4L1LZJmKBrMjU1zUNZghTpaQEzW2A9k1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715255; c=relaxed/simple;
	bh=0LxPiqBxAD9IhreoUXWjHFUoHlm6qZINpaBU8bU6qMA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X7+IPacAPY3Afs81nmiFdEKViUW2dBpXUwkdRQANrSW30YB8oqYnEARVuVP/Aql6akPGKkzX9ROPKwU1Ej7ZAhTaI6FZlqCIyC+vchhOZV27o3wme2x6prCxlmggSfB8G7zkk4Ewfvon+njpGdtvEepQrbVy8Uv2tO8rc43H7U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBGjC0JG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBGjC0JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534F11F000E9;
	Fri, 10 Jul 2026 20:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715254;
	bh=nwHLf7niWPUb+EByGfZPa1IGezWCh6hKiz5/kPjeOK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JBGjC0JG6taRh6W76fZOLNsjNinAKtLEZdyZf56hkpmD1SsPyspbJgP79fA97RNFu
	 rInXrcVoyDKxluHVIscUJlMQmCqhyn5vwU71G1ydzkj06R3KS8xqkqBGEHAwFFX5/0
	 oLU/CAkX/h1Gzz1GS/ZeKTBmtJF2fpl8ljFKwZRglGHj0rtfQ8ndwlo5G5KRsMycDE
	 nxh7CmmMG6beLYOuSIkOMMaLZ1yeaXbdG7b7alCjP4UkqQg8wtUK6yOWoFCJZKQTpC
	 o0a+qybijiTRUl268p65PJiHOM6drgF6XspLNQuwd7bBhft3/7HTnnjHqcGpREBH1/
	 t6TG2qcQpKTOw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:07 +0100
Subject: [PATCH v2 26/33] mm/vma: update vma_shrink() to not pass start,
 pgoff parameters
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-26-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4413; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0LxPiqBxAD9IhreoUXWjHFUoHlm6qZINpaBU8bU6qMA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23LjgYW8Qj8SmXmjwgOjpPi2iF7zC5wcn+95fs7l
 iaOVf86SlkYxLgYZMUUWZ5/Ed8fJBI2r/OCvxvMHFYmkCEMXJwCMBFxP0aGV36b2hPsZB4I79HY
 so+HedmSLrH9my+69IdZeCZd5ouYx8iwVvT+y+n/804y/Dn3tjAuJ/T0sU1CtjziL09p1mW378z
 nAAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

vma_shrink() is only used by relocate_vma_down() to shrink the tail of a
VMA. Therefore neither the start nor the pgoff parameters make any sense.

It seemed we were passing the pgoff parameter solely to satisfy
vma_set_range()'s requirement for pgoff being specified.

Since vma_set_range() is now isolated to vma.c, we can simply introduce
__vma_set_range() which sets only vma->vm_[start, end], and invoke this
instead, removing start and pgoff from vma_shrink() altogether.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c                        | 31 +++++++++++++++++--------------
 mm/vma.h                        |  3 +--
 mm/vma_exec.c                   |  2 +-
 tools/testing/vma/tests/merge.c |  2 +-
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index cc0e449ad0be..a474920a25b3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,11 +70,17 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end)
 {
 	vma->vm_start = start;
 	vma->vm_end = end;
+}
+
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	__vma_set_range(vma, start, end);
 	vma->vm_pgoff = pgoff;
 }
 
@@ -1279,27 +1285,24 @@ int vma_expand(struct vma_merge_struct *vmg)
 	return -ENOMEM;
 }
 
-/*
- * vma_shrink() - Reduce an existing VMAs memory area
+/**
+ * vma_shrink() - Shrink the end of a VMA
  * @vmi: The vma iterator
  * @vma: The VMA to modify
- * @start: The new start
  * @end: The new end
  *
+ * Note that the caller may only shrink the end of the VMA.
+ *
  * Returns: 0 on success, -ENOMEM otherwise
  */
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff)
+	       unsigned long end)
 {
 	struct vma_prepare vp;
 
-	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
-
-	if (vma->vm_start < start)
-		vma_iter_config(vmi, vma->vm_start, start);
-	else
-		vma_iter_config(vmi, end, vma->vm_end);
+	VM_WARN_ON_ONCE(end > vma->vm_end);
 
+	vma_iter_config(vmi, end, vma->vm_end);
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
@@ -1307,10 +1310,10 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, NULL);
+	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
 	vma_iter_clear(vmi);
-	vma_set_range(vma, start, end, pgoff);
+	__vma_set_range(vma, vma->vm_start, end);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);
 	return 0;
diff --git a/mm/vma.h b/mm/vma.h
index 14f026bf3be4..40effaa3ebe4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -297,8 +297,7 @@ void validate_mm(struct mm_struct *mm);
 
 __must_check int vma_expand(struct vma_merge_struct *vmg);
 __must_check int vma_shrink(struct vma_iterator *vmi,
-		struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, pgoff_t pgoff);
+		struct vm_area_struct *vma, unsigned long end);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index e3644a3042e2..13a05e041195 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -89,7 +89,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma_start_pgoff(vma));
+	return vma_shrink(&vmi, vma, new_end);
 }
 
 /*
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index f8666a755749..e357accc8499 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -227,7 +227,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_FALSE(attach_vma(&mm, vma));
 
-	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
+	ASSERT_FALSE(vma_shrink(&vmi, vma, 0x1000));
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);

-- 
2.55.0

