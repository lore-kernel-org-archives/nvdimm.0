Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086D04ADD88
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576155; cv=none; b=cYDQLHCnBTbUHFXDBVxA7HocHLjdP8zELnwftYGZWLbpscYKU86kmuuc62N2I8OYBqs8lxG+Wur+jrt8NBTKcef5TyDapM+36JLrADgyOpMGagh8hl3Cd1RCG6wkyVKa5g0kvow4kxNDyXuA51pEoX/pmNDMMJ/1ZO1Y338Fu4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576155; c=relaxed/simple;
	bh=j5xH/AGqxlMnI4LwfdkAwqF7ClZEvvqOMrstQsxVkTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1WcIueMmA/VMRAuknYNqyKMEoTp6Ehrpw+mPs3T49CWFEylkOHj/vFU6o9xyAI3c618+JhPBTPqKH0Ow+Ikznkquw3pMIqJcdcT1kwEDbmUyQkCfaA/IX6kJz0Uc2DowhIzuxqNJ5jjZpL4ECDNpAZ5F75lEZ3VG7I2YBuWlfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=VWaE4MUP; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="VWaE4MUP"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-902fc790cd5so98374306d6.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576150; x=1785180950; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yASRzDv+z671P8+NV2oI5hgA8GSxr/9xexPSIm4ZBgI=;
        b=VWaE4MUPVc+lmWC8TBuaQ/cHjtCUVaEHMSzbYqPwqS8wY3ew7w7I0+BYqvPhirvcbK
         mzNptNnXp4gQYgyIwp9zSYYzhSJDfMKiK6dxLR73KSiYqI/7ADUi0HeP0DZvTkNu+K0E
         +3KeYsTRDeQs5JRKfPj8fFbzGAg60GEZ43esAB/5VZ8bgjeERQK9EeVxXtJlNan/Vd6n
         9Xj1mLhJP/V6tFyV/rFytqkyNk4jN+PkovcDsPum23sEVlXSCEbwHmn27DPIvk7+Pff1
         jfVplhzkSzyYEZALWpkjZdMEmLG1qLkAsIVePdwj5HUwgxwCFgQkNRLhJ3xRw2i6JIyP
         27AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576150; x=1785180950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yASRzDv+z671P8+NV2oI5hgA8GSxr/9xexPSIm4ZBgI=;
        b=grZjkBnFp68FuDxQ29lmaG3XauxsLR2VkUePQ3B8U5fSQyoaicqXg0W6fngma+dXcL
         jJQgODhfljlWfzpwuZhf5zYayobefzuibYFbLeM3/JY34uvXWj3PMgxORCPjvtyazQ3L
         CRBiOkWNfkNfLe9hhFVUbxfxKxA1UlSnBa4vv/3WRoHPX3jJCKMSkUTxb+G9z1zRfqZW
         G2zz8AttbsZIk2y8zgExTflRphB/xOH2S9kn2BZ6nm4Q6pkRMjHBeLf95GL/J0dPnv/o
         rPXvO4u5/vt06ZQiS6+gRmL/6XOgN9Q/SWf9GP0taGQpC4xu5XpXLe1WMfwHi8vGoK7V
         Q06w==
X-Forwarded-Encrypted: i=1; AHgh+RqiakxubDbUp+oDkHsWWoEq7ahuLlhSWcLfAujlvRQXgtBKPeIE3wIUjQ4iSpnr42PFauaeaJY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9R4NOmSXzTU1Lk1n16q8Ciei/mQ3iXjjqOCh8X6gKiGhS28Na
	25vtNGniQaZCjtNIyooDcVUKh6SyR16GHXK2MOxdj10+tFhw+ktaYgoTq1ro69aMveE=
