Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A63955E1;
	Fri, 10 Jul 2026 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783714885; cv=none; b=UZs9TiSYrOBrazHMYwZGqgvcPkbszlCV8Q61zXCDCmwjhxwsUfzZA6NKpiwBEc2MrHyuXSBUmZuPASLHrSPv7ti8rVBOhPO430P7+Jdj1kILV0oY2OKy0/FY/JY8JnvbHvUlnYEcR1ynOWbQxmtty3QqnNQ8UN8wRUAqg3uK7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783714885; c=relaxed/simple;
	bh=BHX0baiEr9bg7gCqCCxbadqLVVJLcigeq+b/x/sekB0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I+dV/zC0t0xP+BUkoo69vLe+vrLJz8ZCFycsgxtuLviVifPghruM9XValNEeAZdRAhjGLCe6dhE84EZmK3fd7mm2wiuAsk0GA3gWmkqXxC54Mt+LZpuORFJ8bp2amqCkAg8wfKaoajbfrcKV3MWYRaI4sCN4NcQR/bRlHMKsSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YA5DDqaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YA5DDqaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21581F000E9;
	Fri, 10 Jul 2026 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714883;
	bh=gVQmK7W6QoKtw/kGvaitEcUKY+xFpiYNr8Q5ruqmHhg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YA5DDqafLIqNPLP9XGD/K2+Z42mVK146zNneUnUQphi9T6ZT5dS9mtuvVEfhJDTSi
	 s//g62lEPa/5fM6Rj+MfHLeFXY4lmP8YRRNVv/IBUuJF+3suQJzo279O+JLZ3oR0g8
	 17RPG3oi0R+HZ04oSDHcjxfiOvDAfUyl/59WBZGvYlcTsOfv5QtyYXwRI0mROoCNg6
	 bDmWqupn7Bivg41Bjy1cY8FcRJcw1cPUnFVaTBUJXi8e+rHys2oigCKJ0ZN7zH42Qh
	 xqfydxdwf+sygnAcS/tTpUOLud5oxgOgbKSoUNdV2wDLWFryUxryD6cA7pwzceYtQs
	 toirvlGHi640Q==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:51 +0100
Subject: [PATCH v2 10/33] mm/rmap: rename anon_vma_interval_tree_*() params
 and use pgoff_t
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5211; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BHX0baiEr9bg7gCqCCxbadqLVVJLcigeq+b/x/sekB0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg62/nLvR48oWtTJvwtcdDA9nW79gPecs6J5qwZB8n
 +XZu7VdHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIkw4jQxvjWqM9y/w8s1l1
 C5JkljBK2jl9eq/WKbJLfeZ/rp9NCxn+GTsztZksXHtZye1dF8fVwCnL321Zn9aseENRcKXNgt5
 7/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
clear what is being passed.

Also, express page offsets in terms of pgoff_t to be consistent.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 19 +++++++++++--------
 mm/interval_tree.c | 34 +++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5d825824f7e4..ae7c976b516a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4110,23 +4110,26 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
+
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long start, unsigned long last);
+				  pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				 unsigned long start, unsigned long last);
+				 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
-	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
+#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
+	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
+						     pgoff_last);	       \
+	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
+							 pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index b82d2a0d9c4e..5bfe95b5cd28 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,55 +81,55 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
-INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
 		     static, __anon_vma_interval_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
-	node->cached_vma_start = avc_start_pgoff(node);
-	node->cached_vma_last = avc_last_pgoff(node);
+	avc->cached_vma_start = avc_start_pgoff(avc);
+	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long first, unsigned long last)
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
 	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
-						   first, last);
+						   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *node,
-				 unsigned long first, unsigned long last)
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(node, first, last);
+	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node)
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
 {
-	WARN_ON_ONCE(node->cached_vma_start != avc_start_pgoff(node));
-	WARN_ON_ONCE(node->cached_vma_last != avc_last_pgoff(node));
+	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
+	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
 }
 #endif

-- 
2.55.0

