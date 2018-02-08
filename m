Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7131222DE13D
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 13:18:29 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 2/2] libnvdimm,
 testing: update the default smart ctrl_temperature
Date: Thu,  8 Feb 2018 14:24:05 -0700
Message-Id: <20180208212405.10955-2-vishal.l.verma@intel.com>
In-Reply-To: <20180208212405.10955-1-vishal.l.verma@intel.com>
References: <20180208212405.10955-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The default value for smart ctrl_temperature was the same as the
threshold for ctrl_temperature. As a result, any arbitrary smart
injection to the nfit_test dimm could cause this alarm to trigger
and cause an acpi notification. Drop the default value to below the
threshold, so that unrelated injections don't trigger notifications.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1df6131d569f..1bfe669e22f2 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1256,7 +1256,7 @@ static void smart_init(struct nfit_test *t)
 			| ND_INTEL_SMART_MTEMP_VALID,
 		.health = ND_INTEL_SMART_NON_CRITICAL_HEALTH,
 		.media_temperature = 23 * 16,
-		.ctrl_temperature = 30 * 16,
+		.ctrl_temperature = 25 * 16,
 		.pmic_temperature = 40 * 16,
 		.spares = 75,
 		.alarm_flags = ND_INTEL_SMART_SPARE_TRIP
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
