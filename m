Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E222F39CE
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158936; cv=none; b=he/Nu2qsLG4epXBZFOGPklhKqrW/akENbUbyvDrKcoepEqMreNgKDLucaCWXl0pYZLzeu+ybiIwVBAFRan/75vrfVmi76HQq6oag+tM0PBalwcsgeJEorzSm2kfVDLwtX52Io4GaSV/7AaXK6jZfYmjrY+S9v33Ubu0gscDgUhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158936; c=relaxed/simple;
	bh=msfuZK5xnq8l7vUOg/LunQoZKRINmtsh4mc1cJoHDU8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3QU3cv7w9tNF2xPYeLxPrE7VFDRdteaf+qbo0nz2LmQn05cMB6fLVQcSikWbB078DG3qoZu4WPmIVUqex+TBZKx7gx2Ae6lT1jJp2PnAEQs0AkIEIJg8pFDs4qHQ3gH86u3pidvoSXAelBVBkh728WeNLSq9aY3UdPTJbrlXBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXc174NCz1dd8l;
	Thu, 11 Jun 2026 14:21:53 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXc12fj1z1dd8l;
	Thu, 11 Jun 2026 14:21:53 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 510F816CF;
	Thu, 11 Jun 2026 14:21:35 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:47 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 3/4] mm/fs: split the file's i_mmap tree
Date: Thu, 11 Jun 2026 14:18:59 +0800
Message-ID: <20260611061915.2354307-4-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

In the UnixBench tests, there is a test "execl" which tests
the execve system call.
  For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
When we test our server with "./Run -c 384 execl",
the test result is not good enough. The i_mmap locks contended heavily on
"libc.so" and "ld.so". The i_mmap tree for "libc.so" can be
over 6000 VMAs, all the VMAs can be in different NUMA mode. The insert/remove
operations do not run quickly enough.

 In order to reduce the competition of the i_mmap lock, this patch does
following:
   1.) Split the single i_mmap tree into several sibling trees:
       Each tree has a lock. The CONFIG_SPLIT_I_MMAP is used to
       turn on/off this feature.
   2.) Introduce a new field "tree_idx" for vm_area_struct to save the
       sibling tree index for this VMA.
   3.) Introduce a new field "vma_count" for address_space.
       The new mapping_mapped() will use it.
   4.) Rewrite the vma_interval_tree_foreach()
   5.) Rewrite the lock functions.	

 After this patch, the VMA insert/remove operations will work faster,
and we can get over 400% performance improvement with the above test.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/Kconfig               |   8 ++
 fs/hugetlbfs/inode.c     |  20 ++++-
 fs/inode.c               |  75 ++++++++++++++++-
 include/linux/fs.h       | 174 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mm.h       |  80 ++++++++++++++++++
 include/linux/mm_types.h |   3 +
 mm/internal.h            |   3 +-
 mm/mmap.c                |  11 ++-
 mm/nommu.c               |  23 ++++--
 mm/pagewalk.c            |   2 +-
 mm/vma.c                 |  72 +++++++++++-----
 mm/vma_init.c            |   3 +
 12 files changed, 436 insertions(+), 38 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 43cb06de297f..e24804f70432 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -9,6 +9,14 @@ menu "File systems"
 config DCACHE_WORD_ACCESS
        bool
 
+config SPLIT_I_MMAP
+	bool "Split the file's i_mmap to several trees"
+	default n
+	help
+	  Split the file's i_mmap to several trees, each tree has a separate
+	  lock. This will reduce the lock contention of file's i_mmap tree,
+	  but it will cost more memory for per inode.
+
 config VALIDATE_FS_PARSER
 	bool "Validate filesystem parameter description"
 	help
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index da5b41ea5bdd..68d8308418dd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -891,6 +891,23 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
  */
 static struct lock_class_key hugetlbfs_i_mmap_rwsem_key;
 
