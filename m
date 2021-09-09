Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6286872
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:11:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="281695844"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="281695844"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:59 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="469914922"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:59 -0700
Subject: [PATCH v4 05/21] libnvdimm/label: Define CXL region labels
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:11:58 -0700
Message-ID: <163116431893.2460985.4003511000574373922.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add a definition of the CXL 2.0 region label format. Note this is done
as a separate patch to make the next patch that adds namespace label
support easier to read.

Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 7fa757d47846..0519aacc2926 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -66,6 +66,38 @@ struct nd_namespace_index {
 	u8 free[];
 };
 
+/**
+ * struct cxl_region_label - CXL 2.0 Table 211
+ * @type: uuid identifying this label format (region)
+ * @uuid: uuid for the region this label describes
+ * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
+ * @nlabel: 1 per interleave-way in the region
+ * @position: this label's position in the set
+ * @dpa: start address in device-local capacity for this label
+ * @rawsize: size of this label's contribution to region
+ * @hpa: mandatory system physical address to map this region
+ * @slot: slot id of this label in label area
+ * @ig: interleave granularity (1 << @ig) * 256 bytes
+ * @align: alignment in SZ_256M blocks
+ * @reserved: reserved
+ * @checksum: fletcher64 sum of this label
+ */
+struct cxl_region_label {
+	u8 type[NSLABEL_UUID_LEN];
+	u8 uuid[NSLABEL_UUID_LEN];
+	__le32 flags;
+	__le16 nlabel;
+	__le16 position;
+	__le64 dpa;
+	__le64 rawsize;
+	__le64 hpa;
+	__le32 slot;
+	__le32 ig;
+	__le32 align;
+	u8 reserved[0xac];
+	__le64 checksum;
+};
+
 /**
  * struct nd_namespace_label - namespace superblock
  * @uuid: UUID per RFC 4122

