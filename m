Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C31CD21A0480E
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:21 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:39 -0600
Message-Id: <1490911959-5146-9-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 8/8] p2pmem: Added char device user interface
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

This creates a userspace interface to use p2pmemory. A user can use
mmap on the p2pmem char device to get buffers from the corresponding
device. This allows a user to use p2p memory with existing
interfaces like RDMA and O_DIRECT.

This patch is a bit more controversial because people don't want to
expose these interfaces to userspace without more consideration.
However, this patch is _very_ useful for expirementing with p2p memory.

For example, with this patch, you can test with commands like:

ib_write_bw -R --mmap=/dev/p2pmem0 -D 30

or use an fio script like:

[rdma-server]
rw=read
mem=mmapshared:/dev/p2pmem0
ioengine=rdma
port=14242
bs=64k
size=10G
iodepth=2

which would test the bandwidth of RDMA to/from the specified p2p memory.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/memory/p2pmem.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/p2pmem.h  |   4 ++
 2 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/p2pmem.c b/drivers/memory/p2pmem.c
index 499d42c..129c49c 100644
--- a/drivers/memory/p2pmem.c
+++ b/drivers/memory/p2pmem.c
@@ -19,14 +19,20 @@
 #include <linux/genalloc.h>
 #include <linux/memremap.h>
 #include <linux/debugfs.h>
+#include <linux/pfn_t.h>
 
 MODULE_DESCRIPTION("Peer 2 Peer Memory Device");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Microsemi Corporation");
 
+static int max_devices = 16;
+module_param(max_devices, int, 0444);
+MODULE_PARM_DESC(max_devices, "Maximum number of char devices");
+
 static struct class *p2pmem_class;
 static DEFINE_IDA(p2pmem_ida);
+static dev_t p2pmem_devt;
 
 static struct dentry *p2pmem_debugfs_root;
 
@@ -67,6 +73,144 @@ static struct p2pmem_dev *to_p2pmem(struct device *dev)
 	return container_of(dev, struct p2pmem_dev, dev);
 }
 
