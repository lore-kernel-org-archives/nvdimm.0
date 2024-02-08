Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64912E7C
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 01:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707354129; cv=none; b=WLw34OlapI0gTE0CA0SBmtFNjfri9KCX9iuVkmgiS0A1zj/ok1eYEooaHE4EwGsKOyV4PHMNHU0ZTC9HG2kU7xNv6HQ5Zbv/s7Lo93rVNE2uM4y0M/qY1B3S5CkHXH5vydqEb5hfPRoopfgkHlljkkR/v7uGEVqMBiff69w5ZAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707354129; c=relaxed/simple;
	bh=03nNMcoFPn8wAKY2CXwt0qaGCgnWQ87C8p+I43b3mBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rMD30xPeF72Y4HARdMeuf4qfXMyozBPr9eLPWIo5bRMs8/CkaVTmuPNF7JOR89M5DyZoPvh1t+F9D7LXdRiMpyC0Ruh0shJemmtH/KItwXfay4HSS3QLhqOKaekB4Ma5WItXd8uI55/gqBs35gfYYhcuP99UIiGQMoW6xf9i4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMcZpYYc; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMcZpYYc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707354128; x=1738890128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=03nNMcoFPn8wAKY2CXwt0qaGCgnWQ87C8p+I43b3mBA=;
  b=lMcZpYYcada3gpEyhKS18+GvvgOuQbnsrdfnzHbc8bG+mXrfC6XWKO2X
   urgda27Cl1/C3UEC+BlUsVRSiMoCqhzjk0XyAw8ToZLXlZO/a6MpN0JJS
   TCWnqbJOP74E4IJ+NO6umUpRH+TdcSiKieXOseZyqtyG9g7rCynofwCsX
   hA0uWVi3G+AUZEF7PIBcl9vPaLDqSPgphwkjLOKRgqr5jB0fKlCn913K1
   aDvhA00xGP2Aha2x9umS7pr2yhiQxl9xCTermRccmuOdexstpJSf8duBw
   ADeKYSCzYiF5VXRMhBl8m6X/l4Fa+vJpVhPKrG+/xmfmBA6ZPuSM6ym9r
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="18629910"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="18629910"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1529281"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.105.224])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:51 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v7 4/7] cxl/event_trace: add helpers get_field_[string|data]()
Date: Wed,  7 Feb 2024 17:01:43 -0800
Message-Id: <56096cb08363c5743793211b77e52645efdcb1a9.1707351560.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1707351560.git.alison.schofield@intel.com>
References: <cover.1707351560.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Add helpers to extract the value of an event record field given the
field name. This is useful when the user knows the name and format
of the field and simply needs to get it. Add signed and unsigned
char* versions to support string and u64 data fields.

This is in preparation for adding a private parser of cxl_poison
events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/event_trace.h |  5 ++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index fbf7a77235ff..8d04d8d34194 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -15,6 +15,52 @@
 #define _GNU_SOURCE
 #include <string.h>
 
+static struct tep_format_field *__find_field(struct tep_event *event,
+					     const char *name)
+{
+	struct tep_format_field **fields;
+
+	fields = tep_event_fields(event);
+	if (!fields)
+		return NULL;
+
+	for (int i = 0; fields[i]; i++) {
+		struct tep_format_field *f = fields[i];
+
+		if (strcmp(f->name, name) != 0)
+			continue;
+
+		return f;
+	}
+	return NULL;
+}
+
+unsigned char *cxl_get_field_data(struct tep_event *event,
+				  struct tep_record *record, const char *name)
+{
+	struct tep_format_field *f;
+	int len;
+
+	f = __find_field(event, name);
+	if (!f)
+		return NULL;
+
+	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+}
+
+char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
+			   const char *name)
+{
+	struct tep_format_field *f;
+	int len;
+
+	f = __find_field(event, name);
+	if (!f)
+		return NULL;
+
+	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+}
+
 static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
 {
 	bool sign = flags & TEP_FIELD_IS_SIGNED;
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index ec61962abbc6..6252f583097a 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -25,5 +25,8 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
 int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
 		const char *event);
 int cxl_event_tracing_disable(struct tracefs_instance *inst);
-
+char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
+		const char *name);
+unsigned char *cxl_get_field_data(struct tep_event *event,
+		struct tep_record *record, const char *name);
 #endif
-- 
2.37.3

