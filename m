Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 8/8] tools/testing/nvdimm: expand ars unit testing
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:40 -0800
Message-ID: <20160224021740.22776.90857.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Simulate platform-firmware-initiated and asynchronous scrub results.
This injects poison in the middle of all nfit_test pmem address ranges.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |  112 +++++++++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 22 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index a66842e61bbc..1555c09efba1 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -151,6 +151,11 @@ struct nfit_test {
 	int (*alloc)(struct nfit_test *t);
 	void (*setup)(struct nfit_test *t);
 	int setup_hotplug;
+	struct ars_state {
+		struct nd_cmd_ars_status *ars_status;
+		unsigned long deadline;
+		spinlock_t lock;
+	} ars_state;
 };
 
 static struct nfit_test *to_nfit_test(struct device *dev)
@@ -232,30 +237,72 @@ static int nfit_test_cmd_ars_cap(struct nd_cmd_ars_cap *nd_cmd,
 	return 0;
 }
 
-static int nfit_test_cmd_ars_start(struct nd_cmd_ars_start *nd_cmd,
-		unsigned int buf_len)
+/*
+ * Initialize the ars_state to return an ars_result 1 second in the future with
+ * a 4K error range in the middle of the requested address range.
+ */
+static void post_ars_status(struct ars_state *ars_state, u64 addr, u64 len)
 {
-	if (buf_len < sizeof(*nd_cmd))
+	struct nd_cmd_ars_status *ars_status;
+	struct nd_ars_record *ars_record;
+
+	ars_state->deadline = jiffies + 1*HZ;
+	ars_status = ars_state->ars_status;
+	ars_status->status = 0;
+	ars_status->out_length = sizeof(struct nd_cmd_ars_status)
+		+ sizeof(struct nd_ars_record);
+	ars_status->address = addr;
+	ars_status->length = len;
+	ars_status->type = ND_ARS_PERSISTENT;
+	ars_status->num_records = 1;
+	ars_record = &ars_status->records[0];
+	ars_record->handle = 0;
+	ars_record->err_address = addr + len / 2;
+	ars_record->length = SZ_4K;
+}
+
+static int nfit_test_cmd_ars_start(struct ars_state *ars_state,
+		struct nd_cmd_ars_start *ars_start, unsigned int buf_len,
+		int *cmd_rc)
+{
+	if (buf_len < sizeof(*ars_start))
 		return -EINVAL;
 
-	nd_cmd->status = 0;
+	spin_lock(&ars_state->lock);
+	if (time_before(jiffies, ars_state->deadline)) {
+		ars_start->status = NFIT_ARS_START_BUSY;
+		*cmd_rc = -EBUSY;
+	} else {
+		ars_start->status = 0;
+		ars_start->scrub_time = 1;
+		post_ars_status(ars_state, ars_start->address,
+				ars_start->length);
+		*cmd_rc = 0;
+	}
+	spin_unlock(&ars_state->lock);
 
 	return 0;
 }
 
-static int nfit_test_cmd_ars_status(struct nd_cmd_ars_status *nd_cmd,
-		unsigned int buf_len)
+static int nfit_test_cmd_ars_status(struct ars_state *ars_state,
+		struct nd_cmd_ars_status *ars_status, unsigned int buf_len,
+		int *cmd_rc)
 {
-	if (buf_len < sizeof(*nd_cmd))
+	if (buf_len < ars_state->ars_status->out_length)
 		return -EINVAL;
 
-	nd_cmd->out_length = sizeof(struct nd_cmd_ars_status);
-	/* TODO: emit error records */
-	nd_cmd->num_records = 0;
-	nd_cmd->address = 0;
-	nd_cmd->length = -1ULL;
-	nd_cmd->status = 0;
-
+	spin_lock(&ars_state->lock);
+	if (time_before(jiffies, ars_state->deadline)) {
+		memset(ars_status, 0, buf_len);
+		ars_status->status = NFIT_ARS_STATUS_BUSY;
+		ars_status->out_length = sizeof(*ars_status);
+		*cmd_rc = -EBUSY;
+	} else {
+		memcpy(ars_status, ars_state->ars_status,
+				ars_state->ars_status->out_length);
+		*cmd_rc = 0;
+	}
+	spin_unlock(&ars_state->lock);
 	return 0;
 }
 
@@ -265,7 +312,11 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nfit_test *t = container_of(acpi_desc, typeof(*t), acpi_desc);
-	int i, rc = 0;
+	int i, rc = 0, __cmd_rc;
+
+	if (!cmd_rc)
+		cmd_rc = &__cmd_rc;
+	*cmd_rc = 0;
 
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -297,6 +348,8 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			return -ENOTTY;
 		}
 	} else {
+		struct ars_state *ars_state = &t->ars_state;
+
 		if (!nd_desc || !test_bit(cmd, &nd_desc->dsm_mask))
 			return -ENOTTY;
 
@@ -305,19 +358,18 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			rc = nfit_test_cmd_ars_cap(buf, buf_len);
 			break;
 		case ND_CMD_ARS_START:
-			rc = nfit_test_cmd_ars_start(buf, buf_len);
+			rc = nfit_test_cmd_ars_start(ars_state, buf, buf_len,
+					cmd_rc);
 			break;
 		case ND_CMD_ARS_STATUS:
-			rc = nfit_test_cmd_ars_status(buf, buf_len);
+			rc = nfit_test_cmd_ars_status(ars_state, buf, buf_len,
+					cmd_rc);
 			break;
 		default:
 			return -ENOTTY;
 		}
 	}
 
-	/* TODO: error status tests */
-	if (cmd_rc)
-		*cmd_rc = 0;
 	return rc;
 }
 
@@ -427,6 +479,18 @@ static struct nfit_test_resource *nfit_test_lookup(resource_size_t addr)
 	return NULL;
 }
 
+static int ars_state_init(struct device *dev, struct ars_state *ars_state)
+{
+	ars_state->ars_status = devm_kzalloc(dev,
+			sizeof(struct nd_cmd_ars_status)
+			+ sizeof(struct nd_ars_record) * NFIT_TEST_ARS_RECORDS,
+			GFP_KERNEL);
+	if (!ars_state->ars_status)
+		return -ENOMEM;
+	spin_lock_init(&ars_state->lock);
+	return 0;
+}
+
 static int nfit_test0_alloc(struct nfit_test *t)
 {
 	size_t nfit_size = sizeof(struct acpi_nfit_system_address) * NUM_SPA
@@ -476,7 +540,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 			return -ENOMEM;
 	}
 
-	return 0;
+	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 
 static int nfit_test1_alloc(struct nfit_test *t)
@@ -494,7 +558,7 @@ static int nfit_test1_alloc(struct nfit_test *t)
 	if (!t->spa_set[0])
 		return -ENOMEM;
 
-	return 0;
+	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 
 static void nfit_test0_setup(struct nfit_test *t)
@@ -1157,6 +1221,8 @@ static void nfit_test0_setup(struct nfit_test *t)
 		flush->hint_address[0] = t->flush_dma[4];
 	}
 
+	post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA0_SIZE);
+
 	acpi_desc = &t->acpi_desc;
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
@@ -1218,6 +1284,8 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->code = NFIT_FIC_BYTE;
 	dcr->windows = 0;
 
+	post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA2_SIZE);
+
 	acpi_desc = &t->acpi_desc;
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
