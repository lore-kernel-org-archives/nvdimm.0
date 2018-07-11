Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BACAB202E541E
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 10:10:12 -0700 (PDT)
Subject: [PATCH] nfit: fix unchecked dereference in acpi_nfit_ctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jul 2018 10:10:11 -0700
Message-ID: <153132901164.57269.12329347241228490231.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Incremental patch to fix the unchecked dereference in acpi_nfit_ctl.
Reported by Dan Carpenter:

"acpi/nfit: fix cmd_rc for acpi_nfit_ctl to
always return a value" from Jun 28, 2018, leads to the following
Smatch complaint:

    drivers/acpi/nfit/core.c:578 acpi_nfit_ctl()
     warn: variable dereferenced before check 'cmd_rc' (see line 411)

drivers/acpi/nfit/core.c
   410
   411		*cmd_rc = -EINVAL;
                ^^^^^^^^^^^^^^^^^^
Patch adds unchecked dereference.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 2be8373153ed..0f47917b8ef1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -408,7 +408,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	const guid_t *guid;
 	int rc, i;
 
-	*cmd_rc = -EINVAL;
+	if (cmd_rc)
+		*cmd_rc = -EINVAL;
 	func = cmd;
 	if (cmd == ND_CMD_CALL) {
 		call_pkg = buf;
@@ -519,7 +520,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		 * If we return an error (like elsewhere) then caller wouldn't
 		 * be able to rely upon data returned to make calculation.
 		 */
-		*cmd_rc = 0;
+		if (cmd_rc)
+			*cmd_rc = 0;
 		return 0;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
