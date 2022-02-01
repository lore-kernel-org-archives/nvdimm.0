Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAEE2F27
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 22:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643753193; x=1675289193;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RWxjv54zDCrUwS7hL2/Nzgg1s2DMRpDAjCUUHHR7Ob0=;
  b=HPBrvwPQ5GEKzSGTCQMRNVMwx/EQeY36hwJD3BTsg7dDgBcHAtlRMvEg
   BnRA/kU8BHcrEHcI0n/H6iEH31ow0zqV9AX988wK4lPv5udVSgnlBJ+XL
   p00/8J1JPB3yYKrstqREYyMG5H6dclLeMCahfiGj8stVY1foECEgqqeDx
   u9vWdxxAYUimbTNinxuoOSA0FmiVDu+AloOJEkdZVQwhBZzsQCAwgGq1d
   1BPg6wKO4HVhBZYpisXL3hrVFs6Tnf5vRhDo8k2f1DFKwMSqS9U/Ag2Zl
   v3k4sgFQ/+/EfYt2u1oaP6NEwpPS9Gq8ix0xTe1kXmyA2coxAoOwJ1gGA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="235201389"
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="235201389"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 14:06:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="538006031"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 14:06:32 -0800
Subject: [PATCH v4 27/40] cxl/pci: Cache device DVSEC offset
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 01 Feb 2022 14:06:32 -0800
Message-ID: <164375309615.513620.7874131241128599893.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
be implemented by CXL 2.0 endpoint devices. In preparation for consuming
this information in a new cxl_mem driver, retrieve the CXL DVSEC
position and warn about the implications of not finding it. Allow for
mailbox operation even if the CXL DVSEC is missing.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Move the s/device_dvsec/cxl_dvsec/ rename one patch sooner (Jonathan)
- Warn, don't fail, when CXL DVSEC not found

 drivers/cxl/cxlmem.h |    2 ++
 drivers/cxl/pci.c    |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 90d67fff5bed..5cf5329e13a9 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -98,6 +98,7 @@ struct cxl_mbox_cmd {
  *
  * @dev: The device associated with this CXL state
  * @regs: Parsed register blocks
+ * @cxl_dvsec: Offset to the PCIe device DVSEC
  * @payload_size: Size of space for payload
  *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
  * @lsa_size: Size of Label Storage Area
@@ -126,6 +127,7 @@ struct cxl_dev_state {
 	struct device *dev;
 
 	struct cxl_regs regs;
+	int cxl_dvsec;
 
 	size_t payload_size;
 	size_t lsa_size;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index bf14c365ea33..c94002166084 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -408,6 +408,12 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (IS_ERR(cxlds))
 		return PTR_ERR(cxlds);
 
+	cxlds->cxl_dvsec = pci_find_dvsec_capability(
+		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
+	if (!cxlds->cxl_dvsec)
+		dev_warn(&pdev->dev,
+			 "Device DVSEC not present, skip CXL.mem init\n");
+
 	rc = cxl_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map);
 	if (rc)
 		return rc;

