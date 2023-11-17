Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1D446535
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 22:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3jmUQH+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700260534; x=1731796534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=30b6FwU0QIGhviBvoLBeLwCaEn9T1P3ZRIE3Xjkd39M=;
  b=b3jmUQH+qcFcHvR5LYNRMFGdbPmxu6D4Ab+P4pfbmgizhwnH0g5UXps4
   bELli/IMUkZw8sHZPDtQLucikh0O7c7lRDupWx6EnoRvACG+oK+qmqMIS
   SH/DwdYjXkWT6Jiwii3Nb7eV5niF6WTd3jStYvVveBxFS0s42DhVgiwMW
   P7SiQE2rRpJ+pZDUIL1f94rc6u9/jFf62pQiaFcWW7R1mt3SKNfHfiDc8
   fCSRg/MXDicqinbpFYF4z8/cNroWsZbbGwPhI0UEpaEHXxyAbS6jOpEAW
   dSl221TLj4emmMWZ2YseHjvCui3aiuO/xoK/+dDqM9w6dzwdoP87G5gCN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="376428446"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="376428446"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="831732270"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="831732270"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.159])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:33 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 4/5] cxl/list: add --poison option to cxl list
Date: Fri, 17 Nov 2023 14:35:23 -0800
Message-Id: <6a216095bf7644c2087f4aac05c4b01fd5502cb2.1700258145.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1700258145.git.alison.schofield@intel.com>
References: <cover.1700258145.git.alison.schofield@intel.com>
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
index 838de4086678..a4110fff261d 100644
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
+      "nr_records":1,
+      "records":[
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
+      "nr_records":2,
+      "records":[
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
index 3f65990f835a..1241f72ccf62 100644
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
+		flags |= UTIL_JSON_MEDIA_ERRORS;
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

