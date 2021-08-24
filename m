Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DC3FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:06:19 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="217374976"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="217374976"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="535913186"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:46 -0700
Subject: [PATCH v3 04/28] libnvdimm/labels: Add a checksum calculation helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:05:46 -0700
Message-ID: <162982114637.1124374.6966639787307077105.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for LIBNVDIMM to manage labels on CXL devices deploy
helpers that abstract the label type from the implementation. The CXL
label format is mostly similar to the EFI label format with concepts /
fields added, like dynamic region creation and label type guids, and
other concepts removed like BLK-mode and interleave-set-cookie ids.

CXL labels support checksums by default, but early versions of the EFI
labels did not. Add a validate function that can return true in the case
the label format does not implement a checksum.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   68 +++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index b40a4eda1d89..3f73412dd438 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -346,29 +346,45 @@ static bool preamble_next(struct nvdimm_drvdata *ndd,
 			free, nslot);
 }
 
+static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
+				  struct nd_namespace_label *nd_label)
+{
+	u64 sum, sum_save;
+
+	if (!namespace_label_has(ndd, checksum))
+		return true;
+
+	sum_save = nsl_get_checksum(ndd, nd_label);
+	nsl_set_checksum(ndd, nd_label, 0);
+	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
+	nsl_set_checksum(ndd, nd_label, sum_save);
+	return sum == sum_save;
+}
+
+static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
+				   struct nd_namespace_label *nd_label)
+{
+	u64 sum;
+
+	if (!namespace_label_has(ndd, checksum))
+		return;
+	nsl_set_checksum(ndd, nd_label, 0);
+	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
+	nsl_set_checksum(ndd, nd_label, sum);
+}
+
 static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_namespace_label *nd_label, u32 slot)
 {
+	bool valid;
+
 	/* check that we are written where we expect to be written */
 	if (slot != nsl_get_slot(ndd, nd_label))
 		return false;
-
-	/* check checksum */
-	if (namespace_label_has(ndd, checksum)) {
-		u64 sum, sum_save;
-
-		sum_save = nsl_get_checksum(ndd, nd_label);
-		nsl_set_checksum(ndd, nd_label, 0);
-		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
-		nsl_set_checksum(ndd, nd_label, sum_save);
-		if (sum != sum_save) {
-			dev_dbg(ndd->dev, "fail checksum. slot: %d expect: %#llx\n",
-				slot, sum);
-			return false;
-		}
-	}
-
-	return true;
+	valid = nsl_validate_checksum(ndd, nd_label);
+	if (!valid)
+		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
+	return valid;
 }
 
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
@@ -812,13 +828,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		guid_copy(&nd_label->abstraction_guid,
 				to_abstraction_guid(ndns->claim_class,
 					&nd_label->abstraction_guid));
-	if (namespace_label_has(ndd, checksum)) {
-		u64 sum;
-
-		nsl_set_checksum(ndd, nd_label, 0);
-		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
-		nsl_set_checksum(ndd, nd_label, sum);
-	}
+	nsl_calculate_checksum(ndd, nd_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
 
 	/* update label */
@@ -1049,15 +1059,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 			guid_copy(&nd_label->abstraction_guid,
 					to_abstraction_guid(ndns->claim_class,
 						&nd_label->abstraction_guid));
-
-		if (namespace_label_has(ndd, checksum)) {
-			u64 sum;
-
-			nsl_set_checksum(ndd, nd_label, 0);
-			sum = nd_fletcher64(nd_label,
-					sizeof_namespace_label(ndd), 1);
-			nsl_set_checksum(ndd, nd_label, sum);
-		}
+		nsl_calculate_checksum(ndd, nd_label);
 
 		/* update label */
 		offset = nd_label_offset(ndd, nd_label);

