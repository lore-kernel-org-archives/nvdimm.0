Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D710F613A
	for <nvdimm@lists.linux.dev>; Thu, 13 Oct 2022 23:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665704350; x=1697240350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UFMwhK6YQw2aXrhEYsnRxY3RYajHnCCP2N3wG4G6Pyw=;
  b=FDrvHMLMXHZEI9mUZLrNDh2vtjif5HVPMzax1Hs5tFskRn0J5MjW8gVY
   swH5OgrV+xYjQiL4JlWPA9qIyIfMHykmW0w8NClZBO1VenrVjhIYX8zhk
   91VqzvYE1KfRpHwktaxMnYcli9Ex89Qdq9B/MTH6bbKxDKDHzxJE59Q+B
   MLhax8mATccmsYZDjtWLhsg/UNFTWGmKudwTnIokyorEQ5lkmYgWTAuRE
   GtKDUmQm7DCwYvK6trouHxt/iahEnKnNkUrPJ6u7jFNRmJaD5GBHihtqe
   GrpFOC+o8MQ3IhmRfSXhPssj6WM0GA21BaCh1x5/TSjsqVSMbQLfXdYJJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="285620553"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="285620553"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:10 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="872527651"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="872527651"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.171.186])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:09 -0700
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [RFC 3/3] cxl/list: add --media-errors option to cxl list
Date: Thu, 13 Oct 2022 16:39:03 -0700
Message-Id: <37ff292e374be8e34f6d3e7e0ade0a1b84efba89.1665699750.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1665699750.git.alison.schofield@intel.com>
References: <cover.1665699750.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The --media-errors option to 'cxl list' retrieves poison lists
from memory devices (supporting the capability) and displays
the returned media-error records in the cxl list json output.
This option applies to memdevs or regions.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt | 66 ++++++++++++++++++++++++++++++++++
 cxl/filter.c                   |  2 ++
 cxl/filter.h                   |  1 +
 cxl/list.c                     |  2 ++
 4 files changed, 71 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 14a2b4bb5c2a..8cdbe11cc2e4 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -344,6 +344,72 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-a::
+--media-errors::
+	Include media-error information. The poison list is retrieved
+	from the device(s) and media error records are added to the
+	listing. When the request is by region, memdev names and
+	host physical addresses are added to the record.
+
+----
+# cxl list -m mem11 --media-errors
+[
+  {
+    "memdev":"mem11",
+    "pmem_size":268435456,
+    "ram_size":0,
+    "serial":0,
+    "host":"0000:37:00.0",
+    "media_errors":{
+      "nr media-errors":1,
+      "media-error records":[
+        {
+          "dpa":0,
+          "length":64,
+          "source":"Internal",
+          "flags":"",
+          "overflow_time":0
+        }
+      ]
+    }
+  }
+]
+# cxl list -r region5 --media-errors
+[
+  {
+    "region":"region5",
+    "resource":1035623989248,
+    "size":2147483648,
+    "interleave_ways":2,
+    "interleave_granularity":4096,
+    "decode_state":"commit",
+    "media_errors":{
+      "nr media-errors":2,
+      "media-error records":[
+        {
+          "memdev":"mem2",
+          "hpa":0,
+          "dpa":0,
+          "length":64,
+          "source":"Internal",
+          "flags":"",
+          "overflow_time":0
+        },
+        {
+          "memdev":"mem5",
+          "hpa":0,
+          "dpa":1792,
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
diff --git a/cxl/filter.c b/cxl/filter.c
index 56c659965891..fe6c29148fb4 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -686,6 +686,8 @@ static unsigned long params_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_TARGETS;
 	if (param->partition)
 		flags |= UTIL_JSON_PARTITION;
+	if (param->media_errors)
+		flags |= UTIL_JSON_MEDIA_ERRORS;
 	return flags;
 }
 
diff --git a/cxl/filter.h b/cxl/filter.h
index 256df49c3d0c..a92295fe2511 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -26,6 +26,7 @@ struct cxl_filter_params {
 	bool human;
 	bool health;
 	bool partition;
+	bool media_errors;
 	int verbose;
 	struct log_ctx ctx;
 };
diff --git a/cxl/list.c b/cxl/list.c
index 8c48fbbaaec3..df2ae5a3fec0 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -52,6 +52,8 @@ static const struct option options[] = {
 		    "include memory device health information"),
 	OPT_BOOLEAN('I', "partition", &param.partition,
 		    "include memory device partition information"),
+	OPT_BOOLEAN('a', "media-errors", &param.media_errors,
+		    "include media error information "),
 	OPT_INCR('v', "verbose", &param.verbose,
 		 "increase output detail"),
 #ifdef ENABLE_DEBUG
-- 
2.37.3

