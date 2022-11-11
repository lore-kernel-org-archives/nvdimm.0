Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4C639
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136816; x=1699672816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+nvXp12J+biWDdGcdaPbaU5FE0X69XrhRSTjEwW9A4=;
  b=eD1N0O1wlGQy7CR1wFqEsTIzOBtggPqL+dA6KHIQMs6eqbMCUsUJaGZW
   14OG6bOqO8iESL24f75mCRpSd+V5iBTb2S9qrtv1ZhJuHkeqTDxWfXy31
   HcwVc3vwiCWdAqteJCmV7TF+IsdznsNHqRNOxTalj7cpS0XUB9pTULIGy
   vmho+IQlTuYJNUD5PbBAb8EurZ7LrS8yxCZytlwwZ1qc9ESHVTTYP4E6O
   Gfp3pdGywOcMwmteJy0uKRc8OCPTz6I2Nt7Xwo345DE01l3sLG9snbCor
   USiadS9/jvax3pGgUd+bEjsdTR2jF7uJFGFxkXkg4oAlyxpWDtB4/TxEd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638354"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638354"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129970"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129970"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:15 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 4/5] cxl/list: add --media-errors option to cxl list
Date: Thu, 10 Nov 2022 19:20:07 -0800
Message-Id: <762edeab529125d3048cf13721360b1a07260531.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
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
the returned media-error records in the cxl list json. This
option can apply to memdevs or regions.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt | 64 ++++++++++++++++++++++++++++++++++
 cxl/filter.c                   |  2 ++
 cxl/filter.h                   |  1 +
 cxl/list.c                     |  2 ++
 4 files changed, 69 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 14a2b4bb5c2a..24a0cf97cef2 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -344,6 +344,70 @@ OPTIONS
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
 
+-a::
+--media-errors::
+	Include media-error information. The poison list is retrieved
+	from the device(s) and media error records are added to the
+	listing. This option applies to memdevs and regions where
+	devices support the poison list capability.
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
+      "nr_media_errors":1,
+      "media_error_records":[
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
+      "nr_media_errors":2,
+      "media_error_records":[
+        {
+          "memdev":"mem2",
+          "dpa":0,
+          "length":64,
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

