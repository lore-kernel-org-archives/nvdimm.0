Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9940E13E7CA
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750554; cv=none; b=farnWeUaz1tWLe7lgdMYu3ZbM3b2BWwk/yN5JvIF4l96HKJbcsm9LVriazWsDDJB6AjERg8VneuU37efTGgp6KmniDkMvAawPCEdZQlPKX0fiYzPxd/H8EvOOFgfGFmU9WzyJHevcEMOE99Va92kHe8O9M8edy/k/faZbKFXQwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750554; c=relaxed/simple;
	bh=vAtrXMzOPQbVk0ENBhOuNC+XRIcLDIDYr/JHq12NW44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R9ByKvbV02oGz7FVe6IpKV1+sL6ZTbqoPKU9gZdr3clcSnEKVxZccxx8NJDDWDon42JQfMhexQ1F11/2XIgkvslkwwZqcBBZ/u0cHMhfjOCE3f1Be0mRDybJOUbtnwULlJ2dM5D9Az/rwbkawq3XK2UJ7Nn1xfszCmbh/7ooHi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J4Jyusff; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4Jyusff"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750552; x=1741286552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vAtrXMzOPQbVk0ENBhOuNC+XRIcLDIDYr/JHq12NW44=;
  b=J4Jyusff/VW7ZKxyqo2vSHS2SiJMh/DoKAEeH3sBNLnuNvhRSwMgGctX
   avaqLppuXFgUELsu7L1UNWiXR5W8BBxXkdWmxrQcfB1WlbnZYOR2UYPyT
   DV+lXIT+bCcX75XYsN57gG5JQ9CdD0TLSqRs4ZGqjS4motAx8wQpALTCJ
   7B4OxsGYoFmR5lQyHsQJz/oV2wuThmGKmXaqk8ear/+Xo4mzFy6JL/DeK
   lDXwBFbiTzmJO47gmGV0UDOOvTRqHfCUerfZbDDegvVAMmA0VJ0a3R5rd
   hFK9Urvv2J6JqBLd2b4rj8YNSmZyr3Kupji8DT8ykl0sYbfAfLq5v/eDM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819826"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819826"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925969"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:31 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v10 3/7] cxl/event_trace: add a private context for private parsers
Date: Wed,  6 Mar 2024 10:42:22 -0800
Message-Id: <6e975df49a62cdb544791633fdd1a998a0b60164.1709748564.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709748564.git.alison.schofield@intel.com>
References: <cover.1709748564.git.alison.schofield@intel.com>
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
index 93a95f9729fd..bdad0c19dbd4 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -221,7 +221,7 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
 
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