+#ifdef CONFIG_SPLIT_I_MMAP
+static void hugetlbfs_lockdep_set_class(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++) {
+		lockdep_set_class(&mapping->i_mmap[i].rwsem,
+				&hugetlbfs_i_mmap_rwsem_key);
+	}
+}
+#else
+static void hugetlbfs_lockdep_set_class(struct address_space *mapping)
+{
+	lockdep_set_class(&mapping->i_mmap_rwsem, &hugetlbfs_i_mmap_rwsem_key);
+}
+#endif
+
 static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					struct mnt_idmap *idmap,
 					struct inode *dir,
@@ -915,8 +932,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 
 		inode->i_ino = get_next_ino();
 		inode_init_owner(idmap, inode, dir, mode);
-		lockdep_set_class(&inode->i_mapping->i_mmap_rwsem,
-				&hugetlbfs_i_mmap_rwsem_key);
+		hugetlbfs_lockdep_set_class(inode->i_mapping);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
diff --git a/fs/inode.c b/fs/inode.c
index 62c579a0cf7d..cb67ae83f5b3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -214,6 +214,70 @@ static int no_open(struct inode *inode, struct file *file)
 	return -ENXIO;
 }
 
+#ifdef CONFIG_SPLIT_I_MMAP
+int split_tree_num;
+static int split_tree_align __maybe_unused = 32;
+
+static void __init init_split_tree_num(void)
+{
+#ifdef CONFIG_NUMA
+	split_tree_num = nr_node_ids;
+#else
+	split_tree_num = ALIGN(nr_cpu_ids, split_tree_align);
+#endif
+}
+
+static void free_mapping_i_mmap(struct address_space *mapping)
+{
+	int i;
+
+	if (!mapping->i_mmap)
+		return;
+
+	for (i = 0; i < split_tree_num; i++)
+		kfree(mapping->i_mmap[i]);
+
+	kfree(mapping->i_mmap);
+	mapping->i_mmap = NULL;
+}
+
+static int init_mapping_i_mmap(struct address_space *mapping, gfp_t gfp)
+{
+	struct i_mmap_tree *tree;
+	int i;
+
+	/* The extra one is used as terminator in vma_interval_tree_foreach() */
+	mapping->i_mmap = kzalloc(sizeof(tree) * (split_tree_num + 1), gfp);
+	if (!mapping->i_mmap)
+		return -ENOMEM;
+
+	for (i = 0; i < split_tree_num; i++) {
+		tree = kzalloc_node(sizeof(*tree), gfp, i);
+		if (!tree)
+			goto nomem;
+
+		tree->root = RB_ROOT_CACHED;
+		init_rwsem(&tree->rwsem);
+
+		mapping->i_mmap[i] = tree;
+	}
+	return 0;
+nomem:
+	free_mapping_i_mmap(mapping);
+	return -ENOMEM;
+}
+#else
+static int init_mapping_i_mmap(struct address_space *mapping, gfp_t gfp)
+{
+	mapping->i_mmap = RB_ROOT_CACHED;
+	init_rwsem(&mapping->i_mmap_rwsem);
+	return 0;
+}
+
+static void free_mapping_i_mmap(struct address_space *mapping) { }
+static void __init init_split_tree_num(void) {}
+#endif
+
 /**
  * inode_init_always_gfp - perform inode structure initialisation
  * @sb: superblock inode belongs to
@@ -302,9 +366,14 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 #endif
 	inode->i_flctx = NULL;
 
-	if (unlikely(security_inode_alloc(inode, gfp)))
+	if (init_mapping_i_mmap(mapping, gfp))
 		return -ENOMEM;
 
+	if (unlikely(security_inode_alloc(inode, gfp))) {
+		free_mapping_i_mmap(mapping);
+		return -ENOMEM;
+	}
+
 	this_cpu_inc(nr_inodes);
 
 	return 0;
@@ -380,6 +449,7 @@ void __destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && !is_uncached_acl(inode->i_default_acl))
 		posix_acl_release(inode->i_default_acl);
 #endif
+	free_mapping_i_mmap(&inode->i_data);
 	this_cpu_dec(nr_inodes);
 }
 EXPORT_SYMBOL(__destroy_inode);
@@ -480,9 +550,7 @@ EXPORT_SYMBOL(inc_nlink);
 static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
-	init_rwsem(&mapping->i_mmap_rwsem);
 	spin_lock_init(&mapping->i_private_lock);
-	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
 void address_space_init_once(struct address_space *mapping)
@@ -2619,6 +2687,7 @@ void __init inode_init(void)
 					&i_hash_mask,
 					0,
 					0);
+	init_split_tree_num();
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cd46615b8f53..f4b3645b61df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -450,6 +450,25 @@ struct mapping_metadata_bhs {
 	struct list_head list;	/* The list of bhs (b_assoc_buffers) */
 };
 
