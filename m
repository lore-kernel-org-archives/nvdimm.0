Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FDDB210D93A5
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 13:23:03 -0700 (PDT)
Subject: [PATCH v2 08/11] nfit/libnvdimm: adding support for issue secure
 erase DSM to Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 05 Jul 2018 13:22:55 -0700
Message-ID: <153082217561.61422.7938851123374855956.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153082172527.61422.13689320279597181069.stgit@djiang5-desk3.ch.intel.com>
References: <153082172527.61422.13689320279597181069.stgit@djiang5-desk3.ch.intel.com>
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

Adding support to issue a secure erase DSM to the Intel nvdimm. The
required passphrase is acquired from userspace through the kernel key
management. To trigger the action, "erase" is written to the "security"
sysfs attribute.  libnvdimm will support the erase generic API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   47 ++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 3 files changed, 104 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index ab0ad103f861..118edf93116f 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -17,6 +17,60 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_secure_erase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_SECURE_ERASE,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_SECURE_ERASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	memcpy(nd_cmd.cmd.passphrase, nkey->data, ND_INTEL_PASSPHRASE_SIZE);
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
+			sizeof(nd_cmd), &cmd_rc);
+	if (rc < 0)
+		goto out;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out;
+	}
+
+	switch (nd_cmd.cmd.status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_INVALID_PASS:
+		rc = -EINVAL;
+		goto out;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* DIMM unlocked, invalidate all CPU caches before we read it */
+	wbinvd();
+
+ out:
+	return rc;
+}
+
 static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm)
 {
@@ -303,4 +357,5 @@ struct nvdimm_security_ops intel_security_ops = {
 	.change_key = intel_dimm_security_update_passphrase,
 	.disable = intel_dimm_security_disable,
 	.freeze_lock = intel_dimm_security_freeze_lock,
+	.erase = intel_dimm_security_erase,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 0dcb5991a82d..521edf6ed330 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -125,6 +125,51 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_erase(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	void *payload;
+	int rc = 0;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	/* lock the device and disallow driver bind */
+	device_lock(dev);
+	/* No driver data means dimm is disabled. Proceed if so. */
+	if (dev_get_drvdata(dev)) {
+		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
+		goto out;
+
+	key = nvdimm_search_key(dev);
+	if (!key)
+		key = nvdimm_request_key(dev);
+	if (!key) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = nvdimm->security_ops->erase(nvdimm_bus, nvdimm, payload);
+	up_read(&key->sem);
+	/* remove key since secure erase kills the passphrase */
+	key_invalidate(key);
+	key_put(key);
+
+ out:
+	device_unlock(dev);
+	nvdimm_security_get_state(dev);
+	return rc;
+}
+
 static int nvdimm_security_freeze_lock(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -690,6 +735,8 @@ static ssize_t security_store(struct device *dev,
 		rc = nvdimm_security_disable(dev);
 	else if (strcmp(buf, "freeze") == 0 || strcmp(buf, "freeze\n") == 0)
 		rc = nvdimm_security_freeze_lock(dev);
+	else if (strcmp(buf, "erase") == 0 || strcmp(buf, "erase\n") == 0)
+		rc = nvdimm_security_erase(dev);
 	else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1836599ed5b8..1ac5acb3c457 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -187,6 +187,8 @@ struct nvdimm_security_ops {
 			struct nvdimm *nvdimm, struct nvdimm_key_data *nkey);
 	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm);
+	int (*erase)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm, struct nvdimm_key_data *nkey);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
