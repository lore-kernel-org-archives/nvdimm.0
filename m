Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90052C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418377; x=1672954377;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DVPWw7S0J/KfK0ZXN7UYv8lUoolDMju+mf0/cBBKqdg=;
  b=gGhnS0tAa76lXNLZEP0+o0oHusIGdthfOBLTIuAl612eYc0FMDhmor5g
   +Ac+pnpxJuUObcM+oW9dmJZj97hPQ0MukQnP5PXEFNnEMBW+EAU6e29CN
   s+HMNuhGG8wtr6fgTTyhBdF6djb9j5hjtBkw7rShjLUsjdR6II1HkvK5F
   qhuPjp+vVlB/N7TPNDbjePuWVx9rZ0Q2cJ2gVy6FqJ6mz41RI3Ou3PBI0
   ZtPv6qjteMG+4HG/gFEl7oJbUYSG3BnjTWxcoaJa2YdkJsqTYHLUpKXzD
   F5l055IpNjSBhAFWEbF0ZKlu8hoWWuF4th8r44KJosB72Jump4NNk/Qgb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223224420"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="223224420"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="526709530"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:27 -0800
Subject: [ndctl PATCH v3 09/16] util: Distribute 'filter' and 'json' helpers
 to per-tool objects
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:26 -0800
Message-ID: <164141834691.3990253.16681105368577841032.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for switching build systems, fix the long standing wart
of mixing ndctl, daxctl, and cxl 'filter' and 'json' utilities in the
top-level util/filter.[ch]. Distribute them to their respective
{ndctl,daxctl,cxl}/filter.{c,h} locations.

This also removes the naming collisions for util/json.h between util/
and ndct/util/. I.e. <util/json.h> is no longer ambiguous or subject to
being shadowed by the tool local "util" directory.

Unfortunately unwinding this caused a lot of code to move all at once.
The benefit is that now it is clear that ndctl is the only tool that
reaches across into the 'filter' and 'json' functionality of another
tool (daxctl).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am                   |    1 
 Makefile.am.in                |    3 
 cxl/Makefile.am               |    3 
 cxl/filter.c                  |   25 +
 cxl/filter.h                  |    7 
 cxl/json.c                    |  214 ++++++
 cxl/json.h                    |    8 
 cxl/list.c                    |    4 
 cxl/memdev.c                  |    3 
 daxctl/Makefile.am            |    5 
 daxctl/device.c               |    4 
 daxctl/filter.c               |   43 +
 daxctl/filter.h               |   12 
 daxctl/json.c                 |  245 +++++++
 daxctl/json.h                 |   18 
 daxctl/list.c                 |    4 
 ndctl/Makefile.am             |   16 
 ndctl/bus.c                   |    4 
 ndctl/check.c                 |    2 
 ndctl/dimm.c                  |    6 
 ndctl/filter.c                |   60 --
 ndctl/filter.h                |   12 
 ndctl/inject-error.c          |    6 
 ndctl/inject-smart.c          |    6 
 ndctl/json-smart.c            |    5 
 ndctl/json.c                  | 1114 ++++++++++++++++++++++++++++++
 ndctl/json.h                  |   24 +
 ndctl/keys.c                  |    5 
 ndctl/keys.h                  |    0 
 ndctl/lib/libndctl.c          |    2 
 ndctl/lib/papr.c              |    4 
 ndctl/lib/private.h           |    4 
 ndctl/list.c                  |    5 
 ndctl/load-keys.c             |    7 
 ndctl/monitor.c               |    4 
 ndctl/namespace.c             |    6 
 ndctl/region.c                |    3 
 test/Makefile.am              |   22 -
 test/ack-shutdown-count-set.c |    2 
 test/daxdev-errors.c          |    2 
 test/device-dax.c             |    2 
 test/dsm-fail.c               |    4 
 test/libndctl.c               |    2 
 test/list-smart-dimm.c        |    6 
 test/pmem_namespaces.c        |    2 
 test/revoke-devmem.c          |    2 
 util/help.c                   |    2 
 util/json.c                   | 1542 -----------------------------------------
 util/json.h                   |   39 -
 49 files changed, 1820 insertions(+), 1701 deletions(-)
 create mode 100644 cxl/filter.c
 create mode 100644 cxl/filter.h
 create mode 100644 cxl/json.c
 create mode 100644 cxl/json.h
 create mode 100644 daxctl/filter.c
 create mode 100644 daxctl/filter.h
 create mode 100644 daxctl/json.c
 create mode 100644 daxctl/json.h
 rename util/filter.c => ndctl/filter.c (88%)
 rename util/filter.h => ndctl/filter.h (89%)
 rename ndctl/{util/json-smart.c => json-smart.c} (99%)
 create mode 100644 ndctl/json.c
 create mode 100644 ndctl/json.h
 rename ndctl/{util/keys.c => keys.c} (99%)
 rename ndctl/{util/keys.h => keys.h} (100%)

diff --git a/Makefile.am b/Makefile.am
index 269d891f7cd4..daea39f5d41e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -86,7 +86,6 @@ libutil_a_SOURCES = \
 	util/help.c \
 	util/strbuf.c \
 	util/wrapper.c \
-	util/filter.c \
 	util/bitmap.c \
 	util/abspath.c \
 	util/iomem.c \
diff --git a/Makefile.am.in b/Makefile.am.in
index 9c2c4dfbc021..d6b126986bb4 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -9,9 +9,6 @@ AM_CPPFLAGS = \
 	-DLIBEXECDIR=\""$(libexecdir)"\" \
 	-DPREFIX=\""$(prefix)"\" \
 	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
-	-I${top_srcdir}/ndctl/lib \
-	-I${top_srcdir}/ndctl \
-	-I${top_srcdir}/cxl \
 	-I${top_srcdir}/ \
 	$(KMOD_CFLAGS) \
 	$(UDEV_CFLAGS) \
diff --git a/cxl/Makefile.am b/cxl/Makefile.am
index da9f91d8fd05..ee8488900a3b 100644
--- a/cxl/Makefile.am
+++ b/cxl/Makefile.am
@@ -12,6 +12,9 @@ cxl_SOURCES =\
 		list.c \
 		memdev.c \
 		../util/json.c \
+		json.c \
+		filter.c \
+		filter.h \
 		builtin.h
 
 cxl_LDADD =\
