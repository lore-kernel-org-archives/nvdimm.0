Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8194F8F5B
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389135; cv=none; b=gUd9DJu5Ujnm+5j9fWS3+B42t2AEBAwmOosLeyoppLU25oSj5X3/EkTIbVlYCNOuuTJSGB9NM69d0rdwmDO1CbLgWW7ayqnvnqIE3ahgWTLLfj6ya6PfW9+yhQdlapOHrmGos/2iS8rwsyGheFB2xWiPc8NviKn0H29I4l5vz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389135; c=relaxed/simple;
	bh=Fh5lla700vONaOH1/VHbSAKzU7acUdog7JH10qr3u9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oHiMK3UROQDO4VIlY3cKqCsVNA8ESwYVUrSlkDzUpzoBkEkecRsKCCIwntxjX5KUwjtPTVazHvRX73qWtYFVre+kzw9bLFPy6Ffz407ofqCTy0Bxy70TkWBdPtVRaHyZzaIMjZgUnof+EscNUvUPSWZCA4f/g/pJJjpWeibHx/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HG/wX+/i; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HG/wX+/i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389133; x=1741925133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fh5lla700vONaOH1/VHbSAKzU7acUdog7JH10qr3u9I=;
  b=HG/wX+/iZoO6p2eizX17uVTK4AA6WHHHHxdtKe4NFqlQ4h3g+1ysdJj/
   S1IZMqGFGbh21j99Q/CgA6Ff8vZQvBdBsxLLeLHZUGs1PfmsNb38GmzCN
   2NTt2RHmNI2YwrwyklsWJBnePhkiaWpjMVqsp5WC/AImVMBkaDQLFiEcn
   A2HuLvu7ruWcnYjLLMLT1d5PIYbdVf3EVrzNP1ddJmLo8o0SWA5ndJCJe
   b3tn2nkz5fHrl+v6vpZQ62KU/ImlAh1f7AVoijDJR8D0d4BQVH0KeKcah
   +zpo20EEKZu1uiUv/fwj05xEd5d9Zz8Gwk8W+wvnRb6C84ImnV1mPo5qx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648810"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648810"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080700"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:32 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl list
Date: Wed, 13 Mar 2024 21:05:22 -0700
Message-Id: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1710386468.git.alison.schofield@intel.com>
References: <cover.1710386468.git.alison.schofield@intel.com>
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
 Documentation/cxl/cxl-list.txt | 62 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  3 ++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..6d3ef92c29e8 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,66 @@ OPTIONS
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
+----
+In the above example, region mappings can be found using:
+"cxl list -p mem9 --decoders"
+----
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
+In the above example, memdev mappings can be found using:
+"cxl list -r region5 --targets" and "cxl list -d <decoder_name>"
+
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
@@ -431,7 +491,7 @@ OPTIONS
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

