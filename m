Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id DA6AB1A1E16
 for <linux-nvdimm@lists.01.org>; Thu, 16 Jun 2016 18:05:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 1/2] block, badblocks: add a notifier for badblocks
Date: Thu, 16 Jun 2016 19:03:38 -0600
Message-Id: <1466125419-17736-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Filesystems with reverse mapping data may wish to do their own badblock
checking if they can be more efficient. This lays the groundwork for
that by providing a notifier in badblocks that such filesystems may
subscribe to. The notification includes information for whether one or
more badblocks were added or removed, the start sector of the operation,
and the number of sectors affected.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 block/badblocks.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/badblocks.h | 19 ++++++++++++
 2 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 7be53cb..f7cfece 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/badblocks.h>
+#include <linux/notifier.h>
 #include <linux/seqlock.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -25,6 +26,67 @@
 #include <linux/slab.h>
 
 /**
+ * badblocks_notify - call badblocks notifier chain
+ * @bb: struct badblocks that is changing
+ * @op: badblocks operation
+ * @sector: old clk rate
+ *
+ * Triggers a notifier call chain on the badblocks change notification
+ * for 'bb'.  Passes a pointer to the struct badblocks and the operation,
+ * and affected sector. Intended to be called by internal badblocks code
+ * only. Returns whatever atomic_notifier_call_chain returns.
+ */
+static int badblocks_notify(struct badblocks *bb, unsigned long op, sector_t sector,
+		int count)
+{
+	struct bb_notifier_data bbn_data;
+
+	bbn_data.sector = sector;
+	bbn_data.count = count;
+
+	return atomic_notifier_call_chain(&bb->notifier, op, &bbn_data);
+}
+
+/**
+ * bb_notifier_register - add a badblocks change notifier
+ * @bb: struct badblocks * to watch
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request notification when badblocks are added or cleared.
+ * This uses a notifier of the 'atomic' type.
+ *
+ * Returns -EINVAL if called with null arguments otherwise, passes along
+ * the return value of atomic_notifier_chain_register().
+ */
+int bb_notifier_register(struct badblocks *bb, struct notifier_block *nb)
+{
+	if (!bb || !nb)
+		return -EINVAL;
+
+	return atomic_notifier_chain_register(&bb->notifier, nb);
+}
+EXPORT_SYMBOL_GPL(bb_notifier_register);
+
+/**
+ * bb_notifier_unregister - remove a badblocks change notifier
+ * @bb: struct badblocks *
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request no further notification for changes to the badblocks list.
+ *
+ * Returns -EINVAL if called with null arguments; otherwise, passes
+ * along the return value of atomic_notifier_chain_unregister().
+ */
+int bb_notifier_unregister(struct badblocks *bb, struct notifier_block *nb)
+{
+	if (!bb || !nb)
+		return -EINVAL;
+
+	return atomic_notifier_chain_unregister(&bb->notifier, nb);
+}
+EXPORT_SYMBOL_GPL(bb_notifier_unregister);
+
+/**
  * badblocks_check() - check a given range for bad sectors
  * @bb:		the badblocks structure that holds all badblock information
  * @s:		sector (start) at which to check for badblocks
@@ -152,9 +214,10 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged)
 {
 	u64 *p;
-	int lo, hi;
-	int rv = 0;
+	int rv = 0, ret;
 	unsigned long flags;
+	sector_t saved_s = s;
+	int lo, hi, saved_count = sectors;
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
@@ -294,6 +357,11 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bb->changed = 1;
 	if (!acknowledged)
 		bb->unacked_exist = 1;
+
+	ret = badblocks_notify(bb, BB_ADD, saved_s, saved_count);
+	if (ret)
+		WARN(1, "Failure in badblocks notifier chain: %d\n", ret);
+
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
 	return rv;
@@ -318,8 +386,9 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	u64 *p;
 	int lo, hi;
+	sector_t saved_s = s;
 	sector_t target = s + sectors;
-	int rv = 0;
+	int rv = 0, ret, saved_count = sectors;
 
 	if (bb->shift > 0) {
 		/* When clearing we round the start up and the end down.
@@ -400,6 +469,9 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	}
 
 	bb->changed = 1;
+	ret = badblocks_notify(bb, BB_CLEAR, saved_s, saved_count);
+	if (ret)
+		WARN(1, "Failure in badblocks notifier chain: %d\n", ret);
 out:
 	write_sequnlock_irq(&bb->lock);
 	return rv;
@@ -541,6 +613,7 @@ static int __badblocks_init(struct device *dev, struct badblocks *bb,
 		return -ENOMEM;
 	}
 	seqlock_init(&bb->lock);
+	ATOMIC_INIT_NOTIFIER_HEAD(&bb->notifier);
 
 	return 0;
 }
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index c3bdf8c..67539f0 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_BADBLOCKS_H
 #define _LINUX_BADBLOCKS_H
 
+#include <linux/notifier.h>
 #include <linux/seqlock.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -38,8 +39,26 @@ struct badblocks {
 	seqlock_t lock;
 	sector_t sector;
 	sector_t size;		/* in sectors */
+	struct atomic_notifier_head notifier; /* notifier for filesystems */
 };
 
+#define BB_ADD		0
+#define BB_CLEAR	1
+
+/**
+ * struct bb_notifier_data - data to pass to the notifier callback
+ * @bb: struct badblocks * being changed
+ * @sector: the 512B sector being added/removed
+ * @count: number of sectors after @sector being added/removed
+ */
+struct bb_notifier_data {
+	struct badblocks *bb;
+	sector_t sector;
+	int count;
+};
+
+int bb_notifier_register(struct badblocks *bb, struct notifier_block *nb);
+int bb_notifier_unregister(struct badblocks *bb, struct notifier_block *nb);
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
