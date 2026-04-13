Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219D23128D7
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 06:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776062279; cv=none; b=dZ3Ymi0Vu6a221nVJ/Ka0XuOfQvW0zfr+6Q50JjFy6e+eQvR8tl0tP+jphalR3GOjjtI59ojUVIDYYXdG1+I4EM5Gv7N8HgYWwADAF0S+HbgZjkcmlOYey4AchT5YEaXMNUrfgxYSDwx4WqwEco7uolEdJXKsYcHR5EYfOw42u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776062279; c=relaxed/simple;
	bh=MJpWc2ZM9ZNlGme0TLVTzMyJF7M4BfZyxTPqJGEgH10=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtYZvHT0Q9s63ZgulKwnLtGfjRNyIlDwV8hkdPZWhqfIWfhzSz7WPFHm/NuiVH82fgBJGxuPAodjgHkv6b5dento/6ShJzKHDIhNweapqCy4dNlTa6kUcCii4FesmNIhM397/T77qpKG5twIP2iu/dSAiAzkkHe+cHj7gdRWzsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNf68dvz1YQpmG;
	Mon, 13 Apr 2026 14:21:22 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNd3nCLz1YQpmG;
	Mon, 13 Apr 2026 14:21:21 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1A3AD7892;
	Mon, 13 Apr 2026 14:21:19 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 13 Apr
 2026 14:21:20 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH 3/3] mm: split the file's i_mmap tree for NUMA
Date: Mon, 13 Apr 2026 14:20:42 +0800
Message-ID: <20260413062042.804-4-huangsj@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413062042.804-1-huangsj@hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)

  In NUMA, there are maybe many NUMA nodes and many CPUs.
For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
In the UnixBench tests, there is a test "execl" which tests
the execve system call.

  When we test our server with "./Run -c 384 execl",
the test result is not good enough. The i_mmap locks contended heavily on
"libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
over 6000 VMAs, all the VMAs can be in different NUMA mode.
The insert/remove operations do not run quickly enough.

 In order to reduce the competition of the i_mmap lock, this patch does
following:
   1.) Split the single i_mmap tree into several sibling trees:
       Each NUMA node has a tree.
   2.) Introduce a new field "tree_idx" for vm_area_struct to save the
       sibling tree index for this VMA.
   3.) Introduce a new field "vma_count" for address_space.
       The new mapping_mapped() will use it.
   4.) Rewrite the vma_interval_tree_foreach() for NUMA.

 After this patch, the VMA insert/remove operations will work faster,
and we can get 77% (10 times average) performance improvement
with the above test.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/inode.c               | 55 +++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h       | 35 +++++++++++++++++++++++++
 include/linux/mm.h       | 32 +++++++++++++++++++++++
 include/linux/mm_types.h |  1 +
 mm/mmap.c                |  3 ++-
 mm/nommu.c               |  6 +++--
 mm/vma.c                 | 34 +++++++++++++++++++------
 mm/vma_init.c            |  1 +
 8 files changed, 155 insertions(+), 12 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..3067cb2558da 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -215,6 +215,56 @@ static int no_open(struct inode *inode, struct file *file)
 	return -ENXIO;
 }
 
