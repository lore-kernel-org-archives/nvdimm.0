Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C518E06
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247103; cv=none; b=Wj1vlrJ7pm6lrTpZA5OKJ9DN2W3SAcAosA5MKX0x4dEdByKJcmJwnLhA/gxWcdCKtEhEM0k53KojA6W2/2Ft1O/ImawRnQkoOhFv5k7XqsB2mTspmb+lEnXnfC5EGUNg8m+qV7YL0+9wOaDqUmjOTe1DyGsrMPWj50obSCtyXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247103; c=relaxed/simple;
	bh=roIYcf7YeNI5tK4KPiAUUtFVUrvSOClHX7/lSK37xJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lMVCov2WJtEzfwhFYXGZZc/SQ62oE6LAjCAI8VEFGbZcWRGGzu/sgPu5NRjNCVk627OmyYxBcvPQ6JWPel4uaHIC4iUTObL3F4m4xEtE1rig0YNvdDi5oQnclXRiQlIPjkeWOLg0kDofpnKUk9uPZGjKGUvnpgww0bzm7AM2oNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2lTpP5q; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2lTpP5q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247101; x=1751783101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=roIYcf7YeNI5tK4KPiAUUtFVUrvSOClHX7/lSK37xJk=;
  b=G2lTpP5qmRiK2h4aqR68CpIdrNY//QNCJPAY+XfoZxzzAQvKfcr36Pig
   uPJZLL9++mnX9g/InkjFaR9str99PkItK/KQvF5xeYG/FH4fqe03bKnqS
   bboIeYZjTAWsahdXSdfDYrj334bamgOfBGKNmBSaVCx7tamcGCc/7X05s
   ElO3XJmKUJmA1MK7F70lI0rjYagqZcdrZFAwQbkCgnwZL8ZcyTWmDqTw2
   uYaEKGumXSJ1NJen1lujUetAL+mrxQRT8NrdoCz2WOIqbb7GcvZxsAD15
   TyBs33B47zph83U/2HFhX7Lhnp28XZKTSQ3GKKNupjcX5e7xB6bnHZXIz
   w==;
X-CSE-ConnectionGUID: 52OxLAU2Tm+wKCWLSvsfhQ==
X-CSE-MsgGUID: nRtSrpHCSxqmJZbsRaVhEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166931"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166931"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:00 -0700
X-CSE-ConnectionGUID: ejVAxJL7SA+XVqDpLTXl1g==
X-CSE-MsgGUID: UzfHbPpSSAKbdMVYva4KTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172492"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:00 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v13 2/8] util/trace: add an optional pid check to event parsing
Date: Fri,  5 Jul 2024 23:24:48 -0700
Message-Id: <78e904ed934820f217f96d19603acf64e322184a.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1720241079.git.alison.schofield@intel.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

When parsing events, callers may only be interested in events
that originate from the current process. Introduce an optional
argument to the event trace context: event_pid. When event_pid is
present, simply skip the parsing of events without a matching pid.
It is not a failure to see other, non matching events.

The initial use case for this is CXL device poison listings where
only the media-error records requested by this process are wanted.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 util/event_trace.c | 5 +++++
 util/event_trace.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/util/event_trace.c b/util/event_trace.c
index 16013412bc06..57318e2adace 100644
--- a/util/event_trace.c
+++ b/util/event_trace.c
@@ -214,6 +214,11 @@ static int event_parse(struct tep_event *event, struct tep_record *record,
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
diff --git a/util/event_trace.h b/util/event_trace.h
index 37c39aded871..6586e1dc254d 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
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

