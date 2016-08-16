Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 4CCAC1A1E21
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:38 -0700 (PDT)
Subject: [PATCH 3/7] dax: rename fops from dax_dev_ to dax_
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:14 -0700
Message-ID: <147131791472.13727.2023969401837893939.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Shorten the prefix of the file operations to distinguish them from
operations on the struct device associated with the dax_dev.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 3774fc9709bb..994dfa507dfb 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -347,7 +347,7 @@ static const struct vm_operations_struct dax_dev_vm_ops = {
 	.close = dax_dev_vm_close,
 };
 
-static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
+static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct dax_dev *dax_dev = filp->private_data;
 	int rc;
@@ -365,7 +365,7 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 }
 
 /* return an unmapped area aligned to the dax region specified alignment */
-static unsigned long dax_dev_get_unmapped_area(struct file *filp,
+static unsigned long dax_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
@@ -411,7 +411,7 @@ static struct device *dax_dev_find(dev_t dev_t)
 	return class_find_device(dax_class, NULL, &dev_t, __match_devt);
 }
 
-static int dax_dev_open(struct inode *inode, struct file *filp)
+static int dax_open(struct inode *inode, struct file *filp)
 {
 	struct dax_dev *dax_dev = NULL;
 	struct device *dev;
@@ -437,7 +437,7 @@ static int dax_dev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int dax_dev_release(struct inode *inode, struct file *filp)
+static int dax_release(struct inode *inode, struct file *filp)
 {
 	struct dax_dev *dax_dev = filp->private_data;
 	struct device *dev = dax_dev->dev;
@@ -452,10 +452,10 @@ static int dax_dev_release(struct inode *inode, struct file *filp)
 static const struct file_operations dax_fops = {
 	.llseek = noop_llseek,
 	.owner = THIS_MODULE,
-	.open = dax_dev_open,
-	.release = dax_dev_release,
-	.get_unmapped_area = dax_dev_get_unmapped_area,
-	.mmap = dax_dev_mmap,
+	.open = dax_open,
+	.release = dax_release,
+	.get_unmapped_area = dax_get_unmapped_area,
+	.mmap = dax_mmap,
 };
 
 static void unregister_dax_dev(void *_dev)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
