Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D1238A
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 00:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705537696; cv=none; b=LL6lDww27WpEVhXT5s91pPHMz1KjYp+J9zxLVmXPX5kmZl5BKTmBfpH7GGheqtCkFZFJnzAyi72zC4YUHSNH1tF84EKG3PWE1irjbzZFOWZa1bJIM3/7QrwXhNh4EeKJ5/ffGGf3jaR9XovynLzPoOXEoIp3pgibXhZbwjdyJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705537696; c=relaxed/simple;
	bh=/6VpUaWnmXTmaZkbBi4KUBqeRnhZehQ/00i3tBBr8aY=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=pMAvrsffYHEr9XTuHZI3nUe+itCnT1KvvnfgD2gKpdEo6IKvNu4nVCVuMUgWbiIr0JUUvZ7ZwSbVrvPFLwhaDKU1+21Su6SnqrIugP1FHx3KEsCRE8wg5LP5JIgF2kkaAVi0VJhw6gj1tIu0AlNWIKyF2evzhT3A0Ifd1MrzYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKepddJF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKepddJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705537694; x=1737073694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/6VpUaWnmXTmaZkbBi4KUBqeRnhZehQ/00i3tBBr8aY=;
  b=CKepddJF/6uFIqztHh8yvQnnbhHpm5EtpCnuWfghjnbl8a/J1VJTalCU
   Z+Oh9FQM+fbRl/qUOm33MVkoXpW01xqttgLbbITD3JBaGftxnSAqoHitc
   nMJNkU1Kvs89STeCM7XvsTwgzFW1zvpE6moNHQPNOQxNhQQZXUBQbyVCX
   l+UjgSdBrPdjwtOGfz9iED4w9aPR1uciiv6b+Eg9XyhkXJR3gRp2Ucge1
   oTMW0MEOsBWW7RtXg3OJacQ1UH6xogCfGjjVWDPQsbXDM7bGWWBzW0l/s
   zSqp14VzGhpHpsyRJo4fIhdwoDmm2tSMd9afga8CrebJmjTKPY8bqVyOW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18904537"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18904537"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777577204"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777577204"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.110.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:13 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v6 2/7] cxl: add an optional pid check to event parsing
Date: Wed, 17 Jan 2024 16:28:01 -0800
Message-Id: <77d576abb7e7f9badbb0c117935ad1bcc74899bd.1705534719.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1705534719.git.alison.schofield@intel.com>
References: <cover.1705534719.git.alison.schofield@intel.com>
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

