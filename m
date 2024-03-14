Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E76C53BE
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389131; cv=none; b=Mn3qdzZ/nJW6986TJ5gwzW/OGmLRHdDVk1L2UdZuZHuYOBmPHSyCt2Ym1bQ7h4uVXPALTrBGvfhgwK2YrW5Wa1Ba7uKK6FfK8ctdS/E8epQ1pz4vgE0nhkULogUtt/tm0o/uoP1nsLnNWrVca+Ys6oOped6l95I91Pcthx+E7Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389131; c=relaxed/simple;
	bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYlhbEtdl50hrE1TmRyvsk8xo+OQ5M4Yf0WV2vWkYBY+43Ve825XhpC7hDNnQyoXYVwDq1eOnzN/aEjJo+b18XKaoySuhLTEiYRemkAl2JYh8fF9NfIgWk0YKum+tF9cZqUmOtutptUYjsZcCamXeVkSFpARrlDzeSYCRHAkkdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MaHLy9a5; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MaHLy9a5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389130; x=1741925130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
  b=MaHLy9a5bb6FFSDRWlesHYYmqmrxk0tKKkHQJdQMJ2XhEw1HUsM1W+ND
   4T+Za+j/qKUY9uurVTt/pnIz4WhIzLWnT95fkhf6VCrDm63lBZ7dzG9cs
   pA3sO9AbywE3HqVlQvLKW2DxnME8di3zgsyyU9Xtlg+UJa2uh6lHW+gVH
   IsAp98l0wKdQ7sF02e+P8hcF0bfG7n4G/M5olYY0Sw9ERj/xRaSGJ2XEa
   dEYlZ/GDmUWUEdyw8FiZtVj17cTuI7oyYGJJ6Kd6Tjk7WdwhE6luEpQh8
   cRPtivitmWpq1vzbUffz6h0XUV11c2ar5K104D4IXUJwVPCtj4mE64dC/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648798"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648798"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080677"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:28 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v11 2/7] cxl/event_trace: add an optional pid check to event parsing
Date: Wed, 13 Mar 2024 21:05:18 -0700
Message-Id: <5cefea50b4f62e60d642b4a627ca6943755758fc.1710386468.git.alison.schofield@intel.com>
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

