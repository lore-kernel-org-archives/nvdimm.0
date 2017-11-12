Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3ED5220757E9
 for <linux-nvdimm@lists.01.org>; Sun, 12 Nov 2017 15:29:15 -0800 (PST)
Subject: [PATCH 2/2] tools/testing/nvdimm: unit test clear-error commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Nov 2017 15:25:06 -0800
Message-ID: <151052910654.33363.6050998824518199379.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151052910143.33363.12653920068445460294.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151052910143.33363.12653920068445460294.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Validate command parsing in acpi_nfit_ctl for the clear error command.
This tests for a crash condition introduced by commit 4b27db7e26cd
"acpi, nfit: add support for the _LSI, _LSR, and _LSW label methods".

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index edab68c2e221..7a4846d9607d 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1812,6 +1812,7 @@ static int nfit_ctl_test(struct device *dev)
 	unsigned long mask, cmd_size, offset;
 	union {
 		struct nd_cmd_get_config_size cfg_size;
+		struct nd_cmd_clear_error clear_err;
 		struct nd_cmd_ars_status ars_stat;
 		struct nd_cmd_ars_cap ars_cap;
 		char buf[sizeof(struct nd_cmd_ars_status)
@@ -1995,6 +1996,23 @@ static int nfit_ctl_test(struct device *dev)
 		return -EIO;
 	}
 
+	/* test clear error */
+	cmd_size = sizeof(cmds.clear_err);
+	cmds.clear_err = (struct nd_cmd_clear_error) {
+		.length = 512,
+		.cleared = 512,
+	};
+	rc = setup_result(cmds.buf, cmd_size);
+	if (rc)
+		return rc;
+	rc = acpi_nfit_ctl(&acpi_desc->nd_desc, NULL, ND_CMD_CLEAR_ERROR,
+			cmds.buf, cmd_size, &cmd_rc);
+	if (rc < 0 || cmd_rc >= 0) {
+		dev_dbg(dev, "%s: failed at: %d rc: %d cmd_rc: %d\n",
+				__func__, __LINE__, rc, cmd_rc);
+		return -EIO;
+	}
+
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
