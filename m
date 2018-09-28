Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 443F22113A0E0
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 14:54:17 -0700 (PDT)
Subject: [PATCH v11 08/12] nfit/libnvdimm: add support for issue secure
 erase DSM to Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 14:54:12 -0700
Message-ID: <153817165231.17152.5323079106590722908.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
References: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
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

Add support to issue a secure erase DSM to the Intel nvdimm. The
required passphrase is acquired from userspace through the kernel key
management. To trigger the action, "erase <old_keyid>" is written to the
"security" sysfs attribute. libnvdimm will support the erase generic API
call. The user key provided will be verified against the cached kernel
key. If no kernel key exists, then the user key will be attempted for the
operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   58 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   75 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    3 ++
 3 files changed, 136 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index ba886f1f5399..419a7d54d4e8 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,63 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
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
+	/* flush all cache before we erase DIMM */
+	wbinvd_on_all_cpus();
+	memcpy(nd_cmd.cmd.passphrase, nkey->data,
+			sizeof(nd_cmd.cmd.passphrase));
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
+	/* DIMM erased, invalidate all CPU caches before we read it */
+	wbinvd_on_all_cpus();
+
+ out:
+	return rc;
+}
+
 static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm)
 {
@@ -321,4 +378,5 @@ const struct nvdimm_security_ops intel_security_ops = {
 	.change_key = intel_dimm_security_update_passphrase,
 	.disable = intel_dimm_security_disable,
 	.freeze_lock = intel_dimm_security_freeze_lock,
+	.erase = intel_dimm_security_erase,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e0a09bcc8b11..65ef7110c820 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -183,6 +183,76 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	struct user_key_payload *payload;
+	int rc = 0;
+	bool is_userkey = false;
+
+	if (!nvdimm->security_ops)
+		return -EOPNOTSUPP;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	if (atomic_read(&nvdimm->busy)) {
+		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	if (dev_get_drvdata(dev)) {
+		dev_warn(dev, "Unable to secure erase while DIMM enabled.\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED) {
+		dev_warn(dev, "Attempt to secure erase in wrong state.\n");
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* look for a key from cached key if exists */
+	key = nvdimm_get_and_verify_key(dev, keyid);
+	if (IS_ERR(key)) {
+		dev_dbg(dev, "Unable to get and verify key\n");
+		rc = PTR_ERR(key);
+		goto out;
+	}
+	if (!key) {
+		dev_dbg(dev, "No cached key found\n");
+		/* get old user key */
+		key = nvdimm_lookup_user_key(dev, keyid);
+		if (!key) {
+			dev_dbg(dev, "Unable to retrieve user key: %#x\n",
+					keyid);
+			rc = -ENOKEY;
+			goto out;
+		}
+		is_userkey = true;
+	}
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = nvdimm->security_ops->erase(nvdimm_bus, nvdimm,
+			(void *)payload->data);
+	up_read(&key->sem);
+
+	/* remove key since secure erase kills the passphrase */
+	if (!is_userkey) {
+		key_invalidate(key);
+		nvdimm->key = NULL;
+	}
+	key_put(key);
+
+ out:
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_security_get_state(dev);
+	return rc;
+}
+
 static int nvdimm_security_freeze_lock(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -826,6 +896,11 @@ static ssize_t security_store(struct device *dev,
 	} else if (sysfs_streq(buf, "freeze")) {
 		dev_dbg(dev, "freeze\n");
 		rc = nvdimm_security_freeze_lock(dev);
+	} else if (sysfs_streq(cmd, "erase")) {
+		if (rc != 2)
+			return -EINVAL;
+		dev_dbg(dev, "erase %#x\n", old_key);
+		rc = nvdimm_security_erase(dev, old_key);
 	} else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index bcab42caa948..0d85e092a6dd 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -187,6 +187,9 @@ struct nvdimm_security_ops {
 			const struct nvdimm_key_data *nkey);
 	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm);
+	int (*erase)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *nkey);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
