Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9998BE5D
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654552; cv=none; b=nVrFGA1qjFSk5Mrj4vjEwrok8bI23rMc7eLaYh2usXvpX9fDrMU+L3PqPp7dVizS7J6HFfgI9ncpUGaal60xgViycDsZCZ54WMpocEPBRFHC9A015Q9lKFML9W4lpdW0FEsegE4QbKAu7QnQN0JJ+gqEx+6DXmvsY/LHEDt5J8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654552; c=relaxed/simple;
	bh=5l/LDaPWUJnWpUgs2BmMwHt9+H1G0u+Aq/EbL9KxNUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eOmIPMHXyk54gO00Rxn4knHLOebAIuFkPylpOcYE1k8UE1vhqQyEBNNo4netenrW0zcWNV1k+l8GwIQBGI/QuFE0cJdhceZfXk+7cyG0HiTEFMYE6Ch2yYriEUMEsfDdnsNEI8uokVHSOYaOTydEUIDhhzNSNuEgDkKeSbN0w0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LMjVtUZm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LMjVtUZm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654550; x=1740190550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5l/LDaPWUJnWpUgs2BmMwHt9+H1G0u+Aq/EbL9KxNUQ=;
  b=LMjVtUZmwvaH1o0gRU862crpcW7jxYoa9NasXntLTFgRTdTdp7/0Zie0
   j802nbUbWHXau6gY+ET9YSDZjfzwmI3A4B95LaYlVSBPXhvbWLJ22uZ4m
   cCCSx1cerK2Cfo/qRXxGmM0+c1PWyyRO9VW60D0R2oJnqB6mUhG8YHMfw
   nsLXrTrQszQbNWqkxps65rHKQbBkvvRABQXdVT+/gOZP4VuVvU2qfCpOa
   ShIvBU97WGy19AK5EgWKDHgyi0y3eQDt6ygrwFTjIMndq+DFlD9O6/jS4
   etQHh7304+w1UW7kYBXJfOPvLT66FTo92CC6PB6Eta/9E3TjFSE4dj87C
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364245"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364245"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410119"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:49 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 3/7] cxl/event_trace: add a private context for private parsers
Date: Thu, 22 Feb 2024 18:15:40 -0800
Message-Id: <e52603d144783efd5fde8deacbcc923d0e30a888.1708653303.git.alison.schofield@intel.com>
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

