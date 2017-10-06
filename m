Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 895DA21FC748B
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 15:39:01 -0700 (PDT)
Subject: [PATCH v7 08/12] fs, mapdirect: introduce ->lease_direct()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Oct 2017 15:36:00 -0700
Message-ID: <150732936063.22363.4533598271967882402.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Provide a vma operation that registers a lease that is broken by
break_layout(). This is motivated by a need to stop in-progress RDMA
when the block-map of a DAX-file changes. I.e. since DAX gives
direct-access to filesystem blocks we can not allow those blocks to move
or change state while they are under active RDMA. So, if the filesystem
determines it needs to move blocks it can revoke device access before
proceeding.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/mapdirect.c            |  117 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mapdirect.h |   23 +++++++++
 include/linux/mm.h        |    6 ++
 3 files changed, 146 insertions(+)

diff --git a/fs/mapdirect.c b/fs/mapdirect.c
index 9ac7c1d946a2..338cbe055fc7 100644
--- a/fs/mapdirect.c
+++ b/fs/mapdirect.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 
@@ -32,12 +33,26 @@ struct map_direct_state {
 	struct vm_area_struct *mds_vma;
 };
 
+struct lease_direct_state {
+	void *lds_owner;
+	struct file *lds_file;
+	unsigned long lds_state;
+	void (*lds_break_fn)(void *lds_owner);
+	struct work_struct lds_work;
+};
+
 bool is_map_direct_valid(struct map_direct_state *mds)
 {
 	return test_bit(MAPDIRECT_VALID, &mds->mds_state);
 }
 EXPORT_SYMBOL_GPL(is_map_direct_valid);
 
