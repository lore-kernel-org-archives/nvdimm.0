Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB42395
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 00:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705537699; cv=none; b=lR0ffhoQ7n2PMASU/gLzwktniQPfQ15NdDT0VMtddlT4QHqMCeUxLskYNc25L86/yWD/ArAEaJdDk+9KoGSg+GGdWAIeXRtwlrpdgiMZl1Tod7X1jOUYclJNRKg8hxxZMf2y+NDWj15BtNvHVj/WzvHeWvjRpmB1ocXgeZELCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705537699; c=relaxed/simple;
	bh=uxHOPpz1DJf7BmotOR7X3I+QbjiBrrlrJ40kvd+VEdA=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=adp6rUNXPgT54sxaLC4ylfBQ3FiDuZF3zt06Y1/yFq/FpVhKWubFZD0/wQeYHPKscQLAmqy3CstQ6VrX3m2N4EbLd4whYymV/2N+UMQZ/0LYkHdwvXpSNfdBRII3nEYeQBCkRks9WG81ffU++XtsUT2yHrB7xi2/3xiNe+xsT4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oBAuH5e0; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oBAuH5e0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705537698; x=1737073698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uxHOPpz1DJf7BmotOR7X3I+QbjiBrrlrJ40kvd+VEdA=;
  b=oBAuH5e0R4yx1+dv9FPjgJ68zo0J52PW+1JdnGHEgqo5ve54YgGPlVVC
   gAJ/W9ZhzZQ3ElDpiVIt7I7ffW/ASdScDhlUMd5O9e97sdK44niKo8/nk
   JzgJG/0MwOSB2hMlowICVqkv541Br01JfQhShDVg5dRF+GtgcAH9diTaV
   soaPkqkt9yP7DTCEmm+X53qqRR4ojxiTAyw1cLn5EuifQPcG9vnI1NtJ8
   LCA+bNcqbcs4glklhy/FWA+D2Py+P8ZgeepAKAlWz/Tf7aF1Db81ini3C
   8WvvqrWPPZHQJVhe5OUWtsLkitYpZstXnlHpZb+jGgoHGWkY+uQAyZaZm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18904550"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18904550"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777577228"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777577228"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.110.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:16 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v6 4/7] cxl/event_trace: add helpers get_field_[string|data]()
Date: Wed, 17 Jan 2024 16:28:03 -0800
Message-Id: <a4e63238ba2137f4a4b69d2c21c67badec15a659.1705534719.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1705534719.git.alison.schofield@intel.com>
References: <cover.1705534719.git.alison.schofield@intel.com>
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

