Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA13633
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136814; x=1699672814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0lO6qjHWv+IrV/yrUBy/sYYUodJwHEStQS1iikUQicw=;
  b=dF3XMBRI+Xwwg2EHb9egthH+Uif+4Dl78VkbZ9dlsu498Ctwfh0E1dmR
   3FDcKSDE/7QDuzv5A050wDg+GIWqstS6H3kO3whDKNlq8SZ2mABcfn967
   TCe+66jEkpHyU+hFyd6BgnVG4i+gITRdfzl6CdFphEf2vb/B1KiqRaaMy
   DohoI99JxoLAKsDaFKWM2OnpFakNrzbnVutnyRI04DdQNlSNSFG5u98gp
   fCErjeeVhu7z96il4swdAFIUNsVO1ZP40bEuiW0Wqo/1y3JZTTUMomhyV
   yvIGBcl/NXYsBbsXrSN5vpFizJOiV5F5/TXJTw/eYgtLYHjWdXQplkulY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638350"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638350"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129961"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129961"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:13 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/5] cxl: add an optional pid check to event parsing
Date: Thu, 10 Nov 2022 19:20:05 -0800
Message-Id: <ad642bb987990c17c52c9d84f76141e31a43f549.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
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
present, only include events with a matching pid in the returned
JSON list. It is not a failure to see other, non matching results.
Simply skip those.

The initial use case for this is the listing of media errors,
where only the media errors requested by this process are wanted.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/event_trace.c | 5 +++++
 cxl/event_trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index a973a1f62d35..70ab892bbfcb 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -207,6 +207,11 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
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

