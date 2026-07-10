Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7933955C9;
	Fri, 10 Jul 2026 20:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783714769; cv=none; b=p28BZ9Gu9AkttHILjCAYh3o9N9wtqYMNKf/KPnqZDj4A4Wp9rVXlIBpuqmEiClHZV/p0tjX/zNREqIZZF2Or5HKqV88/RlbtH+E22i+ipzppyIJ+EP5vfllN9/kyL8iMP0mGN9mTaZJ2zufsNpa3wHIRxHt5iuxtj4GUrFhdJKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783714769; c=relaxed/simple;
	bh=VZjvr3kZlkmGcsP4WgHgMF6CSbykEZdr5f8GmL5Gfpw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rqJq/0jwu2kGQ0hUhxsyUk9A8ODpIfcxgBBdycEPxwEd5EJvkkisuZJ7bFbJ+b+VE9pUh8KYgixpe3FKEmtZSa59fiw3DyMpFU6vvlBmmKDaRNEBvNVS3C3j6pHJoTN3LMxF9Cwo/IUbxWaee+kn7oUVHnLY8h3kdoWN1QGIcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pcf2+0VD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pcf2+0VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FE1F00A3A;
	Fri, 10 Jul 2026 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714767;
	bh=VRLMqMtx0xVRr5vFgYMRw7ggTvxftRoyLyfFQKrqZ2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pcf2+0VDkxZNuVa2Cy4lDGhsOB6+enWxg/0/q8e278R+fYuriXovlo2KoDVvNTmXN
	 g4JAhfAyf+/GqazKK2Uv8OXmUynTFSmHR6W6xBEN/66hOOQ9qHTpJNIKcHYkKzMTU2
	 QBJnnCrQ/o681samcU8yVgyk3flhOlPsMk6gdUy3Rdu+/qVKxUkFThaEAuSIX2nFCL
	 4Mdnn84yxyjDLlKeMe+A760I8tmgSy5XzTprH0bZq3boIH+4a4l8yyrMOJmOvYIcFe
	 pLrSEnpqwJ0ANXFpuT30ZIcg11rNlGJ8rauvY6XInvMseP5VWizouKSTmnJLUBPs+E
	 OnWQ3HqWG7HFA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:46 +0100
Subject: [PATCH v2 05/33] mm/rmap: update mm/interval_tree.c comments
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1996; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VZjvr3kZlkmGcsP4WgHgMF6CSbykEZdr5f8GmL5Gfpw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg60dcjZeOiBw1zBs0RQu5dke2c4lqtMnRbPMFH73b
 FeeybNPHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIdh8jw0RHC5MPwlHm7AG8
 P7fdMTQJu75b6FP4F0bRMOkHZ69P3svIsM3ac13q3wB972cqVhfOZL1e1ZD0+WSGa4qYHlvxE6W
 rvAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Update the file comment to clarify that both file-backed and anonymous
interval trees are provided, referencing the relevant data types for
clarity.

Also add comments to indicate which parts of the file apply to each.

While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 344d1f5946c7..2d50bc6228c4 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/interval_tree.c - interval tree for mapping->i_mmap
+ * mm/interval_tree.c - interval tree for address_space->i_mmap and
+ * anon_vma->rb_root
  *
  * Copyright (C) 2012, Michel Lespinasse <walken@google.com>
  */
@@ -10,6 +11,8 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
+/* File-backed interval tree (address_space->i_mmap) */
+
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
@@ -23,7 +26,7 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 	struct vm_area_struct *parent;
 	unsigned long last = vma_last_pgoff(node);
 
-	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
+	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
 	if (!prev->shared.rb.rb_right) {
 		parent = prev;
@@ -48,6 +51,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 			    &vma_interval_tree_augment);
 }
 
+/* Anonymous interval tree (anon_vma->rb_root) */
+
 static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);

-- 
2.55.0