X-Gm-Gg: AfdE7cnmoa6n0WZEgIfOSnfOmIW7Nmv3iyH8jBuzhRnBpiiBoCf91wgo5I5sJsrzysV
	xIEXsKOoB4+iuqkXTUXd4UcDv70r7y7P4L5+ErqwZPk+TEegr6ORbbWAXOd+VnQ5EyafRb69y9T
	NE72RSFSEN9acv/pBHG9oLfMZtbzCzRB1p3vrNz+JctHOAGhSSZcDxuG/0QvXJC1Dsy/+idhrf2
	Ni3nlaDlLGSa1uhPYqlWcTvVAgKSU/G6BTVdR+ylTsjbEvxgUYj7ysKRDBg8ufcNwKc0i/y2EEX
	n0GDHL/M+mMnFyO2QvY791SGpnlAkwioqhnxjdXHH4vBfOORc/IFq28R2iLUj/hHdmoGcJ0sk9d
	OwDBuRZsGKBQ6V4msK4PZUzqz/qIVF+UKZjl/P0PgfJtaiVtqiA1vzq4hY5cWtp+gKzez3pYB26
	QfvaZH+4oArXeLE8TCXXNtTw4ZFTjDtOxDpm+TFZBHnIq+vcSGqUx4a3Ifv7+wfqrMdUH/KwJAA
	g==
X-Received: by 2002:a05:620a:711a:b0:92e:c118:18e3 with SMTP id af79cd13be357-930b437fd89mr1528072985a.90.1784576148847;
        Mon, 20 Jul 2026 12:35:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:48 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 27/36] mm: add NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
Date: Mon, 20 Jul 2026 15:34:21 -0400
Message-ID: <20260720193431.3841992-28-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a mechanism to opt private nodes into userland numa management.

Add node_allows_user_numa() to encapsulate whether a node supports
userland NUMA controls (always true for normal nodes).

Placement - setting mempolicy via:
  - mbind()
  - set_mempolicy()
  - set_mempolicy_home_node()

  For mempolicy, enforcement lives in one place: mpol_set_nodemask()

  Private nodes are not N_MEMORY, so they are trimmed from a nodemask
  like a cpuset-trimmed node.  All-private nodemasks without a valid
  node collapse to empty and the mempolicy fails.

  home_node is not special-cased - it is only a preferred-nid hint, and
  placement is governed by the bind nodemask, so a home node pointed at
  an invalid node simply falls back via the normal fallback zonelists.

  (All the same behavior as a node/mask not intersecting cpuset.mems).

Migration - relocation of pages to/from a private node:
  - mbind(MPOL_MF_MOVE)
  - move_pages()
  - migrate_pages()

  mbind(MPOL_MF_MOVE) is a migration, so mempolicy and migration share
  a single opt-in control.

  The migration interfaces all check node eligibility and use
  ALLOC_ZONELIST_PRIVATE to allow eligible migration requests to
  move a folio to a private node..

  alloc_migration_target() carries mtc->zlsel into the allocator
  via __folio_alloc_zonelist().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 33 +++++++++++++++++++++++++++++++++
 mm/internal.h                |  1 +
 mm/mempolicy.c               | 27 ++++++++++++++++++++-------
 mm/migrate.c                 | 19 ++++++++++++++-----
 4 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index f7cbae1309904..655fe9ec5cb61 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -13,6 +13,7 @@ struct page;
  * to let specific services operate on its node.
  */
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
+#define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -69,6 +70,33 @@ static inline bool node_allows_reclaim(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_user_numa - may userspace place or migrate memory here?
+ * @nid: the node to test
+ *
+ * Gate all userspace-directed memory operations on a private node.
+ *   - mbind()/set_mempolicy()
+ *   - move_pages()/migrate_pages()
+ *
+ * return: true for N_MEMORY and N_MEMORY_PRIVATE with CAP_USER_NUMA.
+ *         false for memoryless or opted-out private node.
+ */
+static inline bool node_allows_user_numa(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (node_state(nid, N_MEMORY))
+		return true;
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return false;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_USER_NUMA);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -91,6 +119,11 @@ static inline bool node_allows_reclaim(int nid)
 	return true;
 }
 