+#ifdef CONFIG_NUMA
+static void free_mapping_i_mmap(struct address_space *mapping)
+{
+	int i;
+
+	if (!mapping->i_mmap)
+		return;
+
+	for (i = 0; i < nr_node_ids; i++)
+		kfree(mapping->i_mmap[i]);
+
+	kfree(mapping->i_mmap);
+	mapping->i_mmap = NULL;
+}
+
+static int init_mapping_i_mmap(struct address_space *mapping)
+{
+	struct rb_root_cached *root;
+	int i;
+
+	/* The extra one is used as terminator in vma_interval_tree_foreach() */
+	mapping->i_mmap = kzalloc(sizeof(root) * (nr_node_ids + 1), GFP_KERNEL);
+	if (!mapping->i_mmap)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_node_ids; i++) {
+		root = kzalloc_node(sizeof(*root), GFP_KERNEL, i);
+		if (!root)
+			goto no_mem;
+
+		*root = RB_ROOT_CACHED;
+		mapping->i_mmap[i] = root;
+	}
+	return 0;
+
+no_mem:
+	free_mapping_i_mmap(mapping);
+	return -ENOMEM;
+}
+#else
+static int init_mapping_i_mmap(struct address_space *mapping)
+{
+	mapping->i_mmap = RB_ROOT_CACHED;
+	return 0;
+}
+static void free_mapping_i_mmap(struct address_space *mapping)
+{
+}
+#endif
+
 /**
  * inode_init_always_gfp - perform inode structure initialisation
  * @sb: superblock inode belongs to
@@ -307,6 +357,9 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	if (unlikely(security_inode_alloc(inode, gfp)))
 		return -ENOMEM;
 
+	if (init_mapping_i_mmap(mapping))
+		return -ENOMEM;
+
 	this_cpu_inc(nr_inodes);
 
 	return 0;
@@ -383,6 +436,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_acl))
 		posix_acl_release(inode->i_default_acl);
 #endif
+	free_mapping_i_mmap(&inode->i_data);
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
@@ -486,7 +540,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
 void address_space_init_once(struct address_space *mapping)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6a99e044265..34064c1cbd10 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -477,7 +477,12 @@ struct address_space {
 	/* number of thp, only for non-shmem files */
 	atomic_t		nr_thps;
 #endif
+#ifdef CONFIG_NUMA
+	struct rb_root_cached	**i_mmap;
+	unsigned long		vma_count;
+#else
 	struct rb_root_cached	i_mmap;
+#endif
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
@@ -547,6 +552,27 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 	lockdep_assert_held_write(&mapping->i_mmap_rwsem);
 }
 
+#ifdef CONFIG_NUMA
+static inline int mapping_mapped(const struct address_space *mapping)
+{
+	return	READ_ONCE(mapping->vma_count);
+}
+
+static inline void inc_mapping_vma(struct address_space *mapping)
+{
+	mapping->vma_count++;
+}
+
+static inline void dec_mapping_vma(struct address_space *mapping)
+{
+	mapping->vma_count--;
+}
+
+static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mapping)
+{
+	return (struct rb_root_cached *)mapping->i_mmap;
+}
+#else
 /*
  * Might pages of this file be mapped into userspace?
  */
@@ -555,10 +581,19 @@ static inline int mapping_mapped(const struct address_space *mapping)
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
 
+static inline void inc_mapping_vma(struct address_space *mapping)
+{
+}
+
+static inline void dec_mapping_vma(struct address_space *mapping)
+{
+}
+
 static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mapping)
 {
 	return &mapping->i_mmap;
 }
+#endif
 
 /*
  * Might pages of this file have been modified in userspace?
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15cb1da43eb2..c7f26eb34322 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -913,6 +913,9 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma_lock_init(vma, false);
+#ifdef CONFIG_NUMA
+	vma->tree_idx = numa_node_id();
+#endif
 }
 
 /* Use when VMA is not part of the VMA tree and needs no locking */
@@ -3783,6 +3786,8 @@ extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
 /* interval_tree.c */
+struct rb_root_cached *get_rb_root(struct vm_area_struct *vma,
+					struct address_space *mapping);
 void vma_interval_tree_insert(struct vm_area_struct *node,
 			      struct rb_root_cached *root);
 void vma_interval_tree_insert_after(struct vm_area_struct *node,
@@ -3798,9 +3803,36 @@ struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 				unsigned long start, unsigned long last);
 
 /* Please use get_i_mmap_root() to get the @root */
