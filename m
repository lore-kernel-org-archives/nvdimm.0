Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5093021184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:08 -0800 (PST)
Subject: [PATCH 04/11] libnvdimm/security: introduce NDD_SECURITY_BUSY flag
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:07 -0700
Message-ID: <154180164758.70506.11595335862050814723.stgit@djiang5-desk3.ch.intel.com>
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

Adding a flag for nvdimm->flags to support erase functions. While it's ok
to hold the nvdimm_bus lock for secure erase due to minimal time to execute
the command, overwrite requires a significantly longer time and makes this
impossible. The flag will block any drivers from being loaded and DIMMs
being probed.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region_devs.c |    7 +++++
 drivers/nvdimm/security.c    |   61 ++++++++++++++++++++++++++++++++++++++----
 include/linux/libnvdimm.h    |    2 +
 4 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index f8d8f0a2a40d..6cb1cd4a39d0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -250,6 +250,7 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 void nvdimm_set_aliasing(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
+int nvdimm_check_security_busy(struct nvdimm *nvdimm);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 174a418cb171..a097282b2c01 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -78,6 +78,13 @@ int nd_region_activate(struct nd_region *nd_region)
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		int rc;
+
+		rc = nvdimm_check_security_busy(nvdimm);
+		if (rc) {
+			nvdimm_bus_unlock(&nd_region->dev);
+			return rc;
+		}
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index d2831e61f3d8..2a83be47798e 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -19,6 +19,27 @@ static bool no_key_self_verify;
 module_param(no_key_self_verify, bool, 0644);
 MODULE_PARM_DESC(no_key_self_verify, "Bypass security key self verify");
 
+/*
+ * Check if we are doing security wipes
+ */
+int nvdimm_check_security_busy(struct nvdimm *nvdimm)
+{
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags))
+		return -EBUSY;
+
+	return 0;
+}
+
+static inline void nvdimm_set_security_busy(struct nvdimm *nvdimm)
+{
+	set_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
+}
+
+static inline void nvdimm_clear_security_busy(struct nvdimm *nvdimm)
+{
+	clear_bit(NDD_SECURITY_BUSY, &nvdimm->flags);
+}
+
 /*
  * Retrieve user injected key
  */
@@ -85,6 +106,13 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 
 	nvdimm_bus_lock(dev);
 	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc < 0) {
+		dev_warn(dev, "Security operation in progress.\n");
+		goto out;
+	}
+
+	nvdimm_set_security_busy(nvdimm);
 	if (atomic_read(&nvdimm->busy)) {
 		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
 		rc = -EBUSY;
@@ -113,6 +141,7 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 	key_put(key);
 
  out:
+	nvdimm_clear_security_busy(nvdimm);
 	mutex_unlock(&nvdimm->sec_mutex);
 	nvdimm_bus_unlock(dev);
 	nvdimm_security_get_state(nvdimm);
@@ -130,15 +159,19 @@ int nvdimm_security_freeze_lock(struct nvdimm *nvdimm)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc < 0)
+		goto out;
+
 	rc = nvdimm->security_ops->freeze_lock(nvdimm);
-	if (rc < 0) {
-		mutex_unlock(&nvdimm->sec_mutex);
-		return rc;
-	}
+	if (rc < 0)
+		goto out;
 
 	nvdimm_security_get_state(nvdimm);
+
+out:
 	mutex_unlock(&nvdimm->sec_mutex);
-	return 0;
+	return rc;
 }
 
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
@@ -156,6 +189,12 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc < 0) {
+		mutex_unlock(&nvdimm->sec_mutex);
+		return rc;
+	}
+
 	/* look for a key from cached key */
 	key = nvdimm_lookup_user_key(dev, keyid);
 	if (!key) {
@@ -232,6 +271,12 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 		return 0;
 
 	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc < 0) {
+		mutex_unlock(&nvdimm->sec_mutex);
+		return rc;
+	}
+
 	/*
 	 * If the pre-OS has unlocked the DIMM, we will attempt to send
 	 * the key from request_key() to the hardware for verification.
@@ -294,7 +339,7 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		unsigned int old_keyid, unsigned int new_keyid)
 {
 	int rc;
-	struct key *key, *old_key;
+	struct key *key = NULL, *old_key = NULL;
 	void *old_data = NULL, *new_data;
 	struct device *dev = &nvdimm->dev;
 	struct encrypted_key_payload *epayload, *old_epayload;
@@ -306,6 +351,10 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		return -EBUSY;
 
 	mutex_lock(&nvdimm->sec_mutex);
+	rc = nvdimm_check_security_busy(nvdimm);
+	if (rc < 0)
+		goto out;
+
 	/* look for a key from cached key if exists */
 	old_key = nvdimm_lookup_user_key(dev, old_keyid);
 	if (old_key)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1071fe12081b..f3941836b93d 100644
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