+static inline bool node_allows_user_numa(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/internal.h b/mm/internal.h
index 8329034ae561f..62e68acae08a3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1250,6 +1250,7 @@ struct migration_target_control {
 	nodemask_t *nmask;
 	gfp_t gfp_mask;
 	enum migrate_reason reason;
+	unsigned int alloc_flags;
 };
 
 /*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a3ffb09897489..fe42a510590a2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -434,13 +434,14 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 
 	/*
 	 * Private nodes are not in cpuset.mems, so they're always stripped.
-	 * Driver-allocated policies will already have MPOL_F_PRIVATE set,
-	 * if that's the case, add back in the requested set of private nodes.
+	 * Driver-allocated policies (MPOL_F_PRIVATE) and CAP_USER_NUMA private
+	 * nodes should be added back into the nodemask.
 	 */
 	for_each_node_mask(nid, *nodes) {
 		if (!node_is_private(nid))
 			continue;
-		if (pol->flags & MPOL_F_PRIVATE)
+		if ((pol->flags & MPOL_F_PRIVATE) ||
+		    node_allows_user_numa(nid))
 			node_set(nid, nsc->mask2);
 	}
 
@@ -696,7 +697,7 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	}
 	if (!queue_folio_required(folio, qp))
 		return;
-	if (folio_is_private_node(folio))
+	if (!node_allows_user_numa(folio_nid(folio)))
 		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma) ||
@@ -752,7 +753,8 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 		}
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_private_managed(folio))
+		if (!folio || folio_is_zone_device(folio) ||
+		    !node_allows_user_numa(folio_nid(folio)))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);
@@ -827,7 +829,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	folio = pfn_folio(pte_pfn(ptep));
 	if (!queue_folio_required(folio, qp))
 		goto unlock;
-	if (folio_is_private_node(folio))
+	if (!node_allows_user_numa(folio_nid(folio)))
 		goto unlock;
 	if (!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma)) {
@@ -1412,6 +1414,8 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 		.nid = dest,
 		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
 		.reason = MR_SYSCALL,
+		.alloc_flags = node_is_private(dest) ?
+			 ALLOC_ZONELIST_PRIVATE : ALLOC_DEFAULT,
 	};
 
 	nodes_clear(nmask);
@@ -1985,9 +1989,10 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	nodemask_t task_nodes;
-	int err;
+	nodemask_t priv_ok;
 	nodemask_t *old;
 	nodemask_t *new;
+	int err, nid;
 	NODEMASK_SCRATCH(scratch);
 
 	if (!scratch)
@@ -2027,7 +2032,14 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 	rcu_read_unlock();
 
+	/* Private nodes are stripped by cpuset checks. Allow eligible ones. */
+	nodes_clear(priv_ok);
+	for_each_node_mask(nid, *new)
+		if (node_is_private(nid) && node_allows_user_numa(nid))
+			node_set(nid, priv_ok);
+
 	task_nodes = cpuset_mems_allowed(task);
+	nodes_or(task_nodes, task_nodes, priv_ok);
 	/* Is the user allowed to access the target nodes? */
 	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
@@ -2035,6 +2047,7 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
+	nodes_or(task_nodes, task_nodes, priv_ok);
 	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index d20674c07b947..b548d79352a38 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2231,7 +2231,8 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask,
+			     mtc->alloc_flags);
 }
 
 #ifdef CONFIG_NUMA_MIGRATION
@@ -2253,6 +2254,8 @@ static int do_move_pages_to_node(struct list_head *pagelist, int node)
 		.nid = node,
 		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
 		.reason = MR_SYSCALL,
+		.alloc_flags = node_is_private(node) ?
+			 ALLOC_ZONELIST_PRIVATE : ALLOC_DEFAULT,
 	};
 
 	err = migrate_pages(pagelist, alloc_migration_target, NULL,
@@ -2268,7 +2271,8 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_private_managed(folio))
+	if (folio_is_zone_device(folio) ||
+	    !node_allows_user_numa(folio_nid(folio)))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)
@@ -2392,11 +2396,14 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY))
+
+		if (!node_allows_user_numa(node))
 			goto out_flush;
 
 		err = -EACCES;
-		if (!node_isset(node, task_nodes))
+		/* Private nodes are not partitioned by cpuset.mem */
+		if (!node_is_private(node) &&
+		    !node_isset(node, task_nodes))
 			goto out_flush;
 
 		if (current_node == NUMA_NO_NODE) {
@@ -2477,7 +2484,9 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		if (folio) {
 			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 				err = -EFAULT;
-			else if (folio_is_private_managed(folio))
+			else if (folio_is_zone_device(folio) ||
+				 (folio_is_private_node(folio) &&
+				  !node_allows_user_numa(folio_nid(folio))))
 				err = -ENOENT;
 			else
 				err = folio_nid(folio);
-- 
2.53.0-Meta

