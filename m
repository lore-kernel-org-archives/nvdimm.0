Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8FF72
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:11:49 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="306245252"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="306245252"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:48 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="548331575"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:48 -0700
Subject: [PATCH v4 03/21] libnvdimm/labels: Introduce the concept of
 multi-range namespace labels
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:11:48 -0700
Message-ID: <163116430804.2460985.5482188351381597529.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The CXL specification defines a mechanism for namespaces to be comprised
of multiple dis-contiguous ranges. Introduce that concept to the legacy
NVDIMM namespace implementation with a new nsl_set_nrange() helper, that
sets the number of ranges to 1. Once the NVDIMM subsystem supports CXL
labels and updates its namespace capacity provisioning for
dis-contiguous support nsl_set_nrange() can be updated, but in the
meantime CXL label validation requires nrange be non-zero.

Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |    1 +
 drivers/nvdimm/nd.h    |   13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index e7fdb718ebf0..7832b190efd7 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -856,6 +856,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
 	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
+	nsl_set_nrange(ndd, nd_label, 1);
 	nsl_set_position(ndd, nd_label, pos);
 	nsl_set_isetcookie(ndd, nd_label, cookie);
 	nsl_set_rawsize(ndd, nd_label, resource_size(res));
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 036638bdb7e3..d57f95a48fe1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -164,6 +164,19 @@ static inline void nsl_set_nlabel(struct nvdimm_drvdata *ndd,
 	nd_label->nlabel = __cpu_to_le16(nlabel);
 }
 
+static inline u16 nsl_get_nrange(struct nvdimm_drvdata *ndd,
+				 struct nd_namespace_label *nd_label)
+{
+	/* EFI labels do not have an nrange field */
+	return 1;
+}
+
+static inline void nsl_set_nrange(struct nvdimm_drvdata *ndd,
+				  struct nd_namespace_label *nd_label,
+				  u16 nrange)
+{
+}
+
 static inline u64 nsl_get_lbasize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {

