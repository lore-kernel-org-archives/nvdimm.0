Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9561C72
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:11:54 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="207793593"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="207793593"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="449748458"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:53 -0700
Subject: [PATCH v4 04/21] libnvdimm/labels: Fix kernel-doc for label.h
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:11:53 -0700
Message-ID: <163116431381.2460985.6990754901097922099.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Clean up existing kernel-doc warnings before adding new CXL label data
structures.

drivers/nvdimm/label.h:66: warning: Function parameter or member 'labelsize' not described in 'nd_namespace_index'
drivers/nvdimm/label.h:66: warning: Function parameter or member 'free' not described in 'nd_namespace_index'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'align' not described in 'nd_namespace_label'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'reserved' not described in 'nd_namespace_label'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'type_guid' not described in 'nd_namespace_label'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'abstraction_guid' not described in 'nd_namespace_label'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'reserved2' not described in 'nd_namespace_label'
drivers/nvdimm/label.h:103: warning: Function parameter or member 'checksum' not described in 'nd_namespace_label'

Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 31f94fad7b92..7fa757d47846 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -34,6 +34,7 @@ enum {
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
  * @flags: placeholder
+ * @labelsize: log2 size (v1 labels 128 bytes v2 labels 256 bytes)
  * @seq: sequence number for this index
  * @myoff: offset of this index in label area
  * @mysize: size of this index struct
@@ -43,7 +44,7 @@ enum {
  * @major: label area major version
  * @minor: label area minor version
  * @checksum: fletcher64 of all fields
- * @free[0]: bitmap, nlabel bits
+ * @free: bitmap, nlabel bits
  *
  * The size of free[] is rounded up so the total struct size is a
  * multiple of NSINDEX_ALIGN bytes.  Any bits this allocates beyond
@@ -77,7 +78,12 @@ struct nd_namespace_index {
  * @dpa: DPA of NVM range on this DIMM
  * @rawsize: size of namespace
  * @slot: slot of this label in label area
- * @unused: must be zero
+ * @align: physical address alignment of the namespace
+ * @reserved: reserved
+ * @type_guid: copy of struct acpi_nfit_system_address.range_guid
+ * @abstraction_guid: personality id (btt, btt2, fsdax, devdax....)
+ * @reserved2: reserved
+ * @checksum: fletcher64 sum of this object
  */
 struct nd_namespace_label {
 	u8 uuid[NSLABEL_UUID_LEN];