+#ifdef CONFIG_SPLIT_I_MMAP
+/*
+ * struct i_mmap_tree - A single sibling tree of the file's split i_mmap.
+ * @root: The red/black interval tree root.
+ * @rwsem: Protects insert/remove operations on this sibling tree.
+ * @vma_count: Number of VMAs in this sibling tree.
+ *
+ * When CONFIG_SPLIT_I_MMAP is enabled, the file's single i_mmap tree is
+ * split into split_tree_num sibling trees, each with its own lock. This
+ * reduces lock contention by allowing concurrent VMA insert/remove
+ * operations on different sibling trees.
+ */
+struct i_mmap_tree {
+	struct rb_root_cached	root;
+	struct rw_semaphore	rwsem;
+	atomic_t		vma_count;
+};
+#endif
+
 /**
  * struct address_space - Contents of a cacheable, mappable object.
  * @host: Owner, either the inode or the block_device.
@@ -461,8 +480,13 @@ struct mapping_metadata_bhs {
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
- * @i_mmap: Tree of private and shared mappings.
- * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
+ * @i_mmap: Tree of private and shared mappings. When CONFIG_SPLIT_I_MMAP
+ *   is enabled, this is an array of split_tree_num struct i_mmap_tree
+ *   pointers (plus a NULL terminator).
+ * @vma_count: Total number of VMAs across all sibling trees (only when
+ *   CONFIG_SPLIT_I_MMAP is enabled). Used by mapping_mapped().
+ * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable (only when
+ *   CONFIG_SPLIT_I_MMAP is disabled; otherwise per-tree rwsem is used).
  * @nrpages: Number of page entries, protected by the i_pages lock.
  * @writeback_index: Writeback starts here.
  * @a_ops: Methods.
@@ -480,14 +504,19 @@ struct address_space {
 	/* number of thp, only for non-shmem files */
 	atomic_t		nr_thps;
 #endif
+#ifdef CONFIG_SPLIT_I_MMAP
+	struct i_mmap_tree	**i_mmap;
+	atomic_t		vma_count;
+#else
 	struct rb_root_cached	i_mmap;
+	struct rw_semaphore	i_mmap_rwsem;
+#endif
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
 	unsigned long		flags;
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
-	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
@@ -508,6 +537,133 @@ static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t
 	return xa_marked(&mapping->i_pages, tag);
 }
 
