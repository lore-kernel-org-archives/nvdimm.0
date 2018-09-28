Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7FF02115C092
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:45:20 -0700 (PDT)
Subject: [PATCH v2 2/5] libnvdimm: Add security DSM overwrite support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 15:44:55 -0700
Message-ID: <153817469524.19407.4267332786097495660.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
References: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/acpi/nfit/intel.c  |  113 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h  |    3 +
 drivers/acpi/nfit/nfit.h   |    1 
 drivers/nvdimm/core.c      |    3 +
 drivers/nvdimm/dimm_devs.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h   |    3 +
 include/linux/libnvdimm.h  |    4 +
 7 files changed, 266 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 8d2413810a5f..2783e060e2b1 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,112 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_query_overwrite(struct nvdimm *nvdimm)
+{
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
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
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
+static int intel_dimm_security_overwrite(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *nkey)
+{
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
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
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
 static int intel_dimm_security_erase(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *nkey)
 {
@@ -317,6 +423,11 @@ static int intel_dimm_security_state(struct nvdimm *nvdimm,
 		return 0;
 	}
 
+	if (nfit_mem->overwrite == true) {
+		*state = NVDIMM_SECURITY_OVERWRITE;
+		return 0;
+	}
+
 	*state = NVDIMM_SECURITY_DISABLED;
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
 	if (rc < 0)
@@ -365,5 +476,7 @@ static const struct nvdimm_security_ops __intel_security_ops = {
 	.disable = intel_dimm_security_disable,
 	.freeze_lock = intel_dimm_security_freeze_lock,
 	.erase = intel_dimm_security_erase,
+	.overwrite = intel_dimm_security_overwrite,
+	.query_overwrite = intel_dimm_security_query_overwrite,
 };
 const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index f831084f95fa..65d57a6abbc2 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -17,12 +17,15 @@ extern const struct nvdimm_security_ops *intel_security_ops;
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
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index acce050856a8..b2496c06178b 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -437,6 +437,9 @@ static __init int libnvdimm_init(void)
 {
 	int rc;
 
+	rc = nvdimm_devs_init();
+	if (rc)
+		return rc;
 	rc = nvdimm_bus_init();
 	if (rc)
 		return rc;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 7a71ea666676..73f7e879d6e0 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -28,6 +28,7 @@
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
+static struct workqueue_struct *nvdimm_wq;
 
 /*
  * Find key that's cached with nvdimm
@@ -181,6 +182,126 @@ int nvdimm_security_get_state(struct device *dev)
 	return nvdimm->security_ops->state(nvdimm, &nvdimm->state);
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
+	rc = nvdimm->security_ops->query_overwrite(nvdimm);
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
+	rc = nvdimm->security_ops->overwrite(nvdimm, (void *)pass);
+	if (rc == 0) {
+		if (key) {
+			if (!is_userkey) {
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
@@ -898,6 +1019,8 @@ __weak ssize_t security_show(struct device *dev,
 		return sprintf(buf, "locked\n");
 	case NVDIMM_SECURITY_FROZEN:
 		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_OVERWRITE:
+		return sprintf(buf, "overwrite\n");
 	case NVDIMM_SECURITY_UNSUPPORTED:
 	default:
 		return sprintf(buf, "unsupported\n");
@@ -944,6 +1067,9 @@ static ssize_t security_store(struct device *dev,
 			return -EINVAL;
 		dev_dbg(dev, "erase %#x\n", old_key);
 		rc = nvdimm_security_erase(dev, old_key);
+	} else if (sysfs_streq(cmd, "overwrite")) {
+		dev_dbg(dev, "overwrite %u\n", old_key);
+		rc = nvdimm_security_overwrite(dev, old_key);
 	} else
 		return -EINVAL;
 
@@ -1000,6 +1126,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	dev->type = &nvdimm_device_type;
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
+	nvdimm->overwrite_tmo = 0;
+	INIT_DELAYED_WORK(&nvdimm->dwork, nvdimm_overwrite_query);
 	nd_device_register(dev);
 
 	return nvdimm;
@@ -1276,7 +1404,17 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
 
-void __exit nvdimm_devs_exit(void)
+int __init nvdimm_devs_init(void)
+{
+	nvdimm_wq = create_singlethread_workqueue("nvdimm");
+	if (!nvdimm_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void  nvdimm_devs_exit(void)
 {
+	destroy_workqueue(nvdimm_wq);
 	ida_destroy(&dimm_ida);
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index b4a6ca15d077..efc7eb9e624c 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -46,6 +46,8 @@ struct nvdimm {
 	const struct nvdimm_security_ops *security_ops;
 	enum nvdimm_security_state state;
 	struct key *key;
+	struct delayed_work dwork;
+	unsigned int overwrite_tmo;
 };
 
 /**
@@ -81,6 +83,7 @@ struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
+int nvdimm_devs_init(void);
 void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 32c1da8c49e2..b59ff6b798b2 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -163,6 +163,7 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_UNLOCKED,
 	NVDIMM_SECURITY_LOCKED,
 	NVDIMM_SECURITY_FROZEN,
+	NVDIMM_SECURITY_OVERWRITE,
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
@@ -186,6 +187,9 @@ struct nvdimm_security_ops {
 	int (*freeze_lock)(struct nvdimm *nvdimm);
 	int (*erase)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
+	int (*overwrite)(struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *nkey);
+	int (*query_overwrite)(struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
