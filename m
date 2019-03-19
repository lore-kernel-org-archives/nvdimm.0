Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3499C211DCDB8
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 18:06:20 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl/test: add dax_pmem* modules to the test-core
Date: Mon, 18 Mar 2019 19:06:18 -0600
Message-Id: <20190319010618.26207-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Add a check for the nfit_test overridden modules for dax_pmem,
dax_pmem_core, and dax_pmem_compat to the test core to ensure that the
regular production versions aren't the ones being used.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/core.c b/test/core.c
index 4b36b2d..b9e3bbf 100644
--- a/test/core.c
+++ b/test/core.c
@@ -129,6 +129,8 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		"nfit",
 		"device_dax",
 		"dax_pmem",
+		"dax_pmem_core",
+		"dax_pmem_compat",
 		"libnvdimm",
 		"nd_blk",
 		"nd_btt",
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
