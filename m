Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE4332194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:03:26 -0700 (PDT)
Subject: [PATCH v2 7/7] tools/testing/nvdimm: fix nfit_test shutdown crashes
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 14:57:42 -0700
Message-ID: <149220706287.36563.2986440928438769021.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Keep the nfit_test instances alive until after nfit_test_teardown(), as
we may be doing resource lookups until the final un-registrations have
completed. This fixes crashes of the form.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
 IP: __release_resource+0x12/0x90
 Call Trace:
  remove_resource+0x23/0x40
  __wrap_remove_resource+0x29/0x30 [nfit_test_iomap]
  acpi_nfit_remove_resource+0xe/0x10 [nfit]
  devm_action_release+0xf/0x20
  release_nodes+0x16d/0x2b0
  devres_release_all+0x3c/0x60
  device_release+0x21/0x90
  kobject_release+0x6a/0x170
  kobject_put+0x2f/0x60
  put_device+0x17/0x20
  platform_device_unregister+0x20/0x30
  nfit_test_exit+0x36/0x960 [nfit_test]

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index bc02f28ed8b8..d7fb1b894128 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1958,6 +1958,7 @@ static __init int nfit_test_init(void)
 			put_device(&pdev->dev);
 			goto err_register;
 		}
+		get_device(&pdev->dev);
 
 		rc = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 		if (rc)
@@ -1976,6 +1977,10 @@ static __init int nfit_test_init(void)
 		if (instances[i])
 			platform_device_unregister(&instances[i]->pdev);
 	nfit_test_teardown();
+	for (i = 0; i < NUM_NFITS; i++)
+		if (instances[i])
+			put_device(&instances[i]->pdev.dev);
+
 	return rc;
 }
 
@@ -1983,10 +1988,13 @@ static __exit void nfit_test_exit(void)
 {
 	int i;
 
-	platform_driver_unregister(&nfit_test_driver);
 	for (i = 0; i < NUM_NFITS; i++)
 		platform_device_unregister(&instances[i]->pdev);
+	platform_driver_unregister(&nfit_test_driver);
 	nfit_test_teardown();
+
+	for (i = 0; i < NUM_NFITS; i++)
+		put_device(&instances[i]->pdev.dev);
 	class_destroy(nfit_test_dimm);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
