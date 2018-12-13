Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF32C211A1E47
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 08:49:22 -0800 (PST)
Subject: [PATCH v14 11/17] libnvdimm/security: introduce NDD_SECURITY_BUSY flag
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 13 Dec 2018 09:49:22 -0700
Message-ID: <154471976220.55644.7438654212111357869.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154471935968.55644.4424661179787827497.stgit@djiang5-desk3.ch.intel.com>
References: <154471935968.55644.4424661179787827497.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/nvdimm/dimm_devs.c   |    5 +++++
 drivers/nvdimm/region_devs.c |    5 +++++
 drivers/nvdimm/security.c    |   15 +++++++++++++++
 include/linux/libnvdimm.h    |    2 ++
 4 files changed, 27 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index bc432b7c17b8..e9f11d35ff2b 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -569,6 +569,11 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm)
 	if (nvdimm->sec.state < 0)
 		return -EIO;
 
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
+		dev_warn(&nvdimm->dev, "Security operation in progress.\n");
+		return -EBUSY;
+	}
+
 	rc = nvdimm->sec.ops->freeze(nvdimm);
 	nvdimm->sec.state = nvdimm_security_state(nvdimm);
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 174a418cb171..4e69b1d03c05 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -79,6 +79,11 @@ int nd_region_activate(struct nd_region *nd_region)
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
+		if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
+			nvdimm_bus_unlock(&nd_region->dev);
+			return -EBUSY;
+		}
+
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
 		num_flush = min_not_zero(num_flush, nvdimm->num_flush);
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4836f2fda271..1edd298e6e27 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -143,6 +143,11 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| nvdimm->sec.state < 0)
 		return -EIO;
 
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return -EBUSY;
+	}
+
 	/*
 	 * If the pre-OS has unlocked the DIMM, attempt to send the key
 	 * from request_key() to the hardware for verification.  Failure
@@ -203,6 +208,11 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EIO;
 	}
 
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return -EBUSY;
+	}
+
 	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 	if (!key)
 		return -ENOKEY;
@@ -288,6 +298,11 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EIO;
 	}
 
+	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags)) {
+		dev_warn(dev, "Security operation in progress.\n");
+		return -EBUSY;
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
