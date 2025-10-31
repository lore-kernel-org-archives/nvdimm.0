Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F232EB840
	for <nvdimm@lists.linux.dev>; Fri, 31 Oct 2025 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761954153; cv=none; b=oMhFphDpROJYfBWom274K1vJUnHgNam0PiPaKjIYA6qnhzoeZSd2L+Ep5TQMRaMjAWXf7M4nQtF3u99VcFwvWLjdizUGeS31iSCcGizhkykXJ3L2BPHKFq2ySuB0hnKMVthMCu58AI/sdRSK4qR5kixzjraCRBVq5TooXTSpHm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761954153; c=relaxed/simple;
	bh=i/bb4Ywf2Nr6uloK3QTfhPAkrvD5TNMerqRE20boViM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hmmf9BnwxJ8muESTMlFXniX2iqiRvbaw+Hh7HxaTjaCDg4a0uM0kIVeJE19MrO82JwfeDoTUEXP5wk14N5GhFpAkbvPrRNCDi/uz6xZUTh3hDv12iY6W7DMvIlQrSWr+bEcIr15Ku5GysiOiS9gfqJMufDW6qlfsQ9jN4NJdj9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gALIJ4nS; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gALIJ4nS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761954152; x=1793490152;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i/bb4Ywf2Nr6uloK3QTfhPAkrvD5TNMerqRE20boViM=;
  b=gALIJ4nSMtb4dHHXIhKWUqN9+8BzC9FSYv5SKUxwnTIN7StahebN1f8Q
   WCxwTpXbpXrPx9zTncTgmQFHo2RoDGrLhmJfarFTM+gjTt6CIqIaPjuEY
   GnWvNhfNrJQvmvuG7Z6XcbldoaWLG2uVleY1w2WzF5tuEBFE+0vFGQVXC
   DZUkl7uU3e9360nlVMZ+pXJTfsnyG7pTtUS0mYAh8/usvGgMeCzGYgDk4
   K7bmWPJ2YJXPxxzfxamVnUapypg4J8UCWVeD39rur2TiewEy2/uEhiVWi
   1fCaEDtwOnSInrpD9ZFyYACNTs5Wn441JwIWT4VJlFPhnyZsboqjbl/24
   Q==;
X-CSE-ConnectionGUID: f9A8DgljQdSib+lXB3h+gQ==
X-CSE-MsgGUID: NVJOmMY4TEOA5kAnEEVibA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64161014"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="64161014"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:42:31 -0700
X-CSE-ConnectionGUID: SUqpsbngTp23PzfQMvyc3A==
X-CSE-MsgGUID: jBzmWsLNSDOAutNknt0cpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="186021323"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 16:42:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v2] tools/testing/nvdimm: Use per-DIMM device handle
Date: Fri, 31 Oct 2025 16:42:20 -0700
Message-ID: <20251031234227.1303113-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KASAN reports a global-out-of-bounds access when running these nfit
tests: clear.sh, pmem-errors.sh, pfn-meta-errors.sh, btt-errors.sh,
daxdev-errors.sh, and inject-error.sh.

[] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
[] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
[] The buggy address belongs to the variable:
[] handle+0x1c/0x1df4 [nfit_test]

nfit_test_search_spa() uses handle[nvdimm->id] to retrieve a device
handle and triggers a KASAN error when it reads past the end of the
handle array. It should not be indexing the handle array at all.

The correct device handle is stored in per-DIMM test data. Each DIMM
has a struct nfit_mem that embeds a struct acpi_nfit_memdev that
describes the NFIT device handle. Use that device handle here. 

Fixes: 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Use the correct handle in per-DIMM test data (Dan)
- Update commit message and log
- Update Fixes Tag


 tools/testing/nvdimm/test/nfit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cfd4378e2129..f87e9f251d13 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -670,6 +670,7 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
 		.addr = spa->spa,
 		.region = NULL,
 	};
+	struct nfit_mem *nfit_mem;
 	u64 dpa;
 
 	ret = device_for_each_child(&bus->dev, &ctx,
@@ -687,8 +688,12 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
 	 */
 	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
 	nvdimm = nd_mapping->nvdimm;
+	nfit_mem = nvdimm_provider_data(nvdimm);
+	if (!nfit_mem)
+		return -EINVAL;
 
-	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
+	spa->devices[0].nfit_device_handle =
+		__to_nfit_memdev(nfit_mem)->device_handle;
 	spa->num_nvdimms = 1;
 	spa->devices[0].dpa = dpa;
 

base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
-- 
2.37.3

