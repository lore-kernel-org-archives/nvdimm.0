Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640B678F2F
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 04:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758689588; cv=none; b=lKPBe9y+o1SyFCUOFuFIxHe+LoZ4m5+e4cldzwD1HhqmoSkl+flzu7IhTN/VhH9RvWHERSuUU8XpeGquuDDKUz+BAtUGfqUWTwYL0MrZ6jpb35L3EmUSto94fEpIKRtam2Nur94Zs1JYAKopjhbMSnt2gLakRkSD85T+Arbjc9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758689588; c=relaxed/simple;
	bh=1wWXwX8S7T/M+p6saY3MueVnFnwVP4okVzEUYMKsmr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oNigO9wR9jKUrmwSKXNJ2fw9n5Zq/SNkfwOjSiyIzQw/3tr255OAzfb7Uh+ZKeAg/roKb61JDhlk6Mui9wQzXWGn9yW85auIq4qjqZOGkMKWfa55Bit6dKYodH1Sfytn/Z83COBnQz65XxxGtCwpmXNfLx2ECiggTu+9rNOUAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lpRz7tQu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lpRz7tQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758689586; x=1790225586;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1wWXwX8S7T/M+p6saY3MueVnFnwVP4okVzEUYMKsmr4=;
  b=lpRz7tQuyXjHVfjkIaibwJjmsS+oDBg400kmDmvCcAWLyR97rIUTlDMi
   Om/nK+0OmsjCw6uQ5SBs/sCQpnskBsmCwMhR036AFnkxUvENis5joVcjK
   OnVUboy5p+V+UVyXEpKNobdgrqSdA483kmR8wJfUlmqwDaGkkLWwJbA4h
   /EctOkv/VMTFwGy+zZpxIDq9AT9OrMN4Np3IrLzdJZ9m3XqaYYzY346TI
   z6XlP4qcJD+EqVAdlxq+MhU7dbpZeHk4HEnjXrFlM6KvVuyC7/oEGZtBx
   isYxWOMeJu/9Cwksf6UT9/r6WahD4aIrh+7vHcL74e6CHa2u3V7dIao6Q
   Q==;
X-CSE-ConnectionGUID: dxSXJY2bRjC7S7RnT887yA==
X-CSE-MsgGUID: pqA2asxcTqKbsnUjQ/0TtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61149835"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="61149835"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 21:53:06 -0700
X-CSE-ConnectionGUID: SF+y975AQOu01um1tm6S8w==
X-CSE-MsgGUID: yOhIFC21STajTWxSx7WVzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="176518483"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 21:53:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Andreas Hasenack <andreas.hasenack@canonical.com>
Subject: [ndctl PATCH v2] cxl/list: remove libtracefs build dependency for --media-errors
Date: Tue, 23 Sep 2025 21:52:57 -0700
Message-ID: <20250924045302.90074-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the --media-errors option was added to cxl list it inadvertently
changed the optional libtracefs requirement into a mandatory one.
Ndctl versions 80,81,82 no longer build without libtracefs.

Remove that dependency.

When libtracefs is disabled the user will see a 'Notice' level
message, like this:
	$ cxl list -r region0 --media-errors --targets
	cxl list: cmd_list: --media-errors support disabled at build time

...followed by the region listing including the output for any other
valid command line options, like --targets in the example above.

When libtracefs is disabled the cxl-poison.sh unit test is omitted.

The man page gets a note:
	The media-error option is only available with -Dlibtracefs=enabled.

Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
Closes: https://github.com/pmem/ndctl/issues/289
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Notify and continue when --media-error info is unavailable (Dan)


 Documentation/cxl/cxl-list.txt |  2 ++
 config.h.meson                 |  2 +-
 cxl/json.c                     | 15 ++++++++++++++-
 cxl/list.c                     |  6 ++++++
 test/meson.build               |  9 +++++++--
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 9a9911e7dd9b..0595638ee054 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -425,6 +425,8 @@ OPTIONS
 	"source:" is one of: External, Internal, Injected, Vendor Specific,
 	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
 
+The media-errors option is only available with '-Dlibtracefs=enabled'.
+
 ----
 # cxl list -m mem9 --media-errors -u
 {
diff --git a/config.h.meson b/config.h.meson
index f75db3e6360f..e8539f8d04df 100644
--- a/config.h.meson
+++ b/config.h.meson
@@ -19,7 +19,7 @@
 /* ndctl test support */
 #mesondefine ENABLE_TEST
 
-/* cxl monitor support */
+/* cxl monitor and cxl list --media-errors support */
 #mesondefine ENABLE_LIBTRACEFS
 
 /* Define to 1 if big-endian-arch */
diff --git a/cxl/json.c b/cxl/json.c
index e65bd803b706..a75928bf43ed 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -9,12 +9,15 @@
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 #include <ccan/short_types/short_types.h>
+
+#ifdef ENABLE_LIBTRACEFS
 #include <tracefs.h>
+#include "../util/event_trace.h"
+#endif
 
 #include "filter.h"
 #include "json.h"
 #include "../daxctl/json.h"
-#include "../util/event_trace.h"
 
 #define CXL_FW_VERSION_STR_LEN	16
 #define CXL_FW_MAX_SLOTS	4
@@ -575,6 +578,7 @@ err_jobj:
 	return NULL;
 }
 
+#ifdef ENABLE_LIBTRACEFS
 /* CXL Spec 3.1 Table 8-140 Media Error Record */
 #define CXL_POISON_SOURCE_MAX 7
 static const char *const poison_source[] = { "Unknown", "External", "Internal",
@@ -753,6 +757,15 @@ err_free:
 	tracefs_instance_free(inst);
 	return jpoison;
 }
+#else
+static struct json_object *
+util_cxl_poison_list_to_json(struct cxl_region *region,
+			     struct cxl_memdev *memdev,
+			     unsigned long flags)
+{
+	return NULL;
+}
+#endif
 
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
diff --git a/cxl/list.c b/cxl/list.c
index 0b25d78248d5..48bd1ebc3c0e 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -146,6 +146,12 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.ctx.log_priority = LOG_DEBUG;
 	}
 
+#ifndef ENABLE_LIBTRACEFS
+	if (param.media_errors) {
+		notice(&param, "--media-errors support disabled at build time\n");
+		param.media_errors = false;
+	}
+#endif
 	if (cxl_filter_has(param.port_filter, "root") && param.ports)
 		param.buses = true;
 
diff --git a/test/meson.build b/test/meson.build
index 775542c1b787..615376ea635a 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -167,7 +167,6 @@ cxl_events = find_program('cxl-events.sh')
 cxl_sanitize = find_program('cxl-sanitize.sh')
 cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
-cxl_poison = find_program('cxl-poison.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -200,7 +199,6 @@ tests = [
   [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
   [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
   [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
-  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
@@ -253,6 +251,13 @@ if get_option('fwctl').enabled()
   ]
 endif
 
+if get_option('libtracefs').enabled()
+  cxl_poison = find_program('cxl-poison.sh')
+  tests += [
+    [ 'cxl-poison.sh', cxl_poison, 'cxl' ],
+  ]
+endif
+
 test_env = [
     'LC_ALL=C',
     'NDCTL=@0@'.format(ndctl_tool.full_path()),
-- 
2.37.3

