Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22A612114083E
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:56:32 -0700 (PDT)
Subject: [PATCH v12 11/12] libnvdimm: Drop nvdimm_bus from security_ops
 interface
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:56:31 -0700
Message-ID: <153904299110.60070.14208623458719153958.stgit@djiang5-desk3.ch.intel.com>
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

From: Dan Williams <dan.j.williams@intel.com>

All that is missing is a helper to go from an nvdimm to its bus. With
the new nvdimm_to_bus() and nvdimm_ctl() helpers some boilerplate can be
consolidated.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c           |   46 ++++++++++++-----------------------
 drivers/nvdimm/bus.c                |    6 +++++
 drivers/nvdimm/dimm_devs_security.c |   24 +++++++-----------
 include/linux/libnvdimm.h           |   28 ++++++++++++---------
 4 files changed, 47 insertions(+), 57 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 419a7d54d4e8..70bccb0c57e2 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,10 +18,9 @@
 #include "intel.h"
 #include "nfit.h"
 
-static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
+static int intel_dimm_security_erase(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *nkey)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -47,8 +46,7 @@ static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
 	wbinvd_on_all_cpus();
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
@@ -75,10 +73,8 @@ static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
 	return rc;
 }
 
-static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm)
+static int intel_dimm_security_freeze_lock(struct nvdimm *nvdimm)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -100,8 +96,7 @@ static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
 	if (!test_bit(NVDIMM_INTEL_FREEZE_LOCK, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
@@ -122,10 +117,9 @@ static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
 	return rc;
 }
 
-static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
+static int intel_dimm_security_disable(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *nkey)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -149,8 +143,7 @@ static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
 
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
@@ -182,12 +175,10 @@ static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
  * if the old passphrase is NULL. This typically happens when we are
  * enabling security from the disabled state.
  */
-static int intel_dimm_security_update_passphrase(
-		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+static int intel_dimm_security_update_passphrase(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *old_data,
 		const struct nvdimm_key_data *new_data)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -216,8 +207,7 @@ static int intel_dimm_security_update_passphrase(
 		memset(nd_cmd.cmd.old_pass, 0, sizeof(nd_cmd.cmd.old_pass));
 	memcpy(nd_cmd.cmd.new_pass, new_data->data,
 			sizeof(nd_cmd.cmd.new_pass));
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
@@ -241,10 +231,9 @@ static int intel_dimm_security_update_passphrase(
 	return rc;
 }
 
-static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
+static int intel_dimm_security_unlock(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *nkey)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -268,8 +257,7 @@ static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
 
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
@@ -300,10 +288,9 @@ static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
 	return rc;
 }
 
-static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm, enum nvdimm_security_state *state)
+static int intel_dimm_security_state(struct nvdimm *nvdimm,
+		enum nvdimm_security_state *state)
 {
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -331,8 +318,7 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 	}
 
 	*state = NVDIMM_SECURITY_DISABLED;
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
-			sizeof(nd_cmd), &cmd_rc);
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
 		goto out;
 	if (cmd_rc < 0) {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9743d8083538..eae17d8ee539 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -331,6 +331,12 @@ struct nvdimm_bus *to_nvdimm_bus(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm_bus);
 
+struct nvdimm_bus *nvdimm_to_bus(struct nvdimm *nvdimm)
+{
+	return to_nvdimm_bus(nvdimm->dev.parent);
+}
+EXPORT_SYMBOL_GPL(nvdimm_to_bus);
+
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nd_desc)
 {
diff --git a/drivers/nvdimm/dimm_devs_security.c b/drivers/nvdimm/dimm_devs_security.c
index 4a8bd4d94515..e3be3a238765 100644
--- a/drivers/nvdimm/dimm_devs_security.c
+++ b/drivers/nvdimm/dimm_devs_security.c
@@ -155,13 +155,11 @@ struct key *nvdimm_get_and_verify_key(struct device *dev,
 int nvdimm_security_get_state(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 
 	if (!nvdimm->security_ops)
 		return 0;
 
-	return nvdimm->security_ops->state(nvdimm_bus, nvdimm,
-			&nvdimm->state);
+	return nvdimm->security_ops->state(nvdimm, &nvdimm->state);
 }
 
 int nvdimm_security_erase(struct device *dev, unsigned int keyid)
@@ -218,8 +216,8 @@ int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 
 	down_read(&key->sem);
 	payload = key->payload.data[0];
-	rc = nvdimm->security_ops->erase(nvdimm_bus, nvdimm,
-			(void *)payload->data);
+	rc = nvdimm->security_ops->erase(nvdimm,
+			(const struct nvdimm_key_data *)payload->data);
 	up_read(&key->sem);
 
 	/* remove key since secure erase kills the passphrase */
@@ -239,7 +237,6 @@ int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 int nvdimm_security_freeze_lock(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	int rc;
 
 	if (!nvdimm->security_ops)
@@ -248,7 +245,7 @@ int nvdimm_security_freeze_lock(struct device *dev)
 	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
 		return -EOPNOTSUPP;
 
-	rc = nvdimm->security_ops->freeze_lock(nvdimm_bus, nvdimm);
+	rc = nvdimm->security_ops->freeze_lock(nvdimm);
 	if (rc < 0)
 		return rc;
 
@@ -259,7 +256,6 @@ int nvdimm_security_freeze_lock(struct device *dev)
 int nvdimm_security_disable(struct device *dev, unsigned int keyid)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key;
 	int rc;
 	struct user_key_payload *payload;
@@ -291,8 +287,8 @@ int nvdimm_security_disable(struct device *dev, unsigned int keyid)
 	down_read(&key->sem);
 	payload = key->payload.data[0];
 
-	rc = nvdimm->security_ops->disable(nvdimm_bus, nvdimm,
-			(void *)payload->data);
+	rc = nvdimm->security_ops->disable(nvdimm,
+			(const struct nvdimm_key_data *)payload->data);
 	up_read(&key->sem);
 	if (rc < 0) {
 		dev_warn(dev, "unlock failed\n");
@@ -315,7 +311,6 @@ int nvdimm_security_disable(struct device *dev, unsigned int keyid)
 int nvdimm_security_unlock_dimm(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key;
 	struct user_key_payload *payload;
 	int rc;
@@ -352,8 +347,8 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	dev_dbg(dev, "%s: key: %#x\n", __func__, key_serial(key));
 	down_read(&key->sem);
 	payload = key->payload.data[0];
-	rc = nvdimm->security_ops->unlock(nvdimm_bus, nvdimm,
-			(const void *)payload->data);
+	rc = nvdimm->security_ops->unlock(nvdimm,
+			(const struct nvdimm_key_data *)payload->data);
 	up_read(&key->sem);
 
 	if (rc == 0) {
@@ -377,7 +372,6 @@ int nvdimm_security_change_key(struct device *dev,
 		unsigned int old_keyid, unsigned int new_keyid)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key, *old_key;
 	int rc;
 	void *old_data = NULL, *new_data;
@@ -441,7 +435,7 @@ int nvdimm_security_change_key(struct device *dev,
 
 	new_data = payload->data;
 
-	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_data,
+	rc = nvdimm->security_ops->change_key(nvdimm, old_data,
 			new_data);
 	/* copy new payload to old payload */
 	if (rc == 0) {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0d85e092a6dd..c352b8195675 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -172,23 +172,17 @@ struct nvdimm_key_data {
 };
 
 struct nvdimm_security_ops {
-	int (*state)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm,
+	int (*state)(struct nvdimm *nvdimm,
 			enum nvdimm_security_state *state);
-	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm,
+	int (*unlock)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
-	int (*change_key)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm,
+	int (*change_key)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *old_data,
 			const struct nvdimm_key_data *new_data);
-	int (*disable)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm,
+	int (*disable)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
-	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm);
-	int (*erase)(struct nvdimm_bus *nvdimm_bus,
-			struct nvdimm *nvdimm,
+	int (*freeze_lock)(struct nvdimm *nvdimm);
+	int (*erase)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
 };
 
@@ -202,6 +196,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
+struct nvdimm_bus *nvdimm_to_bus(struct nvdimm *nvdimm);
 struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
 struct device *nd_region_dev(struct nd_region *nd_region);
@@ -243,6 +238,15 @@ void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 
+static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+		unsigned int buf_len, int *cmd_rc)
+{
+	struct nvdimm_bus *nvdimm_bus = nvdimm_to_bus(nvdimm);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+
+	return nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, cmd_rc);
+}
+
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB
 void arch_wb_cache_pmem(void *addr, size_t size);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
