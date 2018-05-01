Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA692203B8BFC
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 11:00:34 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/4] libndctl,
 inject: add 'v2' APIs for inject and uninject
Date: Tue,  1 May 2018 12:00:22 -0600
Message-Id: <20180501180023.30193-4-vishal.l.verma@intel.com>
In-Reply-To: <20180501180023.30193-1-vishal.l.verma@intel.com>
References: <20180501180023.30193-1-vishal.l.verma@intel.com>
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

In preparation for adding a saturate option, add two new APIs:

	ndctl_namespace_inject_error2
	ndctl_namespace_uninject_error2

The old APIs included a flag, such as 'notify' as an explicit part of
the API, thus limiting new flags/options. In hindsight, this was a
mistake, and should have been a flags field. Introduce the new v2 APIs
for injection and un-injection that fix this, and have a flags field.

Convert the users of the old API, i.e. ndctl/inject-error.c, to the new
API, and treat 'notify' as a flag everywhere.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-error.c   | 33 ++++++++++++++++++---------------
 ndctl/lib/inject.c     | 34 +++++++++++++++++++++++++---------
 ndctl/lib/libndctl.sym |  2 ++
 ndctl/libndctl.h       |  9 +++++++++
 4 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 32a58a5..e977136 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -54,8 +54,8 @@ static struct inject_ctx {
 	u64 block;
 	u64 count;
 	unsigned int op_mask;
-	unsigned long flags;
-	bool notify;
+	unsigned long json_flags;
+	unsigned int inject_flags;
 } ictx;
 
 #define BASE_OPTIONS() \
@@ -92,9 +92,9 @@ static int inject_init(void)
 {
 	if (!param.clear && !param.status) {
 		ictx.op_mask |= 1 << OP_INJECT;
-		ictx.notify = true;
+		ictx.inject_flags |= (1 << NDCTL_NS_INJECT_NOTIFY);
 		if (param.no_notify)
-			ictx.notify = false;
+			ictx.inject_flags &= ~(1 << NDCTL_NS_INJECT_NOTIFY);
 	}
 	if (param.clear) {
 		if (param.status) {
@@ -144,7 +144,7 @@ static int inject_init(void)
 	}
 
 	if (param.human)
-		ictx.flags |= UTIL_JSON_HUMAN;
+		ictx.json_flags |= UTIL_JSON_HUMAN;
 
 	return 0;
 }
@@ -152,14 +152,15 @@ static int inject_init(void)
 static int ns_errors_to_json(struct ndctl_namespace *ndns,
 		unsigned int start_count)
 {
-	unsigned long flags = ictx.flags | UTIL_JSON_MEDIA_ERRORS;
+	unsigned long json_flags = ictx.json_flags | UTIL_JSON_MEDIA_ERRORS;
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct json_object *jndns;
 	unsigned int count;
 	int rc, tmo = 30;
 
 	/* only wait for scrubs for the inject and notify case */
-	if ((ictx.op_mask & (1 << OP_INJECT)) && ictx.notify) {
+	if ((ictx.op_mask & (1 << OP_INJECT)) &&
+			(ictx.inject_flags & (1 << NDCTL_NS_INJECT_NOTIFY))) {
 		do {
 			/* wait for a scrub to start */
 			count = ndctl_bus_get_scrub_count(bus);
@@ -177,7 +178,7 @@ static int ns_errors_to_json(struct ndctl_namespace *ndns,
 		}
 	}
 
-	jndns = util_namespace_to_json(ndns, flags);
+	jndns = util_namespace_to_json(ndns, json_flags);
 	if (jndns)
 		printf("%s\n", json_object_to_json_string_ext(jndns,
 				JSON_C_TO_STRING_PRETTY));
@@ -185,7 +186,7 @@ static int ns_errors_to_json(struct ndctl_namespace *ndns,
 }
 
 static int inject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
-		bool notify)
+		unsigned int flags)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	unsigned int scrub_count;
@@ -197,7 +198,7 @@ static int inject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
 		return -ENXIO;
 	}
 
-	rc = ndctl_namespace_inject_error(ndns, offset, length, notify);
+	rc = ndctl_namespace_inject_error2(ndns, offset, length, flags);
 	if (rc) {
 		fprintf(stderr, "Unable to inject error: %s (%d)\n",
 			strerror(abs(rc)), rc);
@@ -207,11 +208,12 @@ static int inject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
 	return ns_errors_to_json(ndns, scrub_count);
 }
 
-static int uninject_error(struct ndctl_namespace *ndns, u64 offset, u64 length)
+static int uninject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
+		unsigned int flags)
 {
 	int rc;
 
-	rc = ndctl_namespace_uninject_error(ndns, offset, length);
+	rc = ndctl_namespace_uninject_error2(ndns, offset, length, flags);
 	if (rc) {
 		fprintf(stderr, "Unable to uninject error: %s (%d)\n",
 			strerror(abs(rc)), rc);
@@ -254,7 +256,7 @@ static int injection_status(struct ndctl_namespace *ndns)
 
 		block = ndctl_bb_get_block(bb);
 		count = ndctl_bb_get_count(bb);
-		jbb = util_badblock_rec_to_json(block, count, ictx.flags);
+		jbb = util_badblock_rec_to_json(block, count, ictx.json_flags);
 		if (!jbb)
 			break;
 		json_object_array_add(jbbs, jbb);
@@ -280,13 +282,14 @@ static int err_inject_ns(struct ndctl_namespace *ndns)
 	while (op_mask) {
 		if (op_mask & (1 << OP_INJECT)) {
 			rc = inject_error(ndns, ictx.block, ictx.count,
-				ictx.notify);
+				ictx.inject_flags);
 			if (rc)
 				return rc;
 			op_mask &= ~(1 << OP_INJECT);
 		}
 		if (op_mask & (1 << OP_CLEAR)) {
-			rc = uninject_error(ndns, ictx.block, ictx.count);
+			rc = uninject_error(ndns, ictx.block, ictx.count,
+				ictx.inject_flags);
 			if (rc)
 				return rc;
 			op_mask &= ~(1 << OP_CLEAR);
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 2865a7d..5cffe53 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -117,7 +117,7 @@ static int ndctl_namespace_get_clear_unit(struct ndctl_namespace *ndns)
 }
 
 static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
-		unsigned long long block, bool notify)
+		unsigned long long block, unsigned int flags)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -147,7 +147,7 @@ static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
 	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
 	err_inj->err_inj_spa_range_base = offset;
 	err_inj->err_inj_spa_range_length = length;
