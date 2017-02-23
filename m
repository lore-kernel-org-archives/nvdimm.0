Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B409F81F5D
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 12:40:13 -0800 (PST)
Subject: [PATCH v2] device-dax: fix cdev leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Feb 2017 12:34:52 -0800
Message-ID: <148788199808.12623.6472923696722027067.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
with a stale device number.

As Jason points out, there is a small possibility that userspace has
opened and mapped the device in the time between cdev_add() and the
device_add() failure. We need a new kill_dax_dev() helper to invalidate
any established mappings.

Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
Cc: <stable@vger.kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Reported-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
v2: handle the potential of userspace establishing mappings
    between cdev_add() and device_add()

 drivers/dax/dax.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index ed758b74ddf0..b62a52fa3707 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -630,13 +630,10 @@ static void dax_dev_release(struct device *dev)
 	kfree(dax_dev);
 }
 
-static void unregister_dax_dev(void *dev)
+static void kill_dax_dev(struct dax_dev *dax_dev)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct cdev *cdev = &dax_dev->cdev;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	/*
 	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
 	 * ensuring that any fault handlers that might have seen
@@ -648,6 +645,15 @@ static void unregister_dax_dev(void *dev)
 	synchronize_rcu();
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
 	cdev_del(cdev);
+}
+
+static void unregister_dax_dev(void *dev)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	kill_dax_dev(dax_dev);
 	device_unregister(dev);
 }
 
@@ -724,6 +730,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
 	rc = device_add(dev);
 	if (rc) {
+		kill_dax_dev(dax_dev);
 		put_device(dev);
 		return ERR_PTR(rc);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
