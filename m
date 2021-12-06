Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAE32CB6
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:47 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804839"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804839"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:45 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310463"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 10/12] util/parse-configs: add a key/value search helper
Date: Mon,  6 Dec 2021 15:28:28 -0700
Message-Id: <20211206222830.2266018-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3874; h=from:subject; bh=+c9PzAL7gilmjcspgyDw3H/dUTOIz9Rw7aE+EZIpuRo=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+nrDf1R6p35uXvihu9vtbunDTZXHJXj0JI8bMHtEnrL4 uu9/RykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTAC5iycjQuaGPS09XSvB0WPmPssMXuL bfTPWdfTjwu5nAhbPRz0ytGf5pOnyJYpF1/WdV7Gpx6gm3YnLEvbBr/KLlKXFPGnMLHzMDAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a new config query type called CONFIG_SEARCH_SECTION, which searches
all loaded config files based on a query criteria of: specified section
name, specified key/value pair within that section, and can return other
key/values from the section that matched the search criteria.

This allows for multiple named subsections, where a subsection name is
of the type: '[section subsection]'.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/parse-configs.h | 15 +++++++++++++
 util/parse-configs.c | 51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/util/parse-configs.h b/util/parse-configs.h
index 491aebb..6dcc01c 100644
--- a/util/parse-configs.h
+++ b/util/parse-configs.h
@@ -9,6 +9,7 @@
 
 enum parse_conf_type {
 	CONFIG_STRING,
+	CONFIG_SEARCH_SECTION,
 	CONFIG_END,
 	MONITOR_CALLBACK,
 };
@@ -20,6 +21,10 @@ typedef int parse_conf_cb(const struct config *, const char *config_file);
 
 struct config {
 	enum parse_conf_type type;
+	const char *section;
+	const char *search_key;
+	const char *search_val;
+	const char *get_key;
 	const char *key;
 	void *value;
 	void *defval;
@@ -31,6 +36,16 @@ struct config {
 #define CONF_END() { .type = CONFIG_END }
 #define CONF_STR(k,v,d) \
 	{ .type = CONFIG_STRING, .key = (k), .value = check_vtype(v, const char **), .defval = (d) }
+#define CONF_SEARCH(s, sk, sv, gk, v, d)	\
+{						\
+	.type = CONFIG_SEARCH_SECTION,		\
+	.section = (s),				\
+	.search_key = (sk),			\
+	.search_val = (sv),			\
+	.get_key = (gk),			\
+	.value = check_vtype(v, const char **),	\
+	.defval = (d)				\
+}
 #define CONF_MONITOR(k,f) \
 	{ .type = MONITOR_CALLBACK, .key = (k), .callback = (f)}
 
diff --git a/util/parse-configs.c b/util/parse-configs.c
index aac129b..ca1daef 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -39,6 +39,54 @@ static void set_str_val(const char **value, const char *val)
 	*value = strbuf_detach(&buf, NULL);
 }
 
+static const char *search_section_kv(dictionary *d, const struct config *c)
+{
+	int i;
+
+	for (i = 0; i < iniparser_getnsec(d); i++) {
+		const char *cur_sec_full = iniparser_getsecname(d, i);
+		char *cur_sec = strdup(cur_sec_full);
+		const char *search_val, *ret_val;
+		const char *delim = " \t\n\r";
+		char *save, *cur, *query;
+
+		if (!cur_sec)
+			return NULL;
+		if (!c->section || !c->search_key || !c->search_val || !c->get_key) {
+			fprintf(stderr, "warning: malformed config query, skipping\n");
+			return NULL;
+		}
+
+		cur = strtok_r(cur_sec, delim, &save);
+		if ((cur == NULL) || (strcmp(cur, c->section) != 0))
+			goto out_sec;
+
+		if (asprintf(&query, "%s:%s", cur_sec_full, c->search_key) < 0)
+			goto out_sec;
+		search_val = iniparser_getstring(d, query, NULL);
+		if (!search_val)
+			goto out_query;
+		if (strcmp(search_val, c->search_val) != 0)
+			goto out_query;
+
+		/* we're now in a matching section */
+		free(query);
+		if (asprintf(&query, "%s:%s", cur_sec_full, c->get_key) < 0)
+			goto out_sec;
+		ret_val = iniparser_getstring(d, query, NULL);
+		free(query);
+		free(cur_sec);
+		return ret_val;
+
+out_query:
+		free(query);
+out_sec:
+		free(cur_sec);
+	}
+
+	return NULL;
+}
+
 static int parse_config_file(const char *config_file,
 			const struct config *configs)
 {
@@ -55,6 +103,9 @@ static int parse_config_file(const char *config_file,
 					iniparser_getstring(dic,
 					configs->key, configs->defval));
 			break;
+		case CONFIG_SEARCH_SECTION:
+			set_str_val((const char **)configs->value,
+					search_section_kv(dic, configs));
 		case MONITOR_CALLBACK:
 		case CONFIG_END:
 			break;
-- 
2.33.1

