Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F963205;
	Wed, 13 Apr 2022 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875097; x=1681411097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rab7+/1vK899gfd3hJN113ssNf+C+OwnTeELqFJrFc0=;
  b=ZAd/9LRaMw9MIQpk9TTE50O+RH83lj4CW24vkMQKYDU2UyFuM6vFwiYl
   /b/C/f1UQ3vgkiW8722mGpqUVqd/C0Fs6hSLefycB+D3bakdznVkY+UWk
   FryQQycbRiocbLg/T4z9EuvhOrYfGPYiYpQR/czFxpCLJVteIJsrCtboX
   jSLcv5In0Ib0y/cGStPL9xsrApx3YbsX1fGRGUWx88PvAMk9Uent/7Mfw
   IL47vZYeZ6rbSVjle3kWxWsoBJhpVaA5gLUwd9s6aSR0ExhlFZ5uMsqYO
   wYVz7g4k5A5FYopE0IJvIps2kvH3oF2keREdUsllK2Da0i1yw11QttNMd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631855"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631855"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013619"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:50 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 11/15] cxl/acpi: Use common IW/IG decoding
Date: Wed, 13 Apr 2022 11:37:16 -0700
Message-Id: <20220413183720.2444089-12-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that functionality to decode interleave ways and granularity is in
a common place, use that functionality in the cxl_acpi driver.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index a6b0c3181d0e..50e54e5d58c0 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -11,8 +11,8 @@
 #include "cxl.h"
 
 /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
-#define CFMWS_INTERLEAVE_WAYS(x)	(1 << (x)->interleave_ways)
-#define CFMWS_INTERLEAVE_GRANULARITY(x)	((x)->granularity + 8)
+#define CFMWS_INTERLEAVE_WAYS(x)	(cxl_to_interleave_ways((x)->interleave_ways))
+#define CFMWS_INTERLEAVE_GRANULARITY(x)	(cxl_to_interleave_granularity((x)->granularity))
 
 static unsigned long cfmws_to_decoder_flags(int restrictions)
 {
-- 
2.35.1

