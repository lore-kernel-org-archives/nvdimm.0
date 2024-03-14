Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1EF5CBD
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389131; cv=none; b=u7EEmrB2bEPsa0KaWydM1n3eqUhrkk6dLYWEnnBbUMGnZuc7kv73A2IpclSA2/BxenfgC3n3ErgTepSnbyqlrSkS9tem9YWrVXHbya48O4/Zjo4+n0wOsCJJe5rDZ3V8OmOw2r8zUu2I3kbyk/szuvMu8dqATnz9pQSAS9hGkMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389131; c=relaxed/simple;
	bh=/X1stBiStEV3wCln7xoNBfmLXVoVlaflFQiGvyIJEJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=exBb3WYb1ErtPp5H69rUGOpfn25GTIJ8CZPCanJXMQ8NGe+uUdjfiemeNsal/OUZrF9i6lsoZ6NDQ6xAHeMN1zw2PBSBThadvLBYocYNffW9RiSmipBsgl1EColIzpaKS9+FRC87hBRUj5WHOz09io/dL7ebW6bshaBeD2HlOHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PKpZZJNC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PKpZZJNC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389130; x=1741925130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/X1stBiStEV3wCln7xoNBfmLXVoVlaflFQiGvyIJEJw=;
  b=PKpZZJNCMf1CQq2hKXkLj8iB871bYosrFBeDjTz0HByRszAuDDzW2lJ4
   FTsFsYmq1odBh3fybm6pQjW6kZ9jmqD3wQdVMFTT/p17M1jvjvsgBE3ic
   dNgHemudMo483B2eTCO3fGss4Nrv+zeFrh1yQfYAmUehX4/2mxXoNL6Gp
   9gyRi7Li+NdRjQuTX71tjsJ6o/3zjVbrVL/bzT76aB8pp5WaxPDvfHLPf
   lPqLLI314BZZypYGGFKNbnITN/eBDY/xiVYu22h5/1+sOoTnYGIa1kP4z
   jEMbzJqkUdSHz1jEWWYA0ypwTjZ64zghQ6SiBabnOJO2I403QJiPFfEqD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648801"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648801"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080683"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:29 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v11 3/7] cxl/event_trace: support poison context in event parsing
Date: Wed, 13 Mar 2024 21:05:19 -0700
Message-Id: <3ebea9e20c9d95095acec7469dd5d12216dcc444.1710386468.git.alison.schofield@intel.com>
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

CXL event tracing provides helpers to iterate through a trace
buffer and extract events of interest. It offers two parsing
options: a default parser that adds every field of an event to
a json object, and a private parsing option where the caller can
parse each event as it wishes.

Although the private parser can do some conditional parsing based
on field values, it has no method to receive additional information
needed to make parsing decisions in the callback.

Provide additional information required by cxl_poison events by
adding a pointer to the poison_ctx directly the struct event_context.

Tidy-up the calling convention by passing the entire event_ctx to
it's own parse_event method rather than growing the param list.

This is in preparation for adding a private parser requiring the
additional context for cxl_poison events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |  9 ++++-----
 cxl/event_trace.h | 10 +++++++++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 93a95f9729fd..640abdab67bf 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -60,7 +60,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
 }
 
 static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
-			     struct list_head *jlist_head)
+			     struct event_ctx *ctx)
 {
 	struct json_object *jevent, *jobj, *jarray;
 	struct tep_format_field **fields;
@@ -190,7 +190,7 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
 		}
 	}
 
-	list_add_tail(jlist_head, &jnode->list);
+	list_add_tail(&ctx->jlist_head, &jnode->list);
 	return 0;
 
 err_jevent:
@@ -220,10 +220,9 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
 	}
 
 	if (event_ctx->parse_event)
-		return event_ctx->parse_event(event, record,
-					      &event_ctx->jlist_head);
+		return event_ctx->parse_event(event, record, event_ctx);
 
-	return cxl_event_to_json(event, record, &event_ctx->jlist_head);
+	return cxl_event_to_json(event, record, event_ctx);
 }
 
 int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index 7f7773b2201f..b77cafb410c4 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -11,13 +11,21 @@ struct jlist_node {
 	struct list_node list;
 };
 
+struct poison_ctx {
+	struct json_object *jpoison;
+	struct cxl_region *region;
+	struct cxl_memdev *memdev;
+	unsigned long flags;
+};
+
 struct event_ctx {
 	const char *system;
 	struct list_head jlist_head;
 	const char *event_name; /* optional */
 	int event_pid; /* optional */
+	struct poison_ctx *poison_ctx; /* optional */
 	int (*parse_event)(struct tep_event *event, struct tep_record *record,
-			   struct list_head *jlist_head); /* optional */
+			   struct event_ctx *ctx);
 };
 
 int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
-- 
2.37.3

