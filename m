Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAD22C68F
	for <nvdimm@lists.linux.dev>; Fri,  1 Mar 2024 01:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709256688; cv=none; b=ZaWEqQLFf2u+9+T9rRHOdAvEPqRRrTmnPRD4U645HwbWPwXYbA/ErCj5rrq52PEGMvzYYdEyiiKGsJgllukQy0aOtn/w1iouMhkn/AZLNs7FpjORyL5E5ecwWzzR2G06RLXuOF8evnf/egMn/hM2TBQu6+9oG8deZNft042N+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709256688; c=relaxed/simple;
	bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MkKkP+WwkFNSB0JyMDmQFIXzDfbR0Is1J2WPMldHuZtZc9DDntJz2aDh4TxuOkobBLgEVEKBN1YpwAFu4xKdomPH3y8DkjdIGtEpF4B7AXK/k8tqw11IFf4nSOTuPNfSuMujnmoZJJlmDP5WrbLB3wvug97Lv15WWH2whkGAWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PD1qk60R; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PD1qk60R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709256687; x=1740792687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
  b=PD1qk60R8kce13TV4mjGlSdZv5LPx7+fZ1+LndBHYiTuydq4UF3+yC/B
   KRNZzC6BFCbX3X+sXOw/RaNW5E7sBeF/elsGMb7MPQcnmcTrH+HG0y/lv
   uuwHW45kvJwl1sBzwsFzsztIWRbq+jSpBlkjyDRo0JldfxoYJDhuziMGU
   2qDTSbhpknDMLmnXAv+1GlRBBLOZah5kUSPAfe9nbTQx+7g5GlXMjT03D
   ciu43hG1KAKN+tHkMtkDEbmS4t/a3ZeVX/MVt7PJas7jUIWBMQp6bVpKi
   NwtNl3Lbx8PNLpIrbhBEWEqrYLTPAG41BHiGUs8evj7Vr63RlZGXM8eC6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14343108"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="14343108"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7952663"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.136.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:25 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v9 2/7] cxl: add an optional pid check to event parsing
Date: Thu, 29 Feb 2024 17:31:17 -0800
Message-Id: <0b1b79d374bbfd90093e2ee47fb130cfbaf36e73.1709253898.git.alison.schofield@intel.com>
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
index 1b5aa09de8b2..93a95f9729fd 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -214,6 +214,11 @@ static int cxl_event_parse(struct tep_event *event, struct tep_record *record,
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

