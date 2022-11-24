Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AB33F9
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314883; x=1700850883;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OQiwZ/nryesuXAudkk9d/wumNNOOVa/gKNYS/Q4OFZA=;
  b=elrvH4SWUh+y1Y0C6ZEWJd3VhdRIid52vSb4QQ4m/xQyH0gqBoxdtLXO
   YqgAvFntcspVtvi00muksuOfcpjk8RBXtW7YaKQKxBs+vVdE4r+ZqaLS5
   W5Dp1cVpYGN79yC/jRDQhfTSNR2ivE1qVjxk6lIXi7WUsrKmbHQmw5Rfv
   v+7iZLxUz522PKvS/SICVF+kQxHE6wKrDAFmnm/iWh33TzFITVGmx/gJq
   w2obdEAtL2Kku6Zh9UinhxZ9mExqjDCa5rDsmeXUwA2mjT8ymAvYFsxfh
   5IxHMwo8IwnOAp76tDziyjfMXXNDT5dQnK9TwXS5iZCKNn71ixA1ipqQy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="376494012"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="376494012"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:34:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="705839139"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="705839139"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:34:41 -0800
Subject: [PATCH v4 01/12] cxl/acpi: Simplify cxl_nvdimm_bridge probing
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:34:41 -0800
Message-ID: <166931488125.2104015.15224170137566912020.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The 'struct cxl_nvdimm_bridge' object advertises platform CXL PMEM
resources. It coordinates with libnvdimm to attach nvdimm devices and
regions for each corresponding CXL object. That coordination is
complicated, i.e. difficult to reason about, and it turns out redundant.
It is already the case that the CXL core knows how to tear down a
cxl_region when a cxl_memdev goes through ->remove(), so that pathway
can be extended to directly cleanup cxl_nvdimm and cxl_pmem_region
objects.

Towards the goal of ripping out the cxl_nvdimm_bridge state machine,
arrange for cxl_acpi to optionally pre-load the cxl_pmem driver so that
the nvdimm bridge is active synchronously with
devm_cxl_add_nvdimm_bridge(), and remove all the bind attributes for the
cxl_nvdimm* objects since the cxl root device and cxl_memdev bind
attributes are sufficient.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c |    1 +
 drivers/cxl/pmem.c |    9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index fb9f72813067..c540da0cbf1e 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -539,3 +539,4 @@ module_platform_driver(cxl_acpi_driver);
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(CXL);
 MODULE_IMPORT_NS(ACPI);
+MODULE_SOFTDEP("pre: cxl_pmem");
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 4c627d67281a..946e171e7d4a 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -99,6 +99,9 @@ static struct cxl_driver cxl_nvdimm_driver = {
 	.name = "cxl_nvdimm",
 	.probe = cxl_nvdimm_probe,
 	.id = CXL_DEVICE_NVDIMM,
+	.drv = {
+		.suppress_bind_attrs = true,
+	},
 };
 
 static int cxl_pmem_get_config_size(struct cxl_dev_state *cxlds,
@@ -360,6 +363,9 @@ static struct cxl_driver cxl_nvdimm_bridge_driver = {
 	.probe = cxl_nvdimm_bridge_probe,
 	.remove = cxl_nvdimm_bridge_remove,
 	.id = CXL_DEVICE_NVDIMM_BRIDGE,
+	.drv = {
+		.suppress_bind_attrs = true,
+	},
 };
 
 static int match_cxl_nvdimm(struct device *dev, void *data)
@@ -583,6 +589,9 @@ static struct cxl_driver cxl_pmem_region_driver = {
 	.name = "cxl_pmem_region",
 	.probe = cxl_pmem_region_probe,
 	.id = CXL_DEVICE_PMEM_REGION,
+	.drv = {
+		.suppress_bind_attrs = true,
+	},
 };
 
 /*