+#ifdef CONFIG_SPLIT_I_MMAP
+static inline int mapping_mapped(const struct address_space *mapping)
+{
+	return	atomic_read(&mapping->vma_count);
+}
+
+static inline void inc_mapping_vma(struct address_space *mapping,
+				struct vm_area_struct *vma)
+{
+	struct i_mmap_tree *tree = mapping->i_mmap[vma->tree_idx];
+
+	atomic_inc(&tree->vma_count);
+	atomic_inc(&mapping->vma_count);
+}
+
+static inline void dec_mapping_vma(struct address_space *mapping,
+				struct vm_area_struct *vma)
+{
+	struct i_mmap_tree *tree = mapping->i_mmap[vma->tree_idx];
+
+	atomic_dec(&tree->vma_count);
+	atomic_dec(&mapping->vma_count);
+}
+
+static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mapping)
+{
+	return (struct rb_root_cached *)mapping->i_mmap;
+}
+
+static inline void i_mmap_tree_lock_write(struct address_space *mapping,
+					struct vm_area_struct *vma)
+{
+	struct i_mmap_tree *tree = mapping->i_mmap[vma->tree_idx];
+
+	down_write(&tree->rwsem);
+}
+
+static inline void i_mmap_tree_unlock_write(struct address_space *mapping,
+					struct vm_area_struct *vma)
+{
+	struct i_mmap_tree *tree = mapping->i_mmap[vma->tree_idx];
+
+	up_write(&tree->rwsem);
+}
+
+#define i_mmap_lock_write_prepare(mapping)
+#define i_mmap_unlock_write_complete(mapping)
+
+extern int split_tree_num;
+static inline void i_mmap_lock_write(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		down_write(&mapping->i_mmap[i]->rwsem);
+}
+
+static inline int i_mmap_trylock_write(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++) {
+		if (!down_write_trylock(&mapping->i_mmap[i]->rwsem)) {
+			while (i--)
+				up_write(&mapping->i_mmap[i]->rwsem);
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static inline void i_mmap_unlock_write(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		up_write(&mapping->i_mmap[i]->rwsem);
+}
+
+static inline int i_mmap_trylock_read(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++) {
+		if (!down_read_trylock(&mapping->i_mmap[i]->rwsem)) {
+			while (i--)
+				up_read(&mapping->i_mmap[i]->rwsem);
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static inline void i_mmap_lock_read(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		down_read(&mapping->i_mmap[i]->rwsem);
+}
+
+static inline void i_mmap_unlock_read(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		up_read(&mapping->i_mmap[i]->rwsem);
+}
+
+static inline void i_mmap_assert_locked(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		lockdep_assert_held(&mapping->i_mmap[i]->rwsem);
+}
+
+static inline void i_mmap_assert_write_locked(struct address_space *mapping)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		lockdep_assert_held_write(&mapping->i_mmap[i]->rwsem);
+}
+
+#else
+
 static inline void i_mmap_lock_write(struct address_space *mapping)
 {
 	down_write(&mapping->i_mmap_rwsem);
@@ -561,6 +717,18 @@ static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mappi
 	return &mapping->i_mmap;
 }
 
+static inline void inc_mapping_vma(struct address_space *mapping,
+				struct vm_area_struct *vma) { }
+static inline void dec_mapping_vma(struct address_space *mapping,
+				struct vm_area_struct *vma) { }
+
+#define i_mmap_lock_write_prepare(mapping)	i_mmap_lock_write(mapping)
+#define i_mmap_unlock_write_complete(mapping)	i_mmap_unlock_write(mapping)
+#define i_mmap_tree_lock_write(mapping, vma)
+#define i_mmap_tree_unlock_write(mapping, vma)
+
+#endif
+
 /*
  * Might pages of this file have been modified in userspace?
  * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0a45c6a8b9f2..9aa8119fa9bf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4041,11 +4041,91 @@ struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 				unsigned long start, unsigned long last);
 
+#ifdef CONFIG_SPLIT_I_MMAP
+extern int split_tree_num;
+
+static inline int smallest_tree_idx(struct file *file)
+{
+	struct address_space *mapping = file->f_mapping;
+	int tmp = INT_MAX, count;
+	int i, j = 0;
+
+	/*
+	 * Since a not 100% accurate value is still okay,
+	 * we do not need any lock here.
+	 */
+	for (i = 0; i < split_tree_num; i++) {
+		count = atomic_read(&mapping->i_mmap[i]->vma_count);
+		if (count < tmp) {
+			j = i;
+			tmp = count;
+			if (!tmp)
+				break;
+		}
+	}
+	return j;
+}
+
+static inline void vma_set_tree_idx(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_NUMA
+	vma->tree_idx = numa_node_id();
+#else
+	vma->tree_idx = smallest_tree_idx(vma->vm_file);
+#endif
+}
+
+static inline struct rb_root_cached *get_rb_root(struct vm_area_struct *vma,
+					struct address_space *mapping)
+{
+	return &mapping->i_mmap[vma->tree_idx]->root;
+}
+
+/* Find the first valid VMA in the sibling trees */
+static inline struct vm_area_struct *first_vma(struct i_mmap_tree ***__r,
+				unsigned long start, unsigned long last)
+{
+	struct vm_area_struct *vma = NULL;
+	struct i_mmap_tree **tree = *__r;
+	struct rb_root_cached *root;
+
+	while (*tree) {
+		root = &(*tree)->root;
+		tree++;
+		vma = vma_interval_tree_iter_first(root, start, last);
+		if (vma)
+			break;
+	}
+
+	/* Save for the next loop */
+	*__r = tree;
+	return vma;
+}
+
+/*
+ * Please use get_i_mmap_root() to get the @root.
+ * @_tmp is referenced to avoid unused variable warning.
+ */
+#define vma_interval_tree_foreach(vma, root, start, last)		\
+	for (struct i_mmap_tree **_r = (struct i_mmap_tree **)(root),	\
+		**_tmp = (vma = first_vma(&_r, start, last)) ? _r : NULL;\
+	     ((_tmp && vma) || (vma = first_vma(&_r, start, last)));	\
+		vma = vma_interval_tree_iter_next(vma, start, last))
+#else
 /* Please use get_i_mmap_root() to get the @root */
 #define vma_interval_tree_foreach(vma, root, start, last)		\
 	for (vma = vma_interval_tree_iter_first(root, start, last);	\
 	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
 
+static inline void vma_set_tree_idx(struct vm_area_struct *vma) { }
+
+static inline struct rb_root_cached *get_rb_root(struct vm_area_struct *vma,
+					struct address_space *mapping)
+{
+	return &mapping->i_mmap;
+}
+#endif
+
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root);
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..8d6aab3346ce 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1072,6 +1072,9 @@ struct vm_area_struct {
 #ifdef __HAVE_PFNMAP_TRACKING
 	struct pfnmap_track_ctx *pfnmap_track_ctx;
 #endif
+#ifdef CONFIG_SPLIT_I_MMAP
+	int tree_idx;			/* The sibling tree index for the VMA */
+#endif
 } __randomize_layout;
 
 /* Clears all bits in the VMA flags bitmap, non-atomically. */
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..2d35cacffd19 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1888,7 +1888,8 @@ static inline void maybe_rmap_unlock_action(struct vm_area_struct *vma,
 
 	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
 	file = vma->vm_file;
-	i_mmap_unlock_write(file->f_mapping);
+	i_mmap_tree_unlock_write(file->f_mapping, vma);
+	i_mmap_unlock_write_complete(file->f_mapping);
 	action->hide_from_rmap_until_complete = false;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index d714fdb357e5..70036ec9dcaa 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1825,15 +1825,20 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			struct address_space *mapping = file->f_mapping;
 
 			get_file(file);
-			i_mmap_lock_write(mapping);
+			i_mmap_lock_write_prepare(mapping);
+			i_mmap_tree_lock_write(mapping, mpnt);
+
 			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_interval_tree_insert_after(tmp, mpnt,
-					get_i_mmap_root(mapping));
+					get_rb_root(mpnt, mapping));
+			inc_mapping_vma(mapping, tmp);
 			flush_dcache_mmap_unlock(mapping);
-			i_mmap_unlock_write(mapping);
+
+			i_mmap_tree_unlock_write(mapping, mpnt);
+			i_mmap_unlock_write_complete(mapping);
 		}
 
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
diff --git a/mm/nommu.c b/mm/nommu.c
index 0f18ffc658e9..1f2c60a220f6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -567,11 +567,16 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 	if (vma->vm_file) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 
-		i_mmap_lock_write(mapping);
+		i_mmap_lock_write_prepare(mapping);
+		i_mmap_tree_lock_write(mapping, vma);
+
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
+		vma_interval_tree_insert(vma, get_rb_root(vma, mapping));
+		inc_mapping_vma(mapping, vma);
 		flush_dcache_mmap_unlock(mapping);
-		i_mmap_unlock_write(mapping);
+
+		i_mmap_tree_unlock_write(mapping, vma);
+		i_mmap_unlock_write_complete(mapping);
 	}
 }
 
