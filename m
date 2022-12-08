Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF07A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534908; x=1702070908;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSg3tRXeh2ljbNLBilzvesOZ52kfpIGevHWDmk6y0Dk=;
  b=DYCLI+YTma/f0tGd5Nvf8y9utIFso24KwAKzjND4sbV3bQoEr+kUEge9
   ehb8P7AqEoiNND/cOV1mQKTrZSiwhgiZlBaWAjN5Jx2Y+OGRjSJc/K3Oz
   GPf2ZybSaJGcztpm9xzIHXpGooa5wVqniitvAyd4ey4XaGrgHDDFZQgz4
   BYIM0hhNQ2UCUGhWVM9Mx4xZTdcUoVQVePp/6HODDhbBycG5KXYKu0jQ5
   IT8nD2Ne8DBWJpS2O1y4I0Qiy/9/hQehTKUOZFLxqPvswMjsVHzrjRjFR
   RTcvG3jUt/UjzrIddJdQGusFeG9HKbd7uGRgA92YehgToTMkKsMi74YR6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458792"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458792"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976047130"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976047130"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:27 -0800
Subject: [ndctl PATCH v2 05/18] cxl/list: Always attempt to collect child
 objects
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:27 -0800
Message-ID: <167053490730.582963.12731194244577097943.stgit@dwillia2-xfh.jf.intel.com>
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

