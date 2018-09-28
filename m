Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A775121106FA6
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:44:50 -0700 (PDT)
Subject: [PATCH v2 1/5] libnvdimm: introduce NDD_SECURITY_BUSY flag
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 15:44:49 -0700
Message-ID: <153817468975.19407.13097333227524016079.stgit@djiang5-desk3.ch.intel.com>
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

Adding a flag for nvdimm->flags to support erase functions. While it's ok
to hold the nvdimm_bus lock for secure erase due to minimal time to execute
the command, overwrite requires a significantly longer time and makes this
impossible. The flag will block any drivers from being loaded and DIMMs
being probed.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/dimm.c        |    4 +++
 drivers/nvdimm/dimm_devs.c   |   52 +++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/nd.h          |    3 ++
 drivers/nvdimm/region_devs.c |    7 ++++++
 include/linux/libnvdimm.h    |    2 ++
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index b6381ddbd6c1..5ff9367b8671 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -26,6 +26,10 @@ static int nvdimm_probe(struct device *dev)
 	struct nvdimm_drvdata *ndd;
 	int rc;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	rc = nvdimm_check_config_data(dev);
 	if (rc) {
 		/* not required for non-aliased nvdimm, ex. NVDIMM-N */
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 656a8fafca8e..7a71ea666676 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -187,12 +187,16 @@ static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key;
 	struct user_key_payload *payload;
-	int rc = 0;
+	int rc;
 	bool is_userkey = false;
 
 	if (!nvdimm->security_ops)
 		return -EOPNOTSUPP;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	nvdimm_bus_lock(&nvdimm_bus->dev);
 	if (atomic_read(&nvdimm->busy)) {
 		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
@@ -212,6 +216,8 @@ static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 		goto out;
 	}
 
+	nvdimm_set_security_busy(dev);
+
 	/* look for a key from cached key if exists */
 	key = nvdimm_get_and_verify_key(dev, keyid);
 	if (IS_ERR(key)) {
@@ -246,6 +252,7 @@ static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 	key_put(key);
 
  out:
+	nvdimm_clear_security_busy(dev);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 	nvdimm_security_get_state(dev);
 	return rc;
@@ -262,6 +269,10 @@ static int nvdimm_security_freeze_lock(struct device *dev)
 	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
 		return -EOPNOTSUPP;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	rc = nvdimm->security_ops->freeze_lock(nvdimm);
 	if (rc < 0)
 		return rc;
@@ -284,6 +295,10 @@ static int nvdimm_security_disable(struct device *dev, unsigned int keyid)
 	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
 		return -EOPNOTSUPP;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	/* look for a key from cached key */
 	key = nvdimm_get_and_verify_key(dev, keyid);
 	if (IS_ERR(key))
@@ -335,6 +350,10 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 			nvdimm->state == NVDIMM_SECURITY_DISABLED)
 		return 0;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	key = nvdimm_get_key(dev);
 	if (!key)
 		key = nvdimm_request_key(dev);
@@ -390,6 +409,10 @@ static int nvdimm_security_change_key(struct device *dev,
 	if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
 		return -EBUSY;
 
+	rc = nvdimm_check_security_busy(dev);
+	if (rc)
+		return rc;
+
 	/* look for a key from cached key if exists */
 	old_key = nvdimm_get_and_verify_key(dev, old_keyid);
 	if (IS_ERR(old_key))
@@ -467,6 +490,33 @@ static int nvdimm_security_change_key(struct device *dev,
 	return rc;
 }
 
+/*
+ * Check if we are doing security wipes
+ */
+int nvdimm_check_security_busy(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags))
+		return -EBUSY;
+
+	return 0;
+}
+
+void nvdimm_set_security_busy(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	set_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
+}
+
+void nvdimm_clear_security_busy(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	clear_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index fa3b89127078..252fbe6d4ecd 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -239,6 +239,9 @@ void nd_region_exit(void);
 struct nvdimm;
 struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nvdimm_check_config_data(struct device *dev);
+int nvdimm_check_security_busy(struct device *dev);
+void nvdimm_set_security_busy(struct device *dev);
+void nvdimm_clear_security_busy(struct device *dev);
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fa37afcd43ff..3e089c533397 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -78,6 +78,13 @@ int nd_region_activate(struct nd_region *nd_region)
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		int rc;
+
+		rc = nvdimm_check_security_busy(&nvdimm->dev);
+		if (rc) {
+			nvdimm_bus_unlock(&nd_region->dev);
+			return rc;
+		}
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index c352b8195675..32c1da8c49e2 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -38,6 +38,8 @@ enum {
 	NDD_UNARMED = 1,
 	/* locked memory devices should not be accessed */
 	NDD_LOCKED = 2,
+	/* memory under security wipes should not be accessed */
+	NDD_SECURITY_BUSY = 3,
 
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