@@ -583,11 +588,16 @@ static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 		struct address_space *mapping;
 		mapping = vma->vm_file->f_mapping;
 
-		i_mmap_lock_write(mapping);
+		i_mmap_lock_write_prepare(mapping);
+		i_mmap_tree_lock_write(mapping, vma);
+
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
+		vma_interval_tree_remove(vma, get_rb_root(vma, mapping));
+		dec_mapping_vma(mapping, vma);
 		flush_dcache_mmap_unlock(mapping);
-		i_mmap_unlock_write(mapping);
+
+		i_mmap_tree_unlock_write(mapping, vma);
+		i_mmap_unlock_write_complete(mapping);
 	}
 }
 
@@ -1063,6 +1073,7 @@ unsigned long do_mmap(struct file *file,
 	if (file) {
 		region->vm_file = get_file(file);
 		vma->vm_file = get_file(file);
+		vma_set_tree_idx(vma);
 	}
 
 	down_write(&nommu_region_sem);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 8df1b5077951..d5745519d95a 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -809,7 +809,7 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	lockdep_assert_held(&mapping->i_mmap_rwsem);
+	i_mmap_assert_locked(mapping);
 	vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), first_index,
 				  first_index + nr - 1) {
 		/* Clip to the vma */
diff --git a/mm/vma.c b/mm/vma.c
index 6159650c1b42..2055758064a9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -234,22 +234,23 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
+	vma_interval_tree_insert(vma, get_rb_root(vma, mapping));
+	inc_mapping_vma(mapping, vma);
 	flush_dcache_mmap_unlock(mapping);
 }
 
