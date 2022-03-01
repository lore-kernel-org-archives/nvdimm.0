Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5026517E8
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646102963; x=1677638963;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKrCzA0DUWytFgTFvZI0tuJIcbREVqqSnKKBEdoNKwU=;
  b=oI2hR9pc8+CnxJkN6eB/k2hIhqObnHVIhfHm8fGH22959psXxYUv9jkd
   Urpr/UoVDo71C8YBjRN2JfX+F4EdGCEBN71TVdLWsjLhwGndzB0snJcJE
   0ycAhHgSxWcrz8Lxyd78xezwEsnidv/hcx1zehJRu08oHDVD9newbUoZS
   edUMyqanJdJPobF2ziKvuUZcFbWAsv5uoKK8loRsF3Tjrlo4EV1jnvp2b
   swTl3NjWJghjRA4YmYAk9lnAD7lJKxRv26Z4tNMZ5s/mqFOSPiThX5Gla
   dovBtM5gJXUHC0Ufoa77cC4dNVRMZfc02+eF3PRmey4Hwy7lN/VGvuw1b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="240453169"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="240453169"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="778310473"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:49:22 -0800
Subject: [PATCH 06/11] cxl/acpi: Add a lock class for the root platform
 device
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 28 Feb 2022 18:49:22 -0800
Message-ID: <164610296214.2682974.9364719321216244746.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the device-core can start validating lockdep usage after the
device has been added, use that capability to validate usage of
device_lock() against the ACPI0017 device relative to other subsystem
locks.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c |    1 +
 drivers/cxl/cxl.h  |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 37bc8d787999..7fa7bf6088cd 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -313,6 +313,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
+	device_set_lock_class(&pdev->dev, CXL_ROOT_LOCK);
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f94eff659cce..5179b6bb1b36 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -496,9 +496,9 @@ struct cxl_nvdimm *cxl_find_nvdimm(struct cxl_memdev *cxlmd);
 #define __mock static
 #endif
 
-#ifdef CONFIG_PROVE_CXL_LOCKING
 enum cxl_lock_class {
 	CXL_ANON_LOCK,
+	CXL_ROOT_LOCK,
 	CXL_NVDIMM_LOCK,
 	CXL_NVDIMM_BRIDGE_LOCK,
 	CXL_PORT_LOCK = 2,
@@ -510,6 +510,7 @@ enum cxl_lock_class {
 	 */
 };
 
+#ifdef CONFIG_PROVE_CXL_LOCKING
 static inline int clamp_lock_class(struct device *dev, int lock_class)
 {
 	if (lock_class >= MAX_LOCKDEP_SUBCLASSES) {

