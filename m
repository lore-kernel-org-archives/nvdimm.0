Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D29B13E7EA
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750556; cv=none; b=Wjrkoal1VZl8wC9hjvpqtsUH+LesbTlG3a+at6P1x3XkjJyH4E8ng6QQ8xSIgUOHG1sQc+QpLgg1NyH6yl9pt66AEhmCZulyLVSVueotN1FL++ogtpnqGeAiUBMeE4/3ILSnKzvekE9fe3bfdW4BM8n1eds902FUZyArYTtnMag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750556; c=relaxed/simple;
	bh=sFSwfMOSaRKAAtONH9OZkJqK2kxBdAF3OaadvPZiR4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N8mBpjUYepuqfUMFsrYzZEN88XFh8c0/vgrLtnoqOCEdlPeqQe/21/inAnfUMcD5Ass2gGBqQXi68j7cAEazhUrWMpf/5yZk6RmAPkMeGoSmOkv9GcriDTvEknDuqaK7hV6R603pyeg9JQxMS3EIoIMGVH7OiWsqpM9ZYutrFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZxHAPWd6; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZxHAPWd6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750554; x=1741286554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sFSwfMOSaRKAAtONH9OZkJqK2kxBdAF3OaadvPZiR4o=;
  b=ZxHAPWd6GgXmhpLqTZM6xxS42rIyG9M+1PiUcGvA7Wv2mUklYhhnjlQt
   94D5uZ/uuDcpMpPKBr7k6hf4KbzTB3UPBhXaH4HNIhzLennwUao21m0N1
   yNmDEAD+8fT25dILvWJagwd4eLYy1Bkvm8AcMlIeWb2DMuVwhl76Iiyc7
   Ob5Ur2UPaCHbSucmGwdDD+iXU1cPoQzWGMqkNMlP1GK3d7nwiH7JfwbbO
   cRGkwCgMI8eqy1RwIAhYyiEswuczsPl5fKTxECJQP9yWKaSIGCrzJ7UdO
   jyLi8+0c038NtH6kucG3VXljPdyksR8tTNz+PxbeqXN18UUpv7amzC2TP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819832"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819832"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925983"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:33 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v10 6/7] cxl/list: add --media-errors option to cxl list
Date: Wed,  6 Mar 2024 10:42:25 -0800
Message-Id: <2047e536ed7a1d1a46c048053dfe22fc798ca35e.1709748564.git.alison.schofield@intel.com>
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

The --media-errors option to 'cxl list' retrieves poison lists from
memory devices supporting the capability and displays the returned
media_error records in the cxl list json. This option can apply to
memdevs or regions.

Include media-errors in the -vvv verbose option.

Example usage in the Documentation/cxl/cxl-list.txt update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt | 79 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  3 ++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..5c20614ef579 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,83 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-L::
+--media-errors::
+	Include media-error information. The poison list is retrieved from the
+	device(s) and media_error records are added to the listing. Apply this
+	option to memdevs and regions where devices support the poison list
+	capability.
+
+	"decoder" and "hpa" are included when the media-error is in a mapped
+        address.
+
+	"source" will be one of: External, Internal, Injected, Vendor Specific,
+        or Unknown, as defined in CXL Specification v3.1 Table 8-140.
+
+----
+# cxl list -m mem1 --media-errors
+[
+  {
+    "memdev":"mem1",
+    "pmem_size":1073741824,
+    "ram_size":1073741824,
+    "serial":1,
+    "numa_node":1,
+    "host":"cxl_mem.1",
+    "media_errors":[
+      {
+        "dpa":0,
+        "length":64,
+        "source":"Internal"
+      },
+      {
+        "decoder":"decoder10.0",
+        "hpa":1035355557888,
+        "dpa":1073741824,
+        "length":64,
+        "source":"External"
+      },
+      {
+        "decoder":"decoder10.0",
+        "hpa":1035355566080,
+        "dpa":1073745920,
+        "length":64,
+        "source":"Injected"
+      }
+    ]
+  }
+]
+
+# cxl list -r region5 --media-errors
+[
+  {
+    "region":"region5",
+    "resource":1035355553792,
+    "size":2147483648,
+    "type":"pmem",
+    "interleave_ways":2,
+    "interleave_granularity":4096,
+    "decode_state":"commit",
+    "media_errors":[
+      {
+        "decoder":"decoder10.0",
+        "hpa":1035355557888,
+        "dpa":1073741824,
+        "length":64,
+        "source":"External"
+      },
+      {
+        "decoder":"decoder8.1",
+        "hpa":1035355553792,
+        "dpa":1073741824,
+        "length":64,
+        "source":"Internal"
+      }
+    ]
+  }
+]
+----
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
@@ -431,7 +508,7 @@ OPTIONS
 	  devices with --idle.
 	- *-vvv*
 	  Everything *-vv* provides, plus enable
-	  --health and --partition.
+	  --health, --partition, --media-errors.
 
 --debug::
 	If the cxl tool was built with debug enabled, turn on debug
diff --git a/cxl/filter.h b/cxl/filter.h
index 3f65990f835a..956a46e0c7a9 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -30,6 +30,7 @@ struct cxl_filter_params {
 	bool fw;
 	bool alert_config;
 	bool dax;
+	bool media_errors;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -88,6 +89,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_ALERT_CONFIG;
 	if (param->dax)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
+	if (param->media_errors)
+		flags |= UTIL_JSON_MEDIA_ERRORS;
 	return flags;
 }
 
diff --git a/cxl/list.c b/cxl/list.c
index 93ba51ef895c..0b25d78248d5 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -57,6 +57,8 @@ static const struct option options[] = {
 		    "include memory device firmware information"),
 	OPT_BOOLEAN('A', "alert-config", &param.alert_config,
 		    "include alert configuration information"),
+	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
+		    "include media-error information "),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -121,6 +123,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.fw = true;
 		param.alert_config = true;
 		param.dax = true;
+		param.media_errors = true;
 		/* fallthrough */
 	case 2:
 		param.idle = true;
-- 
2.37.3

