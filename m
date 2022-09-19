Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0B6747E
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631213; x=1695167213;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zRvCCQdFMS8gRXk3Cb3ubH4bqvKv8FV3o8BZZcD+tqc=;
  b=fbhTBab8Frr/JsfOtO6EDMXod7uQEmEVDbs51POHwkj4c3u7zvFp5Xcr
   JWQXMdb+Xx97ZULICyEIydRG/gT+x4ropQ+HQPxtBu8KOoKXuft9NNdfG
   gx+tX80rENlNqOzYzMWkvSxcLWsZHLs7jCbwV7CPrqQ0dt+7KhjwrFhkV
   a4tQ8VK9WeD+10Mi1u3ro5Tb4WwwOX9PLC4ZIBei71puXa6KHuQXzvbAW
   N1VQVGb8ZztcdYgCbYsLghrEZ2y9byrNjMRqFRtlobOF5mdfr6ZiN+dKd
   Yi/g2/8iVdWiEHtpZ3b5SeCmGmT/6YP6DrSkezpsQBxXq8/PvEfmH7aMv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="279278292"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="279278292"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="722504592"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:51 -0700
Subject: [PATCH v2 3/9] cxl: add common function to enable event trace
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:46:51 -0700
Message-ID: 
 <166363121162.3861186.4784558227642526260.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a common function for cxl command to enable event tracing for the
instance created. The interested "systems" will be enabled for tracing
as well.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |   21 +++++++++++++++++++++
 cxl/event_trace.h |    1 +
 2 files changed, 22 insertions(+)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index 430146ce66f5..ca2fb94f2eba 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -197,3 +197,24 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx)
 	tep_free(tep);
 	return rc;
 }
+
+int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system)
+{
+	int rc;
+	char *path;
+
+	rc = asprintf(&path, "events/%s/enable", system);
+	if (rc == -1)
+		return -errno;
+
+	rc = tracefs_instance_file_write(inst, path, "1");
+	free(path);
+	if (rc == -1)
+		return -errno;
+
+	if (tracefs_trace_is_on(inst))
+		return 0;
+
+	tracefs_trace_on(inst);
+	return 0;
+}
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index 2fbefa1586d9..1fb905664625 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -17,5 +17,6 @@ struct event_ctx {
 };
 
 int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
+int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system);
 
 #endif


