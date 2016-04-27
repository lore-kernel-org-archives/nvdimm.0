Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4619.austin.hp.com (g2t4619.austin.hp.com [15.73.212.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB27D1A1F2D
 for <linux-nvdimm@lists.01.org>; Wed, 27 Apr 2016 15:46:53 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v10 5/7] nvdimm: Extend nfit_cmd_family_tbl to allow masking
 dsm_mask
Date: Wed, 27 Apr 2016 16:46:17 -0600
Message-Id: <c046e835daa8f50bff027078ba6f4b5164ebfec4.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Extend nfit_cmd_family_tbl to have both cmd_mask and dsm_masks
modifiers.  The masking of dsm_mask allows for Linux to block
block calls to only those functions defined in their respective
specifications.

The cmd_mask are different in that with the pass-thru only
ND_CMD_CALL is allowed.  But in case of cmd_mask its not as
simple as taking result of (1ULL << ND_CMD_CALL) | dsm_mask.

acpi_nfit_add_dimm() calls determine_cmd_family() to return table
entry that has separate configuration features of the nvdimm.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c | 45 ++++++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index a15fd92..90b63f9 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -60,7 +60,8 @@ struct cmd_family_tbl {
 	enum nfit_uuids	key_uuid;	/* Internal handle		*/
 	int		key_type;	/* Exported handle		*/
 	int		rev;		/* _DSM rev			*/
-	int		does_ioctls;	/* Family supports all commands? */
+	int		cmd_mask;	/* Family supports these commands */
+	unsigned long	family_mask;	/* Make sure _DSM mask is per spec */
 };
 
 /*
@@ -69,9 +70,9 @@ struct cmd_family_tbl {
 #define ND_MAX_DSM_FUN_IDX	20
 
 static const struct cmd_family_tbl nfit_cmd_family_tbl[] = {
-	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1, 1},
-	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1, 0},
-	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1, 0},
+	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1, 0x3fe, 0x0000003ff},
+	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1, 0,	  0x3ffffffff},
+	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1, 0,	  0x00007ffff},
 	{ -1, -1, -1},
 };
 
@@ -986,7 +987,8 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
-static int determine_uuid(acpi_handle handle, u8 const **cmd_uuid)
+
+static const struct cmd_family_tbl *determine_cmd_family(acpi_handle handle)
 {
 	const struct cmd_family_tbl *tbl = nfit_cmd_family_tbl;
 	int i;
@@ -996,31 +998,16 @@ static int determine_uuid(acpi_handle handle, u8 const **cmd_uuid)
 		int rev = tbl[i].rev;
 
 		if (acpi_check_dsm(handle, uuid, rev, 1ULL)) {
-			*cmd_uuid = uuid;
-			return 1;
+			return &tbl[i];
 		}
 	}
-	return 0;
-}
-
-static int determine_cmd_mask(u8 const *cmd_uuid)
-{
-	const struct cmd_family_tbl *tbl = nfit_cmd_family_tbl;
-	int i;
-
-	for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
-		const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
-
-		if (memcmp(uuid, cmd_uuid, 16) == 0)
-			return tbl[i].does_ioctls;
-	}
-	return 0;
+	return NULL;
 }
 
-
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
+	const struct cmd_family_tbl *tbl;
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
 	const u8 *uuid;
@@ -1039,17 +1026,17 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		return force_enable_dimms ? 0 : -ENODEV;
 	}
 
-	if (!determine_uuid(adev_dimm->handle, &nfit_mem->dsm_uuid))
+	tbl = determine_cmd_family(adev_dimm->handle);
+	if (!tbl)
 		return force_enable_dimms ? 0 : -ENODEV;
 
-	uuid = nfit_mem->dsm_uuid;
-	for (i = 0; i <= ND_MAX_DSM_FUN_IDX; i++)
+	uuid = nfit_mem->dsm_uuid = to_nfit_uuid(tbl->key_uuid);
+	for_each_set_bit(i, &(tbl->family_mask), BITS_PER_LONG)
 		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
-	nfit_mem->cmd_mask = (1 << ND_CMD_CALL);
-	if (determine_cmd_mask(uuid))
-		nfit_mem->cmd_mask |= nfit_mem->dsm_mask;
+	nfit_mem->cmd_mask = (1ULL << ND_CMD_CALL);
+	nfit_mem->cmd_mask |= tbl->cmd_mask;
 
 	return 0;
 }
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
