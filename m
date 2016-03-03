Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 4F91C1A1EBD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 14:40:00 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] nfit: Continue init even if ARS commands are unimplemented
Date: Thu,  3 Mar 2016 15:39:41 -0700
Message-Id: <1457044781-15443-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If firmware doesn't implement any of the ARS commands, take that to
mean that ARS is unsupported, and continue to initialize regions without
bad block lists. We cannot make the assumption that ARS commands will be
unconditionally supported on all NVDIMMs.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2:
- improve the debug message when we his this unimplemented case (Dan).

 drivers/acpi/nfit.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fb53db1..35947ac 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1590,14 +1590,21 @@ static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
 	start = ndr_desc->res->start;
 	len = ndr_desc->res->end - ndr_desc->res->start + 1;
 
+	/*
+	 * If ARS is unimplemented, unsupported, or if the 'Persistent Memory
+	 * Scrub' flag in extended status is not set, skip this but continue
+	 * initialization
+	 */
 	rc = ars_get_cap(nd_desc, ars_cap, start, len);
+	if (rc == -ENOTTY) {
+		dev_dbg(acpi_desc->dev,
+			"Address Range Scrub is not implemented, won't create an error list\n");
+		rc = 0;
+		goto out;
+	}
 	if (rc)
 		goto out;
 
-	/*
-	 * If ARS is unsupported, or if the 'Persistent Memory Scrub' flag in
-	 * extended status is not set, skip this but continue initialization
-	 */
 	if ((ars_cap->status & 0xffff) ||
 		!(ars_cap->status >> 16 & ND_ARS_PERSISTENT)) {
 		dev_warn(acpi_desc->dev,
-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
