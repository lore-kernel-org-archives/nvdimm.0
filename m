Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B7FA2118EF5C
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:14 -0800 (PST)
Subject: [PATCH 05/11] acpi/nfit,
 libnvdimm/security: Add security DSM overwrite support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:13 -0700
Message-ID: <154180165306.70506.12390921144378942420.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
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
 drivers/acpi/nfit/intel.c  |  113 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h  |    3 +
 drivers/acpi/nfit/nfit.h   |    1 
 drivers/nvdimm/core.c      |    3 +
 drivers/nvdimm/dimm_devs.c |   22 ++++++++
 drivers/nvdimm/nd-core.h   |    4 ++
 drivers/nvdimm/nd.h        |    8 +++
 drivers/nvdimm/security.c  |  116 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    4 ++
 9 files changed, 273 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index f8f63f483859..f6d2b217f1c8 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -20,6 +20,112 @@
 
 #include <asm/smp.h> /* for wbinvd_on_all_cpus() on !SMP builds */
 
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
@@ -319,6 +425,11 @@ static int intel_dimm_security_state(struct nvdimm *nvdimm,
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
@@ -367,5 +478,7 @@ static const struct nvdimm_security_ops __intel_security_ops = {
 	.disable = intel_dimm_security_disable,
 	.freeze_lock = intel_dimm_security_freeze_lock,
 	.erase = intel_dimm_security_erase,
+	.overwrite = intel_dimm_security_overwrite,
+	.query_overwrite = intel_dimm_security_query_overwrite,
 };
 const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 0af5b6fd0aea..a4e01de966dc 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -50,12 +50,15 @@ extern const struct nvdimm_security_ops *intel_security_ops;
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
index 00de13bc5714..d50dbb4cdeaf 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -204,6 +204,7 @@ struct nfit_mem {
 	unsigned long flags;
 	u32 dirty_shutdown;
 	int family;
+	bool overwrite;
 };
 
 struct acpi_nfit_desc {
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
index 269f401a5e68..b613c131bfb9 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -25,6 +25,7 @@
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
+struct workqueue_struct *nvdimm_wq;
 
 /*
  * Retrieve bus and dimm handle and return if this bus supports
@@ -386,6 +387,8 @@ __weak ssize_t security_show(struct device *dev,
 		return sprintf(buf, "locked\n");
 	case NVDIMM_SECURITY_FROZEN:
 		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_OVERWRITE:
+		return sprintf(buf, "overwrite\n");
 	case NVDIMM_SECURITY_UNSUPPORTED:
 	default:
 		return sprintf(buf, "unsupported\n");
@@ -432,6 +435,11 @@ static ssize_t security_store(struct device *dev,
 			return -EINVAL;
 		dev_dbg(dev, "erase %#x\n", old_key);
 		rc = nvdimm_security_erase(nvdimm, old_key);
+	} else if (sysfs_streq(cmd, "overwrite")) {
+		if (rc != 2)
+			return -EINVAL;
+		dev_dbg(dev, "overwrite %u\n", old_key);
+		rc = nvdimm_security_overwrite(nvdimm, old_key);
 	} else
 		return -EINVAL;
 
@@ -492,6 +500,8 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_dat
 	dev->type = &nvdimm_device_type;
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
+	nvdimm->overwrite_tmo = 0;
+	INIT_DELAYED_WORK(&nvdimm->dwork, nvdimm_overwrite_query);
 	nd_device_register(dev);
 
 	return nvdimm;
@@ -768,7 +778,17 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
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
index cfb87f71db8d..20a8216c503d 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -22,6 +22,7 @@
 extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
 extern int nvdimm_major;
+extern struct workqueue_struct *nvdimm_wq;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -46,6 +47,8 @@ struct nvdimm {
 	const struct nvdimm_security_ops *security_ops;
 	enum nvdimm_security_state state;
 	struct mutex sec_mutex;
+	struct delayed_work dwork;
+	unsigned int overwrite_tmo;
 };
 
 /**
@@ -81,6 +84,7 @@ struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
+int nvdimm_devs_init(void);
 void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 6cb1cd4a39d0..ba41582c4cc2 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -435,6 +435,9 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm, unsigned int old_keyid,
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 int nvdimm_security_freeze_lock(struct nvdimm *nvdimm);
 int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
+int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid);
+void nvdimm_overwrite_query(struct work_struct *work);
+
 #else
 static inline int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 {
@@ -468,5 +471,10 @@ static inline int nvdimm_security_erase(struct nvdimm *nvdimm,
 {
 	return -EOPNOTSUPP;
 }
+int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
+{
+	return -EOPNOTSUPP;
+}
+void nvdimm_overwrite_query(struct work_struct *work) {}
 #endif
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 2a83be47798e..725acd211114 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -93,6 +93,122 @@ int nvdimm_security_get_state(struct nvdimm *nvdimm)
 	return nvdimm->security_ops->state(nvdimm, &nvdimm->state);
 }
 
+void nvdimm_overwrite_query(struct work_struct *work)
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
+	nvdimm_clear_security_busy(nvdimm);
+	nvdimm_security_get_state(nvdimm);
+}
+
+int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
+	struct device *dev = &nvdimm->dev;
+	struct key *key = NULL;
+	struct encrypted_key_payload *epayload;
+	void *data;
+	int rc;
+	char pass[NVDIMM_PASSPHRASE_LEN];
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc)
+		goto out;
+
+	nvdimm_set_security_busy(nvdimm);
+
+	if (atomic_read(&nvdimm->busy)) {
+		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		nvdimm_clear_security_busy(nvdimm);
+		rc = -EBUSY;
+		goto out;
+	}
+
+	if (dev_get_drvdata(dev)) {
+		dev_warn(dev, "Unable to overwrite while DIMM active.\n");
+		nvdimm_clear_security_busy(nvdimm);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED) {
+		dev_warn(dev, "Attempt to overwrite in wrong state.\n");
+		nvdimm_clear_security_busy(nvdimm);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	key = nvdimm_lookup_user_key(dev, keyid);
+	if (!key && keyid != 0) {
+		dev_dbg(dev, "Unable to get and verify key\n");
+		nvdimm_clear_security_busy(nvdimm);
+		rc = -ENOKEY;
+		goto out;
+	}
+
+	if (key) {
+		down_read(&key->sem);
+		epayload = dereference_key_locked(key);
+		data = epayload->decrypted_data;
+		memcpy(pass, data, NVDIMM_PASSPHRASE_LEN);
+		up_read(&key->sem);
+	} else
+		memset(pass, 0, NVDIMM_PASSPHRASE_LEN);
+	/*
+	 * Overwrite can execute w/o passphrase. we will let the hardware
+	 * determine whether we need a passphrase or not.
+	 */
+	rc = nvdimm->security_ops->overwrite(nvdimm,
+			(const struct nvdimm_key_data *)pass);
+	if (rc == 0) {
+		/* clear out security data */
+		if (key)
+			memset(pass, 0, NVDIMM_PASSPHRASE_LEN);
+		nvdimm->state = NVDIMM_SECURITY_OVERWRITE;
+		queue_delayed_work(nvdimm_wq, &nvdimm->dwork, 0);
+	} else
+		nvdimm_clear_security_busy(nvdimm);
+
+ out:
+	key_put(key);
+	mutex_unlock(&nvdimm->sec_mutex);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	nvdimm_security_get_state(nvdimm);
+	return rc;
+
+}
+
 int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 {
 	int rc = 0;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f3941836b93d..479421ce62c0 100644
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
