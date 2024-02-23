Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81DCBE6F
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654552; cv=none; b=U4RGuqOwsWzi0WjuY/ll6xONbtga9n4rZFUk8IM7orAbNUuRbO7iXhG9xWlOvY1DZlMWRvJTTZhWwf7xkPt25PSvFPWoMhkqjYqmwINNX3KL0VR+v6FJMGAzPE9D/n7IxzhFH/EJe4HsyJxjrXROnid5VhHFUOVyxMJQ+X7AjkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654552; c=relaxed/simple;
	bh=03nNMcoFPn8wAKY2CXwt0qaGCgnWQ87C8p+I43b3mBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JImKsfBO7MSSo773PSdtHTZmtBO9b+8j4GcU/cJRIjLb+mQxbAJVJMmCW78B5XM4qqr9WOi6NdAKm1FaisOPaYO9cysy9v0rmnqkyn4KABMrO4+W026kVMi04cgr+EED0DGlvIapt6DjBG4bsR3aoV+Gf9Y/dPipPeHzphMDreI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AnN2fCKs; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AnN2fCKs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654550; x=1740190550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=03nNMcoFPn8wAKY2CXwt0qaGCgnWQ87C8p+I43b3mBA=;
  b=AnN2fCKsON8Z+GlNTE7TegRE+4Y7NRQZdzsIYnSr3euR1yAYWurJORL0
   AV2hupEZ1/bvxacdNcnKB8d3w+ugRJk+xnBj9z8d/Wb/GoT2sHjpSkXhL
   j7IK5pkcCGRS0/HcdhKl6P8+YREZswwd9vROcvX6N0rfiGN5DRi83ECC+
   fXTdN5fRoXtMVjio5EVTmUcLTajgQEwNVrPsmap1DStropcreR5aHjacE
   b2mRfROOGNXW383sZ1IbCu3ztpPtS91P6BUJgblJHxWk2aWEDPTNXH15Z
   KnpIXUafv/HCa8E9jHw4um9U81H8JeGi5AN3vU+rv2GO2/mdjcC07sClZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364249"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364249"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410134"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:50 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 4/7] cxl/event_trace: add helpers get_field_[string|data]()
Date: Thu, 22 Feb 2024 18:15:41 -0800
Message-Id: <f7f5028564b89a292a11ad4478259fcd132cebfa.1708653303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708653303.git.alison.schofield@intel.com>
References: <cover.1708653303.git.alison.schofield@intel.com>
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

