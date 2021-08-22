Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3B2FB2
	for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 20:30:56 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id i21so13555865pfd.8
        for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rikSzHpM7yOtnJuTI3+qXW0xoDeiFf+FgQN+/yDLogs=;
        b=oxsXJc5H3T37oRoUfdnwSt0k7nXSonRTbVuZL2UVOvnF7nr1j3WlvTEtdPy21fO7iC
         xpVOPfPTeM/tJIOiqyyE1QRP8tmqCP05P3Kcjf/7eKhj+Zx76F42UvWy4SDRLPtgwcA0
         X9h/Pl8MaSrzIDLvoKHe1q5mwn5cy4PSs7xuTUaLwspkZ5D2AtRY4SMen7FBJR+0ep7y
         5flLO8HsUWo0E4RYJM2qCOc/1TqrBuu5MvFZl5shLKxHyLy+IM3CzdQoGlhYuWD4QsSU
         qmUDYLPJLbXFskDRJ3LFMxTuv1D7ZRo/9/WHVbqg9f9B1MgTgpk4R0X9xbs7y6bnJWbe
         +Wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rikSzHpM7yOtnJuTI3+qXW0xoDeiFf+FgQN+/yDLogs=;
        b=tH1N0iUeQkABldeknqMb5ve2sr1hPTzClWdrgipYgTTqMjZFnKJ2fdRLEW6GzRu91h
         RZIM97JnRNT4NUmvU9w+74foRGm/QlTIMFt+f6Plwd+XAEIYyJ8t/90hj2+z2OxbJb8u
         6tkh3fdm3WoDefJQ4agiYIMutqMXKG33wFHxZSNVJ61GWMmX2SlSGQGveWgRLNSi1RKL
         U4lwfaLnvZnkEOZC8aDGeojy9pvsGYwgdXzkSS7xBGiKqQYYygLqcxwhq6v9ZQGDCi3j
         Y2aI3N+Weg6Ivm1RvrJGJ82TnkSGGYu0FTRaSe0oOJ8awekcZ4jtmYjJfM17fOfXeuY1
         o6pg==
X-Gm-Message-State: AOAM533vHUwY1Jlyp9flNbamanGHtjWmxx/8URMgvIF6dDyNy0SineK1
	E9qo+MmQoJTklen8ZNjmxjj1zJUuhKJM6Q==
X-Google-Smtp-Source: ABdhPJxsggJTmSxnReLcmZvvzQwwjsI0ZxlQa5W+s4wVlPAD0uwK3ALe++HzFuGTN5xQ+AHmLMZp6w==
X-Received: by 2002:a63:7cb:: with SMTP id 194mr29253951pgh.308.1629664255651;
        Sun, 22 Aug 2021 13:30:55 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id n30sm13587804pfv.87.2021.08.22.13.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 13:30:55 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 2/5] ndctl, util: add parse-configs helper
Date: Mon, 23 Aug 2021 05:30:12 +0900
Message-Id: <20210822203015.528438-3-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822203015.528438-1-qi.fuli@fujitsu.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add parse-config util to help ndctl commands parse ndctl global
configuration file(s).

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
---
 Makefile.am          |  2 ++
 util/parse-configs.c | 82 ++++++++++++++++++++++++++++++++++++++++++++
 util/parse-configs.h | 34 ++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 util/parse-configs.c
 create mode 100644 util/parse-configs.h

diff --git a/Makefile.am b/Makefile.am
index 960b5e9..6e50741 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -74,6 +74,8 @@ noinst_LIBRARIES += libutil.a
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
index 0000000..b7ae1f0
--- /dev/null
+++ b/util/parse-configs.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
+
+#include <errno.h>
+#include <util/parse-configs.h>
+#include <util/strbuf.h>
+#include <ccan/ciniparser/ciniparser.h>
+
+static void set_str_val(const char **value, char *val)
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
+	dic = ciniparser_load(config_file);
+	if (!dic)
+		return -errno;
+
+	for (; configs->type != CONFIG_END; configs++) {
+		switch (configs->type) {
+		case CONFIG_STRING:
+			set_str_val((const char **)configs->value,
+					ciniparser_getstring(dic,
+					configs->key, configs->defval));
+			break;
+		case MONITOR_CALLBACK:
+		case CONFIG_END:
+			break;
+		}
+	}
+
+	ciniparser_freedict(dic);
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

