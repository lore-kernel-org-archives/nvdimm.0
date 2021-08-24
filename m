Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713073FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 09:51:40 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id j2so7491270pll.1
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 02:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2PXGiV96ks98ZyRx4ECxeT1W/P4gZfz+2Jb9Vgi1H4=;
        b=cCTp+2+uDUVUMFE4JVHdT53l8g7Ob9ozf3TN6iLWv7WlnZjh91x3SuNsyi/X7BBzVP
         wRuA+8vIRFAyZ5YDjPl/Duy4nycRTp4qDnSikyfgfOf8QEsMMkuyWfUdvHL5DFb33NC3
         0XTPrzLk43FMct5cm28tvKJDwd3Y0rOi/0BsFMWSAXZCZW4kMVJ3+oXdWGP4COCYbh2P
         DyPF/FI2exukC5v0LSnjM0AE49jG0/Hdg0xtAFSSsi6Onm9znDw1DkFM4OetnKn3Ugno
         CXalFp1WsoI/taMphBl0nSEBa3mcpYu5HR1qEQrUttkDWDsnY1RO0dUwx1rKVteQh64B
         xSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2PXGiV96ks98ZyRx4ECxeT1W/P4gZfz+2Jb9Vgi1H4=;
        b=NeXrM6+nb5j+1wqx6O3VNDXa8mmJftr1+wR7meLgS8CRoqxJpl7cVPbhkoUIH5pI13
         J4YIvHfp5rDTfuNuRxVDe3BQY2qvOMhSGlspYkolXKYcHp/CfA5T7QjAgJg3rbuJqaP9
         qOuMUbGxlPt0VQ/Kml9bcd5kb+mgWKUFdKBqf5CYsbCrnkjMg6tO4XDIBpMDKgM9/Alo
         ilmRZOHyHBHF99PYlTyqSra4hZ/T6gKRcYF4aUPY/gJCKjBIj8PghUP0IfPp58ZiSvSj
         gXQASICt25ZjlurNp8Ap0ze8aVVpBxDiSvTrMWC+sTdP5xOB2TIQiCe8L8nMjQ+ovrXv
         xPDw==
X-Gm-Message-State: AOAM5325YYCDuKxBQey1Sl2McAF1e8s3abYi2viRqcjhctBEFksMgsOa
	3G28/6I8trNgEsL++fGsQbdEq9rn017QXQ==
X-Google-Smtp-Source: ABdhPJzkxZQuw1v0a3/cN6EQue5+5l2jap03coMiVukxZiw0Zb494NFj2UbXRCpi9s4Hi5vDn7QTIg==
X-Received: by 2002:a17:902:690a:b0:12d:86cf:d981 with SMTP id j10-20020a170902690a00b0012d86cfd981mr32755236plk.39.1629798700105;
        Tue, 24 Aug 2021 02:51:40 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id l19sm1873881pjq.10.2021.08.24.02.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:51:39 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 2/5] ndctl, util: add parse-configs helper
Date: Tue, 24 Aug 2021 18:51:03 +0900
Message-Id: <20210824095106.104808-3-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824095106.104808-1-qi.fuli@fujitsu.com>
References: <20210824095106.104808-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add parse-config util to help ndctl commands parse ndctl global
configuration files.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 Makefile.am          |  2 ++
 util/parse-configs.c | 82 ++++++++++++++++++++++++++++++++++++++++++++
 util/parse-configs.h | 34 ++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 util/parse-configs.c
 create mode 100644 util/parse-configs.h

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
-- 
2.31.1