-/*
- * Requires inode->i_mapping->i_mmap_rwsem
- */
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 				      struct address_space *mapping)
 {
+	i_mmap_tree_lock_write(mapping, vma);
 	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
+	vma_interval_tree_remove(vma, get_rb_root(vma, mapping));
+	dec_mapping_vma(mapping, vma);
 	flush_dcache_mmap_unlock(mapping);
+	i_mmap_tree_unlock_write(mapping, vma);
 }
 
 /*
@@ -297,8 +298,9 @@ static void vma_prepare(struct vma_prepare *vp)
 			uprobe_munmap(vp->adj_next, vp->adj_next->vm_start,
 				      vp->adj_next->vm_end);
 
-		i_mmap_lock_write(vp->mapping);
+		i_mmap_lock_write_prepare(vp->mapping);
 		if (vp->insert && vp->insert->vm_file) {
+			i_mmap_tree_lock_write(vp->mapping, vp->insert);
 			/*
 			 * Put into interval tree now, so instantiated pages
 			 * are visible to arm/parisc __flush_dcache_page
@@ -307,6 +309,7 @@ static void vma_prepare(struct vma_prepare *vp)
 			 */
 			__vma_link_file(vp->insert,
 					vp->insert->vm_file->f_mapping);
+			i_mmap_tree_unlock_write(vp->mapping, vp->insert);
 		}
 	}
 
@@ -318,12 +321,17 @@ static void vma_prepare(struct vma_prepare *vp)
 	}
 
 	if (vp->file) {
+		i_mmap_tree_lock_write(vp->mapping, vp->vma);
 		flush_dcache_mmap_lock(vp->mapping);
 		vma_interval_tree_remove(vp->vma,
-					get_i_mmap_root(vp->mapping));
-		if (vp->adj_next)
+					get_rb_root(vp->vma, vp->mapping));
+		dec_mapping_vma(vp->mapping, vp->vma);
+		if (vp->adj_next) {
+			i_mmap_tree_lock_write(vp->mapping, vp->adj_next);
 			vma_interval_tree_remove(vp->adj_next,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->adj_next, vp->mapping));
+			dec_mapping_vma(vp->mapping, vp->adj_next);
+		}
 	}
 
 }