diff --git a/cxl/filter.c b/cxl/filter.c
new file mode 100644
index 000000000000..21322ed4b4d0
--- /dev/null
+++ b/cxl/filter.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <stdio.h>
+#include <string.h>
+#include <cxl/libcxl.h>
+#include "filter.h"
+
+struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
+                                         const char *ident)
+{
+       int memdev_id;
+
+       if (!ident || strcmp(ident, "all") == 0)
+               return memdev;
+
+       if (strcmp(ident, cxl_memdev_get_devname(memdev)) == 0)
+               return memdev;
+
+       if ((sscanf(ident, "%d", &memdev_id) == 1
+                       || sscanf(ident, "mem%d", &memdev_id) == 1)
+                       && cxl_memdev_get_id(memdev) == memdev_id)
+               return memdev;
+
+       return NULL;
+}
diff --git a/cxl/filter.h b/cxl/filter.h
new file mode 100644
index 000000000000..da800336b528
--- /dev/null
+++ b/cxl/filter.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
+#ifndef _CXL_UTIL_FILTER_H_
+#define _CXL_UTIL_FILTER_H_
+struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
+		const char *ident);
+#endif /* _CXL_UTIL_FILTER_H_ */
diff --git a/cxl/json.c b/cxl/json.c
new file mode 100644
index 000000000000..e562502d9116
--- /dev/null
+++ b/cxl/json.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <cxl/libcxl.h>
+#include <json-c/json.h>
+#include <json-c/printbuf.h>
+#include <ccan/short_types/short_types.h>
+
+#include "json.h"
+
+static struct json_object *util_cxl_memdev_health_to_json(
+		struct cxl_memdev *memdev, unsigned long flags)
+{
+	struct json_object *jhealth;
+	struct json_object *jobj;
+	struct cxl_cmd *cmd;
+	u32 field;
+	int rc;
+
+	jhealth = json_object_new_object();
+	if (!jhealth)
+		return NULL;
+	if (!memdev)
+		goto err_jobj;
+
+	cmd = cxl_cmd_new_get_health_info(memdev);
+	if (!cmd)
+		goto err_jobj;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto err_cmd;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto err_cmd;
+
+	/* health_status fields */
+	rc = cxl_cmd_health_info_get_maintenance_needed(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "maintenance_needed", jobj);
+
+	rc = cxl_cmd_health_info_get_performance_degraded(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "performance_degraded", jobj);
+
+	rc = cxl_cmd_health_info_get_hw_replacement_needed(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "hw_replacement_needed", jobj);
+
+	/* media_status fields */
+	rc = cxl_cmd_health_info_get_media_normal(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_normal", jobj);
+
+	rc = cxl_cmd_health_info_get_media_not_ready(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_not_ready", jobj);
+
+	rc = cxl_cmd_health_info_get_media_persistence_lost(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_persistence_lost", jobj);
+
+	rc = cxl_cmd_health_info_get_media_data_lost(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_data_lost", jobj);
+
+	rc = cxl_cmd_health_info_get_media_powerloss_persistence_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_powerloss_persistence_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_shutdown_persistence_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_shutdown_persistence_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_persistence_loss_imminent(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_persistence_loss_imminent", jobj);
+
+	rc = cxl_cmd_health_info_get_media_powerloss_data_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_powerloss_data_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_shutdown_data_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_shutdown_data_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_data_loss_imminent(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_data_loss_imminent", jobj);
+
+	/* ext_status fields */
+	if (cxl_cmd_health_info_get_ext_life_used_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_life_used_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else if (cxl_cmd_health_info_get_ext_life_used_critical(cmd))
+		jobj = json_object_new_string("critical");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_life_used", jobj);
+
+	if (cxl_cmd_health_info_get_ext_temperature_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_temperature_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else if (cxl_cmd_health_info_get_ext_temperature_critical(cmd))
+		jobj = json_object_new_string("critical");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_temperature", jobj);
+
+	if (cxl_cmd_health_info_get_ext_corrected_volatile_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_corrected_volatile_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_corrected_volatile", jobj);
+
+	if (cxl_cmd_health_info_get_ext_corrected_persistent_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_corrected_persistent_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_corrected_persistent", jobj);
+
+	/* other fields */
+	field = cxl_cmd_health_info_get_life_used(cmd);
+	if (field != 0xff) {
+		jobj = json_object_new_int(field);
+		if (jobj)
+			json_object_object_add(jhealth, "life_used_percent", jobj);
+	}
+
+	field = cxl_cmd_health_info_get_temperature(cmd);
+	if (field != 0xffff) {
+		jobj = json_object_new_int(field);
+		if (jobj)
+			json_object_object_add(jhealth, "temperature", jobj);
+	}
+
+	field = cxl_cmd_health_info_get_dirty_shutdowns(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "dirty_shutdowns", jobj);
+
+	field = cxl_cmd_health_info_get_volatile_errors(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "volatile_errors", jobj);
+
+	field = cxl_cmd_health_info_get_pmem_errors(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "pmem_errors", jobj);
+
+	cxl_cmd_unref(cmd);
+	return jhealth;
+
+err_cmd:
+	cxl_cmd_unref(cmd);
+err_jobj:
+	json_object_put(jhealth);
+	return NULL;
+}
+
+struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
+		unsigned long flags)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct json_object *jdev, *jobj;
+
+	jdev = json_object_new_object();
+	if (!devname || !jdev)
+		return NULL;
+
+	jobj = json_object_new_string(devname);
+	if (jobj)
+		json_object_object_add(jdev, "memdev", jobj);
+
+	jobj = util_json_object_size(cxl_memdev_get_pmem_size(memdev), flags);
+	if (jobj)
+		json_object_object_add(jdev, "pmem_size", jobj);
+
+	jobj = util_json_object_size(cxl_memdev_get_ram_size(memdev), flags);
+	if (jobj)
+		json_object_object_add(jdev, "ram_size", jobj);
+
+	if (flags & UTIL_JSON_HEALTH) {
+		jobj = util_cxl_memdev_health_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "health", jobj);
+	}
+	return jdev;
+}
diff --git a/cxl/json.h b/cxl/json.h
new file mode 100644
index 000000000000..3abcfe6661bf
--- /dev/null
+++ b/cxl/json.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
+#ifndef __CXL_UTIL_JSON_H__
+#define __CXL_UTIL_JSON_H__
+struct cxl_memdev;
+struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
+		unsigned long flags);
+#endif /* __CXL_UTIL_JSON_H__ */
diff --git a/cxl/list.c b/cxl/list.c
index b1468b70f8c9..7f7a04d9a6e5 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -6,12 +6,14 @@
 #include <unistd.h>
 #include <limits.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <cxl/libcxl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 
+#include "json.h"
+#include "filter.h"
+
 static struct {
 	bool memdevs;
 	bool idle;
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 5ee38e51f4ee..d063d51cc571 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -6,12 +6,13 @@
 #include <unistd.h>
 #include <limits.h>
 #include <util/log.h>
-#include <util/filter.h>
 #include <cxl/libcxl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 
+#include "filter.h"
+
 struct action_context {
 	FILE *f_out;
 	FILE *f_in;
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index d1bf9fb25a7d..bbf764f8081f 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -18,6 +18,11 @@ daxctl_SOURCES =\
 		migrate.c \
 		device.c \
 		../util/json.c \
+		../util/json.h \
+		json.c \
+		json.h \
+		filter.c \
+		filter.h \
 		builtin.h
 
 daxctl_LDADD =\
diff --git a/daxctl/device.c b/daxctl/device.c
index c2ff0cc60b52..d202f02d07e7 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -11,7 +11,6 @@
 #include <sys/sysmacros.h>
 #include <util/size.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <json-c/json_util.h>
 #include <ndctl/libndctl.h>
@@ -20,6 +19,9 @@
 #include <util/parse-configs.h>
 #include <ccan/array_size/array_size.h>
 
+#include "filter.h"
+#include "json.h"
+
 static struct {
 	const char *dev;
 	const char *mode;
diff --git a/daxctl/filter.c b/daxctl/filter.c
new file mode 100644
index 000000000000..cecb808edade
--- /dev/null
+++ b/daxctl/filter.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <stdio.h>
+#include <string.h>
+#include <daxctl/libdaxctl.h>
+
+#include "filter.h"
+
+struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
+					  const char *ident)
+{
+	struct daxctl_region *region = daxctl_dev_get_region(dev);
+	int region_id, dev_id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return dev;
+
+	if (strcmp(ident, daxctl_dev_get_devname(dev)) == 0)
+		return dev;
+
+	if (sscanf(ident, "%d.%d", &region_id, &dev_id) == 2 &&
+	    daxctl_region_get_id(region) == region_id &&
+	    daxctl_dev_get_id(dev) == dev_id)
+		return dev;
+
+	return NULL;
+}
+
+struct daxctl_region *util_daxctl_region_filter(struct daxctl_region *region,
+						const char *ident)
+{
+	int region_id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return region;
+
+	if ((sscanf(ident, "%d", &region_id) == 1 ||
+	     sscanf(ident, "region%d", &region_id) == 1) &&
+	    daxctl_region_get_id(region) == region_id)
+		return region;
+
+	return NULL;
+}
diff --git a/daxctl/filter.h b/daxctl/filter.h
new file mode 100644
index 000000000000..234f2216e57e
--- /dev/null
+++ b/daxctl/filter.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
+#ifndef _DAXCTL_UTIL_FILTER_H_
+#define _DAXCTL_UTIL_FILTER_H_
+#include <stdbool.h>
+#include <ccan/list/list.h>
+
+struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
+		const char *ident);
+struct daxctl_region *util_daxctl_region_filter(struct daxctl_region *region,
+		const char *ident);
+#endif /* _DAXCTL_UTIL_FILTER_H_ */
diff --git a/daxctl/json.c b/daxctl/json.c
new file mode 100644
index 000000000000..66a795e2e544
--- /dev/null
+++ b/daxctl/json.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <limits.h>
+#include <string.h>
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <json-c/json.h>
+#include <json-c/printbuf.h>
+#include <daxctl/libdaxctl.h>
+
+#include "filter.h"
+#include "json.h"
+
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
+		unsigned long flags)
+{
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
+	const char *devname = daxctl_dev_get_devname(dev);
+	struct json_object *jdev, *jobj, *jmappings = NULL;
+	struct daxctl_mapping *mapping = NULL;
+	int node, movable, align;
+
+	jdev = json_object_new_object();
+	if (!devname || !jdev)
+		return NULL;
+
+	jobj = json_object_new_string(devname);
+	if (jobj)
+		json_object_object_add(jdev, "chardev", jobj);
+
+	jobj = util_json_object_size(daxctl_dev_get_size(dev), flags);
+	if (jobj)
+		json_object_object_add(jdev, "size", jobj);
+
+	node = daxctl_dev_get_target_node(dev);
+	if (node >= 0) {
+		jobj = json_object_new_int(node);
+		if (jobj)
+			json_object_object_add(jdev, "target_node", jobj);
+	}
+
+	align = daxctl_dev_get_align(dev);
+	if (align > 0) {
+		jobj = util_json_object_size(daxctl_dev_get_align(dev), flags);
+		if (jobj)
+			json_object_object_add(jdev, "align", jobj);
+	}
+
+	if (mem)
+		jobj = json_object_new_string("system-ram");
+	else
+		jobj = json_object_new_string("devdax");
+	if (jobj)
+		json_object_object_add(jdev, "mode", jobj);
+
+	if (mem && daxctl_dev_get_resource(dev) != 0) {
+		int num_sections = daxctl_memory_num_sections(mem);
+		int num_online = daxctl_memory_is_online(mem);
+
+		jobj = json_object_new_int(num_online);
+		if (jobj)
+			json_object_object_add(jdev, "online_memblocks", jobj);
+
+		jobj = json_object_new_int(num_sections);
+		if (jobj)
+			json_object_object_add(jdev, "total_memblocks", jobj);
+
+		movable = daxctl_memory_is_movable(mem);
+		if (movable == 1)
+			jobj = json_object_new_boolean(true);
+		else if (movable == 0)
+			jobj = json_object_new_boolean(false);
+		else
+			jobj = NULL;
+		if (jobj)
+			json_object_object_add(jdev, "movable", jobj);
+	}
+
+	if (!daxctl_dev_is_enabled(dev)) {
+		jobj = json_object_new_string("disabled");
+		if (jobj)
+			json_object_object_add(jdev, "state", jobj);
+	}
+
+	if (!(flags & UTIL_JSON_DAX_MAPPINGS))
+		return jdev;
+
+	daxctl_mapping_foreach(dev, mapping) {
+		struct json_object *jmapping;
+
+		if (!jmappings) {
+			jmappings = json_object_new_array();
+			if (!jmappings)
+				continue;
+
+			json_object_object_add(jdev, "mappings", jmappings);
+		}
+
+		jmapping = util_daxctl_mapping_to_json(mapping, flags);
+		if (!jmapping)
+			continue;
+		json_object_array_add(jmappings, jmapping);
+	}
+	return jdev;
+}
+
+struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
+		struct json_object *jdevs, const char *ident,
+		unsigned long flags)
+{
+	struct daxctl_dev *dev;
+
+	daxctl_dev_foreach(region, dev) {
+		struct json_object *jdev;
+
+		if (!util_daxctl_dev_filter(dev, ident))
+			continue;
+
+		if (!(flags & (UTIL_JSON_IDLE|UTIL_JSON_CONFIGURED))
+				&& !daxctl_dev_get_size(dev))
+			continue;
+
+		if (!jdevs) {
+			jdevs = json_object_new_array();
+			if (!jdevs)
+				return NULL;
+		}
+
+		jdev = util_daxctl_dev_to_json(dev, flags);
+		if (!jdev) {
+			json_object_put(jdevs);
+			return NULL;
+		}
+
+		json_object_array_add(jdevs, jdev);
+	}
+
+	return jdevs;
+}
+
+struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
+		const char *ident, unsigned long flags)
+{
+	unsigned long align;
+	struct json_object *jregion, *jobj;
+	unsigned long long available_size, size;
+
+	jregion = json_object_new_object();
+	if (!jregion)
+		return NULL;
+
+	/*
+	 * The flag indicates when we are being called by an agent that
+	 * already knows about the parent device information.
+	 */
+	if (!(flags & UTIL_JSON_DAX)) {
+		/* trim off the redundant /sys/devices prefix */
+		const char *path = daxctl_region_get_path(region);
+		int len = strlen("/sys/devices");
+		const char *trim = &path[len];
+
+		if (strncmp(path, "/sys/devices", len) != 0)
+			goto err;
+		jobj = json_object_new_string(trim);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "path", jobj);
+	}
+
+	jobj = json_object_new_int(daxctl_region_get_id(region));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jregion, "id", jobj);
+
+	size = daxctl_region_get_size(region);
+	if (size < ULLONG_MAX) {
+		jobj = util_json_object_size(size, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "size", jobj);
+	}
+
+	available_size = daxctl_region_get_available_size(region);
+	if (available_size) {
+		jobj = util_json_object_size(available_size, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "available_size", jobj);
+	}
+
+	align = daxctl_region_get_align(region);
+	if (align < ULONG_MAX) {
+		jobj = json_object_new_int64(align);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "align", jobj);
+	}
+
+	if (!(flags & UTIL_JSON_DAX_DEVS))
+		return jregion;
+
+	jobj = util_daxctl_devs_to_list(region, NULL, ident, flags);
+	if (jobj)
+		json_object_object_add(jregion, "devices", jobj);
+
+	return jregion;
+ err:
+	json_object_put(jregion);
+	return NULL;
+}
+
+struct json_object *util_daxctl_mapping_to_json(struct daxctl_mapping *mapping,
+		unsigned long flags)
+{
+	struct json_object *jmapping = json_object_new_object();
+	struct json_object *jobj;
+
+	if (!jmapping)
+		return NULL;
+
+	jobj = util_json_object_hex(daxctl_mapping_get_offset(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "page_offset", jobj);
+
+	jobj = util_json_object_hex(daxctl_mapping_get_start(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "start", jobj);
+
+	jobj = util_json_object_hex(daxctl_mapping_get_end(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "end", jobj);
+
+	jobj = util_json_object_size(daxctl_mapping_get_size(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "size", jobj);
+
+	return jmapping;
+ err:
+	json_object_put(jmapping);
+	return NULL;
+}
diff --git a/daxctl/json.h b/daxctl/json.h
new file mode 100644
index 000000000000..fc82f06bd594
--- /dev/null
+++ b/daxctl/json.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
+#ifndef __DAXCTL_JSON_H__
+#define __DAXCTL_JSON_H__
+#include <daxctl/libdaxctl.h>
+
+struct json_object *util_daxctl_mapping_to_json(struct daxctl_mapping *mapping,
+		unsigned long flags);
+struct daxctl_region;
+struct daxctl_dev;
+struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
+		const char *ident, unsigned long flags);
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
+		unsigned long flags);
+struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
+		struct json_object *jdevs, const char *ident,
+		unsigned long flags);
+#endif /*  __CXL_UTIL_JSON_H__ */
diff --git a/daxctl/list.c b/daxctl/list.c
index cf93c2f7e8ed..aeff1967116b 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -6,12 +6,14 @@
 #include <unistd.h>
 #include <limits.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <daxctl/libdaxctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 
+#include "filter.h"
+#include "json.h"
+
 static struct {
 	bool devs;
 	bool regions;
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 93b682e8b202..5d5b1cacda9d 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -19,13 +19,19 @@ ndctl_SOURCES = ndctl.c \
 		region.c \
 		dimm.c \
 		../util/log.c \
-		../util/filter.c \
-		../util/filter.h \
+		../daxctl/filter.c \
+		../daxctl/filter.h \
+		filter.c \
+		filter.h \
 		list.c \
 		../util/json.c \
 		../util/json.h \
-		util/json-smart.c \
-		util/keys.h \
+		../daxctl/json.c \
+		../daxctl/json.h \
+		json.c \
+		json.h \
+		json-smart.c \
+		keys.h \
 		inject-error.c \
 		inject-smart.c \
 		monitor.c \
@@ -36,7 +42,7 @@ ndctl_SOURCES = ndctl.c \
 		firmware-update.h
 
 if ENABLE_KEYUTILS
-ndctl_SOURCES += util/keys.c \
+ndctl_SOURCES += keys.c \
 		load-keys.c
 keys_configdir = $(ndctl_keysdir)
 keys_config_DATA = $(ndctl_keysreadme)
diff --git a/ndctl/bus.c b/ndctl/bus.c
index 9bc1797e50eb..4fbb6bb505d1 100644
--- a/ndctl/bus.c
+++ b/ndctl/bus.c
@@ -8,12 +8,14 @@
 #include <syslog.h>
 #include <builtin.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 
+#include "filter.h"
+#include "json.h"
+
 static struct {
 	bool verbose;
 	bool force;
diff --git a/ndctl/check.c b/ndctl/check.c
index b4e20657e1dd..523923745a33 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -8,7 +8,6 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <ndctl.h>
 #include <limits.h>
 #include <stdbool.h>
 #include <sys/mman.h>
@@ -20,6 +19,7 @@
 #include <util/util.h>
 #include <util/bitmap.h>
 #include <util/fletcher.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <ccan/endian/endian.h>
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 1d2d9a2b51d7..0f052644a46e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -11,7 +11,6 @@
 #include <util/size.h>
 #include <uuid/uuid.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <util/fletcher.h>
 #include <ndctl/libndctl.h>
@@ -20,7 +19,10 @@
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 #include <ndctl/firmware-update.h>
-#include <util/keys.h>
+
+#include "filter.h"
+#include "json.h"
+#include "keys.h"
 
 static const char *cmd_name = "dimm";
 static int err_count;
diff --git a/util/filter.c b/ndctl/filter.c
similarity index 88%
rename from util/filter.c
rename to ndctl/filter.c
index d81dadebd0d8..64d00ce87dd5 100644
--- a/util/filter.c
+++ b/ndctl/filter.c
@@ -9,10 +9,9 @@
 #include <util/util.h>
 #include <sys/types.h>
 #include <ndctl/ndctl.h>
-#include <util/filter.h>
 #include <ndctl/libndctl.h>
-#include <daxctl/libdaxctl.h>
-#include <cxl/libcxl.h>
+
+#include "filter.h"
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *__ident)
 {
@@ -304,61 +303,6 @@ struct ndctl_region *util_region_filter_by_namespace(struct ndctl_region *region
 	return NULL;
 }
 
-struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
-		const char *ident)
-{
-	struct daxctl_region *region = daxctl_dev_get_region(dev);
-	int region_id, dev_id;
-
-	if (!ident || strcmp(ident, "all") == 0)
-		return dev;
-
-	if (strcmp(ident, daxctl_dev_get_devname(dev)) == 0)
-		return dev;
-
-	if (sscanf(ident, "%d.%d", &region_id, &dev_id) == 2
-			&& daxctl_region_get_id(region) == region_id
-			&& daxctl_dev_get_id(dev) == dev_id)
-		return dev;
-
-	return NULL;
-}
-
-struct daxctl_region *util_daxctl_region_filter(struct daxctl_region *region,
-		const char *ident)
-{
-	int region_id;
-
-	if (!ident || strcmp(ident, "all") == 0)
-		return region;
-
-	if ((sscanf(ident, "%d", &region_id) == 1
-			|| sscanf(ident, "region%d", &region_id) == 1)
-			&& daxctl_region_get_id(region) == region_id)
-		return region;
-
-	return NULL;
-}
-
-struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
-					  const char *ident)
-{
-	int memdev_id;
-
-	if (!ident || strcmp(ident, "all") == 0)
-		return memdev;
-
-	if (strcmp(ident, cxl_memdev_get_devname(memdev)) == 0)
-		return memdev;
-
-	if ((sscanf(ident, "%d", &memdev_id) == 1
-			|| sscanf(ident, "mem%d", &memdev_id) == 1)
-			&& cxl_memdev_get_id(memdev) == memdev_id)
-		return memdev;
-
-	return NULL;
-}
-
 enum ndctl_namespace_mode util_nsmode(const char *mode)
 {
 	if (!mode)
diff --git a/util/filter.h b/ndctl/filter.h
similarity index 89%
rename from util/filter.h
rename to ndctl/filter.h
index 9a80d65e8b23..9800cc230865 100644
--- a/util/filter.h
+++ b/ndctl/filter.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
-#ifndef _UTIL_FILTER_H_
-#define _UTIL_FILTER_H_
+#ifndef _NDCTL_UTIL_FILTER_H_
+#define _NDCTL_UTIL_FILTER_H_
 #include <stdbool.h>
 #include <ccan/list/list.h>
 
@@ -25,12 +25,6 @@ struct ndctl_dimm *util_dimm_filter_by_namespace(struct ndctl_dimm *dimm,
 		const char *ident);
 struct ndctl_region *util_region_filter_by_namespace(struct ndctl_region *region,
 		const char *ident);
-struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
-		const char *ident);
-struct daxctl_region *util_daxctl_region_filter(struct daxctl_region *region,
-		const char *ident);
-struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
-		const char *ident);
 
 enum ndctl_namespace_mode util_nsmode(const char *mode);
 const char *util_nsmode_name(enum ndctl_namespace_mode mode);
@@ -89,4 +83,4 @@ struct util_filter_params {
 struct ndctl_ctx;
 int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 		struct util_filter_params *param);
-#endif
+#endif /* _NDCTL_UTIL_FILTER_H_ */
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 05c1a22fc36c..f595cec0033d 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -12,12 +12,11 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 
-#include <ndctl.h>
 #include <util/log.h>
 #include <util/size.h>
 #include <util/json.h>
 #include <json-c/json.h>
-#include <util/filter.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
@@ -26,6 +25,9 @@
 #include <builtin.h>
 #include <test.h>
 
+#include "filter.h"
+#include "json.h"
+
 static bool verbose;
 static struct parameters {
 	const char *bus;
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 9077bca256e4..2b9d7e85241c 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -13,12 +13,11 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 
-#include <ndctl.h>
 #include <util/log.h>
 #include <util/size.h>
 #include <util/json.h>
 #include <json-c/json.h>
-#include <util/filter.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
@@ -27,6 +26,9 @@
 #include <builtin.h>
 #include <test.h>
 
+#include "filter.h"
+#include "json.h"
+
 static struct parameters {
 	const char *bus;
 	const char *dimm;
diff --git a/ndctl/util/json-smart.c b/ndctl/json-smart.c
similarity index 99%
rename from ndctl/util/json-smart.c
rename to ndctl/json-smart.c
index e598e04420cd..400f60b0a710 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/json-smart.c
@@ -1,12 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
 #include <limits.h>
-#include <util/json.h>
 #include <uuid/uuid.h>
 #include <json-c/json.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
-#include <ndctl.h>
+
+#include "json.h"
 
 static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 		struct json_object *jhealth)
diff --git a/ndctl/json.c b/ndctl/json.c
new file mode 100644
index 000000000000..c62e6cae01a9
--- /dev/null
+++ b/ndctl/json.c
@@ -0,0 +1,1114 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <limits.h>
+#include <string.h>
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <json-c/printbuf.h>
+
+#include "json.h"
+#include "ndctl.h"
+#include "../daxctl/json.h"
+
+struct json_object *util_bus_to_json(struct ndctl_bus *bus, unsigned long flags)
+{
+	struct json_object *jbus = json_object_new_object();
+	struct json_object *jobj, *fw_obj = NULL;
+	int scrub;
+
+	if (!jbus)
+		return NULL;
+
+	jobj = json_object_new_string(ndctl_bus_get_provider(bus));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jbus, "provider", jobj);
+
+	jobj = json_object_new_string(ndctl_bus_get_devname(bus));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jbus, "dev", jobj);
+
+	scrub = ndctl_bus_get_scrub_state(bus);
+	if (scrub < 0)
+		return jbus;
+
+	jobj = json_object_new_string(scrub ? "active" : "idle");
+	if (!jobj)
+		goto err;
+	json_object_object_add(jbus, "scrub_state", jobj);
+
+	if (flags & UTIL_JSON_FIRMWARE) {
+		struct ndctl_dimm *dimm;
+
+		/*
+		 * Skip displaying firmware activation capability if no
+		 * DIMMs support firmware update.
+		 */
+		ndctl_dimm_foreach(bus, dimm)
+			if (ndctl_dimm_fw_update_supported(dimm) == 0) {
+				fw_obj = json_object_new_object();
+				break;
+			}
+	}
+
+	if (fw_obj) {
+		enum ndctl_fwa_state state;
+		enum ndctl_fwa_method method;
+
+		jobj = NULL;
+		method = ndctl_bus_get_fw_activate_method(bus);
+		if (method == NDCTL_FWA_METHOD_RESET)
+			jobj = json_object_new_string("reset");
+		if (method == NDCTL_FWA_METHOD_SUSPEND)
+			jobj = json_object_new_string("suspend");
+		if (method == NDCTL_FWA_METHOD_LIVE)
+			jobj = json_object_new_string("live");
+		if (jobj)
+			json_object_object_add(fw_obj, "activate_method", jobj);
+
+		jobj = NULL;
+		state = ndctl_bus_get_fw_activate_state(bus);
+		if (state == NDCTL_FWA_ARMED)
+			jobj = json_object_new_string("armed");
+		if (state == NDCTL_FWA_IDLE)
+			jobj = json_object_new_string("idle");
+		if (state == NDCTL_FWA_ARM_OVERFLOW)
+			jobj = json_object_new_string("overflow");
+		if (jobj)
+			json_object_object_add(fw_obj, "activate_state", jobj);
+
+		json_object_object_add(jbus, "firmware", fw_obj);
+	}
+
+	return jbus;
+ err:
+	json_object_put(jbus);
+	return NULL;
+}
+
+
+
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags)
+{
+	struct json_object *jfirmware = json_object_new_object();
+	bool can_update, need_powercycle;
+	enum ndctl_fwa_result result;
+	enum ndctl_fwa_state state;
+	struct json_object *jobj;
+	struct ndctl_cmd *cmd;
+	uint64_t run, next;
+	int rc;
+
+	if (!jfirmware)
+		return NULL;
+
+	cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
+	if (!cmd)
+		goto err;
+
+	rc = ndctl_cmd_submit(cmd);
+	if ((rc < 0) || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
+		jobj = util_json_object_hex(-1, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "current_version",
+					jobj);
+		goto out;
+	}
+
+	run = ndctl_cmd_fw_info_get_run_version(cmd);
+	if (run == ULLONG_MAX) {
+		jobj = util_json_object_hex(-1, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "current_version",
+					jobj);
+		goto out;
+	}
+
+	jobj = util_json_object_hex(run, flags);
+	if (jobj)
+		json_object_object_add(jfirmware, "current_version", jobj);
+
+	rc = ndctl_dimm_fw_update_supported(dimm);
+	can_update = rc == 0;
+	jobj = json_object_new_boolean(can_update);
+	if (jobj)
+		json_object_object_add(jfirmware, "can_update", jobj);
+
+
+	next = ndctl_cmd_fw_info_get_updated_version(cmd);
+	if (next == ULLONG_MAX) {
+		jobj = util_json_object_hex(-1, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "next_version",
+					jobj);
+		goto out;
+	}
+
+	if (!next)
+		goto out;
+
+	jobj = util_json_object_hex(next, flags);
+	if (jobj)
+		json_object_object_add(jfirmware,
+				"next_version", jobj);
+
+	state = ndctl_dimm_get_fw_activate_state(dimm);
+	switch (state) {
+	case NDCTL_FWA_IDLE:
+		jobj = json_object_new_string("idle");
+		break;
+	case NDCTL_FWA_ARMED:
+		jobj = json_object_new_string("armed");
+		break;
+	case NDCTL_FWA_BUSY:
+		jobj = json_object_new_string("busy");
+		break;
+	default:
+		jobj = NULL;
+		break;
+	}
+	if (jobj)
+		json_object_object_add(jfirmware, "activate_state", jobj);
+
+	result = ndctl_dimm_get_fw_activate_result(dimm);
+	switch (result) {
+	case NDCTL_FWA_RESULT_NONE:
+	case NDCTL_FWA_RESULT_SUCCESS:
+	case NDCTL_FWA_RESULT_NOTSTAGED:
+		/*
+		 * If a 'next' firmware version is staged then this
+		 * result is stale, if the activation succeeds that is
+		 * indicated by not finding a 'next' entry.
+		 */
+		need_powercycle = false;
+		break;
+	case NDCTL_FWA_RESULT_NEEDRESET:
+	case NDCTL_FWA_RESULT_FAIL:
+	default:
+		/*
+		 * If the last activation failed, or if the activation
+		 * result is unavailable it is always the case that the
+		 * only remediation is powercycle.
+		 */
+		need_powercycle = true;
+		break;
+	}
+
+	if (need_powercycle) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto out;
+		json_object_object_add(jfirmware, "need_powercycle", jobj);
+	}
+
+	ndctl_cmd_unref(cmd);
+	return jfirmware;
+
+err:
+	json_object_put(jfirmware);
+	jfirmware = NULL;
+out:
+	if (cmd)
+		ndctl_cmd_unref(cmd);
+	return jfirmware;
+}
+
+
+
+struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags)
+{
+	struct json_object *jdimm = json_object_new_object();
+	const char *id = ndctl_dimm_get_unique_id(dimm);
+	unsigned int handle = ndctl_dimm_get_handle(dimm);
+	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
+	struct json_object *jobj;
+	enum ndctl_security_state sstate;
+
+	if (!jdimm)
+		return NULL;
+
+	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jdimm, "dev", jobj);
+
+	if (id) {
+		jobj = json_object_new_string(id);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "id", jobj);
+	}
+
+	if (handle < UINT_MAX) {
+		jobj = util_json_object_hex(handle, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "handle", jobj);
+	}
+
+	if (phys_id < USHRT_MAX) {
+		jobj = util_json_object_hex(phys_id, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "phys_id", jobj);
+	}
+
+	if (!ndctl_dimm_is_enabled(dimm)) {
+		jobj = json_object_new_string("disabled");
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "state", jobj);
+	}
+
+	if (ndctl_dimm_failed_map(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_failed_map", jobj);
+	}
+
+	if (ndctl_dimm_failed_save(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_failed_save", jobj);
+	}
+
+	if (ndctl_dimm_failed_arm(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_failed_arm", jobj);
+	}
+
+	if (ndctl_dimm_failed_restore(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_failed_restore", jobj);
+	}
+
+	if (ndctl_dimm_failed_flush(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_failed_flush", jobj);
+	}
+
+	if (ndctl_dimm_smart_pending(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "flag_smart_event", jobj);
+	}
+
+	sstate = ndctl_dimm_get_security(dimm);
+	if (sstate == NDCTL_SECURITY_DISABLED)
+		jobj = json_object_new_string("disabled");
+	else if (sstate == NDCTL_SECURITY_UNLOCKED)
+		jobj = json_object_new_string("unlocked");
+	else if (sstate == NDCTL_SECURITY_LOCKED)
+		jobj = json_object_new_string("locked");
+	else if (sstate == NDCTL_SECURITY_FROZEN)
+		jobj = json_object_new_string("frozen");
+	else if (sstate == NDCTL_SECURITY_OVERWRITE)
+		jobj = json_object_new_string("overwrite");
+	else
+		jobj = NULL;
+	if (jobj)
+		json_object_object_add(jdimm, "security", jobj);
+
+	if (ndctl_dimm_security_is_frozen(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jdimm, "security_frozen", jobj);
+	}
+
+	if (flags & UTIL_JSON_FIRMWARE) {
+		struct json_object *jfirmware;
+
+		jfirmware = util_dimm_firmware_to_json(dimm, flags);
+		if (jfirmware)
+			json_object_object_add(jdimm, "firmware", jfirmware);
+	}
+
+	return jdimm;
+ err:
+	json_object_put(jdimm);
+	return NULL;
+}
+
+#define _SZ(get_max, get_elem, type) \
+static struct json_object *util_##type##_build_size_array(struct ndctl_##type *arg)	\
+{								\
+	struct json_object *arr = json_object_new_array();	\
+	int i;							\
+								\
+	if (!arr)						\
+		return NULL;					\
+								\
+	for (i = 0; i < get_max(arg); i++) {			\
+		struct json_object *jobj;			\
+		int64_t align;					\
+								\
+		align = get_elem(arg, i);			\
+		jobj = json_object_new_int64(align);		\
+		if (!jobj)					\
+			goto err;				\
+		json_object_array_add(arr, jobj);		\
+	}							\
+								\
+	return arr;						\
+err:								\
+	json_object_put(arr);					\
+	return NULL;						\
+}
+#define SZ(type, kind) _SZ(ndctl_##type##_get_num_##kind##s, \
+			   ndctl_##type##_get_supported_##kind, type)
+SZ(pfn, alignment)
+SZ(dax, alignment)
+SZ(btt, sector_size)
+
+struct json_object *util_region_capabilities_to_json(struct ndctl_region *region)
+{
+	struct json_object *jcaps, *jcap, *jobj;
+	struct ndctl_btt *btt = ndctl_region_get_btt_seed(region);
+	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
+	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
+
+	if (!btt || !pfn || !dax)
+		return NULL;
+
+	jcaps = json_object_new_array();
+	if (!jcaps)
+		return NULL;
+
+	if (btt) {
+		jcap = json_object_new_object();
+		if (!jcap)
+			goto err;
+		json_object_array_add(jcaps, jcap);
+
+		jobj = json_object_new_string("sector");
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "mode", jobj);
+		jobj = util_btt_build_size_array(btt);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "sector_sizes", jobj);
+	}
+
+	if (pfn) {
+		jcap = json_object_new_object();
+		if (!jcap)
+			goto err;
+		json_object_array_add(jcaps, jcap);
+
+		jobj = json_object_new_string("fsdax");
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "mode", jobj);
+		jobj = util_pfn_build_size_array(pfn);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "alignments", jobj);
+	}
+
+	if (dax) {
+		jcap = json_object_new_object();
+		if (!jcap)
+			goto err;
+		json_object_array_add(jcaps, jcap);
+
+		jobj = json_object_new_string("devdax");
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "mode", jobj);
+		jobj = util_dax_build_size_array(dax);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jcap, "alignments", jobj);
+	}
+
+	return jcaps;
+err:
+	json_object_put(jcaps);
+	return NULL;
+}
+
+
+static int compare_dimm_number(const void *p1, const void *p2)
+{
+	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
+	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
+	const char *dimm1_name = ndctl_dimm_get_devname(dimm1);
+	const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
+	int num1, num2;
+
+	if (sscanf(dimm1_name, "nmem%d", &num1) != 1)
+		num1 = 0;
+	if (sscanf(dimm2_name, "nmem%d", &num2) != 1)
+		num2 = 0;
+
+	return num1 - num2;
+}
+
+static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
+		unsigned long long addr, unsigned long len)
+{
+	struct ndctl_bus *bus = ndctl_region_get_bus(region);
+	int count = ndctl_region_get_interleave_ways(region);
+	unsigned long long end = addr + len;
+	struct json_object *jdimms, *jobj;
+	struct ndctl_dimm **dimms, *dimm;
+	int found, i;
+
+	jdimms = json_object_new_array();
+	if (!jdimms)
+		return NULL;
+
+	dimms = calloc(count, sizeof(struct ndctl_dimm *));
+	if (!dimms)
+		goto err_dimms;
+
+	for (found = 0; found < count && addr < end; addr += 512) {
+		dimm = ndctl_bus_get_dimm_by_physical_address(bus, addr);
+		if (!dimm)
+			continue;
+
+		for (i = 0; i < count; i++)
+			if (dimms[i] == dimm)
+				break;
+		if (i >= count)
+			dimms[found++] = dimm;
+	}
+
+	if (!found)
+		goto err_found;
+
+	qsort(dimms, found, sizeof(dimm), compare_dimm_number);
+
+	for (i = 0; i < found; i++) {
+		const char *devname = ndctl_dimm_get_devname(dimms[i]);
+
+		jobj = json_object_new_string(devname);
+		if (!jobj)
+			break;
+		json_object_array_add(jdimms, jobj);
+	}
+
+	if (!i)
+		goto err_found;
+	free(dimms);
+	return jdimms;
+
+err_found:
+	free(dimms);
+err_dimms:
+	json_object_put(jdimms);
+	return NULL;
+}
+
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
+		unsigned int *bb_count, unsigned long flags)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	struct badblock *bb;
+	int bbs = 0;
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	}
+
+	ndctl_region_badblock_foreach(region, bb) {
+		struct json_object *jdimms;
+		unsigned long long addr;
+
+		bbs += bb->len;
+
+		/* recheck so we can still get the badblocks_count from above */
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
+
+		/* get start address of region */
+		addr = ndctl_region_get_resource(region);
+		if (addr == ULLONG_MAX)
+			goto err_array;
+
+		/* get address of bad block */
+		addr += bb->offset << 9;
+
+		jbb = json_object_new_object();
+		if (!jbb)
+			goto err_array;
+
+		jobj = json_object_new_int64(bb->offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "offset", jobj);
+
+		jobj = json_object_new_int(bb->len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "length", jobj);
+
+		jdimms = badblocks_to_jdimms(region, addr, bb->len << 9);
+		if (jdimms)
+			json_object_object_add(jbb, "dimms", jdimms);
+		json_object_array_add(jbbs, jbb);
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
+static struct json_object *util_namespace_badblocks_to_json(
+			struct ndctl_namespace *ndns,
+			unsigned int *bb_count, unsigned long flags)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	struct badblock *bb;
+	int bbs = 0;
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	} else
+		return NULL;
+
+	ndctl_namespace_badblock_foreach(ndns, bb) {
+		bbs += bb->len;
+
+		/* recheck so we can still get the badblocks_count from above */
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
+
+		jbb = json_object_new_object();
+		if (!jbb)
+			goto err_array;
+
+		jobj = json_object_new_int64(bb->offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "offset", jobj);
+
+		jobj = json_object_new_int(bb->len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "length", jobj);
+		json_object_array_add(jbbs, jbb);
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
+static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
+		unsigned long long dev_begin, unsigned long long dev_size,
+		unsigned int *bb_count, unsigned long flags)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	unsigned long long region_begin, dev_end, offset;
+	unsigned int len, bbs = 0;
+	struct badblock *bb;
+
+	region_begin = ndctl_region_get_resource(region);
+	if (region_begin == ULLONG_MAX)
+		return NULL;
+
+	dev_end = dev_begin + dev_size - 1;
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	}
+
+	ndctl_region_badblock_foreach(region, bb) {
+		unsigned long long bb_begin, bb_end, begin, end;
+		struct json_object *jdimms;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_end = bb_begin + (bb->len << 9) - 1;
+
+		if (bb_end <= dev_begin || bb_begin >= dev_end)
+			continue;
+
+		if (bb_begin < dev_begin)
+			begin = dev_begin;
+		else
+			begin = bb_begin;
+
+		if (bb_end > dev_end)
+			end = dev_end;
+		else
+			end = bb_end;
+
+		offset = (begin - dev_begin) >> 9;
+		len = (end - begin + 1) >> 9;
+
+		bbs += len;
+
+		/* recheck so we can still get the badblocks_count from above */
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
+
+		jbb = json_object_new_object();
+		if (!jbb)
+			goto err_array;
+
+		jobj = json_object_new_int64(offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "offset", jobj);
+
+		jobj = json_object_new_int(len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "length", jobj);
+
+		jdimms = badblocks_to_jdimms(region, begin, len << 9);
+		if (jdimms)
+			json_object_object_add(jbb, "dimms", jdimms);
+
+		json_object_array_add(jbbs, jbb);
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
+static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
+		unsigned int *bb_count, unsigned long flags)
+{
+	struct ndctl_region *region = ndctl_pfn_get_region(pfn);
+	unsigned long long pfn_begin, pfn_size;
+
+	pfn_begin = ndctl_pfn_get_resource(pfn);
+	if (pfn_begin == ULLONG_MAX) {
+		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
+
+		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
+	}
+
+	pfn_size = ndctl_pfn_get_size(pfn);
+	if (pfn_size == ULLONG_MAX)
+		return NULL;
+
+	return dev_badblocks_to_json(region, pfn_begin, pfn_size,
+			bb_count, flags);
+}
+
+static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
+		unsigned int *bb_count)
+{
+	struct ndctl_region *region = ndctl_btt_get_region(btt);
+	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
+	unsigned long long begin, size;
+
+	if (!ndns)
+		return;
+
+	begin = ndctl_namespace_get_resource(ndns);
+	if (begin == ULLONG_MAX)
+		return;
+
+	size = ndctl_namespace_get_size(ndns);
+	if (size == ULLONG_MAX)
+		return;
+
+	/*
+	 * The dev_badblocks_to_json() for BTT is not accurate with
+	 * respect to data vs metadata badblocks, and is only useful for
+	 * a potential bb_count.
+	 *
+	 * FIXME: switch to native BTT badblocks representation
+	 * when / if the kernel provides it.
+	 */
+	dev_badblocks_to_json(region, begin, size, bb_count, 0);
+}
+static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
+		unsigned int *bb_count, unsigned long flags)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	unsigned long long dax_begin, dax_size;
+
+	dax_begin = ndctl_dax_get_resource(dax);
+	if (dax_begin == ULLONG_MAX)
+		return NULL;
+
+	dax_size = ndctl_dax_get_size(dax);
+	if (dax_size == ULLONG_MAX)
+		return NULL;
+
+	return dev_badblocks_to_json(region, dax_begin, dax_size,
+			bb_count, flags);
+}
+
+static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
+{
+	char buf[40];
+	uuid_t raw_uuid;
+
+	ndctl_namespace_get_uuid(ndns, raw_uuid);
+	if (uuid_is_null(raw_uuid))
+		return NULL;
+	uuid_unparse(raw_uuid, buf);
+	return json_object_new_string(buf);
+}
+
+static void util_raw_uuid_to_json(struct ndctl_namespace *ndns,
+				  unsigned long flags,
+				  struct json_object *jndns)
+{
+	struct json_object *jobj;
+
+	if (!(flags & UTIL_JSON_VERBOSE))
+		return;
+
+	jobj = util_raw_uuid(ndns);
+	if (!jobj)
+		return;
+	json_object_object_add(jndns, "raw_uuid", jobj);
+}
+
+struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
+		unsigned long flags)
+{
+	struct json_object *jndns = json_object_new_object();
+	enum ndctl_pfn_loc loc = NDCTL_PFN_LOC_NONE;
+	struct json_object *jobj, *jbbs = NULL;
+	const char *locations[] = {
+		[NDCTL_PFN_LOC_NONE] = "none",
+		[NDCTL_PFN_LOC_RAM] = "mem",
+		[NDCTL_PFN_LOC_PMEM] = "dev",
+	};
+	unsigned long long size = ULLONG_MAX;
+	unsigned int sector_size = UINT_MAX;
+	enum ndctl_namespace_mode mode;
+	const char *bdev = NULL, *name;
+	unsigned int bb_count = 0;
+	struct ndctl_btt *btt;
+	struct ndctl_pfn *pfn;
+	struct ndctl_dax *dax;
+	unsigned long align = 0;
+	char buf[40];
+	uuid_t uuid;
+	int numa, target;
+
+	if (!jndns)
+		return NULL;
+
+	jobj = json_object_new_string(ndctl_namespace_get_devname(ndns));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jndns, "dev", jobj);
+
+	btt = ndctl_namespace_get_btt(ndns);
+	dax = ndctl_namespace_get_dax(ndns);
+	pfn = ndctl_namespace_get_pfn(ndns);
+	mode = ndctl_namespace_get_mode(ndns);
+	switch (mode) {
+	case NDCTL_NS_MODE_MEMORY:
+		if (pfn) { /* dynamic memory mode */
+			size = ndctl_pfn_get_size(pfn);
+			loc = ndctl_pfn_get_location(pfn);
+		} else { /* native/static memory mode */
+			size = ndctl_namespace_get_size(ndns);
+			loc = NDCTL_PFN_LOC_RAM;
+		}
+		jobj = json_object_new_string("fsdax");
+		break;
+	case NDCTL_NS_MODE_DAX:
+		if (!dax)
+			goto err;
+		size = ndctl_dax_get_size(dax);
+		jobj = json_object_new_string("devdax");
+		loc = ndctl_dax_get_location(dax);
+		break;
+	case NDCTL_NS_MODE_SECTOR:
+		if (!btt)
+			goto err;
+		jobj = json_object_new_string("sector");
+		size = ndctl_btt_get_size(btt);
+		break;
+	case NDCTL_NS_MODE_RAW:
+		size = ndctl_namespace_get_size(ndns);
+		jobj = json_object_new_string("raw");
+		break;
+	default:
+		jobj = NULL;
+	}
+	if (jobj)
+		json_object_object_add(jndns, "mode", jobj);
+
+	if ((mode != NDCTL_NS_MODE_SECTOR) && (mode != NDCTL_NS_MODE_RAW)) {
+		jobj = json_object_new_string(locations[loc]);
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
+	}
+
+	if (size < ULLONG_MAX) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jndns, "size", jobj);
+	}
+
+	if (btt) {
+		ndctl_btt_get_uuid(btt, uuid);
+		uuid_unparse(uuid, buf);
+		jobj = json_object_new_string(buf);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
+		bdev = ndctl_btt_get_block_device(btt);
+	} else if (pfn) {
+		align = ndctl_pfn_get_align(pfn);
+		ndctl_pfn_get_uuid(pfn, uuid);
+		uuid_unparse(uuid, buf);
+		jobj = json_object_new_string(buf);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
+		bdev = ndctl_pfn_get_block_device(pfn);
+	} else if (dax) {
+		struct daxctl_region *dax_region;
+
+		dax_region = ndctl_dax_get_daxctl_region(dax);
+		align = ndctl_dax_get_align(dax);
+		ndctl_dax_get_uuid(dax, uuid);
+		uuid_unparse(uuid, buf);
+		jobj = json_object_new_string(buf);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
+		if ((flags & UTIL_JSON_DAX) && dax_region) {
+			jobj = util_daxctl_region_to_json(dax_region, NULL,
+					flags);
+			if (jobj)
+				json_object_object_add(jndns, "daxregion", jobj);
+		} else if (dax_region) {
+			struct daxctl_dev *dev;
+
+			/*
+			 * We can only find/list these device-dax
+			 * details when the instance is enabled.
+			 */
+			dev = daxctl_dev_get_first(dax_region);
+			if (dev) {
+				name = daxctl_dev_get_devname(dev);
+				jobj = json_object_new_string(name);
+				if (!jobj)
+					goto err;
+				json_object_object_add(jndns, "chardev", jobj);
+			}
+		}
+	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
+		ndctl_namespace_get_uuid(ndns, uuid);
+		uuid_unparse(uuid, buf);
+		jobj = json_object_new_string(buf);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "uuid", jobj);
+		bdev = ndctl_namespace_get_block_device(ndns);
+	} else
+		bdev = ndctl_namespace_get_block_device(ndns);
+
+	if (btt)
+		sector_size = ndctl_btt_get_sector_size(btt);
+	else if (!dax) {
+		sector_size = ndctl_namespace_get_sector_size(ndns);
+		if (!sector_size || sector_size == UINT_MAX)
+			sector_size = 512;
+	}
+
+	/*
+	 * The kernel will default to a 512 byte sector size on PMEM
+	 * namespaces that don't explicitly have a sector size. This
+	 * happens because they use pre-v1.2 labels or because they
+	 * don't have a label space (devtype=nd_namespace_io).
+	 */
+	if (sector_size < UINT_MAX) {
+		jobj = json_object_new_int(sector_size);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "sector_size", jobj);
+	}
+
+	if (align) {
+		jobj = json_object_new_int64(align);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "align", jobj);
+	}
+
+	if (bdev && bdev[0]) {
+		jobj = json_object_new_string(bdev);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "blockdev", jobj);
+	}
+
+	if (!ndctl_namespace_is_active(ndns)) {
+		jobj = json_object_new_string("disabled");
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "state", jobj);
+	}
+
+	name = ndctl_namespace_get_alt_name(ndns);
+	if (name && name[0]) {
+		jobj = json_object_new_string(name);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "name", jobj);
+	}
+
+	numa = ndctl_namespace_get_numa_node(ndns);
+	if (numa >= 0 && flags & UTIL_JSON_VERBOSE) {
+		jobj = json_object_new_int(numa);
+		if (jobj)
+			json_object_object_add(jndns, "numa_node", jobj);
+	}
+
+	target = ndctl_namespace_get_target_node(ndns);
+	if (target >= 0 && flags & UTIL_JSON_VERBOSE) {
+		jobj = json_object_new_int(target);
+		if (jobj)
+			json_object_object_add(jndns, "target_node", jobj);
+	}
+
+	if (pfn)
+		jbbs = util_pfn_badblocks_to_json(pfn, &bb_count, flags);
+	else if (dax)
+		jbbs = util_dax_badblocks_to_json(dax, &bb_count, flags);
+	else if (btt)
+		util_btt_badblocks_to_json(btt, &bb_count);
+	else {
+		jbbs = util_region_badblocks_to_json(
+				ndctl_namespace_get_region(ndns), &bb_count,
+				flags);
+		if (!jbbs)
+			jbbs = util_namespace_badblocks_to_json(ndns, &bb_count,
+					flags);
+	}
+
+	if (bb_count) {
+		jobj = json_object_new_int(bb_count);
+		if (!jobj) {
+			json_object_put(jbbs);
+			goto err;
+		}
+		json_object_object_add(jndns, "badblock_count", jobj);
+	}
+
+	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
+		json_object_object_add(jndns, "badblocks", jbbs);
+
+	return jndns;
+ err:
+	json_object_put(jndns);
+	return NULL;
+}
+
+
+struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
+		unsigned long flags)
+{
+	struct json_object *jmapping = json_object_new_object();
+	struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
+	struct json_object *jobj;
+	int position;
+
+	if (!jmapping)
+		return NULL;
+
+	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "dimm", jobj);
+
+	jobj = util_json_object_hex(ndctl_mapping_get_offset(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "offset", jobj);
+
+	jobj = util_json_object_hex(ndctl_mapping_get_length(mapping), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jmapping, "length", jobj);
+
+	position = ndctl_mapping_get_position(mapping);
+	if (position >= 0) {
+		jobj = json_object_new_int(position);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jmapping, "position", jobj);
+	}
+
+	return jmapping;
+ err:
+	json_object_put(jmapping);
+	return NULL;
+}
+
+struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
+		unsigned long flags)
+{
+	struct json_object *jerr = json_object_new_object();
+	struct json_object *jobj;
+
+	if (!jerr)
+		return NULL;
+
+	jobj = util_json_object_hex(block, flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jerr, "block", jobj);
+
+	jobj = util_json_object_hex(count, flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jerr, "count", jobj);
+
+	return jerr;
+ err:
+	json_object_put(jerr);
+	return NULL;
+}
diff --git a/ndctl/json.h b/ndctl/json.h
new file mode 100644
index 000000000000..f544b659ca1d
--- /dev/null
+++ b/ndctl/json.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
+#ifndef __NDCTL_UTIL_JSON_H__
+#define __NDCTL_UTIL_JSON_H__
+#include <ndctl/libndctl.h>
+#include <ccan/short_types/short_types.h>
+
+struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
+		unsigned long flags);
+struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
+		unsigned long flags);
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
+		unsigned int *bb_count, unsigned long flags);
+struct json_object *util_bus_to_json(struct ndctl_bus *bus,
+		unsigned long flags);
+struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags);
+struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
+		unsigned long flags);
+struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags);
+struct json_object *util_region_capabilities_to_json(struct ndctl_region *region);
+#endif /* __NDCTL_UTIL_JSON_H__ */
diff --git a/ndctl/util/keys.c b/ndctl/keys.c
similarity index 99%
rename from ndctl/util/keys.c
rename to ndctl/keys.c
index 30cb4c884b98..876b34714b7e 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/keys.c
@@ -13,10 +13,11 @@
 #include <keyutils.h>
 #include <syslog.h>
 
