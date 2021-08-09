Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923B6D0E
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 22:28:08 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214823322"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="214823322"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:27:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="674429267"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:27:58 -0700
Subject: [PATCH 02/23] libnvdimm/labels: Add isetcookie validation helper
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, ira.weiny@intel.com
Date: Mon, 09 Aug 2021 15:27:57 -0700
Message-ID: <162854807792.1980150.8842369662740914960.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation to handle CXL labels with the same code that handles EFI
labels, add a specific interleave-set-cookie validation helper
rather than a getter since the CXL label type does not support this
concept. The answer for CXL labels will always be true.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    8 +++-----
 drivers/nvdimm/nd.h             |    7 +++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 94da804372bf..f33245c27cc4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1847,15 +1847,13 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 			struct nd_namespace_label *nd_label = label_ent->label;
 			u16 position, nlabel;
-			u64 isetcookie;
 
 			if (!nd_label)
 				continue;
-			isetcookie = nsl_get_isetcookie(ndd, nd_label);
 			position = nsl_get_position(ndd, nd_label);
 			nlabel = nsl_get_nlabel(ndd, nd_label);
 
-			if (isetcookie != cookie)
+			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
 				continue;
 
 			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
@@ -1968,10 +1966,10 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		return ERR_PTR(-ENXIO);
 	}
 
-	if (nsl_get_isetcookie(ndd, nd_label) != cookie) {
+	if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
 		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
 				nd_label->uuid);
-		if (nsl_get_isetcookie(ndd, nd_label) != altcookie)
+		if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
 			return ERR_PTR(-EAGAIN);
 
 		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 61f43f0edabf..b3feaf3699f7 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -83,6 +83,13 @@ static inline u64 nsl_get_isetcookie(struct nvdimm_drvdata *ndd,
 	return __le64_to_cpu(nd_label->isetcookie);
 }
 
+static inline bool nsl_validate_isetcookie(struct nvdimm_drvdata *ndd,
+					   struct nd_namespace_label *nd_label,
+					   u64 cookie)
+{
+	return cookie == __le64_to_cpu(nd_label->isetcookie);
+}
+
 static inline u16 nsl_get_position(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label)
 {

