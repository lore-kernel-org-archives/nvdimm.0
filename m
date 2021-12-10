Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EFA2EA6
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175695; x=1670711695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0I1JftdvB3rTfZpoTF26HdclcTfGEarkHEak5eqcR+Q=;
  b=Xo1FlXD9B11Fw5k6tAfKScEQ7LExnY0jjEP01fyrFNMzAIeVGYdX/jSF
   3WUJr123o9/IJnOgP1M4X71ynmEBiD9jaESyZ1UYy31hZIJRc0un/dV8J
   7Zq7zJGjnhTBaQ6fFlbipCfEoheCsekbrs+KprGlaDf1jAmKNT2k9eIgX
   61mz0KdPQHYqPYpDU3zmSV9CPuzsWzw9h8A73gDzfR2io/eiKNWlcDc67
   N4IE/VBsCadM+wvnTT16jyRgRSX3eNyB/Wa/mstFzAga9G33TWOI4A3mK
   3fbubKRqOPLnpukm1yxwcIcbmb9VVD4juzvzy3V4v+VS0aWGoayErtml4
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843373"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843373"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113680"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:47 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v3 08/11] util/parse-configs: add a key/value search helper
Date: Fri, 10 Dec 2021 15:34:37 -0700
Message-Id: <20211210223440.3946603-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3874; h=from:subject; bh=0I1JftdvB3rTfZpoTF26HdclcTfGEarkHEak5eqcR+Q=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/63Zpnln35hG9s1DcV/q7rPblkqvT9V4OU24yiHOztn v/56o6OUhUGMi0FWTJHl756PjMfktufzBCY4wsxhZQIZwsDFKQAT2fmE4X/o5oaX3b8XnY4N7pfa45 i/szTYWXZ+WFy6fPdPveqX8xkZ/sq6PNr9I/va9qfbBQKrDud3nXX27b7R9zk6t5XTVs0rlQ8A
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
index 32783b5..533480a 100644
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
index 61352d8..49ee4e0 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -42,6 +42,54 @@ static void set_str_val(const char **value, const char *val)
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
@@ -62,6 +110,9 @@ static int parse_config_file(const char *config_file,
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

