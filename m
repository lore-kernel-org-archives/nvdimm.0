Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC33152526
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569160; cv=none; b=hiv8RmRt3e43BnaRxLOWhlvb8nT2oFrnNuFVNA9m1oHAK3McHpsE9LPoqD/i2yUzmErvEfOfxjNXM5ZQyQfLB4MUVJLpK2vnM6ON92e5Bc+oTi9VWBgudGjuma5KJUceyopfBFFGJI7wP182IW9kpM+3y5Asahn6r4WKiWsu3Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569160; c=relaxed/simple;
	bh=hvKg/t3CyFdt16dcyKFhlzMVaWxFkrYEOsQBvf3o8zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ijhg6ruUqQ6Mekb7HquPTnl/wf8dV/VC9wt/R7A39URyBpSidezzGXhAJKKOUr7pz5Q8KWQyaCtamA/VQuzTXArUFaNo9Nou7Me24HGI0awJTKe3UvCWuD8h22rLFBjzly18wF6YQmIbRkEPp1z5QrpTqnB3QS93Ong91ai75qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AEb0W2sa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AEb0W2sa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569159; x=1743105159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hvKg/t3CyFdt16dcyKFhlzMVaWxFkrYEOsQBvf3o8zc=;
  b=AEb0W2sa2oQdJNC5YCTlimKthFZmdJVxqYPyyrCzSrAcTAAfYGaR4TzV
   Q7VV0rm5rmU5Ze4/OXwxmiRdO8UyFNKE/oGWWyg8avcL7BSYajTl5xpgE
   LFhIHgFjVYQJdgNcqrnlqIx85E3G/PVQ4FAZFaLpkZ68SeabrFqyEVUak
   VNBacj4Pw7drCulOhxG/oAuWAsj51FrYaLgq18VtSbA7kgk+iVQXiv1O4
   1qN9OY9n56wEgEIB+iZ4vLPBk5H0+nEQSaFs1qq7hml4dQrT8EC4pfeUj
   JMErYK8tXTcA4jnRNVVZsuw2Xryb4OVthANWPXSMKfkAhiyFPkvtcmt2n
   A==;
X-CSE-ConnectionGUID: yMhVml3/Tba4HoJ9nga8FA==
X-CSE-MsgGUID: bn0hJS3BQVWf1S6VusnABA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560213"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560213"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616313"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:37 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [ndctl PATCH v12 4/8] util/trace: add helpers to retrieve tep fields by type
Date: Wed, 27 Mar 2024 12:52:25 -0700
Message-Id: <4a484a14d985cf31808c7f7cb75b04e894d973ab.1711519822.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1711519822.git.alison.schofield@intel.com>
References: <cover.1711519822.git.alison.schofield@intel.com>
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

