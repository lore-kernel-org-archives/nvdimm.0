Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6789211BD605
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 12:05:28 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl: Fix the failure interpretation for status
 translations
Date: Wed, 30 Jan 2019 13:05:21 -0700
Message-Id: <20190130200521.9245-1-vishal.l.verma@intel.com>
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

commit 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
firmware_status translation") has the unfortunate side effect of making
all NDCTL commands fail with -ENOMSG unless an xlat_firmware_status
function is defined for the DIMM family. A failure to translate just
means proceed with the information that we do have, not report a
command failure.

Fixes: 62bbfce3cb62 ("libndctl, intel: Add infrastructure for firmware_status translation")
Reported-by: Oliver O'Halloran <oohall@gmail.com>
Based-on-patch-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 830b791..2fa8916 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2710,7 +2710,7 @@ NDCTL_EXPORT int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 	struct ndctl_dimm_ops *ops = dimm ? dimm->ops : NULL;
 
 	if (!dimm || !ops || !ops->xlat_firmware_status)
-		return -ENOMSG;
+		return 0;
 	return ops->xlat_firmware_status(cmd);
 }
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
