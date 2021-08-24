Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58F3FCC
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:40 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="278355784"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="278355784"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="426161680"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:24 -0700
Subject: [PATCH v3 11/28] libnvdimm/label: Add a helper for nlabel validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com, ira.weiny@intel.com,
 ben.widawsky@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:24 -0700
Message-ID: <162982118423.1124374.11980785134458815600.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In the CXL namespace label there is no need for nlabel since that is
inferred from the region. Add a helper that moves nsl_get_label() behind
a helper that validates the number of labels relative to the region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    5 ++---
 drivers/nvdimm/nd.h             |    7 +++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d4959981c7d4..28ed14052e36 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1848,12 +1848,11 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 			struct nd_namespace_label *nd_label = label_ent->label;
-			u16 position, nlabel;
+			u16 position;
 
 			if (!nd_label)
 				continue;
 			position = nsl_get_position(ndd, nd_label);
-			nlabel = nsl_get_nlabel(ndd, nd_label);
 
 			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
 				continue;
@@ -1870,7 +1869,7 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 				return false;
 			}
 			found_uuid = true;
-			if (nlabel != nd_region->ndr_mappings)
+			if (!nsl_validate_nlabel(nd_region, ndd, nd_label))
 				continue;
 			if (position != pos)
 				continue;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ec3c9aad7f50..036638bdb7e3 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -342,6 +342,13 @@ struct nd_region {
 	struct nd_mapping mapping[];
 };
 
+static inline bool nsl_validate_nlabel(struct nd_region *nd_region,
+				       struct nvdimm_drvdata *ndd,
+				       struct nd_namespace_label *nd_label)
+{
+	return nsl_get_nlabel(ndd, nd_label) == nd_region->ndr_mappings;
+}
+
 struct nd_blk_region {
 	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,

