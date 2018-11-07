Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61CB92118D936
 for <linux-nvdimm@lists.01.org>; Wed,  7 Nov 2018 10:52:45 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] libnvdimm: Fix __nd_ioctl() to check error in cmd_rc
Date: Wed,  7 Nov 2018 11:52:41 -0700
Message-Id: <20181107185241.26982-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ndctl zero-labels completes with a large number of zeroed nmems when
it fails to do zeroing on a protected NVDIMM.

  # ndctl zero-labels nmem1
  zeroed 65504 nmems

When an ACPI call completes with error, xlat_status() called from
acpi_nfit_ctl() sets error to *cmd_rc.  __nd_ioctl(), however, does
not check this error and returns with success.

Fix __nd_ioctl() to check this error in cmd_rc.

Fixes: 006358b35c73a ("libnvdimm: add support for clear poison list and badblocks for device dax")
Reported-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/nvdimm/bus.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index f1fb39921236..af12817d8a02 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -1050,6 +1050,10 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
 	if (rc < 0)
 		goto out_unlock;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out_unlock;
+	}
 
 	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
 		struct nd_cmd_clear_error *clear_err = buf;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
