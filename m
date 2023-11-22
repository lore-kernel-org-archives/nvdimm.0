Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F304917D2
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 01:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFqABM1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700616133; x=1732152133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hCQ70vdYjxDHwuJdyELr8v4z/AkpiRccZ5YJoLFptiU=;
  b=XFqABM1gmajP/ch8hpkKuTeZW4tEeYmS123Ome3giccy/Lo9ZjQB9Zuc
   STTZtyqGOBkUuPLa7sY4xvmxiVx4R/HB11KKG/l09cWltovesGhzigpz6
   jZf7/vEiGA5wIC8vg7qhBeig0Cj62HQJIrh5tVPxTjCv+cpn9Z5ydck9R
   QrVg64nuBAPhEp3jqfizvIN5RiyGTV1fUCvDsX4a4GWNGjsHkyuunTWQI
   HkxKCPNZFJCC9IFWyQTXNZ2Y+mSnUSymKT2drEnWnxmbeAWEkCf6bYCvf
   Iigh+mANgrA6Uu5xociZfYNZvS5yQ7S3WHD7D3dUHgt+xsV2ycooPkvn6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="376988174"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="376988174"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 17:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="760270772"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="760270772"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.90.75])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 17:22:10 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list
Date: Tue, 21 Nov 2023 17:22:05 -0800
Message-Id: <216ab396ab0c34fc391d1c3d3797a0d832a8d563.1700615159.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1700615159.git.alison.schofield@intel.com>
References: <cover.1700615159.git.alison.schofield@intel.com>
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
 Documentation/cxl/cxl-list.txt | 58 ++++++++++++++++++++++++++++++++++
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..ee2f1b2d9fae 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,64 @@ OPTIONS
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
+        },
+        {
+          "memdev":"mem5",
+          "dpa":0,
+          "length":512,
+          "source":"Vendor",
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

