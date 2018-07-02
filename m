Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59531209605D3
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:40:13 -0700 (PDT)
Subject: [PATCH 10/11] nfit_test: adding test support for Intel nvdimm
 security DSMs
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:40:02 -0700
Message-ID: <153057480269.38125.2758457272899455771.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding nfit_test support for DSM functions "Get Security State",
"Set Passphrase", "Disable Passphrase", "Unlock Unit", "Freeze Lock",
and "Secure Erase" for the fake DIMMs.

Also adding a sysfs knob in order to put the DIMMs in "locked" state. The
order of testing DIMM unlocking would be.
1a. Set Passphrase to DIMM X.
1b. Disable DIMM X.
2. Write to
/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimmX/lock_dimm
3. Renable DIMM X
4. Check DIMM X state via sysfs "security" attribute for nmemX.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/Kbuild      |    1 
 tools/testing/nvdimm/test/nfit.c |  185 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 0392153a0009..29e43d64077f 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -36,6 +36,7 @@ obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
+nfit-y += $(ACPI_SRC)/intel.o
 nfit-$(CONFIG_X86_MCE) += $(ACPI_SRC)/mce.o
 nfit-y += acpi_nfit_test.o
 nfit-y += config_check.o
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 7b3ce2194889..85a64d0e73de 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -155,6 +155,11 @@ struct nfit_dimm_dev {
 	struct nfit_mem *nfit_mem;
 };
 
+struct nfit_test_sec {
+	u8 state;
+	u8 passphrase[32];
+};
+
 struct nfit_test {
 	struct acpi_nfit_desc acpi_desc;
 	struct platform_device pdev;
@@ -192,6 +197,7 @@ struct nfit_test {
 	struct badrange badrange;
 	struct work_struct work;
 	struct nfit_test_fw *fw;
+	struct nfit_test_sec *sec;
 };
 
 static struct workqueue_struct *nfit_wq;
@@ -899,6 +905,138 @@ static int override_return_code(int dimm, unsigned int func, int rc)
 	return rc;
 }
 
