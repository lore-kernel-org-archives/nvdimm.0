Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2C10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930407; x=1701466407;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ObTYm2YJZuK4QxeOlN9sk37szLhiybc7WCROYQwIqsY=;
  b=Yn8lUA4Hn44a6mnnl5Nyc/V9XN8xSrEycjPZODycBx03DDyr6d5HowaN
   yRgcKgkuBAX008mDE+Fj4jAxLu7rjXjkI+2rQIQssESnY3dxby8n49uO8
   jy0xEpbaQyPQvEb/h079bvOAO2tGk09a3QN2Tku73czfiu4+1xa8/a0Mn
   xmirDOI6fMoVSL4nlGXRzErPh38fcv3YHwLG1CmQptURlvOlyej2vJw0y
   93W73iwj+6s7xN/SbUi4Y/uo2iFs9Y+P8C2TLqg2iHD1ox80s0BwyvtRb
   f+wJYP+6zQ51RyGLrjqV0Ygjkg/SS1ZDcv/HloFJMZF55ZMvpDfAA4a4U
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315831224"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="315831224"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="677368161"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="677368161"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:26 -0800
Subject: [PATCH v6 01/12] cxl/acpi: Simplify cxl_nvdimm_bridge probing
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:26 -0800
Message-ID: <166993040668.1882361.7450361097265836752.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
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

Tested-by: Robert Richter <rrichter@amd.com>
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

