Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACB12CA8
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:46 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804836"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804836"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:44 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310453"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 08/12] util/parse-config: refactor filter_conf_files into util/
Date: Mon,  6 Dec 2021 15:28:26 -0700
Message-Id: <20211206222830.2266018-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3826; h=from:subject; bh=C0y7/la9iW9jVx5PaYAhfAzzGUlBfTcj6WPDlMLwvEI=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+noZRHqem/1cPE/hsTSzhFzCb9+1Pkzyz/SfN6Qx1Vc7 7FzYUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQ3h4hSAiQhGMTIsnlQ2+8rS+9c//Ziczi72t6 uW48i5w65u2///SWXfIzjtLsP/HKGXXetEBfSuzvLK/Bfa23DyxtX8E7KBb114b4WJz3ZnAgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Move filter_conf() into util/parse-configs.c as filter_conf_files() so
that it can be reused by the config parser in daxctl.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 19 ++-----------------
 util/parse-configs.h   |  4 ++++
 util/parse-configs.c   | 17 +++++++++++++++++
 daxctl/lib/Makefile.am |  2 ++
 ndctl/lib/Makefile.am  |  2 ++
 5 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 6b68e3a..9d33005 100644
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
 NDCTL_EXPORT void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir)
 {
 	struct dirent **namelist;
@@ -291,7 +276,7 @@ NDCTL_EXPORT void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir)
 	if ((!ctx) || (!conf_dir))
 		return;
 
-	rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
+	rc = scandir(conf_dir, &namelist, filter_conf_files, alphasort);
 	if (rc == -1) {
 		if (errno != ENOENT)
 			err(*ctx, "scandir for configs failed: %s\n",
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
index 44dcff4..aac129b 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -6,6 +6,23 @@
 #include <util/strbuf.h>
 #include <util/iniparser.h>
 
+int filter_conf_files(const struct dirent *dir)
+{
+	if (!dir)
+		return 0;
+
+	if (dir->d_type == DT_REG) {
+		const char *ext = strrchr(dir->d_name, '.');
+
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
2.33.1

