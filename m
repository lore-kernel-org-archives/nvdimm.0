Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776B79EE
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389132; cv=none; b=Lsm60AE91UKJO7litUUHDgyW8ZKXLYv48Z9zXGiXVv3dWUSeBq+xSAyrP3yrpn80AcR0/uKarcy2ZnM0MW15dkky5T239dXCnEkKWy8I937BYAkNH3dyadS7i8WW7gROrGYmZFal1w0PdhkLGwSGQXwxMqM+gFfKbOd/iaKVFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389132; c=relaxed/simple;
	bh=f2uYpAZcM9h1Gz2rTb32ZN2hNmqJWyiUEWYb6QUeISY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BbVYB/x7hOYKG1Rb2pzUYbsLFJmV/iv2WCIF86iUvKML1jbYCMaFFEyyxcemCcBL19H7paOIOzlKSQNJi/g2sua3RD4yoBf34fC0ed+MBhMxOyniOrEa60CQjAoMpSaTKTy+2VFgWpp+b3j07ZVOOLPLEM6GutRuqrBtua3vHQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lANihWFn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lANihWFn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389131; x=1741925131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f2uYpAZcM9h1Gz2rTb32ZN2hNmqJWyiUEWYb6QUeISY=;
  b=lANihWFn/MPnWH1VpdROMiFe313s0ZTVvP3acbQUpFdApbWJoISJ/Qhe
   csR84hF9qzoPf5tnoPJOKTCrPLA4Gj9LkPpuh+vPi4lPLBAJLH7RCw2W2
   ct3KmNhw94jDYdJm1PnamRrFbLYvcZj0xYAyEeyX+ZYxJLV/115r4733c
   XYiBiYLEsrKTdwNyh7WpzC3T2ZO6IkrBLBqyhQA+tus3ZkgVtdwTA+bQo
   K71VjJ9JzQphwe0lBWSygvAl5UuS8DUD6i+6hawHnS4b/0aVXQHRyHjq3
   6NY+fJTsbXaYc7f/LzP0P0GbW4BP9eF8sVRG+YHchIPyUWUGMkDigUtLR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648803"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648803"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080689"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:30 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v11 4/7] cxl/event_trace: add helpers to retrieve tep fields by type
Date: Wed, 13 Mar 2024 21:05:20 -0700
Message-Id: <0dbf9557aaf5e8047440cb74f7df84ae404c11ba.1710386468.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1710386468.git.alison.schofield@intel.com>
References: <cover.1710386468.git.alison.schofield@intel.com>
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
---
 cxl/event_trace.c | 37 +++++++++++++++++++++++++++++++++++++
 cxl/event_trace.h |  8 +++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 640abdab67bf..324edb982888 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -15,6 +15,43 @@
 #define _GNU_SOURCE
 #include <string.h>
 
+u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
+		      const char *name)
+{
+	unsigned long long val;
+
+	if (tep_get_field_val(NULL, event, name, record, &val, 0))
+		return ULLONG_MAX;
+
+	return val;
+}
+
+u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
+		      const char *name)
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
+u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
+		    const char *name)
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
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index b77cafb410c4..7b30c3922aef 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -5,6 +5,7 @@
 
 #include <json-c/json.h>
 #include <ccan/list/list.h>
+#include <ccan/short_types/short_types.h>
 
 struct jlist_node {
 	struct json_object *jobj;
@@ -32,5 +33,10 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
 int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
 		const char *event);
 int cxl_event_tracing_disable(struct tracefs_instance *inst);
-
+u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
+		    const char *name);
+u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
+		      const char *name);
+u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
+		      const char *name);
 #endif
-- 
2.37.3

