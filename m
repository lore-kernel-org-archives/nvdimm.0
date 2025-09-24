Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC81F7910
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 01:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758677750; cv=none; b=jE/ggRV67enkmuj7oJVGz07AtiS9EzEUTtiJPmB/zseMrhLfU6CNbAzv9Wey2VDOEds0957Yx164S+4/nBWiYA0HjOWnuIuNS0Dvm1rHWJRXz3iOHRJMBfUd6fM+GBsrKengSFJLXb1iT4g9wrZazfaNRCM3Bxr/edZFh4TFHtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758677750; c=relaxed/simple;
	bh=BW27m63kEVn3ZsRp0XJOyC/RKdezXJU2GVRvhW/Dtts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVTbqJWf7ejRnzmpoilK4ef2c4fGgnEJWbXP1krR5erEpuw63CLG1T2ebzZHigwj/CgQ5YJGxPFx9V4ePdciM/cZ8TMH+jc23AzemX+79uYTdc1I/C9Hd4beGJjZy208Nx06aGgx/LXM6WYlhc9DhQiSmZfijgCJBCqwYRysBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uz9YPwv4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uz9YPwv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758677749; x=1790213749;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BW27m63kEVn3ZsRp0XJOyC/RKdezXJU2GVRvhW/Dtts=;
  b=Uz9YPwv43ECJ3VVpeP2egLDsZFt+Iy2m1YNbzB2sC9R5OoG5izwhwWMH
   nBEhARVhoOHxUV4xNbv2z+oMEnz4Ym1Y5s2t5lpAPth0YsUY2wTtEKeMd
   dsTJ2vrHh1bzfUniQ7WYeZd+62ogwR8sE1hy7svSKNdBGcez4VjFn32Uq
   /p52s4J2rWROkXXYT66WmWpwJ0cFmO7ouuV88HM1a3mEWnVdCca1TurKs
   MTpqd/zF8gfa375obC8iaHHqsbkcieTzPRrrVy3dANTyU9h136brgJIdG
   ntrTYa3gUhfTGoClDRSyFMbu8fGskMI3ktG8RXtbk0DVSAyxFeW5LRkSn
   g==;
X-CSE-ConnectionGUID: 300+0KiIR1G2KDivBWgmng==
X-CSE-MsgGUID: F6/7SJTEQn6qaiCHmZlezA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61138502"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="61138502"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:35:49 -0700
X-CSE-ConnectionGUID: u1KOl709SvCcVAWRL56FuA==
X-CSE-MsgGUID: zcbMmhnoTLmBkU0p0nhN7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176846460"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.28])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 18:35:48 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Andreas Hasenack <andreas.hasenack@canonical.com>
Subject: [ndctl PATCH] cxl/list: remove libtracefs build dependency for --media-errors
Date: Tue, 23 Sep 2025 18:35:33 -0700
Message-ID: <20250924013537.84630-1-alison.schofield@intel.com>
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
NDCTL versions 80,81,82 no longer build without libtracefs.

With this change, NDCTL builds with or without libtracefs.

Now, when libtracefs is not enabled, users will see:
	$ cxl list -r region0 --media-errors
	Error: unknown option `media-errors'

The cxl-poison.sh unit test is omitted when libtracefs is disabled.

The man page gets a note:
	The media-error option is only available with -Dlibtracefs=enabled.

Reported-by: Andreas Hasenack <andreas.hasenack@canonical.com>
Fixes: d7532bb049e0 ("cxl/list: add --media-errors option to cxl list")
Closes: https://github.com/pmem/ndctl/issues/289
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt |  2 ++
 config.h.meson                 |  2 +-
 cxl/json.c                     | 15 ++++++++++++++-
 cxl/list.c                     |  4 ++++
 test/meson.build               |  9 +++++++--
 5 files changed, 28 insertions(+), 4 deletions(-)

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
index 0b25d78248d5..d9412ec72375 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -57,8 +57,10 @@ static const struct option options[] = {
 		    "include memory device firmware information"),
 	OPT_BOOLEAN('A', "alert-config", &param.alert_config,
 		    "include alert configuration information"),
+#ifdef ENABLE_LIBTRACEFS
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+#endif
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -123,7 +125,9 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.fw = true;
 		param.alert_config = true;
 		param.dax = true;
+#ifdef ENABLE_LIBTRACEFS
 		param.media_errors = true;
+#endif
 		/* fallthrough */
 	case 2:
 		param.idle = true;
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

