Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0C13E7C5
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750554; cv=none; b=SewwdMqc88w/c/ssY3t9uTSeJXkyaWqg+mMkcvHKtA4l3mrOQwjZfPXLPStRvXGuiCEDhftW/0Eazxf0n2v7VNQo5A1LgoPsY+8i/7tFWPqGF8za0257YtulmtrGplMJitZCgcDq3SGC7Z/mOMaN6nrsEKUv2HOBzM2wnrbgDfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750554; c=relaxed/simple;
	bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qOVZUt93ShxFi21Foxp3j+1ler+NNxjaBph4pJq9fedgJDzSSciNG/CCrXYkkAQfSpzdROJgg+hBE6zVkeXxpsxyvHsq4YeBlu2z+rKwLVrF4zZIBoG4DN8G/zJGbccTotJWPRdCu0ZAEwKeTpelhH1pLJ9YIHgsrTug4k73Fzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DXqU/L1N; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DXqU/L1N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750551; x=1741286551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hbtZxXnoVzB3QnmV5PLXG8Us1o2ekbGwln4vc2//uhw=;
  b=DXqU/L1NPQdkpIL24maNA9g/4v/CLnakKtumAsJ8Gw0UgSOYc/kLl2I4
   caI/1XIVRXzn4kAxlkvFKKBPiNbbCfah13VhQFtmUURewmpMEfzqb2PrO
   92PZSf+XB4euCTmRRUWmu1rsXo4bJ+1ShCO7hIWzOt7crjHKgcE3PwXg5
   Vjx7/5uDYNS3sPvRGkYgacmba9MfQhYgfUvsZLrDqJ9c4dm6jQof+r1yk
   aYkFgV+LCTA0p0/OyjhHn8qMwAQlA3vikXwgusdHVOSDrrSdfqXfh2C6t
   AhXgxLvVdu1QPSRqK5Ni5mnk79mo8a0IfnOk493rd3d+Svcppvmi1xuD4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819823"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819823"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925966"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:31 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v10 2/7] cxl: add an optional pid check to event parsing
Date: Wed,  6 Mar 2024 10:42:21 -0800
Message-Id: <abe5627e115a94054914030f3aee2aaf5c7c47ca.1709748564.git.alison.schofield@intel.com>
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

