Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BDA320945BD6
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 17:50:57 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 list: fix crash when listing idle device-dax instances
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Sep 2017 17:47:48 -0700
Message-ID: <150664606831.15244.13043658016858646915.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The following crash results from running 'ndctl list -i' on an inactive
namespace that is claimed for device-dax operation.

    Program received signal SIGSEGV, Segmentation fault.
    daxctl_dev_get_devname (dev=0x0) at libdaxctl.c:566
    566             return devpath_to_devname(dev->dev_path);
    (gdb) bt
    #0  daxctl_dev_get_devname (dev=0x0) at libdaxctl.c:566
    #1  0x0000555555563b39 in util_namespace_to_json
        at ../util/json.c:751

By definition the 'chardev' attribute for a device-dax instance can not
be found if the device-dax instance is disabled, because enabling the
namespace creates the child character device(s).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/util/json.c b/util/json.c
index dac8692a89af..d1ee351546b9 100644
--- a/util/json.c
+++ b/util/json.c
@@ -747,12 +747,18 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		} else if (dax_region) {
 			struct daxctl_dev *dev;
 
+			/*
+			 * We can only find/list these device-dax
+			 * details when the instance is enabled.
+			 */
 			dev = daxctl_dev_get_first(dax_region);
-			name = daxctl_dev_get_devname(dev);
-			jobj = json_object_new_string(name);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jndns, "chardev", jobj);
+			if (dev) {
+				name = daxctl_dev_get_devname(dev);
+				jobj = json_object_new_string(name);
+				if (!jobj)
+					goto err;
+				json_object_object_add(jndns, "chardev", jobj);
+			}
 		}
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		ndctl_namespace_get_uuid(ndns, uuid);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