-	if (notify)
+	if (flags & (1 << NDCTL_NS_INJECT_NOTIFY))
 		err_inj->err_inj_options |=
 			(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
 
@@ -162,8 +162,9 @@ static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
 	return rc;
 }
 
-NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
-		unsigned long long block, unsigned long long count, bool notify)
+NDCTL_EXPORT int ndctl_namespace_inject_error2(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		unsigned int flags)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -176,7 +177,7 @@ NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
 		return -EOPNOTSUPP;
 
 	for (i = 0; i < count; i++) {
-		rc = ndctl_namespace_inject_one_error(ndns, block + i, notify);
+		rc = ndctl_namespace_inject_one_error(ndns, block + i, flags);
 		if (rc) {
 			err(ctx, "Injection failed at block %llx\n",
 				block + i);
@@ -186,8 +187,15 @@ NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
 	return rc;
 }
 
+NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count, bool notify)
+{
+	return ndctl_namespace_inject_error2(ndns, block, count,
+		notify ? (1 << NDCTL_NS_INJECT_NOTIFY) : 0);
+}
+
 static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
-		unsigned long long block)
+		unsigned long long block, unsigned int flags)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -230,8 +238,9 @@ static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
 	return rc;
 }
 
-NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
-		unsigned long long block, unsigned long long count)
+NDCTL_EXPORT int ndctl_namespace_uninject_error2(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		unsigned int flags)
 {
 	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -244,7 +253,8 @@ NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
 		return -EOPNOTSUPP;
 
 	for (i = 0; i < count; i++) {
-		rc = ndctl_namespace_uninject_one_error(ndns, block + i);
+		rc = ndctl_namespace_uninject_one_error(ndns, block + i,
+			flags);
 		if (rc) {
 			err(ctx, "Un-injection failed at block %llx\n",
 				block + i);
@@ -254,6 +264,12 @@ NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
 	return rc;
 }
 
+NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count)
+{
+	return ndctl_namespace_inject_error2(ndns, block, count, 0);
+}
+
 static int bb_add_record(struct list_head *h, u64 block, u64 count)
 {
 	struct ndctl_bb *bb, *bb_iter, *bb_next, *bb_prev;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 92822be..c1228e5 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -363,4 +363,6 @@ global:
 LIBNDCTL_16 {
 global:
 	ndctl_cmd_ars_cap_get_clear_unit;
+	ndctl_namespace_inject_error2;
+	ndctl_namespace_uninject_error2;
 } LIBNDCTL_15;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 74fe0f4..a001271 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -479,9 +479,18 @@ int ndctl_namespace_get_numa_node(struct ndctl_namespace *ndns);
 int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
 		unsigned long long block, unsigned long long count,
 		bool notify);
+int ndctl_namespace_inject_error2(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		unsigned int flags);
 int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
 		unsigned long long block, unsigned long long count);
+int ndctl_namespace_uninject_error2(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		unsigned int flags);
 int ndctl_namespace_injection_status(struct ndctl_namespace *ndns);
+enum ndctl_namespace_inject_flags {
+	NDCTL_NS_INJECT_NOTIFY = 0,
+};
 
 struct ndctl_bb;
 unsigned long long ndctl_bb_get_block(struct ndctl_bb *bb);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
