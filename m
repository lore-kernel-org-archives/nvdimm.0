Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91A713E7C0
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750554; cv=none; b=InL4HhsFOfu/nmf/QSQRI2N3qwjoPzaEGNxNgnmV5hfcVKaLiTsrA6LyPVQo6IsDJhRVPeTDJWqzyd313HKzUjpgv4VTUH+OPZ2eTj2/uEQrVvLsD4LflTbf8qEu5QqPIELVtfNxxwELmYUZKHVzWMNmyWTxtppseJrbYFegSKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750554; c=relaxed/simple;
	bh=p8rV7ixS6CdG+oryCs0HOp9CyxgH1ZyvlwmJtf0Zf24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LqgUlhfNUqw+MMbHK8npi+DnzxQh3Dw5dvw5Giaj+W4bM5hK0LjGer9TAoIQTOgC4fgXLBIrONycPwx7kPmcWLvSZJeEeFZ4I46mmtXNGJ2TPX2zXqRBLgJ53PSShQA4S8RQRpQXFO4vHTk6GWwGKRefyBJ+OgQTeZ3yzrfmn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1y8CpV8; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1y8CpV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750553; x=1741286553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p8rV7ixS6CdG+oryCs0HOp9CyxgH1ZyvlwmJtf0Zf24=;
  b=e1y8CpV8RVZjUShJ27lkpYrphQID0txrq1UsO/AQSaXooYOThnJz3PHc
   YEKms3i1RoKHdRTkGK/kWnohReHoXY1lAkOwE1pMRMB0/BnM/fVsx+TzB
   396sVKIsaDV1EmvbFvMtgeeMv1CibownjdlrwZ+NCaowRH+rNiO2aW3jk
   K0Kzgu8YUsjTi+4t7tYjAj4Bw1kJEsN68d3nZbVD5JUeHpQ9TijE8H9gY
   Ocewx4LHXSc87r5ghJDeyZy6n1KTfAQqED8Vlez1CcVFGniSCEl/MlWbJ
   CrSTDKlfbqvqiKGkVmc/FdmaFozmhUDTou9jpLEOn9kvEuhnMPXU03JcQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819828"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819828"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925973"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:32 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v10 4/7] cxl/event_trace: add helpers to retrieve tep fields by type
Date: Wed,  6 Mar 2024 10:42:23 -0800
Message-Id: <3d264f1fe4c92a90eabf9cd3365a2dc69caacc4e.1709748564.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709748564.git.alison.schofield@intel.com>
References: <cover.1709748564.git.alison.schofield@intel.com>
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
of the field and simply needs to get it.

Since this is in preparation for adding a cxl_poison private parser
for 'cxl list --media-errors' support, add those specific required
types: u8, u32, u64, char*

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 cxl/event_trace.h | 10 ++++++-
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index bdad0c19dbd4..6cc9444f3204 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -15,6 +15,81 @@
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
+u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
+		      const char *name)
+{
+	struct tep_format_field *f;
+	unsigned char *val;
+	int len;
+
+	f = __find_field(event, name);
+	if (!f)
+		return ULLONG_MAX;
+
+	val = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
+	if (!val)
+		return ULLONG_MAX;
+
+	return *(u64 *)val;
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
+u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
+		      const char *name)
+{
+	char *val;
+
+	val = cxl_get_field_string(event, record, name);
+	if (!val)
+		return UINT_MAX;
+
+	return *(u32 *)val;
+}
+
+u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
+		    const char *name)
+{
+	char *val;
+
+	val = cxl_get_field_string(event, record, name);
+	if (!val)
+		return UCHAR_MAX;
+
+	return *(u8 *)val;
+}
+
 static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
 {
 	bool sign = flags & TEP_FIELD_IS_SIGNED;
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index ec61962abbc6..bbdea3b896e0 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -5,6 +5,7 @@
 
 #include <json-c/json.h>
 #include <ccan/list/list.h>
+#include <ccan/short_types/short_types.h>
 
 struct jlist_node {
 	struct json_object *jobj;
@@ -25,5 +26,12 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
 int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
 		const char *event);
 int cxl_event_tracing_disable(struct tracefs_instance *inst);
-
+char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
+			   const char *name);
+u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
+		    const char *name);
+u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
+		      const char *name);
+u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
+		      const char *name);
 #endif
-- 
2.37.3

