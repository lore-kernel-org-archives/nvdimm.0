Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B082C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984263; x=1674520263;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9phvsEdVa2NG/oq5IvGjMBe+GhzMW82MW8Sk8mr3eO8=;
  b=Z39eAnVL4l+JKRvTMoKeiKUz2vSK+gCkh2e+e5uT4LcnVVWVmOtzME2w
   zTEvwGEEGCUqNqzlWBPcqC2CrIF2Iqw+1zcpL5grTUTTFpGJ+rQVuWQfe
   mICieFRtfsD7lOB1gr3bQ6/kyoa5ttwEHzmTyXIkZYAk5raRhPhXJXgmh
   95fZ3S96K3gBe59poOg/GjmGJTyZuV1jL8Rmtv2V23sUzbGeihqJ47ysY
   t8dtMA/RX60NtWHqtFQMtuko34ffr0hqRXr5BGxN7LD5mTPqi9YG6MLbB
   WpCGGMq9DfPP2jMOPmvKPWlfO5jhn9NDB5C/7Sn8O5EXjqtEKtNeebdPj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="332288977"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="332288977"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="768517306"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:03 -0800
Subject: [PATCH v3 27/40] cxl/pci: Cache device DVSEC offset
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:31:02 -0800
Message-ID: <164298426273.3018233.9302136088649279124.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The PCIe device DVSEC, defined in the CXL 2.0 spec, 8.1.3 is required to
be implemented by CXL 2.0 endpoint devices. Since the information
contained within this DVSEC will be critically important, it makes sense
to find the value early, and error out if it cannot be found.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxlmem.h |    2 ++
 drivers/cxl/pci.c    |    9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 90d67fff5bed..cedc6d3c0448 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -98,6 +98,7 @@ struct cxl_mbox_cmd {
  *
  * @dev: The device associated with this CXL state
  * @regs: Parsed register blocks
+ * @device_dvsec: Offset to the PCIe device DVSEC
  * @payload_size: Size of space for payload
  *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
  * @lsa_size: Size of Label Storage Area
@@ -126,6 +127,7 @@ struct cxl_dev_state {
 	struct device *dev;
 
 	struct cxl_regs regs;
+	int device_dvsec;
 
 	size_t payload_size;
 	size_t lsa_size;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index e54dbdf9ac15..76de39b90351 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -408,6 +408,15 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (IS_ERR(cxlds))
 		return PTR_ERR(cxlds);
 
+	cxlds->device_dvsec = pci_find_dvsec_capability(pdev,
+							PCI_DVSEC_VENDOR_ID_CXL,
+							CXL_DVSEC_PCIE_DEVICE);
+	if (!cxlds->device_dvsec) {
+		dev_err(&pdev->dev,
+			"Device DVSEC not present. Expect limited functionality.\n");
+		return -ENXIO;
+	}
+
 	rc = cxl_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map);
 	if (rc)
 		return rc;

