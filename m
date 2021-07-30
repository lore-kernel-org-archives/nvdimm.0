Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37E170
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 16:46:05 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10061"; a="212856071"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="212856071"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 09:46:04 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="567627488"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 09:46:04 -0700
Subject: [PATCH] libnvdimm/region: Fix label activation vs errors
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Krzysztof Kensicki <krzysztof.kensicki@intel.com>, vishal.l.verma@intel.com
Date: Fri, 30 Jul 2021 09:46:04 -0700
Message-ID: <162766356450.3223041.1183118139023841447.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

There are a few scenarios where init_active_labels() can return without
registering deactivate_labels() to run when the region is disabled. In
particular label error injection creates scenarios where a DIMM is
disabled, but labels on other DIMMs in the region become activated.

Arrange for init_active_labels() to always register deactivate_labels().

Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation.")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2403b71b601e..745478213ff2 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2527,7 +2527,7 @@ static void deactivate_labels(void *region)
 
 static int init_active_labels(struct nd_region *nd_region)
 {
-	int i;
+	int i, rc = 0;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -2546,13 +2546,14 @@ static int init_active_labels(struct nd_region *nd_region)
 			else if (test_bit(NDD_LABELING, &nvdimm->flags))
 				/* fail, labels needed to disambiguate dpa */;
 			else
-				return 0;
+				continue;
 
 			dev_err(&nd_region->dev, "%s: is %s, failing probe\n",
 					dev_name(&nd_mapping->nvdimm->dev),
 					test_bit(NDD_LOCKED, &nvdimm->flags)
 					? "locked" : "disabled");
-			return -ENXIO;
+			rc = -ENXIO;
+			goto out;
 		}
 		nd_mapping->ndd = ndd;
 		atomic_inc(&nvdimm->busy);
@@ -2586,13 +2587,17 @@ static int init_active_labels(struct nd_region *nd_region)
 			break;
 	}
 
-	if (i < nd_region->ndr_mappings) {
+	if (i < nd_region->ndr_mappings)
+		rc = -ENOMEM;
+
+out:
+	if (rc) {
 		deactivate_labels(nd_region);
-		return -ENOMEM;
+		return rc;
 	}
 
 	return devm_add_action_or_reset(&nd_region->dev, deactivate_labels,
-			nd_region);
+					nd_region);
 }
 
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)

