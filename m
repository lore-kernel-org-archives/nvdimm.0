Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6213.austin.hp.com (g1t6213.austin.hp.com [15.73.96.121])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BB1D1A1F2E
 for <linux-nvdimm@lists.01.org>; Wed, 27 Apr 2016 15:46:54 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v10 6/7] tools/testing/nvdimm: dimm_dsm_force_en
Date: Wed, 27 Apr 2016 16:46:18 -0600
Message-Id: <e85a377a8bdddcdfb1a0de02237be11773eba7d6.1461793650.git.jerry.hoemann@hpe.com>
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

Set ND_CMD_CALL in dimm_dsm_force_en.
Change name dimm_dsm_force_en to dimm_cmd_force_en.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c              | 2 +-
 drivers/acpi/nfit.h              | 2 +-
 tools/testing/nvdimm/test/nfit.c | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 90b63f9..e412b98 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1013,7 +1013,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	const u8 *uuid;
 	int i;
 
-	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
+	nfit_mem->cmd_mask = acpi_desc->dimm_cmd_force_en;
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return 0;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index e2fcab3..3b5759a 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -138,7 +138,7 @@ struct acpi_nfit_desc {
 	size_t ars_status_size;
 	struct work_struct work;
 	unsigned int cancel:1;
-	unsigned long dimm_dsm_force_en;
+	unsigned long dimm_cmd_force_en;
 	unsigned long bus_dsm_force_en;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 6c89811..c04a2c5 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1260,9 +1260,10 @@ static void nfit_test0_setup(struct nfit_test *t)
 	post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA0_SIZE);
 
 	acpi_desc = &t->acpi_desc;
-	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
-	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
-	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
+	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_CALL,		&acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