-#include <ndctl.h>
 #include <ndctl/config.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
-#include <util/keys.h>
+
+#include "keys.h"
 
 static int get_key_path(struct ndctl_dimm *dimm, char *path,
 		enum ndctl_key_type key_type)
diff --git a/ndctl/util/keys.h b/ndctl/keys.h
similarity index 100%
rename from ndctl/util/keys.h
rename to ndctl/keys.h
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index b4939138ed47..47a234ccc8ce 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -20,10 +20,10 @@
 #include <ccan/array_size/array_size.h>
 #include <ccan/build_assert/build_assert.h>
 
-#include <ndctl.h>
 #include <util/util.h>
 #include <util/size.h>
 #include <util/sysfs.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 9c6f2f045fc2..43b8412b2073 100644
--- a/ndctl/lib/papr.c
+++ b/ndctl/lib/papr.c
@@ -10,9 +10,9 @@
 #include <stdlib.h>
 #include <limits.h>
 #include <util/log.h>
-#include <ndctl.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
-#include <lib/private.h>
+#include "private.h"
 #include "papr.h"
 
 /* Utility logging maros for simplify logging */
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index d442e6c16e9a..4d8622978790 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -14,8 +14,9 @@
 #include <ccan/list/list.h>
 #include <ccan/array_size/array_size.h>
 
