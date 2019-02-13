Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C11C202E534E
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 18:03:35 -0800 (PST)
Subject: [PATCH v2] device-dax: Auto-bind device after successful new_id
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 17:50:55 -0800
Message-ID: <155002261877.645460.9109209504128012410.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, Brice Goglin <Brice.Goglin@inria.fr>
List-ID: <linux-nvdimm@lists.01.org>

The typical 'new_id' attribute behavior is to immediately attach a
device to its driver after a new device-id is added. Implement this
behavior for the dax bus.

Reported-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v1:
* Fix the remove_id path since do_id_store() is shared with the new_id
  path (Brice)

Brice, this works for me. I'll push it out on libnvdimm-pending, or in
the meantime you can apply this patch after reverting commit
a9f1ffdb6a20 on the current state of the branch.

 drivers/dax/bus.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c620ad52d7e5..a410154d75fb 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -57,8 +57,13 @@ static int dax_match_id(struct dax_device_driver *dax_drv, struct device *dev)
 	return match;
 }
 
+enum id_action {
+	ID_REMOVE,
+	ID_ADD,
+};
+
 static ssize_t do_id_store(struct device_driver *drv, const char *buf,
-		size_t count, bool add)
+		size_t count, enum id_action action)
 {
 	struct dax_device_driver *dax_drv = to_dax_drv(drv);
 	unsigned int region_id, id;
@@ -77,7 +82,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 	mutex_lock(&dax_bus_lock);
 	dax_id = __dax_match_id(dax_drv, buf);
 	if (!dax_id) {
-		if (add) {
+		if (action == ID_ADD) {
 			dax_id = kzalloc(sizeof(*dax_id), GFP_KERNEL);
 			if (dax_id) {
 				strncpy(dax_id->dev_name, buf, DAX_NAME_LEN);
@@ -86,26 +91,33 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 				rc = -ENOMEM;
 		} else
 			/* nothing to remove */;
-	} else if (!add) {
+	} else if (action == ID_REMOVE) {
 		list_del(&dax_id->list);
 		kfree(dax_id);
 	} else
 		/* dax_id already added */;
 	mutex_unlock(&dax_bus_lock);
-	return rc;
+
+	if (rc < 0)
+		return rc;
+	if (action == ID_ADD)
+		rc = driver_attach(drv);
+	if (rc)
+		return rc;
+	return count;
 }
 
 static ssize_t new_id_store(struct device_driver *drv, const char *buf,
 		size_t count)
 {
-	return do_id_store(drv, buf, count, true);
+	return do_id_store(drv, buf, count, ID_ADD);
 }
 static DRIVER_ATTR_WO(new_id);
 
 static ssize_t remove_id_store(struct device_driver *drv, const char *buf,
 		size_t count)
 {
-	return do_id_store(drv, buf, count, false);
+	return do_id_store(drv, buf, count, ID_REMOVE);
 }
 static DRIVER_ATTR_WO(remove_id);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
