Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: vishal@kernel.org
Subject: [PATCH 1/3] nfit_test: Enable DSMs for all test NFITs
Date: Sun, 20 Dec 2015 02:18:40 -0700
Message-Id: <1450603122-7205-2-git-send-email-vishal@kernel.org>
In-Reply-To: <1450603122-7205-1-git-send-email-vishal@kernel.org>
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

In preparation for getting a poison list using ARS DSMs, enable DSMs for
all manufactured NFITs supplied by the test framework.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 51cf825..298805a 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1088,6 +1088,8 @@ static void nfit_test1_setup(struct nfit_test *t)
 	struct acpi_nfit_memory_map *memdev;
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_system_address *spa;
+	struct nvdimm_bus_descriptor *nd_desc;
+	struct acpi_nfit_desc *acpi_desc;
 
 	offset = 0;
 	/* spa0 (flat range with no bdw aliasing) */
@@ -1135,6 +1137,13 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->command_size = 0;
 	dcr->status_offset = 0;
 	dcr->status_size = 0;
+
+	acpi_desc = &t->acpi_desc;
+	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
+	nd_desc = &acpi_desc->nd_desc;
+	nd_desc->ndctl = nfit_test_ctl;
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
-- 
2.5.0

