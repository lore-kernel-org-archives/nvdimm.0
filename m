Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3774E2EB0A
	for <nvdimm@lists.linux.dev>; Fri,  1 Mar 2024 01:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709256689; cv=none; b=ERaQrD+3fZY3gnaYxLiUAnSYtaFWW1aLMySpknjsgtByURYkldttA8o2ICREX1MAnu8ADacgbgGVZUiLKR8DkqDoPJjynDKpWTlk9wW/hLFkAwHwr9xazYh+G40NDKZSf4jG9VzZd0PuJkREj+UYZP9GaxaCT2uo8yLexdKXU+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709256689; c=relaxed/simple;
	bh=QElUwcVcnupUzTNc63llCO99K2zvT6wzcdjAx4LIt9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dIHL7hk0hinAw8iULSeAKvbmu8hQDLZoE+reXWTUr0aC2R4WJiWmxI5Y0i+t5RHzMLnJdqs45fWoxdAf9VHDaxvvrHj8rXf8FLVgqOim944Ay7iUfG5CZ44dUiOPKoNEHUvyaGtT8iU2wRRpH1nHOoX+Bvg195DjX/kD+sJV2vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APgNJJxF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APgNJJxF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709256688; x=1740792688;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QElUwcVcnupUzTNc63llCO99K2zvT6wzcdjAx4LIt9o=;
  b=APgNJJxFKBTurAaX64NQJKtxXMPyIUZVx7c2wQaMC3wygYc299FKBFc9
   nk9x4PsbeNPDNFDpvyewdXOoFcaASRBDsv9JG2ouu4QcGtCdgDq5+TyoO
   9O3H4uuhfjgevO9kEHPZYqgk3+2oKkAWpc8PJ20675q7NMxDb1AzKqJ00
   EtVC67e39dOKKk9y5zj2C63CThlC2j8MHALkVRfWhfZcGeGsZUUEBg5qX
   tbODS0XZDQqS8iYsaCyqiRGAYbdMfWKR6IDh7Dt82iPvOjsrdLbMW+aH/
   OME+CnFB4emuAbM7baZGcvcICoR9caMBIndNzA0KrLlXeTv2Yvt9F/lzx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14343115"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="14343115"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7952670"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.136.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:27 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v9 4/7] cxl/event_trace: add helpers to retrieve tep fields by type
Date: Thu, 29 Feb 2024 17:31:19 -0800
Message-Id: <6e07b4ceb01a56aa6791749709c2bf311bb91e1d.1709253898.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709253898.git.alison.schofield@intel.com>
References: <cover.1709253898.git.alison.schofield@intel.com>
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

