Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 83A931A1E04
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:00 -0700 (PDT)
Subject: [ndctl PATCH 3/9] ndctl,
 list: list device-dax instances beneath a namespace
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:44 -0700
Message-ID: <146698348413.40541.8831911859137598217.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

For example:

    {
      "dev":"namespace0.0",
      "mode":"dax",
      "size":8453619712,
      "uuid":"277919a1-ba36-4f41-89b5-c9eebb9b7e33",
      "daxdevs":[
        {
          "chardev":"dax0.0",
          "size":8589934592
        }
      ]
    }

Note that "daxdevs" is an array because there may be more than one
per-namespace in the future.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/util/json.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/ndctl/util/json.c b/ndctl/util/json.c
index d144039bb559..dedfb45ed100 100644
--- a/ndctl/util/json.c
+++ b/ndctl/util/json.c
@@ -3,6 +3,7 @@
 #include <uuid/uuid.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 
 #ifdef HAVE_NDCTL_H
@@ -99,6 +100,39 @@ bool util_namespace_active(struct ndctl_namespace *ndns)
 	return false;
 }
 
+static json_object *util_daxctl_region_to_json(struct daxctl_region *region)
+{
+	struct json_object *jdaxdevs = json_object_new_array();
+	struct json_object *jobj;
+	struct daxctl_dev *dev;
+
+	if (!jdaxdevs)
+		return NULL;
+
+	daxctl_dev_foreach(region, dev) {
+		const char *devname = daxctl_dev_get_devname(dev);
+		struct json_object *jdev = json_object_new_object();
+
+		if (!devname || !jdev)
+			continue;
+		jobj = json_object_new_string(devname);
+		if (jobj)
+			json_object_object_add(jdev, "chardev", jobj);
+
+		jobj = json_object_new_int64(daxctl_dev_get_size(dev));
+		if (jobj)
+			json_object_object_add(jdev, "size", jobj);
+
+		json_object_array_add(jdaxdevs, jdev);
+	}
+
+	if (json_object_array_length(jdaxdevs) < 1) {
+		json_object_put(jdaxdevs);
+		return NULL;
+	}
+	return jdaxdevs;
+}
+
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 {
 	struct json_object *jndns = json_object_new_object();
@@ -178,12 +212,18 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 		json_object_object_add(jndns, "uuid", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
 	} else if (dax) {
+		struct daxctl_region *dax_region;
+
 		ndctl_dax_get_uuid(dax, uuid);
 		uuid_unparse(uuid, buf);
 		jobj = json_object_new_string(buf);
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
+		dax_region = ndctl_dax_get_daxctl_region(dax);
+		jobj = util_daxctl_region_to_json(dax_region);
+		if (jobj)
+			json_object_object_add(jndns, "daxdevs", jobj);
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
