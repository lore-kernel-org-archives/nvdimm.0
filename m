Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCD1A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534973; x=1702070973;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2gYGo+7HC2gLAQmyRxAm/yZrTFndTCQOyakXbHun88=;
  b=GksTPpcfUiAa997R9cki572M7urYRlq7vCqzPMWlBcrj+IB1o9j7Zz3p
   jSx7rl6cyOuYn4qNViorV4iA5gfUi7FLJmAX3Q70MWNiG/fdzneCCpaHH
   RUkT5BAu5zA0fYEzOpVRvFXupOW7HdeD5Wa3GW7oTSarmD/cNn31gcPBj
   xeFSZLsi7TAbsg5rDhQmDzxAVYVXZ/Ra768JWc0wVZdWiBYT9ZVTz72Qh
   c9QBIPck+Fig62Qo2IR51uRlP0uF1vXCfyF9ygG+j4UUX76ClU+NDcURE
   cBk0sZFSfmB34KPOYtvVMnOwgUWJKyMiKPB12M0eJCk4K8BmIdP22gtHl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="296988307"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="296988307"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="649323156"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="649323156"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:33 -0800
Subject: [ndctl PATCH v2 16/18] cxl/region: Autoselect memdevs for
 create-region
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:32 -0800
Message-ID: <167053497261.582963.1274754281124548404.stgit@dwillia2-xfh.jf.intel.com>
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

Now that parse_create_region() uses cxl_filter_walk() to gather memdevs
use that as the target list in case no target list is provided. In other
words the result of "cxl list -M -d $decoder" returns all the potential
memdevs that can comprise a region under $decoder, so just go ahead and
try to use that as the target list by default.

Note though that the order of devices returned by cxl_filter_walk() may
not be a suitable region creation order. So this porcelain helps for
simple topologies, but needs a follow-on patch to sort the memdevs by
valid region order, and/or discover cases where deviceA or deviceB can
be in the region, but not both.

Outside of those cases:

   cxl create-region -d decoderX.Y

...is sufficient to create a region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |   10 ++++++----
 cxl/region.c                            |   16 ++++++++--------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index e0e6818cfdd1..286779eff9ed 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -53,16 +53,18 @@ OPTIONS
 -------
 <target(s)>::
 The CXL targets that should be used to form the region. The number of
-'target' arguments must match the '--ways' option (if provided). The
-targets are memdev names such as 'mem0', 'mem1' etc.
+'target' arguments must match the '--ways' option (if provided).
 
 include::bus-option.txt[]
 
 -m::
 --memdevs::
 	Indicate that the non-option arguments for 'target(s)' refer to memdev
-	names. Currently this is the only option supported, and must be
-	specified.
+	device names. If this option is omitted and no targets are specified
+	then create-region uses the equivalent of 'cxl list -M -d $decoder'
+	internally as the target list. Note that depending on the topology, for
+	example with switches, the automatic target list ordering may not be
+	valid and manual specification of the target list is required.
 
 -s::
 --size=::
diff --git a/cxl/region.c b/cxl/region.c
index 286c358f1a34..15cac64a158c 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -269,10 +269,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 	}
 
 	/*
-	 * For all practical purposes, -m is the default target type, but
-	 * hold off on actively making that decision until a second target
-	 * option is available.
+	 * For all practical purposes, -m is the default target type, but hold
+	 * off on actively making that decision until a second target option is
+	 * available. Unless there are no arguments then just assume memdevs.
 	 */
+	if (!count)
+		param.memdevs = true;
+
 	if (!param.memdevs) {
 		log_err(&rl,
 			"must specify option for target object types (-m)\n");
@@ -314,11 +317,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		p->ways = count;
 		if (!validate_ways(p, count))
 			return -EINVAL;
-	} else {
-		log_err(&rl,
-			"couldn't determine interleave ways from options or arguments\n");
-		return -EINVAL;
-	}
+	} else
+		p->ways = p->num_memdevs;
 
 	if (param.granularity < INT_MAX) {
 		if (param.granularity <= 0) {

