Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B33C14F
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654554; cv=none; b=m9hKbIfi1h9AyNJe/jib5iuVIhW8HYV6yPGcNunnRqU2MYyLYMPJGL+AUxkfVxC8dqiwxZNRaGWlM+GFbyR8jmnMGtdhUCBESIJMlmV3zBgNamS12jtVy/6A3n3zWtuzlWPUn0q/KAMoX1nmi9hxeDStQ1SWpdkM4Qw81lAQtoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654554; c=relaxed/simple;
	bh=YgE+jtO0I1XdPTDQTtSFt5xuc6q3/D5Dokw5iW5LWLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oTvndBaZ4puTt8YpWw0TLxRlU6QdP6oYlIJV7YxZORmvoxype+lE8Wyc1MoAX6lItkBQ2QYXRjKpc/pNgdX3BAj7bAydjQJvm0T7bkfAele58DMP3T9HcoJnlRoQrGyMBSR+mzhfAFXrf2ZUp3mLtwYa9nJTzd+APJoHDfmNkdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCcXXNSm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCcXXNSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654552; x=1740190552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YgE+jtO0I1XdPTDQTtSFt5xuc6q3/D5Dokw5iW5LWLQ=;
  b=oCcXXNSmV2xrZyZ6xKQ+S1d/zmjsipBshPnzIicBIR5y7od/4oPneg/D
   i4WW3NjvwkAaL9ZMjm9CGCaZU2cvVOHAKg4EeV0L2wWmZ/yVNtHX5dnm2
   PV4N3DswdL8Tu3yPrQm1GV2qw+MzANWSGtl6GVRuiJBHFV+gxstA3ay+Y
   mQ5D5QuPUZ2jTNa1qoNjomh2e7Z2H/l7n4XcN7LXBsptich/lOSAjN+Oq
   rk2qJC60MBsRQ+jECDhf5dBgDmdn24piBiT2yLlJv4njAd3NMpa32rj/6
   W7OT+sD8+8M8Wun9Fmjcb0PoZ5sDMU22avJKDoVe+aMLhNbCpPkSX02lD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364256"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364256"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410154"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:52 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 6/7] cxl/list: add --media-errors option to cxl list
Date: Thu, 22 Feb 2024 18:15:43 -0800
Message-Id: <aecaae40be17ca32be499beb037e75885ef3712e.1708653303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708653303.git.alison.schofield@intel.com>
References: <cover.1708653303.git.alison.schofield@intel.com>
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

