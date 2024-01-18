Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0603A50
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 00:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705537703; cv=none; b=PQAC9RnL1Gmi6oC0vsh6nbDQqpRKp9aUIfFkdxiHiys6XvbF033YcPk7dUF5o7j0HbVY8FuPQbFahWzPe2V9ndC8dUgkPK2hnNTjmkvhfN4JvRS7/4zqbelBbdtJTrXRAtH/NJO4kbRGD1Z1rJK9Fb4xt+yHbYsk49VW4PiblHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705537703; c=relaxed/simple;
	bh=oek0qkt+aBT7WRJCd9+jfLco9THKG0GNqm4+L7t/V4Q=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=e462pjwMSTZaM3bsLdaX3w/U0BGafURsnGcQNzX6vcpkVIML/qMqQTEVwGbkuqTxvbLgOwqT8QalN0nNgiMHpbhoox8Cpg3OyBo0rE0o+huVbZrxjZHl//7mXQbU0akqxidDqNYJMc/EGVNjGzHax8g3LuDjxbHfzQegSyyuWWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LrX1D59Z; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrX1D59Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705537700; x=1737073700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oek0qkt+aBT7WRJCd9+jfLco9THKG0GNqm4+L7t/V4Q=;
  b=LrX1D59Zv6oik14IXAb5Bl+4PGjcP1jQ/hHbJV0iGvbgsF7weZxDR9ZT
   Jw2AmuXLniph+og/Jhz2GDZ6txd7i6MGYCeebFINVgG6oaL4lpvNqJGEh
   mDf3tbEnCU6HFAOPm3+Rk3oi7+IYJaJoVcdN2GFMjdyzudZ5LkWnHcdH1
   kVIlac5W8nJXUtNzrvOViTH4dkmr0p4a6ehOIEis+eKvtXxaF3tnMybjI
   HLAwg2nDX0AHV3a9th/oU6iGGga9Ej//oIIezT4KQIu9GNsjjrU+ONSOL
   Sq7zF3WTAaEkhL2slRDTnE8fTb614f+rgpKyvZZp3TxAVDrDlG4fySMPM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18904568"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18904568"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777577253"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777577253"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.110.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:19 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v6 6/7] cxl/list: add --media-errors option to cxl list
Date: Wed, 17 Jan 2024 16:28:05 -0800
Message-Id: <acff17b0f76ecf9a0fefdc1d6c02afcc9ef8a530.1705534719.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1705534719.git.alison.schofield@intel.com>
References: <cover.1705534719.git.alison.schofield@intel.com>
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

Example usage in the Documentation/cxl/cxl-list.txt update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt | 71 ++++++++++++++++++++++++++++++++++
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  2 +
 3 files changed, 76 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..6105c896938c 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,77 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-L::
+--media-errors::
+	Include media-error information. The poison list is retrieved from the
+	device(s) and media_error records are added to the listing. Apply this
+	option to memdevs and regions where devices support the poison list
+	capability.
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
+        "dpa_length":64,
+        "source":"Injected"
+      },
+      {
+        "region":"region5",
+        "dpa":1073741824,
+        "dpa_length":64,
+        "hpa":1035355557888,
+        "source":"Injected"
+      },
+      {
+        "region":"region5",
+        "dpa":1073745920,
+        "dpa_length":64,
+        "hpa":1035355566080,
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
+        "memdev":"mem1",
+        "dpa":1073741824,
+        "dpa_length":64,
+        "hpa":1035355557888,
+        "source":"Injected"
+      },
+      {
+        "memdev":"mem1",
+        "dpa":1073745920,
+        "dpa_length":64,
+        "hpa":1035355566080,
+        "source":"Injected"
+      }
+    ]
+  }
+]
+----
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
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
index 93ba51ef895c..bcdee0afd405 100644
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
-- 
2.37.3

