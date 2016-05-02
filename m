Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 420791A1E68
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 09:26:30 -0700 (PDT)
Subject: [PATCH] nfit: fix translation of command status results
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 May 2016 09:25:41 -0700
Message-ID: <146220634174.8521.14748358560688740425.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When transportation of the command completes successfully, it indicates
that the 'status' result is valid.  Fix the missed checking and
translation of the status field at the end of acpi_nfit_ctl().
Otherwise, we fail to handle reported errors and assume commands
complete successfully.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e63640b..63cc9dbe4f3b 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -287,8 +287,11 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 					offset);
 			rc = -ENXIO;
 		}
-	} else
+	} else {
 		rc = 0;
+		if (cmd_rc)
+			*cmd_rc = xlat_status(buf, cmd);
+	}
 
  out:
 	ACPI_FREE(out_obj);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
