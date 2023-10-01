Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DF43D6E
	for <nvdimm@lists.linux.dev>; Sun,  1 Oct 2023 22:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696199502; x=1727735502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qCuYnXUKB6u9g+0ltmmaStCmBZs+B1gL2MkePG6yECg=;
  b=gJn8Mf8RQbBbqYh4OtGw6ZCqfLFPa3SAQuUxvDCiG5PR5Lufqe8EhC8/
   iBtEc7GABpVruWK+Okua8/jm9nGP7r0Llfe0hRMA388QheVJbwEDGs5is
   E4h9uELcIv83MgPqCNxh4VFIzHnxOQCw4hp5WmBRtRFInBtS2nIXPCxMi
   ovycQWXZNsbOVslvOE+KyaDLm6ysnCgu4tCX/VgR+3L4iJ5d6KLYDol1j
   OOioYs8a7bZPY5JAR658nNNn+bHlMolAPArSajGmyos3Mazp6GECCB86+
   NhD7AHIh+z2kGRTCJ10SElic28eA5LaURBf0p14Hl6R1X3yShcbYNAXci
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="367618323"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="367618323"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="779781971"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="779781971"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.20.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:40 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 4/5] cxl/list: add --poison option to cxl list
Date: Sun,  1 Oct 2023 15:31:34 -0700
Message-Id: <e341f21fb51826335360a0d54538f4b6814537dc.1696196382.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1696196382.git.alison.schofield@intel.com>
References: <cover.1696196382.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The --poison option to 'cxl list' retrieves poison lists from
memory devices supporting the capability and displays the
returned poison records in the cxl list json. This option can
apply to memdevs or regions.

Example usage in the Documentation/cxl/cxl-list.txt update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt | 64 ++++++++++++++++++++++++++++++++++
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  2 ++
 3 files changed, 69 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..2a4a8fe2efaa 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,70 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-L::
+--poison::
+	Include poison information. The poison list is retrieved from the
+	device(s) and poison records are added to the listing. Apply this
+	option to memdevs and regions where devices support the poison
+	list capability.
+
+----
+# cxl list -m mem11 --poison
+[
+  {
+    "memdev":"mem11",
+    "pmem_size":268435456,
+    "ram_size":0,
+    "serial":0,
+    "host":"0000:37:00.0",
+    "poison":{
+      "nr_poison_records":1,
+      "poison_records":[
+        {
+          "dpa":0,
+          "dpa_length":64,
+          "source":"Internal",
+          "flags":"",
+          "overflow_time":0
+        }
+      ]
+    }
+  }
+]
+# cxl list -r region5 --poison
+[
+  {
+    "region":"region5",
+    "resource":1035623989248,
+    "size":2147483648,
+    "interleave_ways":2,
+    "interleave_granularity":4096,
+    "decode_state":"commit",
+    "poison":{
+      "nr_poison_records":2,
+      "poison_records":[
+        {
+          "memdev":"mem2",
+          "dpa":0,
+          "dpa_length":64,
+          "source":"Internal",
+          "flags":"",
+          "overflow_time":0
+        },
+        {
+          "memdev":"mem5",
+          "dpa":0,
+          "length":512,
+          "source":"Vendor",
+          "flags":"",
+          "overflow_time":0
+        }
+      ]
+    }
+  }
+]
+----
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
diff --git a/cxl/filter.h b/cxl/filter.h
index 3f65990f835a..f38470e39543 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -30,6 +30,7 @@ struct cxl_filter_params {
 	bool fw;
 	bool alert_config;
 	bool dax;
+	bool poison;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -88,6 +89,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_ALERT_CONFIG;
 	if (param->dax)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
+	if (param->poison)
+		flags |= UTIL_JSON_POISON_LIST;
 	return flags;
 }
 
diff --git a/cxl/list.c b/cxl/list.c
index 93ba51ef895c..13fef8569340 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -57,6 +57,8 @@ static const struct option options[] = {
 		    "include memory device firmware information"),
 	OPT_BOOLEAN('A', "alert-config", &param.alert_config,
 		    "include alert configuration information"),
+	OPT_BOOLEAN('L', "poison", &param.poison,
+		    "include poison information "),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
-- 
2.37.3

