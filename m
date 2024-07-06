Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2D41C2AD
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247104; cv=none; b=DeIvlKnfRrIVnhyB/OaPI8zkl3RQunfa/hy4clS7ZoP5zdhLim58NtZ+XaqRFMRZK+zyDF9lbv4u5m7lmOyd/YA+uKbKLD5qVzzVzI9nZuRUunv+HrAknxPeM73PL+MaI/EpJ6+zTg0PhxUxgXK00hBwW/QLyz/FMGgLC4+fLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247104; c=relaxed/simple;
	bh=hvKg/t3CyFdt16dcyKFhlzMVaWxFkrYEOsQBvf3o8zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgpt50Iro9d27oCHZlJWqXfc0o/UmksvZ6XWngZD8LWJo0NxEC+v3QCVPfMV/zWOEWSxt52eFbBGZkZo/YEhFDMox2/NZv+qOoZ0WpARLjemNqOrDQBOfAT9P9IsBHA6b24g8KCY2rbA0AweWTSatN03RsCqJrC6Rkc9QPSvxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c4OnQmWw; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c4OnQmWw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247103; x=1751783103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hvKg/t3CyFdt16dcyKFhlzMVaWxFkrYEOsQBvf3o8zc=;
  b=c4OnQmWwRUF47TySgYivOfLz2DyocQaT4nC5IMa77zCHEKu/7iY+G+xR
   OXxkH8IB6iNgi8bvdMO9/y/XUxHI9tDXQWf9YHK8diH601W5bIeAHFv9C
   9h6BqZSPFiun9a4Psel5dJ7M+aiZnqpt9Rew8AC6qUorjARmq9GIvZbN6
   2g1XF+pL1JNi2F4FJkN5OO5R4YEFos2YWlP6mIXA+WXjZ2zxDhQ2UuTP1
   InUHbDzStManKAkfrbgXDfllkTMgHoRpQ4W142b2zNB24Adm1rpo5cDpp
   NDUr34ct9j+HOVl21anqZD0Lgj0QbtIPVxPAbLF5SqYSpXc0PTOe2usVL
   w==;
X-CSE-ConnectionGUID: BGSpxP8pThCnpT3fkCpplQ==
X-CSE-MsgGUID: u507xjwERX2eucqhJe/vgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166939"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166939"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:02 -0700
X-CSE-ConnectionGUID: WzvvE/ijQqudln6JSfnsZA==
X-CSE-MsgGUID: FPz/UGr/Rsa4ES7I/41QmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172519"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:02 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [ndctl PATCH v13 4/8] util/trace: add helpers to retrieve tep fields by type
Date: Fri,  5 Jul 2024 23:24:50 -0700
Message-Id: <b6089a98199539eca9c89f81de19cede18468408.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1720241079.git.alison.schofield@intel.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
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
of the field and simply needs to get it. The helpers also return
the 'type'_MAX of the type when the field is

Since this is in preparation for adding a cxl_poison private parser
for 'cxl list --media-errors' support those specific required
types: u8, u32, u64.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
---
 util/event_trace.c | 37 +++++++++++++++++++++++++++++++++++++
 util/event_trace.h |  8 +++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/util/event_trace.c b/util/event_trace.c
index 1f5c180a030b..bde3a76adfbf 100644
--- a/util/event_trace.c
+++ b/util/event_trace.c
@@ -15,6 +15,43 @@
 #define _GNU_SOURCE
 #include <string.h>
 
+u64 trace_get_field_u64(struct tep_event *event, struct tep_record *record,
+			const char *name)
+{
+	unsigned long long val;
+
+	if (tep_get_field_val(NULL, event, name, record, &val, 0))
+		return ULLONG_MAX;
+
+	return val;
+}
+
+u32 trace_get_field_u32(struct tep_event *event, struct tep_record *record,
+			const char *name)
+{
+	char *val;
+	int len;
+
+	val = tep_get_field_raw(NULL, event, name, record, &len, 0);
+	if (!val)
+		return UINT_MAX;
+
+	return *(u32 *)val;
+}
+
+u8 trace_get_field_u8(struct tep_event *event, struct tep_record *record,
+		      const char *name)
+{
+	char *val;
+	int len;
+
+	val = tep_get_field_raw(NULL, event, name, record, &len, 0);
+	if (!val)
+		return UCHAR_MAX;
+
+	return *(u8 *)val;
+}
+
 static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
 {
 	bool sign = flags & TEP_FIELD_IS_SIGNED;
diff --git a/util/event_trace.h b/util/event_trace.h
index 9c53eba7533f..4d498577a00f 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
@@ -5,6 +5,7 @@
 
 #include <json-c/json.h>
 #include <ccan/list/list.h>
+#include <ccan/short_types/short_types.h>
 
 struct jlist_node {
 	struct json_object *jobj;
@@ -24,5 +25,10 @@ int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx);
 int trace_event_enable(struct tracefs_instance *inst, const char *system,
 		       const char *event);
 int trace_event_disable(struct tracefs_instance *inst);
-
+u8 trace_get_field_u8(struct tep_event *event, struct tep_record *record,
+		      const char *name);
+u32 trace_get_field_u32(struct tep_event *event, struct tep_record *record,
+			const char *name);
+u64 trace_get_field_u64(struct tep_event *event, struct tep_record *record,
+			const char *name);
 #endif
-- 
2.37.3

