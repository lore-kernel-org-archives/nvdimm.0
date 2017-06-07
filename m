Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D6D421AE30D1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 10:03:52 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 2/3] acpi, nfit: Enable DSM pass thru for root functions.
Date: Wed,  7 Jun 2017 11:04:56 -0600
Message-Id: <cac12e3bf8ecd1762153d5ee10ee2578f0899c77.1496852665.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1496852665.git.jerry.hoemann@hpe.com>
References: <cover.1496852665.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1496852665.git.jerry.hoemann@hpe.com>
References: <cover.1496852665.git.jerry.hoemann@hpe.com>
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
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Set ND_CMD_CALL in the cmd_mask to enable calling root
functions via the pass trhu mechanism.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit/core.c   | 3 ++-
 include/uapi/linux/ndctl.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 656acb5..a848b17 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1620,9 +1620,10 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	if (!adev)
 		return;
 
-	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
+	for (i = ND_CMD_ARS_CAP; i <  ND_CMD_CALL; i++)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
+	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
 }
 
 static ssize_t range_index_show(struct device *dev,
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7ad3863..e23c37f 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -179,6 +179,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_CALL] = "cmd_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
