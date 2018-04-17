Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 194F02263DD64
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 23:40:15 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9DF04AC019E
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 15:40:10 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
Date: Tue, 17 Apr 2018 15:38:47 +0900
Message-Id: <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds OPT_STRING_LIST to parse_option in order to support
multiple space seperated string objects in one option.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ccan/list/list.h     |  6 ++++++
 util/parse-options.c | 25 +++++++++++++++++++++++++
 util/parse-options.h |  3 +++
 3 files changed, 34 insertions(+)

diff --git a/ccan/list/list.h b/ccan/list/list.h
index 4d1d34e..f6c927f 100644
--- a/ccan/list/list.h
+++ b/ccan/list/list.h
@@ -26,6 +26,12 @@ struct list_node
 	struct list_node *next, *prev;
 };
 
+struct string_list_node
+{
+	char *str;
+	struct list_node list;
+};
+
 /**
  * struct list_head - the head of a doubly-linked list
  * @h: the list_head (containing next and prev pointers)
diff --git a/util/parse-options.c b/util/parse-options.c
index 751c091..cac18f0 100644
--- a/util/parse-options.c
+++ b/util/parse-options.c
@@ -20,6 +20,7 @@
 #include <util/util.h>
 #include <util/strbuf.h>
 #include <util/parse-options.h>
+#include <ccan/list/list.h>
 
 #define OPT_SHORT 1
 #define OPT_UNSET 2
@@ -695,3 +696,27 @@ int parse_opt_verbosity_cb(const struct option *opt,
 	}
 	return 0;
 }
+
+int parse_opt_string_list(const struct option *opt, const char *arg, int unset)
+{
+	if (unset)
+		return 0;
+
+	if (!arg)
+		return -1;
+
+	struct list_head *v = opt->value;
+	char *temp = strdup(arg);
+	const char *deli = " ";
+
+	temp = strtok(temp, deli);
+	while (temp != NULL) {
+		struct string_list_node *sln = malloc(sizeof(*sln));
+		sln->str = temp;
+		list_add_tail(v, &sln->list);
+		temp = strtok(NULL, deli);
+	}
+
+	free(temp);
+	return 0;
+}
diff --git a/util/parse-options.h b/util/parse-options.h
index 6fd6b24..10b79cb 100644
--- a/util/parse-options.h
+++ b/util/parse-options.h
@@ -135,6 +135,8 @@ struct option {
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
 #define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
+#define OPT_STRING_LIST(s, l, v, a, h) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = check_vtype(v, struct list_head *), (a), .help = (h) , 0, &parse_opt_string_list }
 #define OPT_DATE(s, l, v, h) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
@@ -206,6 +208,7 @@ extern int parse_options_end(struct parse_opt_ctx_t *ctx);
 extern int parse_opt_abbrev_cb(const struct option *, const char *, int);
 extern int parse_opt_approxidate_cb(const struct option *, const char *, int);
 extern int parse_opt_verbosity_cb(const struct option *, const char *, int);
+extern int parse_opt_string_list(const struct option *, const char *, int);
 
 #define OPT__VERBOSE(var)  OPT_BOOLEAN('v', "verbose", (var), "be verbose")
 #define OPT__QUIET(var)    OPT_BOOLEAN('q', "quiet",   (var), "be quiet")
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
