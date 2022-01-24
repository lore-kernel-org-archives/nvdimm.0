Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90C929CA
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984153; x=1674520153;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MB2ZlF2aFSyfgNxgC0TuBkMRoRB/3utmmeKBUVvXP34=;
  b=KtBDwrDZNmgteqAzGlg+3ox4aZn3zv6NC8XLdzOpLZUiJmu4FDIzd62K
   gBn6WL414l97at2KmLzpBBoOi0XqPMRGFE57zrG9ch0LkdIhCgWuVxTSJ
   Jpi7T41dpxN/PgCyYrqaQH0NzWc3HoSan4jATQhpV87mWSHoiwQDX/nWl
   YCJMbO/4OLk4Vrlnqp0iPx8TPT/HfuQO/FSzla36mZLUxKhkbn13RuzZZ
   ulxQ1B3bIfr/7oaUzd3f+FEe5Uwq28IPUUqy5V6oDdO3yhKXZrw7I28D5
   lr0DmnBzIgRImrRxbS7sNsYef6VFCJkdl0zEPIulG2Ob9jyFqC0lSCpRC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="244766485"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="244766485"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="533999595"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:05 -0800
Subject: [PATCH v3 05/40] cxl/pci: Add new DVSEC definitions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huwei.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:29:05 -0800
Message-ID: <164298414567.3018233.12005290051592771878.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

In preparation for properly supporting memory active timeout, and later
on, other attributes obtained from DVSEC fields, add the full list of
DVSEC identifiers from the CXL 2.0 specification.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com> (v1)
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/pci.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/cxl/pci.h b/drivers/cxl/pci.h
index 29b8eaef3a0a..8ae2b4adc59d 100644
--- a/drivers/cxl/pci.h
+++ b/drivers/cxl/pci.h
@@ -16,6 +16,21 @@
 /* CXL 2.0 8.1.3: PCIe DVSEC for CXL Device */
 #define CXL_DVSEC_PCIE_DEVICE					0
 
+/* CXL 2.0 8.1.4: Non-CXL Function Map DVSEC */
+#define CXL_DVSEC_FUNCTION_MAP					2
+
+/* CXL 2.0 8.1.5: CXL 2.0 Extensions DVSEC for Ports */
+#define CXL_DVSEC_PORT_EXTENSIONS				3
+
+/* CXL 2.0 8.1.6: GPF DVSEC for CXL Port */
+#define CXL_DVSEC_PORT_GPF					4
+
+/* CXL 2.0 8.1.7: GPF DVSEC for CXL Device */
+#define CXL_DVSEC_DEVICE_GPF					5
+
+/* CXL 2.0 8.1.8: PCIe DVSEC for Flex Bus Port */
+#define CXL_DVSEC_PCIE_FLEXBUS_PORT				7
+
 /* CXL 2.0 8.1.9: Register Locator DVSEC */
 #define CXL_DVSEC_REG_LOCATOR					8
 #define   CXL_DVSEC_REG_LOCATOR_BLOCK1_OFFSET			0xC