+bool is_map_direct_broken(struct map_direct_state *mds)
+{
+	return test_bit(MAPDIRECT_BREAK, &mds->mds_state);
+}
+EXPORT_SYMBOL_GPL(is_map_direct_broken);
+
 static void put_map_direct(struct map_direct_state *mds)
 {
 	if (!atomic_dec_and_test(&mds->mds_ref))
@@ -162,6 +177,108 @@ static const struct lock_manager_operations map_direct_lm_ops = {
 	.lm_setup = map_direct_lm_setup,
 };
 
+static void lease_direct_invalidate(struct work_struct *work)
+{
+	struct lease_direct_state *lds;
+	void *owner;
+
+	lds = container_of(work, typeof(*lds), lds_work);
+	owner = lds;
+	lds->lds_break_fn(lds->lds_owner);
+	vfs_setlease(lds->lds_file, F_UNLCK, NULL, &owner);
+}
+
+static bool lease_direct_lm_break(struct file_lock *fl)
+{
+	struct lease_direct_state *lds = fl->fl_owner;
+
+	if (!test_and_set_bit(MAPDIRECT_BREAK, &lds->lds_state))
+		schedule_work(&lds->lds_work);
+	return false;
+}
+
+static int lease_direct_lm_change(struct file_lock *fl, int arg,
+		struct list_head *dispose)
+{
+	WARN_ON(!(arg & F_UNLCK));
+	return lease_modify(fl, arg, dispose);
+}
+
+static const struct lock_manager_operations lease_direct_lm_ops = {
+	.lm_break = lease_direct_lm_break,
+	.lm_change = lease_direct_lm_change,
+};
+
+struct lease_direct *map_direct_lease(struct vm_area_struct *vma,
+		void (*lds_break_fn)(void *), void *lds_owner)
+{
+	struct file *file = vma->vm_file;
+	struct lease_direct_state *lds;
+	struct lease_direct *ld;
+	struct file_lock *fl;
+	int rc = -ENOMEM;
+	void *owner;
+
+	ld = kzalloc(sizeof(*ld) + sizeof(*lds), GFP_KERNEL);
+	if (!ld)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&ld->list);
+	lds = (struct lease_direct_state *)(ld + 1);
+	owner = lds;
+	ld->lds = lds;
+	lds->lds_break_fn = lds_break_fn;
+	lds->lds_owner = lds_owner;
+	INIT_WORK(&lds->lds_work, lease_direct_invalidate);
+	lds->lds_file = get_file(file);
+
+	fl = locks_alloc_lock();
+	if (!fl)
+		goto err_lock_alloc;
+
+	locks_init_lock(fl);
+	fl->fl_lmops = &lease_direct_lm_ops;
+	fl->fl_flags = FL_LAYOUT;
+	fl->fl_type = F_RDLCK;
+	fl->fl_end = OFFSET_MAX;
+	fl->fl_owner = lds;
+	fl->fl_pid = current->tgid;
+	fl->fl_file = file;
+
+	rc = vfs_setlease(file, fl->fl_type, &fl, &owner);
+	if (rc)
+		goto err_setlease;
+	if (fl) {
+		WARN_ON(1);
+		owner = lds;
+		vfs_setlease(file, F_UNLCK, NULL, &owner);
+		owner = NULL;
+		rc = -ENXIO;
+		goto err_setlease;
+	}
+
+	return ld;
+err_setlease:
+	locks_free_lock(fl);
+err_lock_alloc:
+	kfree(lds);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_GPL(map_direct_lease);
+
+void map_direct_lease_destroy(struct lease_direct *ld)
+{
+	struct lease_direct_state *lds = ld->lds;
+	struct file *file = lds->lds_file;
+	void *owner = lds;
+
+	vfs_setlease(file, F_UNLCK, NULL, &owner);
+	flush_work(&lds->lds_work);
+	fput(file);
+	WARN_ON(!list_empty(&ld->list));
+	kfree(ld);
+}
+EXPORT_SYMBOL_GPL(map_direct_lease_destroy);
+
 struct map_direct_state *map_direct_register(int fd, struct vm_area_struct *vma)
 {
 	struct map_direct_state *mds = kzalloc(sizeof(*mds), GFP_KERNEL);
diff --git a/include/linux/mapdirect.h b/include/linux/mapdirect.h
index 724e27d8615e..dc4d4ba677d0 100644
--- a/include/linux/mapdirect.h
+++ b/include/linux/mapdirect.h
@@ -13,17 +13,28 @@
 #ifndef __MAPDIRECT_H__
 #define __MAPDIRECT_H__
 #include <linux/err.h>
+#include <linux/list.h>
 
 struct inode;
 struct work_struct;
 struct vm_area_struct;
 struct map_direct_state;
+struct list_direct_state;
+
+struct lease_direct {
+	struct list_head list;
+	struct lease_direct_state *lds;
+};
 
 #if IS_ENABLED(CONFIG_FS_DAX)
 struct map_direct_state *map_direct_register(int fd, struct vm_area_struct *vma);
 int put_map_direct_vma(struct map_direct_state *mds);
 void get_map_direct_vma(struct map_direct_state *mds);
 bool is_map_direct_valid(struct map_direct_state *mds);
+bool is_map_direct_broken(struct map_direct_state *mds);
+struct lease_direct *map_direct_lease(struct vm_area_struct *vma,
+		void (*ld_break_fn)(void *), void *ld_owner);
+void map_direct_lease_destroy(struct lease_direct *ld);
 #else
 static inline struct map_direct_state *map_direct_register(int fd,
 		struct vm_area_struct *vma)
@@ -41,5 +52,17 @@ bool is_map_direct_valid(struct map_direct_state *mds)
 {
 	return false;
 }
+bool is_map_direct_broken(struct map_direct_state *mds)
+{
+	return false;
+}
+struct lease_direct *map_direct_lease(struct vm_area_struct *vma,
+		void (*ld_break_fn)(void *), void *ld_owner)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+void map_direct_lease_destroy(struct lease_direct *ld)
+{
+}
 #endif
 #endif /* __MAPDIRECT_H__ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0afa19feb755..d03953f91ce8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -420,6 +420,12 @@ struct vm_operations_struct {
 	 */
 	struct page *(*find_special_page)(struct vm_area_struct *vma,
 					  unsigned long addr);
+	/*
+	 * Called by rdma memory registration to subscribe for "break"
+	 * events that require any ongoing rdma accesses to quiesce.
+	 */
+	struct lease_direct *(*lease_direct)(struct vm_area_struct *vma,
+			void (*break_fn)(void *), void *owner);
 };
 
 struct mmu_gather;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
