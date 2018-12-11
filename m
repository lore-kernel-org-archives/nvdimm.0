Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 712BC21198CDA
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:27:04 -0800 (PST)
Subject: [PATCH v13 16/17] tools/testing/nvdimm: add Intel DSM 1.8 support
 for nfit_test
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:52 -0700
Message-ID: <154456001228.26509.3772856445156192989.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding test support for new Intel DSM from v1.8. The ability of simulating
master passphrase update and master secure erase have been added to
nfit_test.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   86 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 3162fbf6e8a9..9a8d0e432e99 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -144,7 +144,9 @@ static unsigned long dimm_fail_cmd_flags[ARRAY_SIZE(handle)];
 static int dimm_fail_cmd_code[ARRAY_SIZE(handle)];
 struct nfit_test_sec {
 	u8 state;
+	u8 ext_state;
 	u8 passphrase[32];
+	u8 master_passphrase[32];
 	u64 overwrite_end_time;
 } dimm_sec_info[NUM_DCR];
 
@@ -947,6 +949,7 @@ static int nd_intel_test_cmd_security_status(struct nfit_test *t,
 
 	nd_cmd->status = 0;
 	nd_cmd->state = sec->state;
+	nd_cmd->extended_state = sec->ext_state;
 	dev_dbg(dev, "security state (%#x) returned\n", nd_cmd->state);
 
 	return 0;
@@ -1063,7 +1066,9 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 		dev_dbg(dev, "secure erase: wrong passphrase\n");
 	} else {
 		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+		memset(sec->master_passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
 		sec->state = 0;
+		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
 		dev_dbg(dev, "secure erase: done\n");
 	}
 
@@ -1108,12 +1113,69 @@ static int nd_intel_test_cmd_query_overwrite(struct nfit_test *t,
 	if (time_is_before_jiffies64(sec->overwrite_end_time)) {
 		sec->overwrite_end_time = 0;
 		sec->state = 0;
+		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
 		dev_dbg(dev, "overwrite is complete\n");
 	} else
 		nd_cmd->status = ND_INTEL_STATUS_OQUERY_INPROGRESS;
 	return 0;
 }
 
+static int nd_intel_test_cmd_master_set_pass(struct nfit_test *t,
+		struct nd_intel_set_master_passphrase *nd_cmd,
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
+
+	if (!(sec->ext_state & ND_INTEL_SEC_ESTATE_ENABLED)) {
+		nd_cmd->status = ND_INTEL_STATUS_NOT_SUPPORTED;
+		dev_dbg(dev, "master set passphrase: in wrong state\n");
+	} else if (sec->ext_state & ND_INTEL_SEC_ESTATE_PLIMIT) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "master set passphrase: in wrong security state\n");
+	} else if (memcmp(nd_cmd->old_pass, sec->master_passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "master set passphrase: wrong passphrase\n");
+	} else {
+		memcpy(sec->master_passphrase, nd_cmd->new_pass,
+				ND_INTEL_PASSPHRASE_SIZE);
+		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
+		dev_dbg(dev, "master passphrase: updated\n");
+	}
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_master_secure_erase(struct nfit_test *t,
+		struct nd_intel_master_secure_erase *nd_cmd,
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
+
+	if (!(sec->ext_state & ND_INTEL_SEC_ESTATE_ENABLED)) {
+		nd_cmd->status = ND_INTEL_STATUS_NOT_SUPPORTED;
+		dev_dbg(dev, "master secure erase: in wrong state\n");
+	} else if (sec->ext_state & ND_INTEL_SEC_ESTATE_PLIMIT) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "master secure erase: in wrong security state\n");
+	} else if (memcmp(nd_cmd->passphrase, sec->master_passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "master secure erase: wrong passphrase\n");
+	} else {
+		/* we do not erase master state passphrase ever */
+		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
+		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+		sec->state = 0;
+		dev_dbg(dev, "master secure erase: done\n");
+	}
+
+	return 0;
+}
+
+
 static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 {
 	int i;
@@ -1193,6 +1255,14 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				rc = nd_intel_test_cmd_query_overwrite(t,
 						buf, buf_len, i - t->dcr_idx);
 				break;
+			case NVDIMM_INTEL_SET_MASTER_PASSPHRASE:
+				rc = nd_intel_test_cmd_master_set_pass(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_MASTER_SECURE_ERASE:
+				rc = nd_intel_test_cmd_master_secure_erase(t,
+						buf, buf_len, i);
+				break;
 			case ND_INTEL_ENABLE_LSS_STATUS:
 				rc = nd_intel_test_cmd_set_lss_status(t,
 						buf, buf_len);
@@ -1571,6 +1641,17 @@ static int nfit_test_dimm_init(struct nfit_test *t)
 	return 0;
 }
 
+static void security_init(struct nfit_test *t)
+{
+	int i;
+
+	for (i = 0; i < t->num_dcr; i++) {
+		struct nfit_test_sec *sec = &dimm_sec_info[i];
+
+		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
+	}
+}
+
 static void smart_init(struct nfit_test *t)
 {
 	int i;
@@ -1649,6 +1730,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (nfit_test_dimm_init(t))
 		return -ENOMEM;
 	smart_init(t);
+	security_init(t);
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 
@@ -2430,6 +2512,10 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(NVDIMM_INTEL_SECURE_ERASE, &acpi_desc->dimm_cmd_force_en);
 	set_bit(NVDIMM_INTEL_OVERWRITE, &acpi_desc->dimm_cmd_force_en);
 	set_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_SET_MASTER_PASSPHRASE,
+			&acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_MASTER_SECURE_ERASE,
+			&acpi_desc->dimm_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
