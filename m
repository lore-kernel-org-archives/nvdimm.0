Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 281A182003
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:21 -0800 (PST)
Subject: [RFC PATCH 02/17] dax: convert dax_inode locking to srcu
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:15 -0800
Message-ID: <148559257511.11180.7445606032994481709.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for adding dax_operations that perform ->direct_access()
and user copy operations relative to a dax_inode, convert the existing
dax_inode locking to srcu. Some dax drivers need to sleep in their
->direct_access() methods and user copying may fault / sleep.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig  |    1 +
 drivers/dax/device.c |   18 +++++++++---------
 drivers/dax/super.c  |   20 ++++++++++++++++----
 include/linux/dax.h  |    3 +++
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 39bcbf4c5e40..b7053eafd88e 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,5 +1,6 @@
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
+	select SRCU
 	default m if NVDIMM_DAX
 
 if DAX
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 5b5572314929..af06d0bfd6ea 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -333,16 +333,16 @@ static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 
 static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	int rc;
+	int rc, id;
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
 	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
 			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
-	rcu_read_lock();
+	id = dax_read_lock();
 	rc = __dax_dev_fault(dax_dev, vma, vmf);
-	rcu_read_unlock();
+	dax_read_unlock(id);
 
 	return rc;
 }
@@ -390,7 +390,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
 static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned int flags)
 {
-	int rc;
+	int rc, id;
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
@@ -398,9 +398,9 @@ static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 			current->comm, (flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 
-	rcu_read_lock();
+	id = dax_read_lock();
 	rc = __dax_dev_pmd_fault(dax_dev, vma, addr, pmd, flags);
-	rcu_read_unlock();
+	dax_read_unlock(id);
 
 	return rc;
 }
@@ -412,8 +412,8 @@ static const struct vm_operations_struct dax_dev_vm_ops = {
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 {
+	int rc, id;
 	struct dax_dev *dax_dev = filp->private_data;
-	int rc;
 
 	dev_dbg(&dax_dev->dev, "%s\n", __func__);
 
@@ -421,9 +421,9 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 	 * We lock to check dax_inode liveness and will re-check at
 	 * fault time.
 	 */
-	rcu_read_lock();
+	id = dax_read_lock();
 	rc = check_vma(dax_dev, vma, __func__);
-	rcu_read_unlock();
+	dax_read_unlock(id);
 	if (rc)
 		return rc;
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e6369b851619..7c4dc97d53a8 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -24,11 +24,24 @@ module_param(nr_dax, int, S_IRUGO);
 MODULE_PARM_DESC(nr_dax, "max number of dax device instances");
 
 static dev_t dax_devt;
+DEFINE_STATIC_SRCU(dax_srcu);
 static struct vfsmount *dax_mnt;
 static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 
+int dax_read_lock(void)
+{
+	return srcu_read_lock(&dax_srcu);
+}
+EXPORT_SYMBOL_GPL(dax_read_lock);
+
+void dax_read_unlock(int id)
+{
+	srcu_read_unlock(&dax_srcu, id);
+}
+EXPORT_SYMBOL_GPL(dax_read_unlock);
+
 /**
  * struct dax_inode - anchor object for dax services
  * @inode: core vfs
@@ -45,8 +58,7 @@ struct dax_inode {
 
 bool dax_inode_alive(struct dax_inode *dax_inode)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
-			"dax operations require rcu_read_lock()\n");
+	lockdep_assert_held(&dax_srcu);
 	return dax_inode->alive;
 }
 EXPORT_SYMBOL_GPL(dax_inode_alive);
@@ -55,7 +67,7 @@ EXPORT_SYMBOL_GPL(dax_inode_alive);
  * Note, rcu is not protecting the liveness of dax_inode, rcu is
  * ensuring that any fault handlers or operations that might have seen
  * dax_inode_alive(), have completed.  Any operations that start after
- * synchronize_rcu() has run will abort upon seeing !dax_inode_alive().
+ * synchronize_srcu() has run will abort upon seeing !dax_inode_alive().
  */
 void kill_dax_inode(struct dax_inode *dax_inode)
 {
@@ -63,7 +75,7 @@ void kill_dax_inode(struct dax_inode *dax_inode)
 		return;
 
 	dax_inode->alive = false;
-	synchronize_rcu();
+	synchronize_srcu(&dax_srcu);
 	dax_inode->private = NULL;
 }
 EXPORT_SYMBOL_GPL(kill_dax_inode);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 24ad71173995..67002898d130 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -8,6 +8,9 @@
 
 struct iomap_ops;
 
+int dax_read_lock(void);
+void dax_read_unlock(int id);
+
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
  * the entry size (PMD) and two more to tell us if the entry is a huge zero

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
