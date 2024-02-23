Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAD5BA5F
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654550; cv=none; b=AexDgLZTYlZ4bfvKjVz0+Srec0iRaOcTT7xNMtF18eIRJTQjml9DbPJ3mq9Vh2+w8CG6IhJ7u6zHz+4yr4rduU3DgCAtdeLzANgCARdolrMdsKzAPScu/i/Alb0LEwVkB9Q9B2oLU02OhMuFNJj1rbQNr2QrgOkOzZoJrQUncew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654550; c=relaxed/simple;
	bh=sg75Nzd0Nfpa+tECk4dpxR+hOqypAdcjo1sTuoZWf9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nhdAznf+K8TKh4axtQXKD4ZMZ+Md3mRL0irW7uyaz7r+JRFmKw/yQeoQoxv/il7HwhDI9NDZJ7jCvMpNHq+tuLqGB+0U9OVrWUtnoKvUCY2Nms+I5+kpT75jHNGmE41snTbw+gcAiCyjUEwicfQKzF7iZFLcCw3RYtASyVZ+S4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYlaJLLN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYlaJLLN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654549; x=1740190549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sg75Nzd0Nfpa+tECk4dpxR+hOqypAdcjo1sTuoZWf9Q=;
  b=JYlaJLLN4yAQcUuGqaffbBluqqhPlumAucQ1ggl4zrDWcWuRYjCaBBX4
   c9VSGPcL3KFHOU7cpLdIBXs2o27Ppq4K68/mTVuCeOvi9vsbFW6L3nZeO
   iKwoCZ9lEDKSM/ZASGa94tfb9IeFyrpSyK1psyT2oC4WVSpt+DCIbU/3X
   IduvwxcXqj0dpRjH9B1yVhKFgLeih+87Ty5qZTWGShvEx1kjDRMZOFkAE
   rjTZwDj/6pIj9j/eh6tFI7f6AIgNZeZgpG2hU3bBHNkB5b4q4xIh31weF
   j61rpMDnxWJMxHoYBYQOCHlpE2/YO8Cn3rqGvr5MSMIKHrrXUxk/Wkiou
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364243"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364243"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410100"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:48 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 2/7] cxl: add an optional pid check to event parsing
Date: Thu, 22 Feb 2024 18:15:39 -0800
Message-Id: <14a5fd819da5f4607463135f0340675b9e836e78.1708653303.git.alison.schofield@intel.com>
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

When parsing CXL events, callers may only be interested in events
that originate from the current process. Introduce an optional
argument to the event trace context: event_pid. When event_pid is
present, simply skip the parsing of events without a matching pid.
It is not a failure to see other, non matching events.

The initial use case for this is device poison listings where
only the media-error records requested by this process are wanted.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c | 5 +++++
 cxl/event_trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index db8cc85f0b6f..269060898118 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -208,6 +208,11 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
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
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index ec6267202c8b..7f7773b2201f 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
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

