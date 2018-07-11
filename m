Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 270EE20968910
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 09:01:10 -0700 (PDT)
Subject: [PATCH v2] acpi/nfit: fix cmd_rc for acpi_nfit_ctl to always return
 a value
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jul 2018 09:01:09 -0700
Message-ID: <153132483983.35487.460701028810915794.stgit@djiang5-desk3.ch.intel.com>
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

cmd_rc is passed in by reference to the acpi_nfit_ctl() function and the
caller expects a value returned. However, when the package is pass through
via the ND_CMD_CALL command, cmd_rc is not touched. Make sure cmd_rc is
always set.

Fixes: aef253382266 ("libnvdimm, nfit: centralize command status translation")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2:
- Fix unchecked dereference (Dan Carpenter)


 drivers/acpi/nfit/core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7327b6a11ca9..0f47917b8ef1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -408,6 +408,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	const guid_t *guid;
 	int rc, i;
 
+	if (cmd_rc)
+		*cmd_rc = -EINVAL;
 	func = cmd;
 	if (cmd == ND_CMD_CALL) {
 		call_pkg = buf;
@@ -518,6 +520,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		 * If we return an error (like elsewhere) then caller wouldn't
 		 * be able to rely upon data returned to make calculation.
 		 */
+		if (cmd_rc)
+			*cmd_rc = 0;
 		return 0;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
