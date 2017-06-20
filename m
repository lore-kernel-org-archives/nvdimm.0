Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41B1621BBC42F
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:50:33 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 7/7] acpi, nfit: override mask
Date: Tue, 20 Jun 2017 10:51:26 -0600
Message-Id: <a9511b97feab5d3963c6e98391176c5c782277d5.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
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

Add module parameter override_dsm_mask_root for overriding
the dsm_mask like we do for non-root dsm calls.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f133b3e..456fcc2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1624,6 +1624,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
 	const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
 	struct acpi_device *adev;
+	unsigned long dsm_mask;
 	int i;
 
 	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
@@ -1635,7 +1636,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
 	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
-	for (i = 0; i < ND_CMD_CALL; i++)
+
+	dsm_mask = 0x3bf;
+	if (override_dsm_mask)
+		dsm_mask = override_dsm_mask;
+	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->bus_dsm_mask);
 }
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
