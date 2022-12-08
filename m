Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5AA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534962; x=1702070962;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UxXMmxQvRHOB+EhTRe3756DB2jI5Fe7wMbKv5vdQX1U=;
  b=djECri2ySnFAhEEy05h3p1W7KXCoPllrdxac5W06nI0kyTTc92afO2P7
   Vqz4Lr1ljWYiQTNMeN5dy89muRWVa2D+OJx5hIOqqGfHtJEuLeLXhoN2U
   3qeIkUVYWQIUD7d3CETZSZIJaaTnZr7Vfd+1IPNJM1yNKMUWPBpvB1tuz
   YngYmL5iLixq7j2cr/r/wJ6UBuOdlNNoTiIMkrGArXQ6XD+RhvdGn7dWC
   +Nz5yXCdoIK8qKnq8mF+GtxlSfync2HvexYU6vzj8PNHW0K+HfMcekxu0
   aVIpruQJo8rr29kpLMf/EF/izyDnwIu7gwumg5O3I35zQj5iyixs2mU34
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="304950774"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="304950774"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="649323128"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="649323128"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:21 -0800
Subject: [ndctl PATCH v2 14/18] cxl/region: Trim region size by max
 available extent
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:20 -0800
Message-ID: <167053496075.582963.15276731392463349632.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When a size is not specified, limit the size to either the available DPA
capacity, or the max available extent in the root decoder, whichever is
smaller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index 36ebc8e5210f..286c358f1a34 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -544,6 +544,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	unsigned long flags = UTIL_JSON_TARGETS;
 	struct json_object *jregion;
 	struct cxl_region *region;
+	bool default_size = true;
 	int i, rc, granularity;
 	u64 size, max_extent;
 	const char *devname;
@@ -555,6 +556,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 	if (p->size) {
 		size = p->size;
+		default_size = false;
 	} else if (p->ep_min_size) {
 		size = p->ep_min_size * p->ways;
 	} else {
@@ -567,13 +569,16 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 			cxl_decoder_get_devname(p->root_decoder));
 		return -EINVAL;
 	}
-	if (size > max_extent) {
+	if (!default_size && size > max_extent) {
 		log_err(&rl,
 			"%s: region size %#lx exceeds max available space\n",
 			cxl_decoder_get_devname(p->root_decoder), size);
 		return -ENOSPC;
 	}
 
+	if (size > max_extent)
+		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
+
 	if (p->mode == CXL_DECODER_MODE_PMEM) {
 		region = cxl_decoder_create_pmem_region(p->root_decoder);
 		if (!region) {

