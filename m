Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1972
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:11:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="200881436"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="200881436"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:43 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="479464034"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:43 -0700
Subject: [PATCH v4 02/21] libnvdimm/label: Add a helper for nlabel validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:11:42 -0700
Message-ID: <163116430293.2460985.12693942353621355232.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

