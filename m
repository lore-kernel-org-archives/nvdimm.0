Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEC12D20E
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569163; cv=none; b=Br0eHsk+3MoR2po3yTLYE9fYIl/2QFYQMlTkOtzK4Ox3fnXstoLvjR9IsUtk5WGJ2ERcckYdOlfWcct9og4LRuihi58M8Hbpaa8QKYkKrlcyw8tWl5TXRdk9Lm370jPsadlrYOLpqO4qsQ/Xa7KxtIu810uUk55vCbF+1+ozMb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569163; c=relaxed/simple;
	bh=b/NC0lk9oni2dFwNWUKgLJoqyMiqXOLcaJpM1xCZ7OQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CjTOSn5W+wTxSZgdCmG4cD1p1jyd2C6LAKjOWdRM92EXPWzMWGocU7INmXjCc4FdtmpSE/b7U3hHT8SSsEmdj2rKdJkGaXN2cJ3w/WsnS0o9ubsleZW6B0bWqvh+YL3if9fQIeDPK1kTgZtzL40iHARbicBPRM2q11ZbY5r/lJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z1iJdrUF; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z1iJdrUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569161; x=1743105161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b/NC0lk9oni2dFwNWUKgLJoqyMiqXOLcaJpM1xCZ7OQ=;
  b=Z1iJdrUF2vASkOopFyofhJSGZUjC0X4YzDFBulKUsipzzbeE5bUvh/cm
   D8Zy46xdr1AmrHCP5++gzJ5N+NL5ZmadGhspILAZ1nmHhbgI5wYrTruRa
   RZdoblQ2p4TlYlJjGXLJYgBul2bAqQ2Q9AKQ7G99et9IXDXyzT6ncab1C
   NpyOrJ7GqvsWsUU+qWUSP9XaZGqq/jOWSnuo+B+ivWR+DdwTWJEUvAFkK
   yt6oZzoLcnpPsB4a7cpodV28hFSn1xRQfeGTR+NfzIKxEw+IPDW6A7TKp
   5p60lG6E25enWVxrUfu5YxWmi2JfTWN7M4TgIW1NKfATVi+us+rRJW84c
   Q==;
X-CSE-ConnectionGUID: sUpnT4uRRrCYErj6GvjrSg==
X-CSE-MsgGUID: dZaERiEkQ2qewSQmV/VlPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560227"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560227"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616368"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:41 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v12 7/8] cxl/list: add --media-errors option to cxl list
Date: Wed, 27 Mar 2024 12:52:28 -0700
Message-Id: <b45867067399b06db8d94a774578dc742a939aed.1711519822.git.alison.schofield@intel.com>
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

The --media-errors option to 'cxl list' retrieves poison lists from
memory devices supporting the capability and displays the returned
media_error records in the cxl list json. This option can apply to
memdevs or regions.

Include media-errors in the -vvv verbose option.

Example usage in the Documentation/cxl/cxl-list.txt update.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/cxl-list.txt | 64 +++++++++++++++++++++++++++++++++-
 cxl/filter.h                   |  3 ++
 cxl/list.c                     |  3 ++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 838de4086678..8a030ba7c3b1 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -415,6 +415,68 @@ OPTIONS
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
+More complex cxl list queries can be created by using cxl list object and
+filtering options. The first example below emits all the endpoint ports
+with their decoders and memdevs with media-errors. The second example filters
+that output further by a single memdev.
+----
+# cxl list -DEM -p endpoint --media-errors
+# cxl list -DEM -p mem9 --media-errors
+----
+
 -v::
 --verbose::
 	Increase verbosity of the output. This can be specified
@@ -431,7 +493,7 @@ OPTIONS
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

