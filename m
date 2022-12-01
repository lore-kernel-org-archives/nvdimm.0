Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CE610782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932216; x=1701468216;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zlnaBZrMcsB0htWquhZofEZiWcJh5cS5+nTSB3JLS8I=;
  b=X+yDpW2LVK9RFgIwH0cuQ4iDAzkfJjTP0rZ8HLoGk74EYrhnS1kTusAm
   PhYbIeEQeaVYuPJSNospB+yq2e3vRSSU7wjJyNqG7Z/jbEN8Q6qc59Bxh
   vS7vxGTZSm0UlOWxUVry0tPVbRxjNY421/MMCdrRv4PkiyiPpkGPhdvqI
   TZVQUs4uuVZyVWjJBNwNJF6p6VzABUBB7HIdSbhdhifQNMR5JBhmC0fuN
   bRMxqYO6yCVnF9PhbmcvSRIHw4bSbLgQ/ZpoDlI1uRStXDkiLLD8IJXh8
   ED59nX5ao96x17WTp6eF8veR8EuXAXt7KFloazV5IEfaQR681ujrEwyY6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295503697"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295503697"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638545056"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638545056"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:35 -0800
Subject: [PATCH 4/5] nvdimm/region: Move cache management to the region
 driver
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, dave.jiang@intel.com, nvdimm@lists.linux.dev,
 dave@stgolabs.net
Date: Thu, 01 Dec 2022 14:03:35 -0800
Message-ID: <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that cpu_cache_invalidate_memregion() is generically available, use
it to centralize CPU cache management in the nvdimm region driver.

This trades off removing redundant per-dimm CPU cache flushing with an
opportunistic flush on every region disable event to cover the case of
sensitive dirty data in the cache being written back to media after a
secure erase / overwrite event.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c    |   25 ---------------------
 drivers/nvdimm/region.c      |   11 +++++++++
 drivers/nvdimm/region_devs.c |   49 +++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/security.c    |    6 +++++
 include/linux/libnvdimm.h    |    5 ++++
 5 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index fa0e57e35162..3902759abcba 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -212,9 +212,6 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
-		return -EINVAL;
-
 	memcpy(nd_cmd.cmd.passphrase, key_data->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -229,9 +226,6 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 		return -EIO;
 	}
 
-	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
-
 	return 0;
 }
 
@@ -299,11 +293,6 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
-		return -EINVAL;
-
-	/* flush all cache before we erase DIMM */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	memcpy(nd_cmd.cmd.passphrase, key->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -322,8 +311,6 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 		return -ENXIO;
 	}
 
-	/* DIMM erased, invalidate all CPU caches before we read it */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	return 0;
 }
 
@@ -346,9 +333,6 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
-		return -EINVAL;
-
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
 	if (rc < 0)
 		return rc;
@@ -362,8 +346,6 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 		return -ENXIO;
 	}
 
-	/* flush all cache before we make the nvdimms available */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	return 0;
 }
 
@@ -388,11 +370,6 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
-		return -EINVAL;
-
-	/* flush all cache before we erase DIMM */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -770,5 +747,3 @@ static const struct nvdimm_fw_ops __intel_fw_ops = {
 };
 
 const struct nvdimm_fw_ops *intel_fw_ops = &__intel_fw_ops;
-
-MODULE_IMPORT_NS(DEVMEM);
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 390123d293ea..88dc062af5f8 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -2,6 +2,7 @@
 /*
  * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
  */
+#include <linux/memregion.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -100,6 +101,16 @@ static void nd_region_remove(struct device *dev)
 	 */
 	sysfs_put(nd_region->bb_state);
 	nd_region->bb_state = NULL;
+
+	/*
+	 * Try to flush caches here since a disabled region may be subject to
+	 * secure erase while disabled, and previous dirty data should not be
+	 * written back to a new instance of the region. This only matters on
+	 * bare metal where security commands are available, so silent failure
+	 * here is ok.
+	 */
+	if (cpu_cache_has_invalidate_memregion())
+		cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
 }
 
 static int child_notify(struct device *dev, void *data)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e0875d369762..c73e3b1fd0a6 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -59,13 +59,57 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 	return 0;
 }
 
+static int nd_region_invalidate_memregion(struct nd_region *nd_region)
+{
+	int i, incoherent = 0;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		if (test_bit(NDD_INCOHERENT, &nvdimm->flags))
+			incoherent++;
+	}
+
+	if (!incoherent)
+		return 0;
+
+	if (!cpu_cache_has_invalidate_memregion()) {
+		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
+			dev_warn(
+				&nd_region->dev,
+				"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
+			goto out;
+		} else {
+			dev_err(&nd_region->dev,
+				"Failed to synchronize CPU cache state\n");
+			return -ENXIO;
+		}
+	}
+
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+out:
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		clear_bit(NDD_INCOHERENT, &nvdimm->flags);
+	}
+
+	return 0;
+}
+
 int nd_region_activate(struct nd_region *nd_region)
 {
-	int i, j, num_flush = 0;
+	int i, j, rc, num_flush = 0;
 	struct nd_region_data *ndrd;
 	struct device *dev = &nd_region->dev;
 	size_t flush_data_size = sizeof(void *);
 
+	rc = nd_region_invalidate_memregion(nd_region);
+	if (rc)
+		return rc;
+
 	nvdimm_bus_lock(&nd_region->dev);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -85,6 +129,7 @@ int nd_region_activate(struct nd_region *nd_region)
 	}
 	nvdimm_bus_unlock(&nd_region->dev);
 
+
 	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
 	if (!ndrd)
 		return -ENOMEM;
@@ -1222,3 +1267,5 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
 
 	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
 }
+
+MODULE_IMPORT_NS(DEVMEM);
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 6814339b3dab..a03e3c45f297 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -208,6 +208,8 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 	rc = nvdimm->sec.ops->unlock(nvdimm, data);
 	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
+	if (rc == 0)
+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
 
 	nvdimm_put_key(key);
 	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
@@ -374,6 +376,8 @@ static int security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
+	if (rc == 0)
+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
 	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
 			rc == 0 ? "success" : "fail");
@@ -408,6 +412,8 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
+	if (rc == 0)
+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
 	dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3bf658a74ccb..af38252ad704 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -35,6 +35,11 @@ enum {
 	NDD_WORK_PENDING = 4,
 	/* dimm supports namespace labels */
 	NDD_LABELING = 6,
+	/*
+	 * dimm contents have changed requiring invalidation of CPU caches prior
+	 * to activation of a region that includes this device
+	 */
+	NDD_INCOHERENT = 7,
 
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,