@@ -340,12 +348,17 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			 struct mm_struct *mm)
 {
 	if (vp->file) {
-		if (vp->adj_next)
+		if (vp->adj_next) {
 			vma_interval_tree_insert(vp->adj_next,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->adj_next, vp->mapping));
+			inc_mapping_vma(vp->mapping, vp->adj_next);
+			i_mmap_tree_unlock_write(vp->mapping, vp->adj_next);
+		}
 		vma_interval_tree_insert(vp->vma,
-					get_i_mmap_root(vp->mapping));
+					get_rb_root(vp->vma, vp->mapping));
+		inc_mapping_vma(vp->mapping, vp->vma);
 		flush_dcache_mmap_unlock(vp->mapping);
+		i_mmap_tree_unlock_write(vp->mapping, vp->vma);
 	}
 
 	if (vp->remove && vp->file) {
@@ -370,7 +383,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	}
 
 	if (vp->file) {
-		i_mmap_unlock_write(vp->mapping);
+		i_mmap_unlock_write_complete(vp->mapping);
 
 		if (!vp->skip_vma_uprobe) {
 			uprobe_mmap(vp->vma);
@@ -1799,12 +1812,12 @@ static void unlink_file_vma_batch_process(struct unlink_vma_file_batch *vb)
 	int i;
 
 	mapping = vb->vmas[0]->vm_file->f_mapping;
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_write_prepare(mapping);
 	for (i = 0; i < vb->count; i++) {
 		VM_WARN_ON_ONCE(vb->vmas[i]->vm_file->f_mapping != mapping);
 		__remove_shared_vm_struct(vb->vmas[i], mapping);
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_write_complete(mapping);
 
 	unlink_file_vma_batch_init(vb);
 }
@@ -1836,10 +1849,13 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 
 	if (file) {
 		mapping = file->f_mapping;
-		i_mmap_lock_write(mapping);
+		i_mmap_lock_write_prepare(mapping);
+		i_mmap_tree_lock_write(mapping, vma);
 		__vma_link_file(vma, mapping);
-		if (!hold_rmap_lock)
-			i_mmap_unlock_write(mapping);
+		if (!hold_rmap_lock) {
+			i_mmap_tree_unlock_write(mapping, vma);
+			i_mmap_unlock_write_complete(mapping);
+		}
 	}
 }
 
@@ -2164,6 +2180,23 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 	}
 }
 
+#ifdef CONFIG_SPLIT_I_MMAP
+static inline void i_mmap_nest_lock(struct address_space *mapping,
+				struct rw_semaphore *lock)
+{
+	int i;
+
+	for (i = 0; i < split_tree_num; i++)
+		down_write_nest_lock(&mapping->i_mmap[i]->rwsem, lock);
+}
+#else
+static inline void i_mmap_nest_lock(struct address_space *mapping,
+				struct rw_semaphore *lock)
+{
+	down_write_nest_lock(&mapping->i_mmap_rwsem, lock);
+}
+#endif
+
 static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 {
 	if (!test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
@@ -2178,7 +2211,7 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		down_write_nest_lock(&mapping->i_mmap_rwsem, &mm->mmap_lock);
+		i_mmap_nest_lock(mapping, &mm->mmap_lock);
 	}
 }
 
@@ -2489,6 +2522,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	int error;
 
 	vma->vm_file = map->file;
+	vma_set_tree_idx(vma);
 	if (!map->file_doesnt_need_get)
 		get_file(map->file);
 
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 3c0b65950510..c115e33d4812 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -72,6 +72,9 @@ static void vm_area_init_from(const struct vm_area_struct *src,
 #ifdef CONFIG_NUMA
 	dest->vm_policy = src->vm_policy;
 #endif
+#ifdef CONFIG_SPLIT_I_MMAP
+	dest->tree_idx = src->tree_idx;
+#endif
 #ifdef __HAVE_PFNMAP_TRACKING
 	dest->pfnmap_track_ctx = NULL;
 #endif
-- 
2.53.0


