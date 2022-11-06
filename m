Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3032D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778435; x=1699314435;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSg3tRXeh2ljbNLBilzvesOZ52kfpIGevHWDmk6y0Dk=;
  b=VF0JfVNqQ9WWPHx03/9Yuo32/3GbRo9IKJ5K0/ZDkTwRo/9ZKDtTHRwH
   m99rRWip5YmPA0IirYXGNStITWr533zdKPhR/VA0zjzTfDQ5s2dknb9tq
   p/6Il2dA0ExD24Pe5EN7PHK3G5hOQQpcRtUN0uEQy/5VxK4ZqC1/cMOZ9
   q8+TkcKtqcrGVmZ/ZNdqf7dgmS95iFLjnFGIrhBTwts4390EVHarKphrv
   O/kKvGM7tiMuZuBMPtdJrcqLuwxx+TO183D8tLdmGujkk5TJHwx1hIiH1
   rp9rhUQVTN19iCEi8q39i5uCO5waR+9SiomP5CMV3/lRdDAsjbs3Qarqr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="372407778"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="372407778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="964951400"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="964951400"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:14 -0800
Subject: [ndctl PATCH 05/15] cxl/list: Always attempt to collect child
 objects
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:14 -0800
Message-ID: <166777843446.1238089.2906418615142087799.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The evolution of the hierarchical listing left warts like the following:

	if (p->memdevs && !p->ports && !p->endpoints) {
		jchilddevs = json_object_new_array();

...whereby it tried to avoid creating a container for child devices if
another container deeper in the hierarchy might supersede the upper-level
containers. I.e. if endpoints are included in the listing then there will
be nothing to report at the bus level. The protection is unnnecessary
because cond_add_put_array_suffix() already handles the case of dropping
empty containers when a lower level container subsumes all the objects.

Moreover, it's a broken check when adding objects at new levels of the
topology. CXL devices attached to an RCH cause memdevs to appear directly
beneath a bus object, and not an intervening port. So in preparation for
that change, delete all the unnecessary special casing for "jchildobj"
container creation.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Fixes: 41d6769393f4 ("cxl/list: Move enabled memdevs underneath their endpoint")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 56c659965891..040e7deefb3e 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -971,7 +971,7 @@ walk_child_ports(struct cxl_port *parent_port, struct cxl_filter_params *p,
 				continue;
 			}
 
-			if (p->memdevs && !p->endpoints) {
+			if (p->memdevs) {
 				jchilddevs = json_object_new_array();
 				if (!jchilddevs) {
 					err(p,
@@ -1151,7 +1151,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 				}
 			}
 
-			if (p->memdevs && !p->ports && !p->endpoints) {
+			if (p->memdevs) {
 				jchilddevs = json_object_new_array();
 				if (!jchilddevs) {
 					err(p,
@@ -1169,7 +1169,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 					continue;
 				}
 			}
-			if (p->regions && !p->decoders) {
+			if (p->regions) {
 				jchildregions = json_object_new_array();
 				if (!jchildregions) {
 					err(p,

