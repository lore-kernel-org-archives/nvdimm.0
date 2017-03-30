Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD71B21A0480E
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:36 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:35 -0600
Message-Id: <1490911959-5146-5-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 4/8] p2pmem: Add debugfs "stats" file
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

From: Steve Wise <swise@opengridcomputing.com>

For each p2pmem instance, add a "stats" file to show
the gen_pool statistics.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 drivers/memory/p2pmem.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/p2pmem.h  |  2 ++
 2 files changed, 51 insertions(+)

diff --git a/drivers/memory/p2pmem.c b/drivers/memory/p2pmem.c
index c4ea311..71741c2 100644
--- a/drivers/memory/p2pmem.c
+++ b/drivers/memory/p2pmem.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/genalloc.h>
 #include <linux/memremap.h>
+#include <linux/debugfs.h>
 
 MODULE_DESCRIPTION("Peer 2 Peer Memory Device");
 MODULE_VERSION("0.1");
@@ -27,6 +28,40 @@ MODULE_AUTHOR("Microsemi Corporation");
 static struct class *p2pmem_class;
 static DEFINE_IDA(p2pmem_ida);
 
+static struct dentry *p2pmem_debugfs_root;
+
+static int stats_show(struct seq_file *seq, void *v)
+{
+	struct p2pmem_dev *p = seq->private;
+
+	if (p->pool) {
+		seq_printf(seq, "total size: %lu\n", gen_pool_size(p->pool));
+		seq_printf(seq, "available:  %lu\n", gen_pool_avail(p->pool));
+	}
+	return 0;
+}
+
+static int stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stats_show, inode->i_private);
+}
+
+static const struct file_operations stats_debugfs_fops = {
+	.owner   = THIS_MODULE,
+	.open    = stats_open,
+	.release = single_release,
+	.read	 = seq_read,
+	.llseek  = seq_lseek,
+};
+
+static void setup_debugfs(struct p2pmem_dev *p)
+{
+	struct dentry *de;
+
+	de = debugfs_create_file("stats", 0400, p->debugfs_root,
+				 (void *)p, &stats_debugfs_fops);
+}
+
 static struct p2pmem_dev *to_p2pmem(struct device *dev)
 {
 	return container_of(dev, struct p2pmem_dev, dev);
@@ -62,6 +97,8 @@ static void p2pmem_release(struct device *dev)
 {
 	struct p2pmem_dev *p = to_p2pmem(dev);
 
+	debugfs_remove_recursive(p->debugfs_root);
+
 	if (p->pool)
 		gen_pool_destroy(p->pool);
 
@@ -114,6 +151,13 @@ struct p2pmem_dev *p2pmem_create(struct device *parent)
 	if (rc)
 		goto err_id;
 
+	if (p2pmem_debugfs_root) {
+		p->debugfs_root = debugfs_create_dir(dev_name(&p->dev),
+						     p2pmem_debugfs_root);
+		if (p->debugfs_root)
+			setup_debugfs(p);
+	}
+
 	rc = device_add(&p->dev);
 	if (rc)
 		goto err_id;
@@ -390,12 +434,17 @@ static int __init p2pmem_init(void)
 	if (IS_ERR(p2pmem_class))
 		return PTR_ERR(p2pmem_class);
 
+	p2pmem_debugfs_root = debugfs_create_dir("p2pmem", NULL);
+	if (!p2pmem_debugfs_root)
+		pr_info("could not create debugfs entry, continuing\n");
+
 	return 0;
 }
 module_init(p2pmem_init);
 
 static void __exit p2pmem_exit(void)
 {
+	debugfs_remove_recursive(p2pmem_debugfs_root);
 	class_destroy(p2pmem_class);
 
 	pr_info(KBUILD_MODNAME ": unloaded.\n");
diff --git a/include/linux/p2pmem.h b/include/linux/p2pmem.h
index 71dc1e1..4cd6f35 100644
--- a/include/linux/p2pmem.h
+++ b/include/linux/p2pmem.h
@@ -26,6 +26,8 @@ struct p2pmem_dev {
 	struct percpu_ref ref;
 	struct completion cmp;
 	struct gen_pool *pool;
+
+	struct dentry *debugfs_root;
 };
 
 #ifdef CONFIG_P2PMEM
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