+struct p2pmem_vma {
+	struct p2pmem_dev *p2pmem_dev;
+	atomic_t mmap_count;
+	size_t nr_pages;
+
+	/* Protects the used_pages array */
+	struct mutex mutex;
+	struct page *used_pages[];
+};
+
+static void p2pmem_vma_open(struct vm_area_struct *vma)
+{
+	struct p2pmem_vma *pv = vma->vm_private_data;
+
+	atomic_inc(&pv->mmap_count);
+}
+
+static void p2pmem_vma_free_pages(struct vm_area_struct *vma)
+{
+	int i;
+	struct p2pmem_vma *pv = vma->vm_private_data;
+
+	mutex_lock(&pv->mutex);
+
+	for (i = 0; i < pv->nr_pages; i++) {
+		if (pv->used_pages[i]) {
+			p2pmem_free_page(pv->p2pmem_dev, pv->used_pages[i]);
+			pv->used_pages[i] = NULL;
+		}
+	}
+
+	mutex_unlock(&pv->mutex);
+}
+
+static void p2pmem_vma_close(struct vm_area_struct *vma)
+{
+	struct p2pmem_vma *pv = vma->vm_private_data;
+
+	if (!atomic_dec_and_test(&pv->mmap_count))
+		return;
+
+	p2pmem_vma_free_pages(vma);
+
+	dev_dbg(&pv->p2pmem_dev->dev, "vma close");
+	kfree(pv);
+}
+
+static int p2pmem_vma_fault(struct vm_fault *vmf)
+{
+	struct p2pmem_vma *pv = vmf->vma->vm_private_data;
+	unsigned int pg_idx;
+	struct page *pg;
+	pfn_t pfn;
+	int rc;
+
+	if (!pv->p2pmem_dev->alive)
+		return VM_FAULT_SIGBUS;
+
+	pg_idx = (vmf->address - vmf->vma->vm_start) / PAGE_SIZE;
+
+	mutex_lock(&pv->mutex);
+
+	if (pv->used_pages[pg_idx])
+		pg = pv->used_pages[pg_idx];
+	else
+		pg = p2pmem_alloc_page(pv->p2pmem_dev);
+
+	if (!pg)
+		return VM_FAULT_OOM;
+
+	pv->used_pages[pg_idx] = pg;
+
+	pfn = phys_to_pfn_t(page_to_phys(pg), PFN_DEV | PFN_MAP);
+	rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
+
+	mutex_unlock(&pv->mutex);
+
+	if (rc == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (rc < 0 && rc != -EBUSY)
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+
+const struct vm_operations_struct p2pmem_vmops = {
+	.open = p2pmem_vma_open,
+	.close = p2pmem_vma_close,
+	.fault = p2pmem_vma_fault,
+};
+
+static int p2pmem_open(struct inode *inode, struct file *filp)
+{
+	struct p2pmem_dev *p;
+
+	p = container_of(inode->i_cdev, struct p2pmem_dev, cdev);
+	filp->private_data = p;
+	p->inode = inode;
+
+	return 0;
+}
+
+static int p2pmem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct p2pmem_dev *p = filp->private_data;
+	struct p2pmem_vma *pv;
+	size_t nr_pages = (vma->vm_end - vma->vm_start) / PAGE_SIZE;
+
+	if ((vma->vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
+		dev_warn(&p->dev, "mmap failed: can't create private mapping\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(&p->dev, "Allocating mmap with %zd pages.\n", nr_pages);
+
+	pv = kzalloc(sizeof(*pv) + sizeof(pv->used_pages[0]) * nr_pages,
+		     GFP_KERNEL);
+	if (!pv)
+		return -ENOMEM;
+
+	mutex_init(&pv->mutex);
+	pv->nr_pages = nr_pages;
+	pv->p2pmem_dev = p;
+	atomic_set(&pv->mmap_count, 1);
+
+	vma->vm_private_data = pv;
+	vma->vm_ops = &p2pmem_vmops;
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	return 0;
+}
+
+static const struct file_operations p2pmem_fops = {
+	.owner = THIS_MODULE,
+	.open = p2pmem_open,
+	.mmap = p2pmem_mmap,
+};
+
 static void p2pmem_percpu_release(struct percpu_ref *ref)
 {
 	struct p2pmem_dev *p = container_of(ref, struct p2pmem_dev, ref);
@@ -114,10 +258,23 @@ struct remove_callback {
 static void p2pmem_remove(struct p2pmem_dev *p)
 {
 	struct remove_callback *remove_call, *tmp;
+	struct vm_area_struct *vma;
 
 	p->alive = false;
 	list_for_each_entry_safe(remove_call, tmp, &p->remove_list, list)
 		remove_call->callback(remove_call->context);
+
+	if (!p->inode)
+		return;
+
+	unmap_mapping_range(p->inode->i_mapping, 0, 0, 1);
+
+	i_mmap_lock_write(p->inode->i_mapping);
+	vma_interval_tree_foreach(vma, &p->inode->i_mapping->i_mmap, 0,
+				  ULONG_MAX) {
+		p2pmem_vma_free_pages(vma);
+	}
+	i_mmap_unlock_write(p->inode->i_mapping);
 }
 
 /**
@@ -147,6 +304,10 @@ struct p2pmem_dev *p2pmem_create(struct device *parent)
 	p->dev.parent = parent;
 	p->dev.release = p2pmem_release;
 
+	cdev_init(&p->cdev, &p2pmem_fops);
+	p->cdev.owner = THIS_MODULE;
+	p->cdev.kobj.parent = &p->dev.kobj;
+
 	p->id = ida_simple_get(&p2pmem_ida, 0, 0, GFP_KERNEL);
 	if (p->id < 0) {
 		rc = p->id;
@@ -154,6 +315,7 @@ struct p2pmem_dev *p2pmem_create(struct device *parent)
 	}
 
 	dev_set_name(&p->dev, "p2pmem%d", p->id);
+	p->dev.devt = MKDEV(MAJOR(p2pmem_devt), p->id);
 
 	p->pool = gen_pool_create(PAGE_SHIFT, nid);
 	if (!p->pool) {
@@ -177,14 +339,20 @@ struct p2pmem_dev *p2pmem_create(struct device *parent)
 			setup_debugfs(p);
 	}
 
-	rc = device_add(&p->dev);
+	rc = cdev_add(&p->cdev, p->dev.devt, 1);
 	if (rc)
 		goto err_id;
 
-	dev_info(&p->dev, "registered");
+	rc = device_add(&p->dev);
+	if (rc)
+		goto err_cdev;
 
+	dev_info(&p->dev, "registered");
 	return p;
 
+err_cdev:
+	cdev_del(&p->cdev);
+	p2pmem_remove(p);
 err_id:
 	ida_simple_remove(&p2pmem_ida, p->id);
 err_free:
@@ -206,6 +374,7 @@ void p2pmem_unregister(struct p2pmem_dev *p)
 
 	dev_info(&p->dev, "unregistered");
 	device_del(&p->dev);
+	cdev_del(&p->cdev);
 	p2pmem_remove(p);
 	ida_simple_remove(&p2pmem_ida, p->id);
 	put_device(&p->dev);
@@ -495,21 +664,32 @@ EXPORT_SYMBOL(p2pmem_put);
 
 static int __init p2pmem_init(void)
 {
+	int rc;
+
 	p2pmem_class = class_create(THIS_MODULE, "p2pmem");
 	if (IS_ERR(p2pmem_class))
 		return PTR_ERR(p2pmem_class);
 
+	rc = alloc_chrdev_region(&p2pmem_devt, 0, max_devices, "iopmemc");
+	if (rc)
+		goto err_chrdev;
+
 	p2pmem_debugfs_root = debugfs_create_dir("p2pmem", NULL);
 	if (!p2pmem_debugfs_root)
 		pr_info("could not create debugfs entry, continuing\n");
 
 	return 0;
+
+err_chrdev:
+	class_destroy(p2pmem_class);
+	return rc;
 }
 module_init(p2pmem_init);
 
 static void __exit p2pmem_exit(void)
 {
 	debugfs_remove_recursive(p2pmem_debugfs_root);
+	unregister_chrdev_region(p2pmem_devt, max_devices);
 	class_destroy(p2pmem_class);
 
 	pr_info(KBUILD_MODNAME ": unloaded.\n");
diff --git a/include/linux/p2pmem.h b/include/linux/p2pmem.h
index 9365b02..aeee60d 100644
--- a/include/linux/p2pmem.h
+++ b/include/linux/p2pmem.h
@@ -18,6 +18,7 @@
 
 #include <linux/device.h>
 #include <linux/pci.h>
+#include <linux/cdev.h>
 
 struct p2pmem_dev {
 	struct device dev;
@@ -32,6 +33,9 @@ struct p2pmem_dev {
 
 	struct mutex remove_mutex;	/* protects the remove callback list */
 	struct list_head remove_list;
+
+	struct cdev cdev;
+	struct inode *inode;
 };
 
 #ifdef CONFIG_P2PMEM
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
