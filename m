Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD93FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:21 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="196918107"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="196918107"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:52 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="575064020"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:05:51 -0700
Subject: [PATCH v3 05/28] libnvdimm/labels: Add blk isetcookie set /
 validation helpers
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:05:51 -0700
Message-ID: <162982115185.1124374.13459190993792729776.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given BLK-mode is not even supported on CXL push hide the BLK-mode
specific details inside the helpers.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c          |   30 ++++++++++++++++++++++++++++--
 drivers/nvdimm/namespace_devs.c |    9 ++-------
 drivers/nvdimm/nd.h             |    4 ++++
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 3f73412dd438..d1a7f399cfe4 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -898,6 +898,33 @@ static struct resource *to_resource(struct nvdimm_drvdata *ndd,
 	return NULL;
 }
 
+static void nsl_set_blk_isetcookie(struct nvdimm_drvdata *ndd,
+				   struct nd_namespace_label *nd_label,
+				   u64 isetcookie)
+{
+	if (namespace_label_has(ndd, type_guid)) {
+		nsl_set_isetcookie(ndd, nd_label, isetcookie);
+		return;
+	}
+	nsl_set_isetcookie(ndd, nd_label, 0); /* N/A */
+}
+
+bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
+				 struct nd_namespace_label *nd_label,
+				 u64 isetcookie)
+{
+	if (!namespace_label_has(ndd, type_guid))
+		return true;
+
+	if (nsl_get_isetcookie(ndd, nd_label) != isetcookie) {
+		dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n", isetcookie,
+			nsl_get_isetcookie(ndd, nd_label));
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * 1/ Account all the labels that can be freed after this update
  * 2/ Allocate and write the label to the staging (next) index
@@ -1042,12 +1069,11 @@ static int __blk_label_update(struct nd_region *nd_region,
 				nsl_set_nlabel(ndd, nd_label, 0xffff);
 				nsl_set_position(ndd, nd_label, 0xffff);
 			}
-			nsl_set_isetcookie(ndd, nd_label, nd_set->cookie2);
 		} else {
 			nsl_set_nlabel(ndd, nd_label, 0); /* N/A */
 			nsl_set_position(ndd, nd_label, 0); /* N/A */
-			nsl_set_isetcookie(ndd, nd_label, 0); /* N/A */
 		}
+		nsl_set_blk_isetcookie(ndd, nd_label, nd_set->cookie2);
 
 		nsl_set_dpa(ndd, nd_label, res->start);
 		nsl_set_rawsize(ndd, nd_label, resource_size(res));
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index fb9e080ce654..fbd0c2fcea4a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2272,14 +2272,9 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 					&nd_label->type_guid);
 			return ERR_PTR(-EAGAIN);
 		}
-
-		if (nd_label->isetcookie != __cpu_to_le64(nd_set->cookie2)) {
-			dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n",
-					nd_set->cookie2,
-					nsl_get_isetcookie(ndd, nd_label));
-			return ERR_PTR(-EAGAIN);
-		}
 	}
+	if (!nsl_validate_blk_isetcookie(ndd, nd_label, nd_set->cookie2))
+		return ERR_PTR(-EAGAIN);
 
 	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
 	if (!nsblk)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 9bf9cd4a9a2d..955c4395a8e3 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -177,6 +177,10 @@ static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
 	nd_label->lbasize = __cpu_to_le64(lbasize);
 }
 
+bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
+				 struct nd_namespace_label *nd_label,
+				 u64 isetcookie);
+
 struct nd_region_data {
 	int ns_count;
 	int ns_active;

