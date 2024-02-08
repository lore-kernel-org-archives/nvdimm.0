Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621914008
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 01:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707354127; cv=none; b=WahnLWtNuF802FJqZoODqIItyThfscK6IZP7J6x5m1GQ5LAxZnzGBTG8XFSKEk/6fe+K9dB/1O1LgV7BElLBVyowSn67tZ4zzVC13RsE9thm1JOqJDeP23Cu5zPoXEWwssZZXQMFmMLKe3gNPDVUvr2d+G1ebMEhDwIRt+IgV0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707354127; c=relaxed/simple;
	bh=5l/LDaPWUJnWpUgs2BmMwHt9+H1G0u+Aq/EbL9KxNUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QyqO7LwoolNiIuOsaaSrXRYbk4eaM42FGnxJ03PtBXYTfCCveWd9PAdICX2VIIn1VQKsKKus6+kbhLuWJJb0VkKtpvEyf7vS2JxyLxvsahlvrqmN0qmf82DeVsnMgVDs/t+tF7V/dMYR8Iv0IqqRDxtexwJWRILp1P4vaibD9wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FWJPxlCj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FWJPxlCj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707354126; x=1738890126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5l/LDaPWUJnWpUgs2BmMwHt9+H1G0u+Aq/EbL9KxNUQ=;
  b=FWJPxlCjdsHL817yPFZgZK4pDKAGzgJTvF89E6oToruFAIObucQqDaZA
   w0JzeZLcSnvcdBgg0hsVcVPNwLhqSnDtGkmdvuqgxp0P/fk2JE3Empv58
   3NbTxom3nkMdL4dOcQQTYqo2i7bVrZkBEU9ZY7+faunNzKVl5ziE1DHNg
   oO4g5Uc0larwWHBhCBqrHD5jW39EqUfTbAe8y2NuDLsq/nl1f8kNH7uSL
   bHexKu5Oz3nq4oJlAwI3zHGmKnRMtvAQ9+C86i9cDVHIm9tgGokZbqWQb
   wzDHtO+nfLc+hJHEU+/jD84nr4c7GHHzD0bbyu4V11es4kst0ljD7+vJq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="18629903"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="18629903"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1529271"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.105.224])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:50 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v7 3/7] cxl/event_trace: add a private context for private parsers
Date: Wed,  7 Feb 2024 17:01:42 -0800
Message-Id: <3085229a8b979dfb6686baacfd606b7c96150862.1707351560.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1707351560.git.alison.schofield@intel.com>
References: <cover.1707351560.git.alison.schofield@intel.com>
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

Add a private_ctx field to the existing 'struct event_context'.
Replace the jlist_head parameter, used in the default parser,
with the private_ctx.

This is in preparation for adding a private parser requiring
additional context for cxl_poison events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c | 2 +-
 cxl/event_trace.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 269060898118..fbf7a77235ff 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -215,7 +215,7 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
 
 	if (event_ctx->parse_event)
 		return event_ctx->parse_event(event, record,
-					      &event_ctx->jlist_head);
+					      event_ctx->private_ctx);
 
 	return cxl_event_to_json(event, record, &event_ctx->jlist_head);
 }
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index 7f7773b2201f..ec61962abbc6 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -16,8 +16,9 @@ struct event_ctx {
 	struct list_head jlist_head;
 	const char *event_name; /* optional */
 	int event_pid; /* optional */
+	void *private_ctx; /* required with parse_event() */
 	int (*parse_event)(struct tep_event *event, struct tep_record *record,
-			   struct list_head *jlist_head); /* optional */
+			   void *private_ctx);/* optional */
 };
 
 int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
-- 
2.37.3

