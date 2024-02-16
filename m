Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D7A12E74
	for <nvdimm@lists.linux.dev>; Fri, 16 Feb 2024 06:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708063577; cv=none; b=e7YiuI7ckiEMtha66JT9aenOGFqxXcQBa+P92W4Nm8MD0qMHV9NE4awzWp+qWLlqsVrldPZxU8zhswCvPb7Fs4GkncSIY1fGXiKTXcMyn3TL4dSFWc7rDM57cpbq6yLK89pgEysx2sRAU0F5b8jGnk9vKtutGa10KOhEHZyIf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708063577; c=relaxed/simple;
	bh=0RHZFSNQ1BMP7jyKeAZvbEHNEbnFayAYLabALwJTlEo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PHJsJtUhXAU0A6YGAXsQl5QL64nctM6BjLh1wXIUV//u0q4uo7cerOyAgDIrbhCAQJ/SauO1xPUKecYVDBndixEVtEbGp682jdow3ooBkfjYL5aRO3DnjVQIIcjFF+7gWRqpXREXQoudw5PZAxZUniT3E8QFMmPVv6fSPT/q/Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=klmuYKgt; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="klmuYKgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708063575; x=1739599575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0RHZFSNQ1BMP7jyKeAZvbEHNEbnFayAYLabALwJTlEo=;
  b=klmuYKgtn3C81CnK6rohEi2Dd+/HGxjT9udEfyGDprpDfU/zaNaPp+hM
   W5MV9D0weDuAutsJ9icHT3GKkj/Gks7C5lCzxxl9VAhysW1B497toy+W9
   L9JFaVVDoo7nfuHpeDT3CvXE4pxUkDApQNXmZQVXMUEeGWc//6B141WP+
   iSsUr0JF+tCfKND2d2rCmYvgjr8ksWPBM8ENPT9O1ffWmFsA1yjb5f2gp
   EJNZC9yaIzjcev+tFfBHNABzaT5VYbk4H3x6wq446AQ5kfcRgjaDC0L66
   lJxQYSAZDqvanULRt52SkX3Hk4KTNbqIGB6Z+rJhPhnRaKQCbE1j52IxD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="19705594"
X-IronPort-AV: E=Sophos;i="6.06,163,1705392000"; 
   d="scan'208";a="19705594"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 22:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,163,1705392000"; 
   d="scan'208";a="4116556"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.94.63])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 22:06:14 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [ndctl PATCH] cxl/event_trace: parse arrays separately from strings
Date: Thu, 15 Feb 2024 22:06:10 -0800
Message-Id: <20240216060610.1951127-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Arrays are being parsed as strings based on a flag that seems like
it would be the differentiator, ARRAY and STRING, but it is not.

libtraceevent sets the flags for arrays and strings like this:
array:  TEP_FIELD_IS_[ARRAY | STRING]
string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]

Use TEP_FIELD_IS_DYNAMIC to discover the field type, otherwise arrays
get parsed as strings and 'cxl monitor' returns gobbledygook in the
array type fields.

This fixes the "data" field of cxl_generic_events and the "uuid" field
of cxl_poison.

Before:
{"system":"cxl","event":"cxl_generic_event","timestamp":3469041387470,"memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-abcd-efeb-a55a-a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_handle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0,"data":"Þ­¾ï"}

After:
{"system":"cxl","event":"cxl_generic_event","timestamp":312851657810,"memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-abcd-efeb-a55a-a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_handle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0,"data":[222,173,190,239,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}

Before:
{"system":"cxl","event":"cxl_poison","timestamp":3292418311609,"memdev":"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"region5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length":64,"uuid":"�Fe�c�CI�����2�]","source":0,"flags":0}

After:
{"system":"cxl","event":"cxl_poison","timestamp":94600531271,"memdev":"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"region5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length":64,"uuid":[139,200,184,22,236,103,76,121,157,243,47,110,243,11,158,62],"source":0,"flags":0}

That cxl_poison uuid format can be further improved by using the trace
type (__field_struct uuid_t) in the CXL kernel driver. The parser will
automatically pick up that new type, as illustrated in the "hdr_uuid"
of cxl_generic_media event trace above.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/event_trace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index db8cc85f0b6f..1b5aa09de8b2 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -109,7 +109,13 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
 		struct tep_format_field *f = fields[i];
 		int len;
 
-		if (f->flags & TEP_FIELD_IS_STRING) {
+		/*
+		 * libtraceevent differentiates arrays and strings like this:
+		 * array:  TEP_FIELD_IS_[ARRAY | STRING]
+		 * string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]
+		 */
+		if ((f->flags & TEP_FIELD_IS_STRING) &&
+		    ((f->flags & TEP_FIELD_IS_DYNAMIC))) {
 			char *str;
 
 			str = tep_get_field_raw(NULL, event, f->name, record, &len, 0);

base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

