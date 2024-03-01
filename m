Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBBC2B9CE
	for <nvdimm@lists.linux.dev>; Fri,  1 Mar 2024 01:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709256689; cv=none; b=slw4eh4+2v1hL2VkQL9ITet9bBo/JU9IbsTa4gcgNSHP4HrMUlx4+MmFd/AdR3t2aqE8tqJIBDVxZdZ3edVcEFovXYMb7HX91KTq/Jc2sWvdMIenJodOnN7YPK4cxsEfRqdpQXx0pAntpyJDnvg24Y+sGw/jhEthxCsB69c9ivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709256689; c=relaxed/simple;
	bh=vAtrXMzOPQbVk0ENBhOuNC+XRIcLDIDYr/JHq12NW44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=agUhwnJwxomfSC6bIhyN8Wc/STQd4Esrv/KEkZW0EnzEm0iwdpjSaHGuyr53QwVxuvlcz1OgEIRbj2re3ZYqr2PNvAQ04+oyi6FPF7nnxYIkPpsJNjg2hUtnwM/45a+qiagF3aSwRevA2IfhdyRELnLwiRwgDWMmJXvjwF7awsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kHv7ZHy3; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kHv7ZHy3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709256687; x=1740792687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vAtrXMzOPQbVk0ENBhOuNC+XRIcLDIDYr/JHq12NW44=;
  b=kHv7ZHy3N5EljKiYCp2JMPuOgzRCosN8e9tVQBmUv3vJqPsMVt1PJOsA
   3OJ821EhzuLyffHkb62oAXDARpe+H90AKIaLZtmwZzZZivzl1/DH9L4O7
   evSIQihxFYNFHoRPWYBTKWwPsOagpXmbpCxnI74kadBkFLiQjfj3Y+l9K
   k+/U8+qD6d6OvtIMPq3ztiuoKKavpHxgIWaqmsBQP8GoWHqn3ogUmq8TC
   aX3CBdhh6Ec3p/xFo+/kT1S8FKRwQUETdk+CfXP/9WpID44v01K0ogKR6
   pcTQptMbrgDM2//aiwubzLX8ht/R9ojDc/1esNQFyhj3+t9eNMVsyYMJE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14343113"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="14343113"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7952667"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.136.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:26 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v9 3/7] cxl/event_trace: add a private context for private parsers
Date: Thu, 29 Feb 2024 17:31:18 -0800
Message-Id: <dc877abf1ccbe0ad3a4a5360c876fc252f05ae10.1709253898.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709253898.git.alison.schofield@intel.com>
References: <cover.1709253898.git.alison.schofield@intel.com>
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

