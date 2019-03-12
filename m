From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] nvdimm: btt_devs: fix a NULL pointer dereference and a memory leak
Date: Tue, 12 Mar 2019 03:15:29 -0500
Message-ID: <20190312081529.4889-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

In case kmemdup fails, the fix releases resources and returns to
avoid the NULL pointer dereference.
Also, the error paths in the following code should release
resources to avoid memory leaks.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/nvdimm/btt_devs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 795ad4ff35ca..565ea0b6f765 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -196,8 +196,13 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 	}
 
 	nd_btt->lbasize = lbasize;
-	if (uuid)
+	if (uuid) {
 		uuid = kmemdup(uuid, 16, GFP_KERNEL);
+		if (!uuid) {
+			kfree(nd_btt);
+			return NULL;
+		}
+	}
 	nd_btt->uuid = uuid;
 	dev = &nd_btt->dev;
 	dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
@@ -209,6 +214,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
 		dev_dbg(&ndns->dev, "failed, already claimed by %s\n",
 				dev_name(ndns->claim));
 		put_device(dev);
+		kfree(uuid);
 		return NULL;
 	}
 	return dev;
-- 
2.17.1