+static int nd_intel_test_cmd_security_status(struct nfit_test *t,
+		struct nd_intel_get_security_state *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	nd_cmd->status = 0;
+	nd_cmd->state = sec->state;
+	dev_dbg(dev, "security state (%#x) returned\n", nd_cmd->state);
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_unlock_unit(struct nfit_test *t,
+		struct nd_intel_unlock_unit *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	if (!(sec->state & ND_INTEL_SEC_STATE_LOCKED) ||
+			(sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "unlock unit: invalid state: %#x\n",
+				sec->state);
+	} else if (memcmp(nd_cmd->passphrase, sec->passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "unlock unit: invalid passphrase\n");
+	} else {
+		nd_cmd->status = 0;
+		sec->state = ND_INTEL_SEC_STATE_ENABLED;
+		dev_dbg(dev, "Unit unlocked\n");
+	}
+
+	dev_dbg(dev, "unlocking status returned: %#x\n", nd_cmd->status);
+	return 0;
+}
+
+static int nd_intel_test_cmd_set_pass(struct nfit_test *t,
+		struct nd_intel_set_passphrase *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	if (sec->state & ND_INTEL_SEC_STATE_FROZEN) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "set passphrase: wrong security state\n");
+	} else if (memcmp(nd_cmd->old_pass, sec->passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "set passphrase: wrong passphrase\n");
+	} else {
+		memcpy(sec->passphrase, nd_cmd->new_pass,
+				ND_INTEL_PASSPHRASE_SIZE);
+		sec->state |= ND_INTEL_SEC_STATE_ENABLED;
+		nd_cmd->status = 0;
+		dev_dbg(dev, "passphrase updated\n");
+	}
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_freeze_lock(struct nfit_test *t,
+		struct nd_intel_freeze_lock *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED)) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "freeze lock: wrong security state\n");
+	} else {
+		sec->state |= ND_INTEL_SEC_STATE_FROZEN;
+		nd_cmd->status = 0;
+		dev_dbg(dev, "security frozen\n");
+	}
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_disable_pass(struct nfit_test *t,
+		struct nd_intel_disable_passphrase *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED) ||
+			(sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "disable passphrase: wrong security state\n");
+	} else if (memcmp(nd_cmd->passphrase, sec->passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "disable passphrase: wrong passphrase\n");
+	} else {
+		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+		sec->state = 0;
+		dev_dbg(dev, "disable passphrase: done\n");
+	}
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
+		struct nd_intel_secure_erase *nd_cmd,
+		unsigned int buf_len, int idx)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &t->sec[idx];
+
+	if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED) ||
+			(sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
+		dev_dbg(dev, "secure erase: wrong security state\n");
+	} else if (memcmp(nd_cmd->passphrase, sec->passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "secure erase: wrong passphrase\n");
+	} else {
+		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+		sec->state = 0;
+		dev_dbg(dev, "secure erase: done\n");
+	}
+
+	return 0;
+}
+
 static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 {
 	int i;
@@ -946,6 +1084,30 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				return i;
 
 			switch (func) {
+			case NVDIMM_INTEL_GET_SECURITY_STATE:
+				rc = nd_intel_test_cmd_security_status(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_UNLOCK_UNIT:
+				rc = nd_intel_test_cmd_unlock_unit(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_SET_PASSPHRASE:
+				rc = nd_intel_test_cmd_set_pass(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_DISABLE_PASSPHRASE:
+				rc = nd_intel_test_cmd_disable_pass(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_FREEZE_LOCK:
+				rc = nd_intel_test_cmd_freeze_lock(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_SECURE_ERASE:
+				rc = nd_intel_test_cmd_secure_erase(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_ENABLE_LSS_STATUS:
 				rc = nd_intel_test_cmd_set_lss_status(t,
 						buf, buf_len);
@@ -1280,10 +1442,23 @@ static ssize_t fail_cmd_code_store(struct device *dev, struct device_attribute *
 }
 static DEVICE_ATTR_RW(fail_cmd_code);
 
+static ssize_t lock_dimm_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	int dimm = dimm_name_to_id(dev);
+	struct nfit_test *t = dev_get_drvdata(dev);
+	struct nfit_test_sec *sec = &t->sec[dimm];
+
+	sec->state = ND_INTEL_SEC_STATE_ENABLED | ND_INTEL_SEC_STATE_LOCKED;
+	return size;
+}
+static DEVICE_ATTR_WO(lock_dimm);
+
 static struct attribute *nfit_test_dimm_attributes[] = {
 	&dev_attr_fail_cmd.attr,
 	&dev_attr_fail_cmd_code.attr,
 	&dev_attr_handle.attr,
+	&dev_attr_lock_dimm.attr,
 	NULL,
 };
 
@@ -2192,6 +2367,14 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_INTEL_FW_FINISH_UPDATE, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_FW_FINISH_QUERY, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_ENABLE_LSS_STATUS, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_GET_SECURITY_STATE,
+			&acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_SET_PASSPHRASE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_DISABLE_PASSPHRASE,
+			&acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_UNLOCK_UNIT, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_FREEZE_LOCK, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_SECURE_ERASE, &acpi_desc->dimm_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -2611,6 +2794,8 @@ static int nfit_test_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 		nfit_test->fw = devm_kcalloc(dev, num,
 				sizeof(struct nfit_test_fw), GFP_KERNEL);
+		nfit_test->sec = devm_kcalloc(dev, num,
+				sizeof(struct nfit_test_sec), GFP_KERNEL);
 		if (nfit_test->dimm && nfit_test->dimm_dma && nfit_test->label
 				&& nfit_test->label_dma && nfit_test->dcr
 				&& nfit_test->dcr_dma && nfit_test->flush

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
