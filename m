Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DD81BDDB
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247104; cv=none; b=jOIYRgA9qY8OvGFGl6gHURKdf8rgProCOJ2lVKNl+ElGtpVNkw0Z8Zv4rbFkIy8NQlqoPMQKWE+7aKYFfFyBVK0u9ReAl0Fra+rqWP3AnRfCBXBBqdOnC9W8t9ffGmxQuAcD9g9Yod1wsGoNZrKu/j8U7bx7TaJZbFSrGxpi9e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247104; c=relaxed/simple;
	bh=XISgranDwa4ij9bgE4Mun2LrZs7N9ulXb55CaoAbkp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=skiFpUK4gsaTR5rGyJLMumsLH9IE+j94gFso4jrFZAqly91F20sxSuIQI7CVmyR39vh1buQd5f261hwpKeAUwWWFO2Q4vEbSOUnqrs5lsOuE9CnAwNKFHX3usYeIXhsHLfUR5Oh4lxc5vwHndXW3i6zA/X7tcwOwZU0yW+Va0WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VY44Af6g; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VY44Af6g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247103; x=1751783103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XISgranDwa4ij9bgE4Mun2LrZs7N9ulXb55CaoAbkp0=;
  b=VY44Af6ga90MGBuci81CbE0Q62SI1t5//BQo/hGWcm3T/u2YJb3nhpe0
   9Pdyync6H8q4ZbifP9AsnVlboHuYK2cG4lT04pVkE/pzh0oOmDIWjPnfL
   iP+5YIX3IGk8qFk2X2Posxm8TuGRPRK1DEJ/uEDF/oDyyoznFNr2akDeh
   Qi5eA7uc6AW1JtiGWyXBtXZ4xYulkXaaHMiliUM5scxQq/7khcHym9TVh
   9xzNESYyRYBfWOW8ZWc835Z4CXnrzFG88GnaEdW0rgL7OGXXF7IIGhafL
   TWPLWX5yrjh+JnLD/zKa5kBGsxzkP0SSioWSXFtYHSXYQp4nIRa9nU8vf
   w==;
X-CSE-ConnectionGUID: T5gOy5XbS+6CrheydyrD7Q==
X-CSE-MsgGUID: OIl5GCZ5ScWl+S9RE6+JpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166935"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166935"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:01 -0700
X-CSE-ConnectionGUID: LVFKvypHSx+cbynVDLkLPA==
X-CSE-MsgGUID: qWjtLJoXS1W6PUua51yYhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172503"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:01 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v13 3/8] util/trace: pass an event_ctx to its own parse_event method
Date: Fri,  5 Jul 2024 23:24:49 -0700
Message-Id: <da9be6ff7edcaef18470cc1579343fc08bc1dc1e.1720241079.git.alison.schofield@intel.com>
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

Tidy-up the calling convention used in trace event parsing by
passing the entire event_ctx to its parse_event method. This
makes it explicit that a parse_event operates on an event_ctx
object and it allows the parse_event function to access any
members of the event_ctx structure.

This is in preparation for adding a private parser requiring more
context for cxl_poison events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/event_trace.c | 9 ++++-----
 util/event_trace.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/util/event_trace.c b/util/event_trace.c
index 57318e2adace..1f5c180a030b 100644
--- a/util/event_trace.c
+++ b/util/event_trace.c
@@ -60,7 +60,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
 }
 
 static int event_to_json(struct tep_event *event, struct tep_record *record,
-			 struct list_head *jlist_head)
+			 struct event_ctx *ctx)
 {
 	struct json_object *jevent, *jobj, *jarray;
 	struct tep_format_field **fields;
@@ -190,7 +190,7 @@ static int event_to_json(struct tep_event *event, struct tep_record *record,
 		}
 	}
 
-	list_add_tail(jlist_head, &jnode->list);
+	list_add_tail(&ctx->jlist_head, &jnode->list);
 	return 0;
 
 err_jevent:
@@ -220,10 +220,9 @@ static int event_parse(struct tep_event *event, struct tep_record *record,
 	}
 
 	if (event_ctx->parse_event)
-		return event_ctx->parse_event(event, record,
-					      &event_ctx->jlist_head);
+		return event_ctx->parse_event(event, record, event_ctx);
 
-	return event_to_json(event, record, &event_ctx->jlist_head);
+	return event_to_json(event, record, event_ctx);
 }
 
 int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx)
diff --git a/util/event_trace.h b/util/event_trace.h
index 6586e1dc254d..9c53eba7533f 100644
--- a/util/event_trace.h
+++ b/util/event_trace.h
@@ -17,7 +17,7 @@ struct event_ctx {
 	const char *event_name; /* optional */
 	int event_pid; /* optional */
 	int (*parse_event)(struct tep_event *event, struct tep_record *record,
-			   struct list_head *jlist_head); /* optional */
+			   struct event_ctx *ctx);
 };
 
 int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx);
-- 
2.37.3

