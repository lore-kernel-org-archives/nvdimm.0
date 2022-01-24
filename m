Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDF02C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984332; x=1674520332;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zjJfWfbswenFYOz5k8X7DYO75wu8mBNq2H/tyjem1Zc=;
  b=LFqC0lMMJTrFNdvTZi4H5qX8ssCz6F62nyqn7x8Cv7P8PmxvruWwPWcm
   zjDxBa8SitbPD1yAx6siJyDJhvTGoWVKZwF4ziXYGEtEAnA5iCHbx6OZr
   +yTiuQWVa5YgHVqToWsqHdIg/GlX6Wg5fwPwcK5XH5ufdoFN2SAZA4kxa
   PySgN3BpPh0XL1veYbH6i4eNshMXwGZb+IrdF3yRBuXeg6V0kf5ySAJHO
   E43VvQHo8VMD7Jhik4SffZmhiSPvZ+XB81X3gYhFfkon1tFdRi/pgQt8Z
   Pq4kz5139RZlfhZYN2bJW27TPMSQaOU3c/xSnh6HPNGRPLrnOJU8uxWzj
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="270368609"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="270368609"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:32:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="673453970"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:32:12 -0800
Subject: [PATCH v3 40/40] tools/testing/cxl: Add a physical_node link
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:32:12 -0800
Message-ID: <164298433209.3018233.18101085948127163720.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Emulate what ACPI does to link a host bridge platform firmware device to
device node on the PCI bus. In this case it's just self referencing
link, but it otherwise lets the tooling test out its lookup code.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 1b36e67dcd7e..431f2bddf6c8 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -641,7 +641,12 @@ static __init int cxl_test_init(void)
 			platform_device_put(pdev);
 			goto err_bridge;
 		}
+
 		cxl_host_bridge[i] = pdev;
+		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
+				       "physical_node");
+		if (rc)
+			goto err_bridge;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
@@ -745,8 +750,14 @@ static __init int cxl_test_init(void)
 	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
 		platform_device_unregister(cxl_root_port[i]);
 err_bridge:
-	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--)
+	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_host_bridge[i];
+
+		if (!pdev)
+			continue;
+		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
 		platform_device_unregister(cxl_host_bridge[i]);
+	}
 err_populate:
 	depopulate_all_mock_resources();
 err_gen_pool_add:
@@ -769,8 +780,14 @@ static __exit void cxl_test_exit(void)
 		platform_device_unregister(cxl_switch_uport[i]);
 	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--)
 		platform_device_unregister(cxl_root_port[i]);
-	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--)
+	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_host_bridge[i];
+
+		if (!pdev)
+			continue;
+		sysfs_remove_link(&pdev->dev.kobj, "physical_node");
 		platform_device_unregister(cxl_host_bridge[i]);
+	}
 	depopulate_all_mock_resources();
 	gen_pool_destroy(cxl_mock_pool);
 	unregister_cxl_mock_ops(&cxl_mock_ops);

