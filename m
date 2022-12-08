Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880CA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534932; x=1702070932;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oo+YDC2MaJSBfiBtU5WPJPPsRqc63yK4zGMMsoyeCMg=;
  b=fqyrURT0tPbT9wN/RAF5xbhqy/8xufkEQf8tccTz9ELl9dPd59bszw5r
   koEFPmNDTK7cM0Fc7s29CCiyQWKcZR5WrD/tu16FJS3pKdZzSzArKWPSe
   9itIA53yRXriF6sjz8NbSGDM0eBYOZTAJUvC63Vexj9bgucHvQBzxRtEf
   k8+calU1qxuobzoT014rjVc7YreCyVevil6GkJMEoVdNjZvIGhBnn9BSO
   5OmXNgUzOnJ9j+CZJg03q4YDUcPi8vGOqwUwY0QtkTCkMiZKee5PgjiIA
   Y8ffWRLm3PjxUqzvLKIBqLf3l7P9lXOiTEBpZAaV9uBH5pSITq8UspHA4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319170370"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319170370"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753756164"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753756164"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:51 -0800
Subject: [ndctl PATCH v2 09/18] cxl/filter: Return json-c topology
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:50 -0800
Message-ID: <167053493095.582963.5155962994216061570.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for cxl_filter_walk() to be used to collect and publish cxl
objects for other utilities, return the resulting json_object directly.
Move the responsibility of freeing and optionally printing the object to
the caller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |   30 ++++++------------------------
 cxl/filter.h |   22 +++++++++++++++++++++-
 cxl/list.c   |    7 ++++++-
 3 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 040e7deefb3e..8499450ded01 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -672,23 +672,6 @@ util_cxl_decoder_filter_by_region(struct cxl_decoder *decoder,
 	return decoder;
 }
 
-static unsigned long params_to_flags(struct cxl_filter_params *param)
-{
-	unsigned long flags = 0;
-
-	if (param->idle)
-		flags |= UTIL_JSON_IDLE;
-	if (param->human)
-		flags |= UTIL_JSON_HUMAN;
-	if (param->health)
-		flags |= UTIL_JSON_HEALTH;
-	if (param->targets)
-		flags |= UTIL_JSON_TARGETS;
-	if (param->partition)
-		flags |= UTIL_JSON_PARTITION;
-	return flags;
-}
-
 static void splice_array(struct cxl_filter_params *p, struct json_object *jobjs,
 			 struct json_object *platform,
 			 const char *container_name, bool do_container)
@@ -1027,11 +1010,12 @@ walk_children:
 	}
 }
 
-int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
+struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
+				    struct cxl_filter_params *p)
 {
 	struct json_object *jdevs = NULL, *jbuses = NULL, *jports = NULL;
 	struct json_object *jplatform = json_object_new_array();
-	unsigned long flags = params_to_flags(p);
+	unsigned long flags = cxl_filter_to_flags(p);
 	struct json_object *jportdecoders = NULL;
 	struct json_object *jbusdecoders = NULL;
 	struct json_object *jepdecoders = NULL;
@@ -1044,7 +1028,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 
 	if (!jplatform) {
 		dbg(p, "platform object allocation failure\n");
-		return -ENOMEM;
+		return NULL;
 	}
 
 	janondevs = json_object_new_array();
@@ -1232,9 +1216,7 @@ walk_children:
 		     top_level_objs > 1);
 	splice_array(p, jregions, jplatform, "regions", top_level_objs > 1);
 
-	util_display_json_array(stdout, jplatform, flags);
-
-	return 0;
+	return jplatform;
 err:
 	json_object_put(janondevs);
 	json_object_put(jbuses);
@@ -1246,5 +1228,5 @@ err:
 	json_object_put(jepdecoders);
 	json_object_put(jregions);
 	json_object_put(jplatform);
-	return -ENOMEM;
+	return NULL;
 }
diff --git a/cxl/filter.h b/cxl/filter.h
index 256df49c3d0c..2bda6ddd77ca 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -5,6 +5,7 @@
 
 #include <stdbool.h>
 #include <util/log.h>
+#include <util/json.h>
 
 struct cxl_filter_params {
 	const char *memdev_filter;
@@ -59,6 +60,25 @@ struct cxl_dport *util_cxl_dport_filter_by_memdev(struct cxl_dport *dport,
 						  const char *serial);
 struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
 					    const char *__ident);
-int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *param);
+struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
+				    struct cxl_filter_params *param);
+
+static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
+{
+	unsigned long flags = 0;
+
+	if (param->idle)
+		flags |= UTIL_JSON_IDLE;
+	if (param->human)
+		flags |= UTIL_JSON_HUMAN;
+	if (param->health)
+		flags |= UTIL_JSON_HEALTH;
+	if (param->targets)
+		flags |= UTIL_JSON_TARGETS;
+	if (param->partition)
+		flags |= UTIL_JSON_PARTITION;
+	return flags;
+}
+
 bool cxl_filter_has(const char *needle, const char *__filter);
 #endif /* _CXL_UTIL_FILTER_H_ */
diff --git a/cxl/list.c b/cxl/list.c
index 8c48fbbaaec3..2026de2b548b 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -72,6 +72,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		"cxl list [<options>]",
 		NULL
 	};
+	struct json_object *jtopology;
 	int i;
 
 	argc = parse_options(argc, argv, options, u, 0);
@@ -140,5 +141,9 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.endpoints = true;
 
 	dbg(&param, "walk topology\n");
-	return cxl_filter_walk(ctx, &param);
+	jtopology = cxl_filter_walk(ctx, &param);
+	if (!jtopology)
+		return -ENOMEM;
+	util_display_json_array(stdout, jtopology, cxl_filter_to_flags(&param));
+	return 0;
 }

