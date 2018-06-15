Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CBC0210F6727
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:40:21 -0700 (PDT)
Subject: [PATCH] tools/testing/nvdimm: Fix support for emulating controller
 temperature
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:30:23 -0700
Message-ID: <152902262388.10279.6032527372904228835.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In addition to populating the value the payload also needs to set the
"controller temperature valid" flag.

Fixes: cdd77d3e1930 ("nfit, libnvdimm: deprecate the generic SMART ioctl")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 6f19d6e28f5f..15dc280eb3ae 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1321,7 +1321,8 @@ static void smart_init(struct nfit_test *t)
 			| ND_INTEL_SMART_ALARM_VALID
 			| ND_INTEL_SMART_USED_VALID
 			| ND_INTEL_SMART_SHUTDOWN_VALID
-			| ND_INTEL_SMART_MTEMP_VALID,
+			| ND_INTEL_SMART_MTEMP_VALID
+			| ND_INTEL_SMART_CTEMP_VALID,
 		.health = ND_INTEL_SMART_NON_CRITICAL_HEALTH,
 		.media_temperature = 23 * 16,
 		.ctrl_temperature = 25 * 16,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
