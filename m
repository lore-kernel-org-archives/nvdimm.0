Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB3E152517
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569160; cv=none; b=Urk3O4kdp8mXxhij30HuTyuPF5PdE71ICXqMlWij50tJGoYjf184Loc+/lyPtx664lkt9gU/k3Fdmjo1ip+YlT3aggY8Sf2yQyrCIaiG7Kl7RvnWV+NETaM5X78wdLtEdQVzq3yQ71EJZ3lvPOi3X2392rLBTbpkC1wQu4LZc/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569160; c=relaxed/simple;
	bh=XISgranDwa4ij9bgE4Mun2LrZs7N9ulXb55CaoAbkp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O1FH+gWuLfPXz+ZofGFrCTz/lV6wmzD52EEXW5ehTuIXrxKTk2NqpX5HYOOc3qkR0DnFToB+NFBbIjq+tCRAiGg5gctISxApW6m/kuYRdeFAckC022s2AjGoLaQvA4l0736DrvFTXPGB0E6TynqWUxoErGndAAVfdWIXmpC8hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+0V2Fkk; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+0V2Fkk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569159; x=1743105159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XISgranDwa4ij9bgE4Mun2LrZs7N9ulXb55CaoAbkp0=;
  b=M+0V2FkkZzJnit1BPLAuEbXq2ofLuTSDmVF+G99WbPi7Rt7aiRp7jf+O
   woebPqid1RVQP0MEWzgdT5leQcIfpKvF7/yQJAY5FvKplQEv7c63nJHN7
   Ym9mk3WrWRaPF9tY2eMQyEhT8xCiqJqI0RqhVyDp82PKgv+sceypxKiKe
   uCyJFjwgFtJsnR74oo+fyjnxFRMFGTSNUkEQsV4SeODYdup0CSjLeUMrz
   dOhuHoZAp1wKnCVS+fW5+dq588Ah0QBS+Vm/8U/X3ceCoOLDRe8fMfx23
   nVXhTCBOfNjozLGFvZISH9pgue/citVxYDRhnq0oC6RR1lTCMHWu6DbkO
   w==;
X-CSE-ConnectionGUID: t5cHrAOtQbac7fG791hWJQ==
X-CSE-MsgGUID: lxOQ1XKBTASacQx2FMc7hA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560207"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560207"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616303"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:36 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v12 3/8] util/trace: pass an event_ctx to its own parse_event method
Date: Wed, 27 Mar 2024 12:52:24 -0700
Message-Id: <a3984549969ff77441979229a30dd0ca24b93044.1711519822.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1711519822.git.alison.schofield@intel.com>
References: <cover.1711519822.git.alison.schofield@intel.com>
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

