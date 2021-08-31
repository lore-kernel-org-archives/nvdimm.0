Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8D72
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:20 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009053"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009053"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577062994"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:07 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 3/7] util/parse-config: refactor filter_conf_files into util/
Date: Tue, 31 Aug 2021 03:04:55 -0600
Message-Id: <20210831090459.2306727-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3726; h=from:subject; bh=43yM7GmiQdu2zFYDOd1yPQaNuDLpwWaLyR/jlwYlKjM=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6H1bz7q1cKbf3fcO1nkM7vOs9kmJjTdPSHG37ZqvYyWzK Z//WUcrCIMbBICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIlwvWP4H5vmWrei9cL9iDy33cf6g2 USJqvseGGX8l0x+sSE8k2P4xgZnil0tMzzeZoyden+j9xH7odsyhZLuaD38bm16xvjTYq1TAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Move filter_conf() into util/parse-configs.c as filter_conf_files() so
that it can be reused by the config parser in daxctl.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 19 ++-----------------
 util/parse-configs.h   |  4 ++++
 util/parse-configs.c   | 16 ++++++++++++++++
 daxctl/lib/Makefile.am |  2 ++
 ndctl/lib/Makefile.am  |  2 ++
 5 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index db2e38b..a01ac80 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -25,6 +25,7 @@
 #include <util/size.h>
 #include <util/sysfs.h>
 #include <util/strbuf.h>
+#include <util/parse-configs.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
@@ -266,22 +267,6 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
-static int filter_conf(const struct dirent *dir)
-{
-	if (!dir)
-		return 0;
-
-	if (dir->d_type == DT_REG) {
-		const char *ext = strrchr(dir->d_name, '.');
-		if ((!ext) || (ext == dir->d_name))
-			return 0;
-		if (strcmp(ext, ".conf") == 0)
-			return 1;
-	}
-
-	return 0;
-}
-
 NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir)
 {
 	struct dirent **namelist;
@@ -291,7 +276,7 @@ NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir)
 	if ((!ctx) || (!conf_dir))
 		return;
 
-	rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
+	rc = scandir(conf_dir, &namelist, filter_conf_files, alphasort);
 	if (rc == -1) {
 		perror("scandir");
 		return;
diff --git a/util/parse-configs.h b/util/parse-configs.h
index f70f58f..491aebb 100644
--- a/util/parse-configs.h
+++ b/util/parse-configs.h
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
 
+#include <dirent.h>
 #include <stdbool.h>
 #include <stdint.h>
+#include <string.h>
 #include <util/util.h>
 
 enum parse_conf_type {
@@ -11,6 +13,8 @@ enum parse_conf_type {
 	MONITOR_CALLBACK,
 };
 
+int filter_conf_files(const struct dirent *dir);
+
 struct config;
 typedef int parse_conf_cb(const struct config *, const char *config_file);
 
diff --git a/util/parse-configs.c b/util/parse-configs.c
index 44dcff4..72c4913 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -6,6 +6,22 @@
 #include <util/strbuf.h>
 #include <util/iniparser.h>
 
+int filter_conf_files(const struct dirent *dir)
+{
+	if (!dir)
+		return 0;
+
+	if (dir->d_type == DT_REG) {
+		const char *ext = strrchr(dir->d_name, '.');
+		if ((!ext) || (ext == dir->d_name))
+			return 0;
+		if (strcmp(ext, ".conf") == 0)
+			return 1;
+	}
+
+	return 0;
+}
+
 static void set_str_val(const char **value, const char *val)
 {
 	struct strbuf buf = STRBUF_INIT;
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
index 25efd83..db2351e 100644
--- a/daxctl/lib/Makefile.am
+++ b/daxctl/lib/Makefile.am
@@ -15,6 +15,8 @@ libdaxctl_la_SOURCES =\
 	../../util/sysfs.h \
 	../../util/log.c \
 	../../util/log.h \
+	../../util/parse-configs.h \
+	../../util/parse-configs.c \
 	libdaxctl.c
 
 libdaxctl_la_LIBADD =\
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index f741c44..8020eb4 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -19,6 +19,8 @@ libndctl_la_SOURCES =\
 	../../util/wrapper.c \
 	../../util/usage.c \
 	../../util/fletcher.h \
+	../../util/parse-configs.h \
+	../../util/parse-configs.c \
 	dimm.c \
 	inject.c \
 	nfit.c \
-- 
2.31.1

