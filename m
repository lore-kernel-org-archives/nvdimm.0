Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E92CB3
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:29:02 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="236159418"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="236159418"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:41 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310419"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:41 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 02/12] ndctl, util: add parse-configs helper
Date: Mon,  6 Dec 2021 15:28:20 -0700
Message-Id: <20211206222830.2266018-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4096; i=vishal.l.verma@intel.com; h=from:subject; bh=/FPon6BgNSScFjsTiy9JG4E8k2vQqVLptr5vS0B4ajM=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+nqU/whPzFrPPCVG+dj1SxwNG5d9jZqjvGb+9dIvdzlM wsM6OkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRnLUM/z28RNYGvFZqk51gzXZU5N rRBS8ZU9laAhzSr9475NIhbM/wT8VQ88j7eVN9Dnx685P/xh/PJWtsp1jcfie/TurUfmn9ElYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add parse-config util to help ndctl commands parse ndctl global
configuration files.

Link: https://lore.kernel.org/r/20210824095106.104808-3-qi.fuli@fujitsu.com
Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am          |  2 ++
 util/parse-configs.h | 34 ++++++++++++++++++
 util/parse-configs.c | 82 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 util/parse-configs.h
 create mode 100644 util/parse-configs.c

diff --git a/Makefile.am b/Makefile.am
index 235c362..af55f0e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -70,6 +70,8 @@ noinst_LIBRARIES += libutil.a
 libutil_a_SOURCES = \
 	util/parse-options.c \
 	util/parse-options.h \
+	util/parse-configs.c \
+	util/parse-configs.h \
 	util/usage.c \
 	util/size.c \
 	util/main.c \
diff --git a/util/parse-configs.h b/util/parse-configs.h
new file mode 100644
index 0000000..f70f58f
--- /dev/null
+++ b/util/parse-configs.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
+
+#include <stdbool.h>
+#include <stdint.h>
+#include <util/util.h>
+
+enum parse_conf_type {
+	CONFIG_STRING,
+	CONFIG_END,
+	MONITOR_CALLBACK,
+};
+
+struct config;
+typedef int parse_conf_cb(const struct config *, const char *config_file);
+
+struct config {
+	enum parse_conf_type type;
+	const char *key;
+	void *value;
+	void *defval;
+	parse_conf_cb *callback;
+};
+
+#define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
+
+#define CONF_END() { .type = CONFIG_END }
+#define CONF_STR(k,v,d) \
+	{ .type = CONFIG_STRING, .key = (k), .value = check_vtype(v, const char **), .defval = (d) }
+#define CONF_MONITOR(k,f) \
+	{ .type = MONITOR_CALLBACK, .key = (k), .callback = (f)}
+
+int parse_configs_prefix(const char *__config_file, const char *prefix,
+				const struct config *configs);
diff --git a/util/parse-configs.c b/util/parse-configs.c
new file mode 100644
index 0000000..44dcff4
--- /dev/null
+++ b/util/parse-configs.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
+
+#include <errno.h>
+#include <util/parse-configs.h>
+#include <util/strbuf.h>
+#include <util/iniparser.h>
+
+static void set_str_val(const char **value, const char *val)
+{
+	struct strbuf buf = STRBUF_INIT;
+	size_t len = *value ? strlen(*value) : 0;
+
+	if (!val)
+		return;
+
+	if (len) {
+		strbuf_add(&buf, *value, len);
+		strbuf_addstr(&buf, " ");
+	}
+	strbuf_addstr(&buf, val);
+	*value = strbuf_detach(&buf, NULL);
+}
+
+static int parse_config_file(const char *config_file,
+			const struct config *configs)
+{
+	dictionary *dic;
+
+	dic = iniparser_load(config_file);
+	if (!dic)
+		return -errno;
+
+	for (; configs->type != CONFIG_END; configs++) {
+		switch (configs->type) {
+		case CONFIG_STRING:
+			set_str_val((const char **)configs->value,
+					iniparser_getstring(dic,
+					configs->key, configs->defval));
+			break;
+		case MONITOR_CALLBACK:
+		case CONFIG_END:
+			break;
+		}
+	}
+
+	iniparser_freedict(dic);
+	return 0;
+}
+
+int parse_configs_prefix(const char *__config_files, const char *prefix,
+				const struct config *configs)
+{
+	char *config_files, *save;
+	const char *config_file;
+	int rc;
+
+	config_files = strdup(__config_files);
+	if (!config_files)
+		return -ENOMEM;
+
+	for (config_file = strtok_r(config_files, " ", &save); config_file;
+				config_file = strtok_r(NULL, " ", &save)) {
+
+		if (strncmp(config_file, "./", 2) != 0)
+			fix_filename(prefix, &config_file);
+
+		if ((configs->type == MONITOR_CALLBACK) &&
+				(strcmp(config_file, configs->key) == 0))
+			rc = configs->callback(configs, configs->key);
+		else
+			rc = parse_config_file(config_file, configs);
+
+		if (rc)
+			goto end;
+	}
+
+ end:
+	free(config_files);
+	return rc;
+
+}
-- 
2.33.1

