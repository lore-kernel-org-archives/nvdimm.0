Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AD5621B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:59:06 -0700 (PDT)
Subject: [PATCH v4 14/16] dax: convert to bitmask for flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:54:12 -0700
Message-ID: <149875885239.10031.8327478660509602792.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, x86@kernel.org, hch@lst.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

In preparation for adding more flags, convert the existing flag to a
bit-flag.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9e0160b950d7..8bf71195921b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -116,13 +116,18 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 EXPORT_SYMBOL_GPL(__bdev_dax_supported);
 #endif
 
+enum dax_device_flags {
+	/* !alive + rcu grace period == no new operations / mappings */
+	DAXDEV_ALIVE,
+};
+
 /**
  * struct dax_device - anchor object for dax services
  * @inode: core vfs
  * @cdev: optional character interface for "device dax"
  * @host: optional name for lookups where the device path is not available
  * @private: dax driver private data
- * @alive: !alive + rcu grace period == no new operations / mappings
+ * @flags: state and boolean properties
  */
 struct dax_device {
 	struct hlist_node list;
@@ -130,7 +135,7 @@ struct dax_device {
 	struct cdev cdev;
 	const char *host;
 	void *private;
-	bool alive;
+	unsigned long flags;
 	const struct dax_operations *ops;
 };
 
@@ -197,7 +202,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
-	return dax_dev->alive;
+	return test_bit(DAXDEV_ALIVE, &dax_dev->flags);
 }
 EXPORT_SYMBOL_GPL(dax_alive);
 
@@ -217,7 +222,7 @@ void kill_dax(struct dax_device *dax_dev)
 	if (!dax_dev)
 		return;
 
-	dax_dev->alive = false;
+	clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
 
 	synchronize_srcu(&dax_srcu);
 
@@ -257,7 +262,7 @@ static void dax_destroy_inode(struct inode *inode)
 {
 	struct dax_device *dax_dev = to_dax_dev(inode);
 
-	WARN_ONCE(dax_dev->alive,
+	WARN_ONCE(test_bit(DAXDEV_ALIVE, &dax_dev->flags),
 			"kill_dax() must be called before final iput()\n");
 	call_rcu(&inode->i_rcu, dax_i_callback);
 }
@@ -309,7 +314,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	dax_dev = to_dax_dev(inode);
 	if (inode->i_state & I_NEW) {
-		dax_dev->alive = true;
+		set_bit(DAXDEV_ALIVE, &dax_dev->flags);
 		inode->i_cdev = &dax_dev->cdev;
 		inode->i_mode = S_IFCHR;
 		inode->i_flags = S_DAX;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
