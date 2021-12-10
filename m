Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7CB2CBF
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175691; x=1670711691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/5JO7omEmiTzOFLLnMYHv14gNCj/4dZe5axV61oSrw=;
  b=bni1fKZvtbMARCI3v8CRCXu0tqiJ2EbbuTBEB9xEAMVKUrBj8ZdmIsVk
   5uyK9tC3T/1mfp05QFEQS3LHRgtLXIPpC/TdqDB6hXwdVcMPf351zcZZ7
   W+gouRZzgezR0ysJy3RVQZSnU5HIqIDxknMSeBaqmFNGBr51M0gnQiTmi
   TbgXbLznkHZhDjadHpPTaaYp2PzphKbXgcvsVWuMI6q8SzG60xGBgGssf
   7kZ+z32Q4VAgmWqlKchXtP7NUQb7B9QSM0US1bkJzHaa33BflhxQ40MxD
   HMOo9Xcgn8UUfoZTX4lu+r1+2dQRXWMG7Xk/7Yj54v7+U4aw16rgEFKMQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843341"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843341"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113649"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:43 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 01/11] ndctl, util: add parse-configs helper
Date: Fri, 10 Dec 2021 15:34:30 -0700
Message-Id: <20211210223440.3946603-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5770; i=vishal.l.verma@intel.com; h=from:subject; bh=FqHrI1ooeoKhvPXr7JyK0pwn8FrdD3frmKZtYGQD7QE=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/6bWyvc4rJwn8VdiX8xUXWLL4unlTd7dIeHHr/gG1jX ea+qo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABNZzcTIMP+FT7bqA+vfoU8/bqg/sX a7RLfn63nc0pcdY2Q1kk7o/2FkOG0i+Ybr9+eQp5UHxD8f9AsREt+wIj75y5aTaYu9lyiyMgMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add parse-config util to help ndctl commands parse ndctl global
configuration files. This provides a parse_configs_prefix() helper which
uses the iniparser APIs to read all applicable config files, and either
return a 'value' for a requested 'key', or perform a callback if
requested. The operation is defined by a 'struct config' which
encapsulates the key to search for, the location to store the value, and
any callbacks to be executed.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac         |   4 ++
 Makefile.am          |   2 +
 util/parse-configs.h |  38 ++++++++++++++++
 util/parse-configs.c | 105 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/Makefile.am    |   3 +-
 5 files changed, 151 insertions(+), 1 deletion(-)
 create mode 100644 util/parse-configs.h
 create mode 100644 util/parse-configs.c

diff --git a/configure.ac b/configure.ac
index dc39dbe..cbd5a6f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -199,6 +199,10 @@ ndctl_keysreadme=keys.readme
 AC_SUBST([ndctl_keysdir])
 AC_SUBST([ndctl_keysreadme])
 
+AC_CHECK_HEADERS([iniparser.h],,[
+		  AC_MSG_ERROR([iniparser.h not found, install iniparser-devel, libiniparser-dev, or so])
+		 ])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
diff --git a/Makefile.am b/Makefile.am
index 60a1998..c547459 100644
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
index 0000000..32783b5
--- /dev/null
+++ b/util/parse-configs.h
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
+
+#include <dirent.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <util/util.h>
+
+enum parse_conf_type {
+	CONFIG_STRING,
+	CONFIG_END,
+	MONITOR_CALLBACK,
+};
+
+int filter_conf_files(const struct dirent *dir);
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
+int parse_configs_prefix(const char *config_path, const char *prefix,
+			 const struct config *configs);
diff --git a/util/parse-configs.c b/util/parse-configs.c
new file mode 100644
index 0000000..61352d8
--- /dev/null
+++ b/util/parse-configs.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
+
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <iniparser/iniparser.h>
+#include <sys/stat.h>
+#include <util/parse-configs.h>
+#include <util/strbuf.h>
+
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
+	if ((configs->type == MONITOR_CALLBACK) &&
+			(strcmp(config_file, configs->key) == 0))
+		return configs->callback(configs, configs->key);
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
+int parse_configs_prefix(const char *config_path, const char *prefix,
+			 const struct config *configs)
+{
+	const char *config_file = NULL;
+	struct dirent **namelist;
+	int rc, count;
+
+	if (configs->type == MONITOR_CALLBACK)
+		return parse_config_file(config_path, configs);
+
+	count = scandir(config_path, &namelist, filter_conf_files, alphasort);
+	if (count == -1)
+		return -errno;
+
+	while (count--) {
+		char *conf_abspath;
+
+		config_file = namelist[count]->d_name;
+		rc = asprintf(&conf_abspath, "%s/%s", config_path, config_file);
+		if (rc < 0)
+			return -ENOMEM;
+
+		rc = parse_config_file(conf_abspath, configs);
+
+		free(conf_abspath);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index a63b1e0..afdd03c 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -56,7 +56,8 @@ ndctl_LDADD =\
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	-liniparser
 
 if ENABLE_KEYUTILS
 ndctl_LDADD += -lkeyutils
-- 
2.33.1

