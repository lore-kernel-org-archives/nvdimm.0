Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3E1C693
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247107; cv=none; b=KNxMB5LrS2k4r92cEz1wfSiFSe9QdreM6jigL0DP7OgknfkcXLlfG9nf+jZk4z5wbU3uG4FjFgNRyriu3zYxTXBTv4YrazOGEgOjiMOkqVg5s/Q4zX54qd4Au7+Z7dFnNr2uIDCff3KDYlWif1WGmvLITUP6bCfgLl0jO2nG4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247107; c=relaxed/simple;
	bh=hjPo4ROZPv9HYfnmt1Ek/EoJqcd1JCplv4L11Gc+/8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=orBOSDwacd4lgztMUcyvWhW6xGQkk3+rKkBIcfWlAiXiNkjkp6cAfVQRE9IYv4BMAaSl1Up2sgVPZkr3DrpXmfYtwyLnFSjSSOKibDtHuH711a6HTYr/VNpg5AOqGN0zy1ygMHKKJPDIyfTN83P8/tCjey01ehaKZEBTXTL0OoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cIgewi6z; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cIgewi6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247105; x=1751783105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hjPo4ROZPv9HYfnmt1Ek/EoJqcd1JCplv4L11Gc+/8o=;
  b=cIgewi6zoahyPsesqcbiWd6d52dAyJQwtWE0v7ottRU6tX1ni8e6Pku5
   W/VRLyRthOtHV05UIG9y2lVf040RGGYZgZUxDhzdsryTu/3PNk6VFMIyq
   WpFxaxttLWj9IWOep8UIoYANULtqvOIzCxw5Q8iJZ1AXpP/VBNLo+i+Hb
   aYuartifTXaBI8ky2+TPxAJccrpiMuVou8qiGT0+fHRmxDSQl8SpE6sjh
   TjYNlgRMXTOaoLwi0GZ4rIqPl5oYnjLb1Sc8FHkAFcqP6NTOP+mttf1yw
   KsCzyWoHP1k6Wd8NQjCd9y8Q1KOJDoJk1j84fVca/FyGxhs6gzl5Jn9pZ
   Q==;
X-CSE-ConnectionGUID: FWPO+F6CTYeRZCBAo7nzcA==
X-CSE-MsgGUID: DOMXJcjqQSyhpIW5gcplxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166947"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166947"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:05 -0700
X-CSE-ConnectionGUID: Q8kyhXqZSHepOrQ9gL2cZg==
X-CSE-MsgGUID: e8kzR7tUSxONS4NFbanR4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172557"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:05 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v13 7/8] cxl/list: add --media-errors option to cxl list
Date: Fri,  5 Jul 2024 23:24:53 -0700
Message-Id: <76eb7636d1aab2fecd60d18617828d004adb58d9.1720241079.git.alison.schofield@intel.com>
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

The --media-errors option to 'cxl list' retrieves poison lists from
memory devices supporting the capability and displays the returned
media_error records in the cxl list json. This option can apply to
memdevs or regions.

Include media-errors in the -vvv verbose option.

Example usage in the Documentation/cxl/cxl-list.txt update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-list.txt | 56 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  3 ++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..8f52ef0cf687 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,60 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-L::
+--media-errors::
+	Include media-error information. The poison list is retrieved from the
+	device(s) and media_error records are added to the listing. Apply this
+	option to memdevs and regions where devices support the poison list
+	capability. "offset:" is relative to the region resource when listing
+	by region and is the absolute device DPA when listing by memdev.
+	"source:" is one of: External, Internal, Injected, Vendor Specific,
+	or Unknown, as defined in CXL Specification v3.1 Table 8-140.
+
+----
+# cxl list -m mem9 --media-errors -u
+{
+  "memdev":"mem9",
+  "pmem_size":"1024.00 MiB (1073.74 MB)",
+  "pmem_qos_class":42,
+  "ram_size":"1024.00 MiB (1073.74 MB)",
+  "ram_qos_class":42,
+  "serial":"0x5",
+  "numa_node":1,
+  "host":"cxl_mem.5",
+  "media_errors":[
+    {
+      "offset":"0x40000000",
+      "length":64,
+      "source":"Injected"
+    }
+  ]
+}
+
+# cxl list -r region5 --media-errors -u
+{
+  "region":"region5",
+  "resource":"0xf110000000",
+  "size":"2.00 GiB (2.15 GB)",
+  "type":"pmem",
+  "interleave_ways":2,
+  "interleave_granularity":4096,
+  "decode_state":"commit",
+  "media_errors":[
+    {
+      "offset":"0x1000",
+      "length":64,
+      "source":"Injected"
+    },
+    {
+      "offset":"0x2000",
+      "length":64,
+      "source":"Injected"
+    }
+  ]
+}
+----
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
@@ -431,7 +485,7 @@ OPTIONS
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

