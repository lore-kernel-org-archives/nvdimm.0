Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id BB9031A1E14
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 15:39:52 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] nvdimm, btt: add a size attribute for BTTs
Date: Wed, 27 Jul 2016 16:38:59 -0600
Message-Id: <1469659139-26088-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

To be consistent with other namespaces, expose a 'size' attribute for
BTT devices also.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2:
- Use the correct locking in size_show (Dan)
- Use a typecast for 64b multiplication

 drivers/nvdimm/btt.c      |  1 +
 drivers/nvdimm/btt_devs.c | 20 ++++++++++++++++++++
 drivers/nvdimm/nd.h       |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 68a7c3c..e0084ae 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1270,6 +1270,7 @@ static int btt_blk_init(struct btt *btt)
 		}
 	}
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
+	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	revalidate_disk(btt->btt_disk);
 
 	return 0;
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 3fa7919..97dd292 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -140,10 +140,30 @@ static ssize_t namespace_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(namespace);
 
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	ssize_t rc;
+
+	device_lock(dev);
+	if (dev->driver)
+		rc = sprintf(buf, "%llu\n", nd_btt->size);
+	else {
+		/* no size to convey if the btt instance is disabled */
+		rc = -ENXIO;
+	}
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(size);
+
 static struct attribute *nd_btt_attributes[] = {
 	&dev_attr_sector_size.attr,
 	&dev_attr_namespace.attr,
 	&dev_attr_uuid.attr,
+	&dev_attr_size.attr,
 	NULL,
 };
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 4047639..8024a0e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -143,6 +143,7 @@ struct nd_btt {
 	struct nd_namespace_common *ndns;
 	struct btt *btt;
 	unsigned long lbasize;
+	u64 size;
 	u8 *uuid;
 	int id;
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
