Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC49621159810
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 17:59:02 -0700 (PDT)
Subject: [PATCH 2/5] libnvdimm: Add security DSM overwrite support
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 26 Sep 2018 17:58:35 -0700
Message-ID: <153800991508.57703.702651572767206720.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153800975246.57703.6532101433026481472.stgit@djiang5-desk3.ch.intel.com>
References: <153800975246.57703.6532101433026481472.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We are adding support for the security calls of ovewrite and query
overwrite from Intel DSM spec v1.7. This will allow triggering of
overwrite on Intel NVDIMMs. The overwrite operation can take tens
of minutes. When the overwrite DSM is issued successfully, the NVDIMMs
will be unaccessible. The kernel will do backoff polling to detect when
the overwrite process is completed. According to the DSM spec v1.7,
the 128G NVDIMMs can take up to 15mins to perform overwrite and larger
DIMMs will take longer.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |  118 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h  |    3 +
 drivers/acpi/nfit/nfit.h   |    1 
 drivers/nvdimm/dimm_devs.c |  143 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h   |    2 +
 include/linux/libnvdimm.h  |    6 ++
 6 files changed, 272 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 419a7d54d4e8..a11ba0041fa9 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,117 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_query_overwrite(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_query_overwrite cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_QUERY_OVERWRITE,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = 0,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
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
+	case ND_INTEL_STATUS_OQUERY_INPROGRESS:
+		rc = -EBUSY;
+		goto out;
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* flush all cache before we make the nvdimms available */
+	wbinvd_on_all_cpus();
+	nfit_mem->overwrite = false;
+
+out:
+	return rc;
+}
+
+static int intel_dimm_security_overwrite(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_overwrite cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_OVERWRITE,
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
+	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
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
+		nfit_mem->overwrite = true;
+		break;
+	case ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED:
+		rc = -ENOTSUPP;
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
+ out:
+	return rc;
+}
+
 static int intel_dimm_security_erase(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
 {
@@ -330,6 +441,11 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 		return 0;
 	}
 
+	if (nfit_mem->overwrite == true) {
+		*state = NVDIMM_SECURITY_OVERWRITE;
+		return 0;
+	}
+
 	*state = NVDIMM_SECURITY_DISABLED;
 	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
 			sizeof(nd_cmd), &cmd_rc);
@@ -379,4 +495,6 @@ const struct nvdimm_security_ops intel_security_ops = {
 	.disable = intel_dimm_security_disable,
 	.freeze_lock = intel_dimm_security_freeze_lock,
 	.erase = intel_dimm_security_erase,
+	.overwrite = intel_dimm_security_overwrite,
+	.query_overwrite = intel_dimm_security_query_overwrite,
 };
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index f9ac718776ca..943ee993e31e 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -17,12 +17,15 @@ extern const struct nvdimm_security_ops intel_security_ops;
 #define ND_INTEL_STATUS_NOT_READY	9
 #define ND_INTEL_STATUS_INVALID_STATE	10
 #define ND_INTEL_STATUS_INVALID_PASS	11
+#define ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED	0x10007
+#define ND_INTEL_STATUS_OQUERY_INPROGRESS	0x10007
 
 #define ND_INTEL_SEC_STATE_ENABLED	0x02
 #define ND_INTEL_SEC_STATE_LOCKED	0x04
 #define ND_INTEL_SEC_STATE_FROZEN	0x08
 #define ND_INTEL_SEC_STATE_PLIMIT	0x10
 #define ND_INTEL_SEC_STATE_UNSUPPORTED	0x20
