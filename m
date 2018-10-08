Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BB8621163DDC
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:56:55 -0700 (PDT)
Subject: [PATCH v12 09/12] nfit_test: add test support for Intel nvdimm
 security DSMs
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:56:19 -0700
Message-ID: <153904297989.60070.16417611396147609717.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
References: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add nfit_test support for DSM functions "Get Security State",
"Set Passphrase", "Disable Passphrase", "Unlock Unit", "Freeze Lock",
and "Secure Erase" for the fake DIMMs.

Also adding a sysfs knob in order to put the DIMMs in "locked" state. The
order of testing DIMM unlocking would be.
1a. Disable DIMM X.
1b. Set Passphrase to DIMM X.
2. Write to
/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimmX/lock_dimm
3. Renable DIMM X
4. Check DIMM X state via sysfs "security" attribute for nmemX.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c       |    2 
 drivers/nvdimm/nd.h              |    2 
 tools/testing/nvdimm/Kbuild      |    1 
 tools/testing/nvdimm/dimm_devs.c |   39 ++++++++
 tools/testing/nvdimm/test/nfit.c |  185 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 228 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/nvdimm/dimm_devs.c

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 1421404a687f..9e71e9497536 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -390,7 +390,7 @@ static ssize_t available_slots_show(struct device *dev,
 static DEVICE_ATTR_RO(available_slots);
 
 #ifdef CONFIG_NVDIMM_SECURITY
-static ssize_t security_show(struct device *dev,
+__weak ssize_t security_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 08e442632a2d..75ff9b327543 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -433,6 +433,8 @@ int nvdimm_security_change_key(struct device *dev, unsigned int old_keyid,
 int nvdimm_security_disable(struct device *dev, unsigned int keyid);
 int nvdimm_security_freeze_lock(struct device *dev);
 int nvdimm_security_erase(struct device *dev, unsigned int keyid);
+ssize_t security_show(struct device *dev, struct device_attribute *attr,
+		char *buf);
 #else
 static inline struct key *nvdimm_get_key(struct device *dev)
 {
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 80cd0b0399ec..379da8312dc2 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -79,6 +79,7 @@ libnvdimm-$(CONFIG_ND_CLAIM) += $(NVDIMM_SRC)/claim.o
 libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
+libnvdimm-y += dimm_devs.o
 libnvdimm-y += libnvdimm_test.o
 libnvdimm-y += config_check.o
 libnvdimm-$(CONFIG_NVDIMM_SECURITY) += $(NVDIMM_SRC)/dimm_devs_security.o
diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
new file mode 100644
index 000000000000..f6717312dbb2
--- /dev/null
+++ b/tools/testing/nvdimm/dimm_devs.c
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright Intel Corp. 2018 */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/nd.h>
+#include "pmem.h"
+#include "pfn.h"
+#include "nd.h"
+#include "nd-core.h"
+
+ssize_t security_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	/*
+	 * For the test version we need to poll the "hardware" in order
+	 * to get the updated status for unlock testing.
+	 */
+	nvdimm_security_get_state(dev);
+
+	switch (nvdimm->state) {
+	case NVDIMM_SECURITY_DISABLED:
+		return sprintf(buf, "disabled\n");
+	case NVDIMM_SECURITY_UNLOCKED:
+		return sprintf(buf, "unlocked\n");
+	case NVDIMM_SECURITY_LOCKED:
+		return sprintf(buf, "locked\n");
+	case NVDIMM_SECURITY_FROZEN:
+		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_UNSUPPORTED:
+	default:
+		return sprintf(buf, "unsupported\n");
+	}
+
+	return -ENOTTY;
+}
+
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cffc2c5a778d..1d7ae7aecb46 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <nd-core.h>
+#include <intel.h>
 #include <nfit.h>
 #include <nd.h>
 #include "nfit_test.h"
@@ -139,8 +140,16 @@ static u32 handle[] = {
 	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
 };
 
+/*
+ * State that needs to be maintained for sysfs where we can't reliably
+ * look up our nfit_test relative dimm index.
+ */
 static unsigned long dimm_fail_cmd_flags[NUM_DCR];
 static int dimm_fail_cmd_code[NUM_DCR];
+struct nfit_test_sec {
+	u8 state;
+	u8 passphrase[32];
+} dimm_sec_info[NUM_DCR];
 
 static const struct nd_intel_smart smart_def = {
 	.flags = ND_INTEL_SMART_HEALTH_VALID
@@ -931,6 +940,138 @@ static int override_return_code(int dimm, unsigned int func, int rc)
 	return rc;
 }
 
+static int nd_intel_test_cmd_security_status(struct nfit_test *t,
+		struct nd_intel_get_security_state *nd_cmd,
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
@@ -978,6 +1119,30 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				return i;
 
 			switch (func) {
+			case NVDIMM_INTEL_GET_SECURITY_STATE:
+				rc = nd_intel_test_cmd_security_status(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_UNLOCK_UNIT:
+				rc = nd_intel_test_cmd_unlock_unit(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_SET_PASSPHRASE:
+				rc = nd_intel_test_cmd_set_pass(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_DISABLE_PASSPHRASE:
+				rc = nd_intel_test_cmd_disable_pass(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_FREEZE_LOCK:
+				rc = nd_intel_test_cmd_freeze_lock(t,
+						buf, buf_len, i);
+				break;
+			case NVDIMM_INTEL_SECURE_ERASE:
+				rc = nd_intel_test_cmd_secure_erase(t,
+						buf, buf_len, i);
+				break;
 			case ND_INTEL_ENABLE_LSS_STATUS:
 				rc = nd_intel_test_cmd_set_lss_status(t,
 						buf, buf_len);
@@ -1311,10 +1476,22 @@ static ssize_t fail_cmd_code_store(struct device *dev, struct device_attribute *
 }
 static DEVICE_ATTR_RW(fail_cmd_code);
 
+static ssize_t lock_dimm_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	int dimm = dimm_name_to_id(dev);
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
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
 
@@ -2193,6 +2370,14 @@ static void nfit_test0_setup(struct nfit_test *t)
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
