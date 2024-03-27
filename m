Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F71514F4
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569158; cv=none; b=Y2HUomqvGDcxEyLeRoMWMwh37PBTVLGr+zav/XAk283nTisXYvXr6Gn/aoaBTHKhezvnld8U7AYu7+noZBXNloviDwnBNRe12lILIQKg8KtnxTmRg99joCx8PnoX/yq4hR6miuR8EXpvCXFqcCKEdLpfswO50yt8NH3guc0m+8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569158; c=relaxed/simple;
	bh=roIYcf7YeNI5tK4KPiAUUtFVUrvSOClHX7/lSK37xJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j0S6V+tCDMzUhsNZRXayttovQbj9gu/GlGJIVRSAfdLgTibfAgRd/4vUiS4j/rvq6sRwpxtuz3Tsc9qdjkugC//fLj8mLGVVtK5ZSzLorQ3C5KWjKwNvrKYeeOyO+vbrX1RbrLCHQQtWuD0eIB6OUGpGFTGh0hkDtdGBSivXhcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAqPk7uN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAqPk7uN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569157; x=1743105157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=roIYcf7YeNI5tK4KPiAUUtFVUrvSOClHX7/lSK37xJk=;
  b=PAqPk7uNcTuOSKGLMJHBepeOPdra4XTExZN7Q1IUJVpGBRihGP0cos0N
   8ugAfgzWc7HeBwD2IyphMOsdzPP9WwH8CeJkCliRDil7GtWnm86sJjTM0
   YM0uUGh9qY5YFev54q/VzUx/Q/744WbgfQryhvDq+u5sIWHJzSwTonFXs
   QRk5jmkDg6IPAMIaEugq6T/qZwruL4GKxRs0PPIM5JruWUBfJVsxc/14D
   GY4FvSjttd9Q1YmX6r4LKbDPxvRabhV7YA7oK/AJ4xJ98weskHINQjKIB
   LBnJW47b541YFycLTlCXXPZ0Z0+pYnQFc9gnOtgrxywl0oR2g38pgztoy
   g==;
X-CSE-ConnectionGUID: 4dFHsksKRPSFgsRRd0y8Mw==
X-CSE-MsgGUID: FyOVSLaKTBe3KTRVcmqxcA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560202"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560202"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616299"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:35 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v12 2/8] util/trace: add an optional pid check to event parsing
Date: Wed, 27 Mar 2024 12:52:23 -0700
Message-Id: <efabce2812206f59d85cfb0490e946a26d640713.1711519822.git.alison.schofield@intel.com>
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

When parsing events, callers may only be interested in events
that originate from the current process. Introduce an optional
argument to the event trace context: event_pid. When event_pid is
present, simply skip the parsing of events without a matching pid.
It is not a failure to see other, non matching events.

The initial use case for this is CXL device poison listings where
only the media-error records requested by this process are wanted.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 util/event_trace.c | 5 +++++
 util/event_trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/util/event_trace.c b/util/event_trace.c
index 16013412bc06..57318e2adace 100644
--- a/util/event_trace.c
+++ b/util/event_trace.c
@@ -214,6 +214,11 @@ static int event_parse(struct tep_event *event, struct tep_record *record,
 			return 0;
 	}
 
+	if (event_ctx->event_pid) {
+		if (event_ctx->event_pid != tep_data_pid(event->tep, record))
+			return 0;
+	}
+
 	if (event_ctx->parse_event)
 		return event_ctx->parse_event(event, record,
 					      &event_ctx->jlist_head);
diff --git a/util/event_trace.h b/util/event_trace.h
index 37c39aded871..6586e1dc254d 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
@@ -15,6 +15,7 @@ struct event_ctx {
 	const char *system;
 	struct list_head jlist_head;
 	const char *event_name; /* optional */
+	int event_pid; /* optional */
 	int (*parse_event)(struct tep_event *event, struct tep_record *record,
 			   struct list_head *jlist_head); /* optional */
 };
-- 
2.37.3

