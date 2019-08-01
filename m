Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFB24212FD41D
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jul 2019 17:32:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v9 06/13] daxctl/list: display the mode for a dax device
Date: Wed, 31 Jul 2019 18:29:25 -0600
Message-Id: <20190801002932.26430-7-vishal.l.verma@intel.com>
In-Reply-To: <20190801002932.26430-1-vishal.l.verma@intel.com>
References: <20190801002932.26430-1-vishal.l.verma@intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for a reconfigure-device command, allow JSON listings to
display the 'mode' of a dax device. This will allow the
reconfigure-device command (and via daxctl_dev_to_json(), also
daxctl-list) to print the mode in device listings via a 'daxctl-list'
command or immediately after a mode change.

Add a 'state' attribute to the json listings for devices, since a device
could end up in a state where it is not bound to any driver, and hence,
'disabled'. The state attribute is only displayed for disabled devices.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/lib/libdaxctl.c |  2 ++
 util/json.c            | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 949c56f..edb8257 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -12,6 +12,8 @@
  */
 #include <stdio.h>
 #include <errno.h>
+#include <limits.h>
+#include <libgen.h>
 #include <stdlib.h>
 #include <dirent.h>
 #include <unistd.h>
diff --git a/util/json.c b/util/json.c
index f521337..9f80b5b 100644
--- a/util/json.c
+++ b/util/json.c
@@ -269,6 +269,7 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 		unsigned long flags)
 {
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct json_object *jdev, *jobj;
 	int node;
@@ -292,6 +293,19 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 			json_object_object_add(jdev, "target_node", jobj);
 	}
 
+	if (mem)
+		jobj = json_object_new_string("system-ram");
+	else
+		jobj = json_object_new_string("devdax");
+	if (jobj)
+		json_object_object_add(jdev, "mode", jobj);
+
+	if (!daxctl_dev_is_enabled(dev)) {
+		jobj = json_object_new_string("disabled");
+		if (jobj)
+			json_object_object_add(jdev, "state", jobj);
+	}
+
 	return jdev;
 }
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