+#ifdef CONFIG_NUMA
+/* Find the first valid VMA in the sibling trees */
+static inline struct vm_area_struct *first_vma(struct rb_root_cached ***__r,
+				unsigned long start, unsigned long last)
+{
+	struct vm_area_struct *vma = NULL;
+	struct rb_root_cached **tree = *__r;
+
+	while (*tree) {
+		vma = vma_interval_tree_iter_first(*tree++, start, last);
+		if (vma)
+			break;
+	}
+
+	/* Save for the next loop */
+	*__r = tree;
+	return vma;
+}
+
+/* @_tmp is referenced to avoid unused variable warning. */
+#define vma_interval_tree_foreach(vma, root, start, last)		\
+	for (struct rb_root_cached **_r = (void *)(root),		\
+		**_tmp = (vma = first_vma(&_r, start, last)) ? _r : NULL;\
+	     ((_tmp && vma) || (vma = first_vma(&_r, start, last)));	\
+		vma = vma_interval_tree_iter_next(vma, start, last))
+#else
 #define vma_interval_tree_foreach(vma, root, start, last)		\
 	for (vma = vma_interval_tree_iter_first(root, start, last);	\
 	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
+#endif
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae722886..4982e20ce27c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -984,6 +984,7 @@ struct vm_area_struct {
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
+	int tree_idx;			/* The sibling tree index for the VMA */
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
diff --git a/mm/mmap.c b/mm/mmap.c
index 5b0671dff019..81a2f4932ca8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1832,8 +1832,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_interval_tree_insert_after(tmp, mpnt,
-					get_i_mmap_root(mapping));
+					get_rb_root(mpnt, mapping));
 			flush_dcache_mmap_unlock(mapping);
+			inc_mapping_vma(mapping);
 			i_mmap_unlock_write(mapping);
 		}
 
diff --git a/mm/nommu.c b/mm/nommu.c
index 2e64b6c4c539..6553cfcb6683 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -569,8 +569,9 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
+		vma_interval_tree_insert(vma, get_rb_root(vma, mapping));
 		flush_dcache_mmap_unlock(mapping);
+		inc_mapping_vma(mapping);
 		i_mmap_unlock_write(mapping);
 	}
 }
@@ -585,8 +586,9 @@ static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
+		vma_interval_tree_remove(vma, get_rb_root(vma, mapping));
 		flush_dcache_mmap_unlock(mapping);
+		dec_mapping_vma(mapping);
 		i_mmap_unlock_write(mapping);
 	}
 }
diff --git a/mm/vma.c b/mm/vma.c
index 1768e4355a13..5aa3915d183b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -224,6 +224,16 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 	return false;
 }
 
+struct rb_root_cached *get_rb_root(struct vm_area_struct *vma,
+					struct address_space *mapping)
+{
+#ifdef CONFIG_NUMA
+	return mapping->i_mmap[vma->tree_idx];
+#else
+	return &mapping->i_mmap;
+#endif
+}
+
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
@@ -231,8 +241,9 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
+	vma_interval_tree_insert(vma, get_rb_root(vma, mapping));
 	flush_dcache_mmap_unlock(mapping);
+	inc_mapping_vma(mapping);
 }
 
 /*
@@ -245,8 +256,9 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
+	vma_interval_tree_remove(vma, get_rb_root(vma, mapping));
 	flush_dcache_mmap_unlock(mapping);
+	dec_mapping_vma(mapping);
 }
 
 /*
@@ -317,10 +329,13 @@ static void vma_prepare(struct vma_prepare *vp)
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
 		vma_interval_tree_remove(vp->vma,
-					get_i_mmap_root(vp->mapping));
-		if (vp->adj_next)
+					get_rb_root(vp->vma, vp->mapping));
+		dec_mapping_vma(vp->mapping);
+		if (vp->adj_next) {
 			vma_interval_tree_remove(vp->adj_next,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->adj_next, vp->mapping));
+			dec_mapping_vma(vp->mapping);
+		}
 	}
 
 }
@@ -337,11 +352,14 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			 struct mm_struct *mm)
 {
 	if (vp->file) {
-		if (vp->adj_next)
+		if (vp->adj_next) {
 			vma_interval_tree_insert(vp->adj_next,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->adj_next, vp->mapping));
+			inc_mapping_vma(vp->mapping);
+		}
 		vma_interval_tree_insert(vp->vma,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->vma, vp->mapping));
+		inc_mapping_vma(vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 3c0b65950510..5735868b1ad4 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -71,6 +71,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
 #endif
 #ifdef CONFIG_NUMA
 	dest->vm_policy = src->vm_policy;
+	dest->tree_idx = src->tree_idx;
 #endif
 #ifdef __HAVE_PFNMAP_TRACKING
 	dest->pfnmap_track_ctx = NULL;
-- 
2.43.0