+#define ND_INTEL_SEC_STATE_OVERWRITE	0x40
 
 struct nd_intel_get_security_state {
 	u32 status;
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 36c8695a3d27..e36a111d393a 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -198,6 +198,7 @@ struct nfit_mem {
 	int family;
 	bool has_lsr;
 	bool has_lsw;
+	bool overwrite;
 	char id[NFIT_DIMM_ID_LEN+1];
 };
 
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index af1fd4434037..c636ce1d8f5f 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -29,6 +29,7 @@
 
 static DEFINE_IDA(dimm_ida);
 static struct key *nvdimm_keyring;
+static struct workqueue_struct *nvdimm_wq;
 
 /*
  * Find key in kernel keyring
@@ -183,6 +184,128 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static void nvdimm_overwrite_query(struct work_struct *work)
+{
+	struct nvdimm *nvdimm;
+	struct nvdimm_bus *nvdimm_bus;
+	int rc;
+	unsigned int tmo;
+
+	nvdimm = container_of(work, typeof(*nvdimm), dwork.work);
+	nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
+	tmo = nvdimm->overwrite_tmo;
+
+	if (!nvdimm->security_ops)
+		return;
+
+	rc = nvdimm->security_ops->query_overwrite(nvdimm_bus, nvdimm);
+	if (rc == -EBUSY) {
+
+		/* setup delayed work again */
+		tmo += 10;
+		queue_delayed_work(nvdimm_wq, &nvdimm->dwork, tmo * HZ);
+		nvdimm->overwrite_tmo = min(15U * 60U, tmo);
+		return;
+	}
+
+	if (rc < 0)
+		dev_warn(&nvdimm->dev, "Overwrite failed\n");
+	else
+		dev_info(&nvdimm->dev, "Overwrite completed\n");
+
+	nvdimm->overwrite_tmo = 0;
+	nvdimm_clear_security_busy(&nvdimm->dev);
+	nvdimm_security_get_state(&nvdimm->dev);
+}
+
+static int nvdimm_security_overwrite(struct device *dev, unsigned int keyid)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	struct user_key_payload *payload;
+	int rc;
+	char pass[NVDIMM_PASSPHRASE_LEN];
+	bool is_userkey = false;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	if (atomic_read(&nvdimm->busy)) {
+		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	if (dev_get_drvdata(dev)) {
+		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED) {
+		dev_warn(dev, "Attempt to overwrite in wrong state.\n");
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* look for a key from keyring if exists and remove */
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
+		if (key)
+			is_userkey = true;
+	}
+
+	if (key) {
+		down_read(&key->sem);
+		payload = key->payload.data[0];
+		memcpy(pass, payload->data, NVDIMM_PASSPHRASE_LEN);
+		up_read(&key->sem);
+	} else
+		memset(pass, 0, NVDIMM_PASSPHRASE_LEN);
+
+	nvdimm_set_security_busy(dev);
+	/*
+	 * Overwrite can execute w/o passphrase. we will let the hardware
+	 * determine whether we need a passphrase or not.
+	 */
+	rc = nvdimm->security_ops->overwrite(nvdimm_bus, nvdimm,
+			(void *)pass);
+	if (rc == 0) {
+		if (key) {
+			if (!is_userkey) {
+				key_unlink(nvdimm_keyring, key);
+				key_invalidate(key);
+				nvdimm->key = NULL;
+			}
+			key_put(key);
+			memset(pass, 0, NVDIMM_PASSPHRASE_LEN);
+		}
+		nvdimm->state = NVDIMM_SECURITY_OVERWRITE;
+		queue_delayed_work(nvdimm_wq, &nvdimm->dwork, 0);
+	} else
+		nvdimm_clear_security_busy(dev);
+
+ out:
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_security_get_state(dev);
+	return rc;
+
+}
+
 static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -902,6 +1025,8 @@ static ssize_t security_show(struct device *dev,
 		return sprintf(buf, "locked\n");
 	case NVDIMM_SECURITY_FROZEN:
 		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_OVERWRITE:
+		return sprintf(buf, "overwrite\n");
 	case NVDIMM_SECURITY_UNSUPPORTED:
 	default:
 		return sprintf(buf, "unsupported\n");
@@ -941,6 +1066,9 @@ static ssize_t security_store(struct device *dev,
 	} else if (sysfs_streq(cmd, "erase")) {
 		dev_dbg(dev, "erase %u\n", old_key);
 		rc = nvdimm_security_erase(dev, old_key);
+	} else if (sysfs_streq(cmd, "overwrite")) {
+		dev_dbg(dev, "overwrite %u\n", old_key);
+		rc = nvdimm_security_overwrite(dev, old_key);
 	} else
 		return -EINVAL;
 
@@ -997,6 +1125,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	dev->type = &nvdimm_device_type;
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
+	nvdimm->overwrite_tmo = 0;
+	INIT_DELAYED_WORK(&nvdimm->dwork, nvdimm_overwrite_query);
 	nd_device_register(dev);
 
 	return nvdimm;
@@ -1293,11 +1423,22 @@ static void nvdimm_unregister_keyring(void)
 
 int __init nvdimm_devs_init(void)
 {
-	return nvdimm_register_keyring();
+	int rc;
+
+	nvdimm_wq = create_singlethread_workqueue("nvdimm");
+	if (!nvdimm_wq)
+		return -ENOMEM;
+
+	rc = nvdimm_register_keyring();
+	if (rc < 0)
+		destroy_workqueue(nvdimm_wq);
+
+	return rc;
 }
 
 void  nvdimm_devs_exit(void)
 {
 	nvdimm_unregister_keyring();
+	destroy_workqueue(nvdimm_wq);
 	ida_destroy(&dimm_ida);
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 3833b725b4f9..f44ad99763ba 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -47,6 +47,8 @@ struct nvdimm {
 	const struct nvdimm_security_ops *security_ops;
 	enum nvdimm_security_state state;
 	struct key *key;
+	struct delayed_work dwork;
+	unsigned int overwrite_tmo;
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1feca4d1c1fb..c334fd70afb4 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -163,6 +163,7 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_UNLOCKED,
 	NVDIMM_SECURITY_LOCKED,
 	NVDIMM_SECURITY_FROZEN,
+	NVDIMM_SECURITY_OVERWRITE,
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
@@ -192,6 +193,11 @@ struct nvdimm_security_ops {
 	int (*erase)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
+	int (*overwrite)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *nkey);
+	int (*query_overwrite)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