-#include <ndctl.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
+#include <ndctl/libndctl-nfit.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
 #include "intel.h"
@@ -23,7 +24,6 @@
 #include "msft.h"
 #include "hyperv.h"
 #include "papr.h"
-#include "libndctl-nfit.h"
 
 struct nvdimm_data {
 	struct ndctl_cmd *cmd_read;
diff --git a/ndctl/list.c b/ndctl/list.c
index 0017f159c708..869edde4fc65 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -7,13 +7,14 @@
 #include <limits.h>
 
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 
-#include <ndctl.h>
+#include "ndctl.h"
+#include "filter.h"
+#include "json.h"
 
 static struct {
 	bool buses;
diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
index 26648fe90fe6..d60e7eeb985d 100644
--- a/ndctl/load-keys.c
+++ b/ndctl/load-keys.c
@@ -12,13 +12,14 @@
 #include <fcntl.h>
 #include <keyutils.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
-#include <util/keys.h>
-#include <ndctl.h>
+
+#include "filter.h"
+#include "keys.h"
 
 static struct parameters {
 	const char *key_path;
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 0e9b65cb2bc4..8b600a4e762b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -7,7 +7,6 @@
 #include <time.h>
 #include <dirent.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <util/util.h>
 #include <util/parse-options.h>
 #include <util/parse-configs.h>
@@ -27,6 +26,9 @@
 #endif
 #include <util/log.h>
 
+#include "filter.h"
+#include "json.h"
+
 static struct monitor {
 	const char *log;
 	const char *configs;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index c67c0861afac..257b58ce5917 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -9,7 +9,6 @@
 #include <limits.h>
 #include <syslog.h>
 
-#include <ndctl.h>
 #include "action.h"
 #include "namespace.h"
 #include <sys/stat.h>
@@ -20,11 +19,14 @@
 #include <util/size.h>
 #include <util/json.h>
 #include <json-c/json.h>
-#include <util/filter.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 
+#include "filter.h"
+#include "json.h"
+
 static bool verbose;
 static bool force;
 static bool repair;
diff --git a/ndctl/region.c b/ndctl/region.c
index 4552c4a33478..e49954660ebb 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -5,10 +5,11 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include "action.h"
-#include <util/filter.h>
 #include <util/parse-options.h>
 #include <ndctl/libndctl.h>
 
+#include "filter.h"
+
 static struct {
 	const char *bus;
 	const char *type;
diff --git a/test/Makefile.am b/test/Makefile.am
index a5a54df4f260..a2a4ee4a4335 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -80,12 +80,19 @@ testcore =\
 libndctl_SOURCES = libndctl.c $(testcore)
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
+namespace_core =\
+	../ndctl/namespace.c \
+	../ndctl/filter.c \
+	../ndctl/check.c \
+	../util/json.c \
+	../ndctl/json.c \
+	../daxctl/filter.c \
+	../daxctl/json.c
+
 dsm_fail_SOURCES =\
 	dsm-fail.c \
 	$(testcore) \
-	../ndctl/namespace.c \
-	../ndctl/check.c \
-	../util/json.c
+	$(namespace_core)
 
 dsm_fail_LDADD = $(LIBNDCTL_LIB) \
 		$(KMOD_LIBS) \
@@ -122,9 +129,7 @@ device_dax_SOURCES = \
 		dax-dev.c \
 		dax-pmd.c \
 		$(testcore) \
-		../ndctl/namespace.c \
-		../ndctl/check.c \
-		../util/json.c
+		$(namespace_core)
 
 if ENABLE_POISON
 dax_pmd_SOURCES += dax-poison.c
@@ -153,7 +158,10 @@ smart_listen_LDADD = $(LIBNDCTL_LIB)
 
 list_smart_dimm_SOURCES = \
 		list-smart-dimm.c \
-		../util/json.c
+		../ndctl/filter.c \
+		../util/json.c \
+		../ndctl/json.c
+
 list_smart_dimm_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index c561ff3416ea..a9e95c63b76c 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -15,7 +15,7 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#include <ndctl.h>
+#include <ndctl/ndctl.h>
 #include <test.h>
 
 static int test_dimm(struct ndctl_dimm *dimm)
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index fbbea21448d8..706670767b1a 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -23,7 +23,7 @@
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#include <ndctl.h>
+#include <ndctl/ndctl.h>
 
 #define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
 
diff --git a/test/device-dax.c b/test/device-dax.c
index aad8fa5f1cb1..49c9bc8b1748 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -20,7 +20,7 @@
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 
-#include <builtin.h>
+#include <ndctl/builtin.h>
 #include <test.h>
 
 static sigjmp_buf sj_env;
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 0a6383d49910..5b443dcd703d 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -14,8 +14,8 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#include <builtin.h>
-#include <ndctl.h>
+#include <ndctl/builtin.h>
+#include <ndctl/ndctl.h>
 #include <test.h>
 
 #define DIMM_PATH "/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm0"
diff --git a/test/libndctl.c b/test/libndctl.c
index 0bee06b93787..75c15303fad4 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -21,7 +21,7 @@
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
-#include <ndctl.h>
+#include <ndctl/ndctl.h>
 #include <test.h>
 
 #define BLKROGET _IO(0x12,94) /* get read-only status (0 = read_write) */
diff --git a/test/list-smart-dimm.c b/test/list-smart-dimm.c
index 00c24e11bf24..47b711e63670 100644
--- a/test/list-smart-dimm.c
+++ b/test/list-smart-dimm.c
@@ -3,11 +3,13 @@
 #include <stdio.h>
 #include <errno.h>
 #include <util/json.h>
-#include <util/filter.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
-#include <ndctl.h>
+
+#include <ndctl/filter.h>
+#include <ndctl/ndctl.h>
+#include <ndctl/json.h>
 
 struct util_filter_params param;
 static int did_fail;
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index a4db1ae3ecae..4bafff5164c8 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -3,6 +3,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/fs.h>
+#include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -18,7 +19,6 @@
 #include <test.h>
 
 #include <ccan/array_size/array_size.h>
-#include <ndctl.h>
 
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
diff --git a/test/revoke-devmem.c b/test/revoke-devmem.c
index bb8979e9a3d4..59d1a72df6ad 100644
--- a/test/revoke-devmem.c
+++ b/test/revoke-devmem.c
@@ -19,7 +19,7 @@
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
-#include <builtin.h>
+#include <ndctl/builtin.h>
 #include <test.h>
 
 static sigjmp_buf sj_env;
diff --git a/util/help.c b/util/help.c
index 6eebfe5143e1..da8408328771 100644
--- a/util/help.c
+++ b/util/help.c
@@ -14,7 +14,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
-#include <builtin.h>
+#include <ndctl/builtin.h>
 #include <util/strbuf.h>
 #include <util/parse-options.h>
 
diff --git a/util/json.c b/util/json.c
index f97cf070b840..9f0a8e137caa 100644
--- a/util/json.c
+++ b/util/json.c
@@ -2,17 +2,10 @@
 // Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
 #include <limits.h>
 #include <string.h>
+#include <stdio.h>
 #include <util/json.h>
-#include <util/filter.h>
-#include <uuid/uuid.h>
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
-#include <ndctl/libndctl.h>
-#include <daxctl/libdaxctl.h>
-#include <cxl/libcxl.h>
-#include <ccan/array_size/array_size.h>
-#include <ccan/short_types/short_types.h>
-#include <ndctl.h>
 
 /* adapted from mdadm::human_size_brief() */
 static int display_size(struct json_object *jobj, struct printbuf *pbuf,
@@ -112,1536 +105,3 @@ void util_display_json_array(FILE *f_out, struct json_object *jarray,
 	}
 	json_object_put(jarray);
 }
-
-struct json_object *util_bus_to_json(struct ndctl_bus *bus, unsigned long flags)
-{
-	struct json_object *jbus = json_object_new_object();
-	struct json_object *jobj, *fw_obj = NULL;
-	int scrub;
-
-	if (!jbus)
-		return NULL;
-
-	jobj = json_object_new_string(ndctl_bus_get_provider(bus));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jbus, "provider", jobj);
-
-	jobj = json_object_new_string(ndctl_bus_get_devname(bus));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jbus, "dev", jobj);
-
-	scrub = ndctl_bus_get_scrub_state(bus);
-	if (scrub < 0)
-		return jbus;
-
-	jobj = json_object_new_string(scrub ? "active" : "idle");
-	if (!jobj)
-		goto err;
-	json_object_object_add(jbus, "scrub_state", jobj);
-
-	if (flags & UTIL_JSON_FIRMWARE) {
-		struct ndctl_dimm *dimm;
-
-		/*
-		 * Skip displaying firmware activation capability if no
-		 * DIMMs support firmware update.
-		 */
-		ndctl_dimm_foreach(bus, dimm)
-			if (ndctl_dimm_fw_update_supported(dimm) == 0) {
-				fw_obj = json_object_new_object();
-				break;
-			}
-	}
-
-	if (fw_obj) {
-		enum ndctl_fwa_state state;
-		enum ndctl_fwa_method method;
-
-		jobj = NULL;
-		method = ndctl_bus_get_fw_activate_method(bus);
-		if (method == NDCTL_FWA_METHOD_RESET)
-			jobj = json_object_new_string("reset");
-		if (method == NDCTL_FWA_METHOD_SUSPEND)
-			jobj = json_object_new_string("suspend");
-		if (method == NDCTL_FWA_METHOD_LIVE)
-			jobj = json_object_new_string("live");
-		if (jobj)
-			json_object_object_add(fw_obj, "activate_method", jobj);
-
-		jobj = NULL;
-		state = ndctl_bus_get_fw_activate_state(bus);
-		if (state == NDCTL_FWA_ARMED)
-			jobj = json_object_new_string("armed");
-		if (state == NDCTL_FWA_IDLE)
-			jobj = json_object_new_string("idle");
-		if (state == NDCTL_FWA_ARM_OVERFLOW)
-			jobj = json_object_new_string("overflow");
-		if (jobj)
-			json_object_object_add(fw_obj, "activate_state", jobj);
-
-		json_object_object_add(jbus, "firmware", fw_obj);
-	}
-
-	return jbus;
- err:
-	json_object_put(jbus);
-	return NULL;
-}
-
-struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
-		unsigned long flags)
-{
-	struct json_object *jfirmware = json_object_new_object();
-	bool can_update, need_powercycle;
-	enum ndctl_fwa_result result;
-	enum ndctl_fwa_state state;
-	struct json_object *jobj;
-	struct ndctl_cmd *cmd;
-	uint64_t run, next;
-	int rc;
-
-	if (!jfirmware)
-		return NULL;
-
-	cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
-	if (!cmd)
-		goto err;
-
-	rc = ndctl_cmd_submit(cmd);
-	if ((rc < 0) || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
-		jobj = util_json_object_hex(-1, flags);
-		if (jobj)
-			json_object_object_add(jfirmware, "current_version",
-					jobj);
-		goto out;
-	}
-
-	run = ndctl_cmd_fw_info_get_run_version(cmd);
-	if (run == ULLONG_MAX) {
-		jobj = util_json_object_hex(-1, flags);
-		if (jobj)
-			json_object_object_add(jfirmware, "current_version",
-					jobj);
-		goto out;
-	}
-
-	jobj = util_json_object_hex(run, flags);
-	if (jobj)
-		json_object_object_add(jfirmware, "current_version", jobj);
-
-	rc = ndctl_dimm_fw_update_supported(dimm);
-	can_update = rc == 0;
-	jobj = json_object_new_boolean(can_update);
-	if (jobj)
-		json_object_object_add(jfirmware, "can_update", jobj);
-
-
-	next = ndctl_cmd_fw_info_get_updated_version(cmd);
-	if (next == ULLONG_MAX) {
-		jobj = util_json_object_hex(-1, flags);
-		if (jobj)
-			json_object_object_add(jfirmware, "next_version",
-					jobj);
-		goto out;
-	}
-
-	if (!next)
-		goto out;
-
-	jobj = util_json_object_hex(next, flags);
-	if (jobj)
-		json_object_object_add(jfirmware,
-				"next_version", jobj);
-
-	state = ndctl_dimm_get_fw_activate_state(dimm);
-	switch (state) {
-	case NDCTL_FWA_IDLE:
-		jobj = json_object_new_string("idle");
-		break;
-	case NDCTL_FWA_ARMED:
-		jobj = json_object_new_string("armed");
-		break;
-	case NDCTL_FWA_BUSY:
-		jobj = json_object_new_string("busy");
-		break;
-	default:
-		jobj = NULL;
-		break;
-	}
-	if (jobj)
-		json_object_object_add(jfirmware, "activate_state", jobj);
-
-	result = ndctl_dimm_get_fw_activate_result(dimm);
-	switch (result) {
-	case NDCTL_FWA_RESULT_NONE:
-	case NDCTL_FWA_RESULT_SUCCESS:
-	case NDCTL_FWA_RESULT_NOTSTAGED:
-		/*
-		 * If a 'next' firmware version is staged then this
-		 * result is stale, if the activation succeeds that is
-		 * indicated by not finding a 'next' entry.
-		 */
-		need_powercycle = false;
-		break;
-	case NDCTL_FWA_RESULT_NEEDRESET:
-	case NDCTL_FWA_RESULT_FAIL:
-	default:
-		/*
-		 * If the last activation failed, or if the activation
-		 * result is unavailable it is always the case that the
-		 * only remediation is powercycle.
-		 */
-		need_powercycle = true;
-		break;
-	}
-
-	if (need_powercycle) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto out;
-		json_object_object_add(jfirmware, "need_powercycle", jobj);
-	}
-
-	ndctl_cmd_unref(cmd);
-	return jfirmware;
-
-err:
-	json_object_put(jfirmware);
-	jfirmware = NULL;
-out:
-	if (cmd)
-		ndctl_cmd_unref(cmd);
-	return jfirmware;
-}
-
-struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
-		unsigned long flags)
-{
-	struct json_object *jdimm = json_object_new_object();
-	const char *id = ndctl_dimm_get_unique_id(dimm);
-	unsigned int handle = ndctl_dimm_get_handle(dimm);
-	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
-	struct json_object *jobj;
-	enum ndctl_security_state sstate;
-
-	if (!jdimm)
-		return NULL;
-
-	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jdimm, "dev", jobj);
-
-	if (id) {
-		jobj = json_object_new_string(id);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "id", jobj);
-	}
-
-	if (handle < UINT_MAX) {
-		jobj = util_json_object_hex(handle, flags);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "handle", jobj);
-	}
-
-	if (phys_id < USHRT_MAX) {
-		jobj = util_json_object_hex(phys_id, flags);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "phys_id", jobj);
-	}
-
-	if (!ndctl_dimm_is_enabled(dimm)) {
-		jobj = json_object_new_string("disabled");
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "state", jobj);
-	}
-
-	if (ndctl_dimm_failed_map(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_failed_map", jobj);
-	}
-
-	if (ndctl_dimm_failed_save(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_failed_save", jobj);
-	}
-
-	if (ndctl_dimm_failed_arm(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_failed_arm", jobj);
-	}
-
-	if (ndctl_dimm_failed_restore(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_failed_restore", jobj);
-	}
-
-	if (ndctl_dimm_failed_flush(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_failed_flush", jobj);
-	}
-
-	if (ndctl_dimm_smart_pending(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jdimm, "flag_smart_event", jobj);
-	}
-
-	sstate = ndctl_dimm_get_security(dimm);
-	if (sstate == NDCTL_SECURITY_DISABLED)
-		jobj = json_object_new_string("disabled");
-	else if (sstate == NDCTL_SECURITY_UNLOCKED)
-		jobj = json_object_new_string("unlocked");
-	else if (sstate == NDCTL_SECURITY_LOCKED)
-		jobj = json_object_new_string("locked");
-	else if (sstate == NDCTL_SECURITY_FROZEN)
-		jobj = json_object_new_string("frozen");
-	else if (sstate == NDCTL_SECURITY_OVERWRITE)
-		jobj = json_object_new_string("overwrite");
-	else
-		jobj = NULL;
-	if (jobj)
-		json_object_object_add(jdimm, "security", jobj);
-
-	if (ndctl_dimm_security_is_frozen(dimm)) {
-		jobj = json_object_new_boolean(true);
-		if (jobj)
-			json_object_object_add(jdimm, "security_frozen", jobj);
-	}
-
-	if (flags & UTIL_JSON_FIRMWARE) {
-		struct json_object *jfirmware;
-
-		jfirmware = util_dimm_firmware_to_json(dimm, flags);
-		if (jfirmware)
-			json_object_object_add(jdimm, "firmware", jfirmware);
-	}
-
-	return jdimm;
- err:
-	json_object_put(jdimm);
-	return NULL;
-}
-
-struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
-		unsigned long flags)
-{
-	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
-	const char *devname = daxctl_dev_get_devname(dev);
-	struct json_object *jdev, *jobj, *jmappings = NULL;
-	struct daxctl_mapping *mapping = NULL;
-	int node, movable, align;
-
-	jdev = json_object_new_object();
-	if (!devname || !jdev)
-		return NULL;
-
-	jobj = json_object_new_string(devname);
-	if (jobj)
-		json_object_object_add(jdev, "chardev", jobj);
-
-	jobj = util_json_object_size(daxctl_dev_get_size(dev), flags);
-	if (jobj)
-		json_object_object_add(jdev, "size", jobj);
-
-	node = daxctl_dev_get_target_node(dev);
-	if (node >= 0) {
-		jobj = json_object_new_int(node);
-		if (jobj)
-			json_object_object_add(jdev, "target_node", jobj);
-	}
-
-	align = daxctl_dev_get_align(dev);
-	if (align > 0) {
-		jobj = util_json_object_size(daxctl_dev_get_align(dev), flags);
-		if (jobj)
-			json_object_object_add(jdev, "align", jobj);
-	}
-
-	if (mem)
-		jobj = json_object_new_string("system-ram");
-	else
-		jobj = json_object_new_string("devdax");
-	if (jobj)
-		json_object_object_add(jdev, "mode", jobj);
-
-	if (mem && daxctl_dev_get_resource(dev) != 0) {
-		int num_sections = daxctl_memory_num_sections(mem);
-		int num_online = daxctl_memory_is_online(mem);
-
-		jobj = json_object_new_int(num_online);
-		if (jobj)
-			json_object_object_add(jdev, "online_memblocks", jobj);
-
-		jobj = json_object_new_int(num_sections);
-		if (jobj)
-			json_object_object_add(jdev, "total_memblocks", jobj);
-
-		movable = daxctl_memory_is_movable(mem);
-		if (movable == 1)
-			jobj = json_object_new_boolean(true);
-		else if (movable == 0)
-			jobj = json_object_new_boolean(false);
-		else
-			jobj = NULL;
-		if (jobj)
-			json_object_object_add(jdev, "movable", jobj);
-	}
-
-	if (!daxctl_dev_is_enabled(dev)) {
-		jobj = json_object_new_string("disabled");
-		if (jobj)
-			json_object_object_add(jdev, "state", jobj);
-	}
-
-	if (!(flags & UTIL_JSON_DAX_MAPPINGS))
-		return jdev;
-
-	daxctl_mapping_foreach(dev, mapping) {
-		struct json_object *jmapping;
-
-		if (!jmappings) {
-			jmappings = json_object_new_array();
-			if (!jmappings)
-				continue;
-
-			json_object_object_add(jdev, "mappings", jmappings);
-		}
-
-		jmapping = util_daxctl_mapping_to_json(mapping, flags);
-		if (!jmapping)
-			continue;
-		json_object_array_add(jmappings, jmapping);
-	}
-	return jdev;
-}
-
-struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
-		struct json_object *jdevs, const char *ident,
-		unsigned long flags)
-{
-	struct daxctl_dev *dev;
-
-	daxctl_dev_foreach(region, dev) {
-		struct json_object *jdev;
-
-		if (!util_daxctl_dev_filter(dev, ident))
-			continue;
-
-		if (!(flags & (UTIL_JSON_IDLE|UTIL_JSON_CONFIGURED))
-				&& !daxctl_dev_get_size(dev))
-			continue;
-
-		if (!jdevs) {
-			jdevs = json_object_new_array();
-			if (!jdevs)
-				return NULL;
-		}
-
-		jdev = util_daxctl_dev_to_json(dev, flags);
-		if (!jdev) {
-			json_object_put(jdevs);
-			return NULL;
-		}
-
-		json_object_array_add(jdevs, jdev);
-	}
-
-	return jdevs;
-}
-
-#define _SZ(get_max, get_elem, type) \
-static struct json_object *util_##type##_build_size_array(struct ndctl_##type *arg)	\
-{								\
-	struct json_object *arr = json_object_new_array();	\
-	int i;							\
-								\
-	if (!arr)						\
-		return NULL;					\
-								\
-	for (i = 0; i < get_max(arg); i++) {			\
-		struct json_object *jobj;			\
-		int64_t align;					\
-								\
-		align = get_elem(arg, i);			\
-		jobj = json_object_new_int64(align);		\
-		if (!jobj)					\
-			goto err;				\
-		json_object_array_add(arr, jobj);		\
-	}							\
-								\
-	return arr;						\
-err:								\
-	json_object_put(arr);					\
-	return NULL;						\
-}
-#define SZ(type, kind) _SZ(ndctl_##type##_get_num_##kind##s, \
-			   ndctl_##type##_get_supported_##kind, type)
-SZ(pfn, alignment)
-SZ(dax, alignment)
-SZ(btt, sector_size)
-
-struct json_object *util_region_capabilities_to_json(struct ndctl_region *region)
-{
-	struct json_object *jcaps, *jcap, *jobj;
-	struct ndctl_btt *btt = ndctl_region_get_btt_seed(region);
-	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
-	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
-
-	if (!btt || !pfn || !dax)
-		return NULL;
-
-	jcaps = json_object_new_array();
-	if (!jcaps)
-		return NULL;
-
-	if (btt) {
-		jcap = json_object_new_object();
-		if (!jcap)
-			goto err;
-		json_object_array_add(jcaps, jcap);
-
-		jobj = json_object_new_string("sector");
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "mode", jobj);
-		jobj = util_btt_build_size_array(btt);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "sector_sizes", jobj);
-	}
-
-	if (pfn) {
-		jcap = json_object_new_object();
-		if (!jcap)
-			goto err;
-		json_object_array_add(jcaps, jcap);
-
-		jobj = json_object_new_string("fsdax");
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "mode", jobj);
-		jobj = util_pfn_build_size_array(pfn);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "alignments", jobj);
-	}
-
-	if (dax) {
-		jcap = json_object_new_object();
-		if (!jcap)
-			goto err;
-		json_object_array_add(jcaps, jcap);
-
-		jobj = json_object_new_string("devdax");
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "mode", jobj);
-		jobj = util_dax_build_size_array(dax);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jcap, "alignments", jobj);
-	}
-
-	return jcaps;
-err:
-	json_object_put(jcaps);
-	return NULL;
-}
-
-struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
-		const char *ident, unsigned long flags)
-{
-	unsigned long align;
-	struct json_object *jregion, *jobj;
-	unsigned long long available_size, size;
-
-	jregion = json_object_new_object();
-	if (!jregion)
-		return NULL;
-
-	/*
-	 * The flag indicates when we are being called by an agent that
-	 * already knows about the parent device information.
-	 */
-	if (!(flags & UTIL_JSON_DAX)) {
-		/* trim off the redundant /sys/devices prefix */
-		const char *path = daxctl_region_get_path(region);
-		int len = strlen("/sys/devices");
-		const char *trim = &path[len];
-
-		if (strncmp(path, "/sys/devices", len) != 0)
-			goto err;
-		jobj = json_object_new_string(trim);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jregion, "path", jobj);
-	}
-
-	jobj = json_object_new_int(daxctl_region_get_id(region));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jregion, "id", jobj);
-
-	size = daxctl_region_get_size(region);
-	if (size < ULLONG_MAX) {
-		jobj = util_json_object_size(size, flags);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jregion, "size", jobj);
-	}
-
-	available_size = daxctl_region_get_available_size(region);
-	if (available_size) {
-		jobj = util_json_object_size(available_size, flags);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jregion, "available_size", jobj);
-	}
-
-	align = daxctl_region_get_align(region);
-	if (align < ULONG_MAX) {
-		jobj = json_object_new_int64(align);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jregion, "align", jobj);
-	}
-
-	if (!(flags & UTIL_JSON_DAX_DEVS))
-		return jregion;
-
-	jobj = util_daxctl_devs_to_list(region, NULL, ident, flags);
-	if (jobj)
-		json_object_object_add(jregion, "devices", jobj);
-
-	return jregion;
- err:
-	json_object_put(jregion);
-	return NULL;
-}
-
-static int compare_dimm_number(const void *p1, const void *p2)
-{
-	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
-	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
-	const char *dimm1_name = ndctl_dimm_get_devname(dimm1);
-	const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
-	int num1, num2;
-
-	if (sscanf(dimm1_name, "nmem%d", &num1) != 1)
-		num1 = 0;
-	if (sscanf(dimm2_name, "nmem%d", &num2) != 1)
-		num2 = 0;
-
-	return num1 - num2;
-}
-
-static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
-		unsigned long long addr, unsigned long len)
-{
-	struct ndctl_bus *bus = ndctl_region_get_bus(region);
-	int count = ndctl_region_get_interleave_ways(region);
-	unsigned long long end = addr + len;
-	struct json_object *jdimms, *jobj;
-	struct ndctl_dimm **dimms, *dimm;
-	int found, i;
-
-	jdimms = json_object_new_array();
-	if (!jdimms)
-		return NULL;
-
-	dimms = calloc(count, sizeof(struct ndctl_dimm *));
-	if (!dimms)
-		goto err_dimms;
-
-	for (found = 0; found < count && addr < end; addr += 512) {
-		dimm = ndctl_bus_get_dimm_by_physical_address(bus, addr);
-		if (!dimm)
-			continue;
-
-		for (i = 0; i < count; i++)
-			if (dimms[i] == dimm)
-				break;
-		if (i >= count)
-			dimms[found++] = dimm;
-	}
-
-	if (!found)
-		goto err_found;
-
-	qsort(dimms, found, sizeof(dimm), compare_dimm_number);
-
-	for (i = 0; i < found; i++) {
-		const char *devname = ndctl_dimm_get_devname(dimms[i]);
-
-		jobj = json_object_new_string(devname);
-		if (!jobj)
-			break;
-		json_object_array_add(jdimms, jobj);
-	}
-
-	if (!i)
-		goto err_found;
-	free(dimms);
-	return jdimms;
-
-err_found:
-	free(dimms);
-err_dimms:
-	json_object_put(jdimms);
-	return NULL;
-}
-
-struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
-		unsigned int *bb_count, unsigned long flags)
-{
-	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
-	struct badblock *bb;
-	int bbs = 0;
-
-	if (flags & UTIL_JSON_MEDIA_ERRORS) {
-		jbbs = json_object_new_array();
-		if (!jbbs)
-			return NULL;
-	}
-
-	ndctl_region_badblock_foreach(region, bb) {
-		struct json_object *jdimms;
-		unsigned long long addr;
-
-		bbs += bb->len;
-
-		/* recheck so we can still get the badblocks_count from above */
-		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
-			continue;
-
-		/* get start address of region */
-		addr = ndctl_region_get_resource(region);
-		if (addr == ULLONG_MAX)
-			goto err_array;
-
-		/* get address of bad block */
-		addr += bb->offset << 9;
-
-		jbb = json_object_new_object();
-		if (!jbb)
-			goto err_array;
-
-		jobj = json_object_new_int64(bb->offset);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "offset", jobj);
-
-		jobj = json_object_new_int(bb->len);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "length", jobj);
-
-		jdimms = badblocks_to_jdimms(region, addr, bb->len << 9);
-		if (jdimms)
-			json_object_object_add(jbb, "dimms", jdimms);
-		json_object_array_add(jbbs, jbb);
-	}
-
-	*bb_count = bbs;
-
-	if (bbs)
-		return jbbs;
-
- err:
-	json_object_put(jbb);
- err_array:
-	json_object_put(jbbs);
-	return NULL;
-}
-
-static struct json_object *util_namespace_badblocks_to_json(
-			struct ndctl_namespace *ndns,
-			unsigned int *bb_count, unsigned long flags)
-{
-	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
-	struct badblock *bb;
-	int bbs = 0;
-
-	if (flags & UTIL_JSON_MEDIA_ERRORS) {
-		jbbs = json_object_new_array();
-		if (!jbbs)
-			return NULL;
-	} else
-		return NULL;
-
-	ndctl_namespace_badblock_foreach(ndns, bb) {
-		bbs += bb->len;
-
-		/* recheck so we can still get the badblocks_count from above */
-		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
-			continue;
-
-		jbb = json_object_new_object();
-		if (!jbb)
-			goto err_array;
-
-		jobj = json_object_new_int64(bb->offset);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "offset", jobj);
-
-		jobj = json_object_new_int(bb->len);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "length", jobj);
-		json_object_array_add(jbbs, jbb);
-	}
-
-	*bb_count = bbs;
-
-	if (bbs)
-		return jbbs;
-
- err:
-	json_object_put(jbb);
- err_array:
-	json_object_put(jbbs);
-	return NULL;
-}
-
-static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
-		unsigned long long dev_begin, unsigned long long dev_size,
-		unsigned int *bb_count, unsigned long flags)
-{
-	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
-	unsigned long long region_begin, dev_end, offset;
-	unsigned int len, bbs = 0;
-	struct badblock *bb;
-
-	region_begin = ndctl_region_get_resource(region);
-	if (region_begin == ULLONG_MAX)
-		return NULL;
-
-	dev_end = dev_begin + dev_size - 1;
-
-	if (flags & UTIL_JSON_MEDIA_ERRORS) {
-		jbbs = json_object_new_array();
-		if (!jbbs)
-			return NULL;
-	}
-
-	ndctl_region_badblock_foreach(region, bb) {
-		unsigned long long bb_begin, bb_end, begin, end;
-		struct json_object *jdimms;
-
-		bb_begin = region_begin + (bb->offset << 9);
-		bb_end = bb_begin + (bb->len << 9) - 1;
-
-		if (bb_end <= dev_begin || bb_begin >= dev_end)
-			continue;
-
-		if (bb_begin < dev_begin)
-			begin = dev_begin;
-		else
-			begin = bb_begin;
-
-		if (bb_end > dev_end)
-			end = dev_end;
-		else
-			end = bb_end;
-
-		offset = (begin - dev_begin) >> 9;
-		len = (end - begin + 1) >> 9;
-
-		bbs += len;
-
-		/* recheck so we can still get the badblocks_count from above */
-		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
-			continue;
-
-		jbb = json_object_new_object();
-		if (!jbb)
-			goto err_array;
-
-		jobj = json_object_new_int64(offset);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "offset", jobj);
-
-		jobj = json_object_new_int(len);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jbb, "length", jobj);
-
-		jdimms = badblocks_to_jdimms(region, begin, len << 9);
-		if (jdimms)
-			json_object_object_add(jbb, "dimms", jdimms);
-
-		json_object_array_add(jbbs, jbb);
-	}
-
-	*bb_count = bbs;
-
-	if (bbs)
-		return jbbs;
-
- err:
-	json_object_put(jbb);
- err_array:
-	json_object_put(jbbs);
-	return NULL;
-}
-
-static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
-		unsigned int *bb_count, unsigned long flags)
-{
-	struct ndctl_region *region = ndctl_pfn_get_region(pfn);
-	unsigned long long pfn_begin, pfn_size;
-
-	pfn_begin = ndctl_pfn_get_resource(pfn);
-	if (pfn_begin == ULLONG_MAX) {
-		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
-
-		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
-	}
-
-	pfn_size = ndctl_pfn_get_size(pfn);
-	if (pfn_size == ULLONG_MAX)
-		return NULL;
-
-	return dev_badblocks_to_json(region, pfn_begin, pfn_size,
-			bb_count, flags);
-}
-
-static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
-		unsigned int *bb_count)
-{
-	struct ndctl_region *region = ndctl_btt_get_region(btt);
-	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
-	unsigned long long begin, size;
-
-	if (!ndns)
-		return;
-
-	begin = ndctl_namespace_get_resource(ndns);
-	if (begin == ULLONG_MAX)
-		return;
-
-	size = ndctl_namespace_get_size(ndns);
-	if (size == ULLONG_MAX)
-		return;
-
-	/*
-	 * The dev_badblocks_to_json() for BTT is not accurate with
-	 * respect to data vs metadata badblocks, and is only useful for
-	 * a potential bb_count.
-	 *
-	 * FIXME: switch to native BTT badblocks representation
-	 * when / if the kernel provides it.
-	 */
-	dev_badblocks_to_json(region, begin, size, bb_count, 0);
-}
-
-static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
-		unsigned int *bb_count, unsigned long flags)
-{
-	struct ndctl_region *region = ndctl_dax_get_region(dax);
-	unsigned long long dax_begin, dax_size;
-
-	dax_begin = ndctl_dax_get_resource(dax);
-	if (dax_begin == ULLONG_MAX)
-		return NULL;
-
-	dax_size = ndctl_dax_get_size(dax);
-	if (dax_size == ULLONG_MAX)
-		return NULL;
-
-	return dev_badblocks_to_json(region, dax_begin, dax_size,
-			bb_count, flags);
-}
-
-static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
-{
-	char buf[40];
-	uuid_t raw_uuid;
-
-	ndctl_namespace_get_uuid(ndns, raw_uuid);
-	if (uuid_is_null(raw_uuid))
-		return NULL;
-	uuid_unparse(raw_uuid, buf);
-	return json_object_new_string(buf);
-}
-
-static void util_raw_uuid_to_json(struct ndctl_namespace *ndns,
-				  unsigned long flags,
-				  struct json_object *jndns)
-{
-	struct json_object *jobj;
-
-	if (!(flags & UTIL_JSON_VERBOSE))
-		return;
-
-	jobj = util_raw_uuid(ndns);
-	if (!jobj)
-		return;
-	json_object_object_add(jndns, "raw_uuid", jobj);
-}
-
-struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		unsigned long flags)
-{
-	struct json_object *jndns = json_object_new_object();
-	enum ndctl_pfn_loc loc = NDCTL_PFN_LOC_NONE;
-	struct json_object *jobj, *jbbs = NULL;
-	const char *locations[] = {
-		[NDCTL_PFN_LOC_NONE] = "none",
-		[NDCTL_PFN_LOC_RAM] = "mem",
-		[NDCTL_PFN_LOC_PMEM] = "dev",
-	};
-	unsigned long long size = ULLONG_MAX;
-	unsigned int sector_size = UINT_MAX;
-	enum ndctl_namespace_mode mode;
-	const char *bdev = NULL, *name;
-	unsigned int bb_count = 0;
-	struct ndctl_btt *btt;
-	struct ndctl_pfn *pfn;
-	struct ndctl_dax *dax;
-	unsigned long align = 0;
-	char buf[40];
-	uuid_t uuid;
-	int numa, target;
-
-	if (!jndns)
-		return NULL;
-
-	jobj = json_object_new_string(ndctl_namespace_get_devname(ndns));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jndns, "dev", jobj);
-
-	btt = ndctl_namespace_get_btt(ndns);
-	dax = ndctl_namespace_get_dax(ndns);
-	pfn = ndctl_namespace_get_pfn(ndns);
-	mode = ndctl_namespace_get_mode(ndns);
-	switch (mode) {
-	case NDCTL_NS_MODE_MEMORY:
-		if (pfn) { /* dynamic memory mode */
-			size = ndctl_pfn_get_size(pfn);
-			loc = ndctl_pfn_get_location(pfn);
-		} else { /* native/static memory mode */
-			size = ndctl_namespace_get_size(ndns);
-			loc = NDCTL_PFN_LOC_RAM;
-		}
-		jobj = json_object_new_string("fsdax");
-		break;
-	case NDCTL_NS_MODE_DAX:
-		if (!dax)
-			goto err;
-		size = ndctl_dax_get_size(dax);
-		jobj = json_object_new_string("devdax");
-		loc = ndctl_dax_get_location(dax);
-		break;
-	case NDCTL_NS_MODE_SECTOR:
-		if (!btt)
-			goto err;
-		jobj = json_object_new_string("sector");
-		size = ndctl_btt_get_size(btt);
-		break;
-	case NDCTL_NS_MODE_RAW:
-		size = ndctl_namespace_get_size(ndns);
-		jobj = json_object_new_string("raw");
-		break;
-	default:
-		jobj = NULL;
-	}
-	if (jobj)
-		json_object_object_add(jndns, "mode", jobj);
-
-	if ((mode != NDCTL_NS_MODE_SECTOR) && (mode != NDCTL_NS_MODE_RAW)) {
-		jobj = json_object_new_string(locations[loc]);
-		if (jobj)
-			json_object_object_add(jndns, "map", jobj);
-	}
-
-	if (size < ULLONG_MAX) {
-		jobj = util_json_object_size(size, flags);
-		if (jobj)
-			json_object_object_add(jndns, "size", jobj);
-	}
-
-	if (btt) {
-		ndctl_btt_get_uuid(btt, uuid);
-		uuid_unparse(uuid, buf);
-		jobj = json_object_new_string(buf);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "uuid", jobj);
-		util_raw_uuid_to_json(ndns, flags, jndns);
-		bdev = ndctl_btt_get_block_device(btt);
-	} else if (pfn) {
-		align = ndctl_pfn_get_align(pfn);
-		ndctl_pfn_get_uuid(pfn, uuid);
-		uuid_unparse(uuid, buf);
-		jobj = json_object_new_string(buf);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "uuid", jobj);
-		util_raw_uuid_to_json(ndns, flags, jndns);
-		bdev = ndctl_pfn_get_block_device(pfn);
-	} else if (dax) {
-		struct daxctl_region *dax_region;
-
-		dax_region = ndctl_dax_get_daxctl_region(dax);
-		align = ndctl_dax_get_align(dax);
-		ndctl_dax_get_uuid(dax, uuid);
-		uuid_unparse(uuid, buf);
-		jobj = json_object_new_string(buf);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "uuid", jobj);
-		util_raw_uuid_to_json(ndns, flags, jndns);
-		if ((flags & UTIL_JSON_DAX) && dax_region) {
-			jobj = util_daxctl_region_to_json(dax_region, NULL,
-					flags);
-			if (jobj)
-				json_object_object_add(jndns, "daxregion", jobj);
-		} else if (dax_region) {
-			struct daxctl_dev *dev;
-
-			/*
-			 * We can only find/list these device-dax
-			 * details when the instance is enabled.
-			 */
-			dev = daxctl_dev_get_first(dax_region);
-			if (dev) {
-				name = daxctl_dev_get_devname(dev);
-				jobj = json_object_new_string(name);
-				if (!jobj)
-					goto err;
-				json_object_object_add(jndns, "chardev", jobj);
-			}
-		}
-	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
-		ndctl_namespace_get_uuid(ndns, uuid);
-		uuid_unparse(uuid, buf);
-		jobj = json_object_new_string(buf);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "uuid", jobj);
-		bdev = ndctl_namespace_get_block_device(ndns);
-	} else
-		bdev = ndctl_namespace_get_block_device(ndns);
-
-	if (btt)
-		sector_size = ndctl_btt_get_sector_size(btt);
-	else if (!dax) {
-		sector_size = ndctl_namespace_get_sector_size(ndns);
-		if (!sector_size || sector_size == UINT_MAX)
-			sector_size = 512;
-	}
-
-	/*
-	 * The kernel will default to a 512 byte sector size on PMEM
-	 * namespaces that don't explicitly have a sector size. This
-	 * happens because they use pre-v1.2 labels or because they
-	 * don't have a label space (devtype=nd_namespace_io).
-	 */
-	if (sector_size < UINT_MAX) {
-		jobj = json_object_new_int(sector_size);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "sector_size", jobj);
-	}
-
-	if (align) {
-		jobj = json_object_new_int64(align);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "align", jobj);
-	}
-
-	if (bdev && bdev[0]) {
-		jobj = json_object_new_string(bdev);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "blockdev", jobj);
-	}
-
-	if (!ndctl_namespace_is_active(ndns)) {
-		jobj = json_object_new_string("disabled");
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "state", jobj);
-	}
-
-	name = ndctl_namespace_get_alt_name(ndns);
-	if (name && name[0]) {
-		jobj = json_object_new_string(name);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "name", jobj);
-	}
-
-	numa = ndctl_namespace_get_numa_node(ndns);
-	if (numa >= 0 && flags & UTIL_JSON_VERBOSE) {
-		jobj = json_object_new_int(numa);
-		if (jobj)
-			json_object_object_add(jndns, "numa_node", jobj);
-	}
-
-	target = ndctl_namespace_get_target_node(ndns);
-	if (target >= 0 && flags & UTIL_JSON_VERBOSE) {
-		jobj = json_object_new_int(target);
-		if (jobj)
-			json_object_object_add(jndns, "target_node", jobj);
-	}
-
-	if (pfn)
-		jbbs = util_pfn_badblocks_to_json(pfn, &bb_count, flags);
-	else if (dax)
-		jbbs = util_dax_badblocks_to_json(dax, &bb_count, flags);
-	else if (btt)
-		util_btt_badblocks_to_json(btt, &bb_count);
-	else {
-		jbbs = util_region_badblocks_to_json(
-				ndctl_namespace_get_region(ndns), &bb_count,
-				flags);
-		if (!jbbs)
-			jbbs = util_namespace_badblocks_to_json(ndns, &bb_count,
-					flags);
-	}
-
-	if (bb_count) {
-		jobj = json_object_new_int(bb_count);
-		if (!jobj) {
-			json_object_put(jbbs);
-			goto err;
-		}
-		json_object_object_add(jndns, "badblock_count", jobj);
-	}
-
-	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
-		json_object_object_add(jndns, "badblocks", jbbs);
-
-	return jndns;
- err:
-	json_object_put(jndns);
-	return NULL;
-}
-
-struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
-		unsigned long flags)
-{
-	struct json_object *jmapping = json_object_new_object();
-	struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
-	struct json_object *jobj;
-	int position;
-
-	if (!jmapping)
-		return NULL;
-
-	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "dimm", jobj);
-
-	jobj = util_json_object_hex(ndctl_mapping_get_offset(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "offset", jobj);
-
-	jobj = util_json_object_hex(ndctl_mapping_get_length(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "length", jobj);
-
-	position = ndctl_mapping_get_position(mapping);
-	if (position >= 0) {
-		jobj = json_object_new_int(position);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jmapping, "position", jobj);
-	}
-
-	return jmapping;
- err:
-	json_object_put(jmapping);
-	return NULL;
-}
-
-struct json_object *util_daxctl_mapping_to_json(struct daxctl_mapping *mapping,
-		unsigned long flags)
-{
-	struct json_object *jmapping = json_object_new_object();
-	struct json_object *jobj;
-
-	if (!jmapping)
-		return NULL;
-
-	jobj = util_json_object_hex(daxctl_mapping_get_offset(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "page_offset", jobj);
-
-	jobj = util_json_object_hex(daxctl_mapping_get_start(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "start", jobj);
-
-	jobj = util_json_object_hex(daxctl_mapping_get_end(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "end", jobj);
-
-	jobj = util_json_object_size(daxctl_mapping_get_size(mapping), flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jmapping, "size", jobj);
-
-	return jmapping;
- err:
-	json_object_put(jmapping);
-	return NULL;
-}
-
-struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
-		unsigned long flags)
-{
-	struct json_object *jerr = json_object_new_object();
-	struct json_object *jobj;
-
-	if (!jerr)
-		return NULL;
-
-	jobj = util_json_object_hex(block, flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jerr, "block", jobj);
-
-	jobj = util_json_object_hex(count, flags);
-	if (!jobj)
-		goto err;
-	json_object_object_add(jerr, "count", jobj);
-
-	return jerr;
- err:
-	json_object_put(jerr);
-	return NULL;
-}
-
-static struct json_object *util_cxl_memdev_health_to_json(
-		struct cxl_memdev *memdev, unsigned long flags)
-{
-	struct json_object *jhealth;
-	struct json_object *jobj;
-	struct cxl_cmd *cmd;
-	u32 field;
-	int rc;
-
-	jhealth = json_object_new_object();
-	if (!jhealth)
-		return NULL;
-	if (!memdev)
-		goto err_jobj;
-
-	cmd = cxl_cmd_new_get_health_info(memdev);
-	if (!cmd)
-		goto err_jobj;
-
-	rc = cxl_cmd_submit(cmd);
-	if (rc < 0)
-		goto err_cmd;
-	rc = cxl_cmd_get_mbox_status(cmd);
-	if (rc != 0)
-		goto err_cmd;
-
-	/* health_status fields */
-	rc = cxl_cmd_health_info_get_maintenance_needed(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "maintenance_needed", jobj);
-
-	rc = cxl_cmd_health_info_get_performance_degraded(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "performance_degraded", jobj);
-
-	rc = cxl_cmd_health_info_get_hw_replacement_needed(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "hw_replacement_needed", jobj);
-
-	/* media_status fields */
-	rc = cxl_cmd_health_info_get_media_normal(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_normal", jobj);
-
-	rc = cxl_cmd_health_info_get_media_not_ready(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_not_ready", jobj);
-
-	rc = cxl_cmd_health_info_get_media_persistence_lost(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_persistence_lost", jobj);
-
-	rc = cxl_cmd_health_info_get_media_data_lost(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_data_lost", jobj);
-
-	rc = cxl_cmd_health_info_get_media_powerloss_persistence_loss(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_powerloss_persistence_loss", jobj);
-
-	rc = cxl_cmd_health_info_get_media_shutdown_persistence_loss(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_shutdown_persistence_loss", jobj);
-
-	rc = cxl_cmd_health_info_get_media_persistence_loss_imminent(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_persistence_loss_imminent", jobj);
-
-	rc = cxl_cmd_health_info_get_media_powerloss_data_loss(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_powerloss_data_loss", jobj);
-
-	rc = cxl_cmd_health_info_get_media_shutdown_data_loss(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_shutdown_data_loss", jobj);
-
-	rc = cxl_cmd_health_info_get_media_data_loss_imminent(cmd);
-	jobj = json_object_new_boolean(rc);
-	if (jobj)
-		json_object_object_add(jhealth, "media_data_loss_imminent", jobj);
-
-	/* ext_status fields */
-	if (cxl_cmd_health_info_get_ext_life_used_normal(cmd))
-		jobj = json_object_new_string("normal");
-	else if (cxl_cmd_health_info_get_ext_life_used_warning(cmd))
-		jobj = json_object_new_string("warning");
-	else if (cxl_cmd_health_info_get_ext_life_used_critical(cmd))
-		jobj = json_object_new_string("critical");
-	else
-		jobj = json_object_new_string("unknown");
-	if (jobj)
-		json_object_object_add(jhealth, "ext_life_used", jobj);
-
-	if (cxl_cmd_health_info_get_ext_temperature_normal(cmd))
-		jobj = json_object_new_string("normal");
-	else if (cxl_cmd_health_info_get_ext_temperature_warning(cmd))
-		jobj = json_object_new_string("warning");
-	else if (cxl_cmd_health_info_get_ext_temperature_critical(cmd))
-		jobj = json_object_new_string("critical");
-	else
-		jobj = json_object_new_string("unknown");
-	if (jobj)
-		json_object_object_add(jhealth, "ext_temperature", jobj);
-
-	if (cxl_cmd_health_info_get_ext_corrected_volatile_normal(cmd))
-		jobj = json_object_new_string("normal");
-	else if (cxl_cmd_health_info_get_ext_corrected_volatile_warning(cmd))
-		jobj = json_object_new_string("warning");
-	else
-		jobj = json_object_new_string("unknown");
-	if (jobj)
-		json_object_object_add(jhealth, "ext_corrected_volatile", jobj);
-
-	if (cxl_cmd_health_info_get_ext_corrected_persistent_normal(cmd))
-		jobj = json_object_new_string("normal");
-	else if (cxl_cmd_health_info_get_ext_corrected_persistent_warning(cmd))
-		jobj = json_object_new_string("warning");
-	else
-		jobj = json_object_new_string("unknown");
-	if (jobj)
-		json_object_object_add(jhealth, "ext_corrected_persistent", jobj);
-
-	/* other fields */
-	field = cxl_cmd_health_info_get_life_used(cmd);
-	if (field != 0xff) {
-		jobj = json_object_new_int(field);
-		if (jobj)
-			json_object_object_add(jhealth, "life_used_percent", jobj);
-	}
-
-	field = cxl_cmd_health_info_get_temperature(cmd);
-	if (field != 0xffff) {
-		jobj = json_object_new_int(field);
-		if (jobj)
-			json_object_object_add(jhealth, "temperature", jobj);
-	}
-
-	field = cxl_cmd_health_info_get_dirty_shutdowns(cmd);
-	jobj = json_object_new_int64(field);
-	if (jobj)
-		json_object_object_add(jhealth, "dirty_shutdowns", jobj);
-
-	field = cxl_cmd_health_info_get_volatile_errors(cmd);
-	jobj = json_object_new_int64(field);
-	if (jobj)
-		json_object_object_add(jhealth, "volatile_errors", jobj);
-
-	field = cxl_cmd_health_info_get_pmem_errors(cmd);
-	jobj = json_object_new_int64(field);
-	if (jobj)
-		json_object_object_add(jhealth, "pmem_errors", jobj);
-
-	cxl_cmd_unref(cmd);
-	return jhealth;
-
-err_cmd:
-	cxl_cmd_unref(cmd);
-err_jobj:
-	json_object_put(jhealth);
-	return NULL;
-}
-
-struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
-		unsigned long flags)
-{
-	const char *devname = cxl_memdev_get_devname(memdev);
-	struct json_object *jdev, *jobj;
-
-	jdev = json_object_new_object();
-	if (!devname || !jdev)
-		return NULL;
-
-	jobj = json_object_new_string(devname);
-	if (jobj)
-		json_object_object_add(jdev, "memdev", jobj);
-
-	jobj = util_json_object_size(cxl_memdev_get_pmem_size(memdev), flags);
-	if (jobj)
-		json_object_object_add(jdev, "pmem_size", jobj);
-
-	jobj = util_json_object_size(cxl_memdev_get_ram_size(memdev), flags);
-	if (jobj)
-		json_object_object_add(jdev, "ram_size", jobj);
-
-	if (flags & UTIL_JSON_HEALTH) {
-		jobj = util_cxl_memdev_health_to_json(memdev, flags);
-		if (jobj)
-			json_object_object_add(jdev, "health", jobj);
-	}
-	return jdev;
-}
diff --git a/util/json.h b/util/json.h
index ce575e6358f3..4ca2c890fa5c 100644
--- a/util/json.h
+++ b/util/json.h
@@ -1,12 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
-#ifndef __NDCTL_JSON_H__
-#define __NDCTL_JSON_H__
+#ifndef __UTIL_JSON_H__
+#define __UTIL_JSON_H__
 #include <stdio.h>
 #include <stdbool.h>
-#include <ndctl/libndctl.h>
-#include <daxctl/libdaxctl.h>
-#include <ccan/short_types/short_types.h>
 
 enum util_json_flags {
 	UTIL_JSON_IDLE		= (1 << 0),
@@ -25,38 +22,8 @@ enum util_json_flags {
 struct json_object;
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
 		unsigned long flags);
-struct json_object *util_bus_to_json(struct ndctl_bus *bus,
-		unsigned long flags);
-struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
-		unsigned long flags);
-struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
-		unsigned long flags);
-struct json_object *util_daxctl_mapping_to_json(struct daxctl_mapping *mapping,
-		unsigned long flags);
-struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		unsigned long flags);
-struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
-		unsigned long flags);
-struct daxctl_region;
-struct daxctl_dev;
-struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
-		unsigned int *bb_count, unsigned long flags);
-struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
-		const char *ident, unsigned long flags);
-struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
-		unsigned long flags);
-struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
-		struct json_object *jdevs, const char *ident,
-		unsigned long flags);
 struct json_object *util_json_object_size(unsigned long long size,
 		unsigned long flags);
 struct json_object *util_json_object_hex(unsigned long long val,
 		unsigned long flags);
-struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
-struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
-		unsigned long flags);
-struct json_object *util_region_capabilities_to_json(struct ndctl_region *region);
-struct cxl_memdev;
-struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
-		unsigned long flags);
-#endif /* __NDCTL_JSON_H__ */
+#endif /* __UTIL_JSON_H__ */

