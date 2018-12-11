Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7F3B2119AC09
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:26:25 -0800 (PST)
Subject: [PATCH v13 11/17] libnvdimm/security: introduce NDD_SECURITY_BUSY flag
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:25 -0700
Message-ID: <154455998510.26509.12864195383108839732.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding a flag for nvdimm->flags to support erase functions. While it's ok
to hold the nvdimm_bus lock for secure erase due to minimal time to execute
the command, overwrite requires a significantly longer time and makes this
impossible. The flag will block any drivers from being loaded and DIMMs
being probed.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/dimm_devs.c   |    6 ++++++
 drivers/nvdimm/nd-core.h     |   16 ++++++++++++++++
 drivers/nvdimm/region_devs.c |    7 +++++++
 drivers/nvdimm/security.c    |   18 ++++++++++++++++++
 include/linux/libnvdimm.h    |    2 ++
 5 files changed, 49 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e3b46849ee0a..bfdc4824ba11 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -557,6 +557,12 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm)
 	if (nvdimm->sec.state < 0)
 		return -EIO;
 
+	rc = nvdimm_security_check_busy(nvdimm);
+	if (rc < 0) {
+		dev_warn(&nvdimm->dev, "Security operation in progress.\n");
+		return rc;
+	}
+
 	rc = nvdimm->sec.ops->freeze(nvdimm);
 	nvdimm->sec.state = nvdimm_security_state(nvdimm);
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 3c8cdd40c456..353f945cda5b 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -61,6 +61,22 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		unsigned int new_keyid);
 int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
+static inline int nvdimm_security_check_busy(struct nvdimm *nvdimm)
+{
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags))
+		return -EBUSY;
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
 
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 174a418cb171..7ccca49c7a52 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -78,6 +78,13 @@ int nd_region_activate(struct nd_region *nd_region)
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		int rc;
+
+		rc = nvdimm_security_check_busy(nvdimm);
+		if (rc) {
+			nvdimm_bus_unlock(&nd_region->dev);
+			return rc;
+		}
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4836f2fda271..5a03dffd0056 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -143,6 +143,12 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| nvdimm->sec.state < 0)
 		return -EIO;
 
+	rc = nvdimm_security_check_busy(nvdimm);
+	if (rc < 0) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return rc;
+	}
+
 	/*
 	 * If the pre-OS has unlocked the DIMM, attempt to send the key
 	 * from request_key() to the hardware for verification.  Failure
@@ -203,6 +209,12 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EIO;
 	}
 
+	rc = nvdimm_security_check_busy(nvdimm);
+	if (rc < 0) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return rc;
+	}
+
 	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 	if (!key)
 		return -ENOKEY;
@@ -288,6 +300,12 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EIO;
 	}
 
+	rc = nvdimm_security_check_busy(nvdimm);
+	if (rc < 0) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return rc;
+	}
+
 	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 	if (!key)
 		return -ENOKEY;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 9a6cb7067dc7..8507d2896ae0 100644
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
