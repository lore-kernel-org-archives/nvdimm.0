Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15033FCC
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:08:35 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="281060114"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="281060114"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:31 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="597633802"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:30 -0700
Subject: [PATCH v3 12/28] libnvdimm/labels: Introduce the concept of
 multi-range namespace labels
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:29 -0700
Message-ID: <162982118939.1124374.9504087573920499391.stgit@dwillia2-desk3.amr.corp.intel.com>
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
index e8e0d3e409a2..7abeb1233404 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -901,6 +901,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
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

