Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F89258CDA
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649222; cv=none; b=OoQdTHx8M3bQz20GSXp9NEkjMUTnfdSxN6+LzxNvIUJddJjoGr+NeBGULIFrjDtAajkGlOjt4ON0xsF+zpjq6Q3WEkr+q8Pd/Mm5atzpCYt9sGIuofje4OhcT5QPLMhQcJpKQTCngIYKaQJikOWviNk9D0ksv8ufnNGShDDqUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649222; c=relaxed/simple;
	bh=XXST6vLXBhFciUtsEAEzIoGJvsU1Qx9P3uRufVQdlEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYCFAC7sftp8F8KwgqBxnTgONWvf0FGvKp4jKdc6FuNpzZ0kGotvJU54F35T3bdwGGE5S3Xe90gAc2fxLfI6KeSX3yFNBzn1dEJM7rbY7u0//H7jTdHt3/ivu5nVOgvSLDRNA6sJ+GNrRtMk82DKaI8o2V5kFSfCbgm/faWifVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E328FC4CEF5;
	Tue, 23 Sep 2025 17:40:21 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev
Cc: ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	jonathan.cameron@huawei.com,
	s.neeraj@samsung.com
Subject: [PATCH v2 1/2] nvdimm: Introduce guard() for nvdimm_bus_lock
Date: Tue, 23 Sep 2025 10:40:12 -0700
Message-ID: <20250923174013.3319780-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250923174013.3319780-1-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Converting nvdimm_bus_lock/unlock to guard() to clean up usage
of gotos for error handling and avoid future mistakes of missed
unlock on error paths.

Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Moved cleanup of __nd_ioctl() cleanup to a different patch. (Dan)
- Various minor fixes and cleanups. (Jonathan)
---
 drivers/nvdimm/badrange.c       |   3 +-
 drivers/nvdimm/btt_devs.c       |  24 +++----
 drivers/nvdimm/bus.c            |   6 +-
 drivers/nvdimm/claim.c          |   7 +-
 drivers/nvdimm/core.c           |  17 +++--
 drivers/nvdimm/dax_devs.c       |  12 ++--
 drivers/nvdimm/dimm.c           |   5 +-
 drivers/nvdimm/dimm_devs.c      |  48 +++++--------
 drivers/nvdimm/namespace_devs.c | 117 +++++++++++++++----------------
 drivers/nvdimm/nd.h             |   3 +
 drivers/nvdimm/pfn_devs.c       |  61 +++++++----------
 drivers/nvdimm/region.c         |  14 ++--
 drivers/nvdimm/region_devs.c    | 118 ++++++++++++++------------------
 drivers/nvdimm/security.c       |  10 +--
 14 files changed, 194 insertions(+), 251 deletions(-)

diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index ee478ccde7c6..36c626db459a 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -278,8 +278,7 @@ void nvdimm_badblocks_populate(struct nd_region *nd_region,
 	}
 	nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	guard(nvdimm_bus)(&nvdimm_bus->dev);
 	badblocks_populate(&nvdimm_bus->badrange, bb, range);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 497fd434a6a1..b3279b86bbfd 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -50,14 +50,12 @@ static ssize_t sector_size_store(struct device *dev,
 	struct nd_btt *nd_btt = to_nd_btt(dev);
 	ssize_t rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_size_select_store(dev, buf, &nd_btt->lbasize,
 			btt_lbasize_supported);
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc ? rc : len;
 }
@@ -93,13 +91,10 @@ static ssize_t namespace_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_btt *nd_btt = to_nd_btt(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
-	rc = sprintf(buf, "%s\n", nd_btt->ndns
+	guard(nvdimm_bus)(dev);
+	return sprintf(buf, "%s\n", nd_btt->ndns
 			? dev_name(&nd_btt->ndns->dev) : "");
-	nvdimm_bus_unlock(dev);
-	return rc;
 }
 
 static ssize_t namespace_store(struct device *dev,
@@ -108,13 +103,11 @@ static ssize_t namespace_store(struct device *dev,
 	struct nd_btt *nd_btt = to_nd_btt(dev);
 	ssize_t rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_namespace_store(dev, &nd_btt->ndns, buf, len);
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc;
 }
@@ -351,9 +344,8 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 		return -ENODEV;
 	}
 
-	nvdimm_bus_lock(&ndns->dev);
-	btt_dev = __nd_btt_create(nd_region, 0, NULL, ndns);
-	nvdimm_bus_unlock(&ndns->dev);
+	scoped_guard(nvdimm_bus, &ndns->dev)
+		btt_dev = __nd_btt_create(nd_region, 0, NULL, ndns);
 	if (!btt_dev)
 		return -ENOMEM;
 	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 0ccf4a9e523a..e57d5677d44b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -64,17 +64,15 @@ static struct module *to_bus_provider(struct device *dev)
 
 static void nvdimm_bus_probe_start(struct nvdimm_bus *nvdimm_bus)
 {
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	guard(nvdimm_bus)(&nvdimm_bus->dev);
 	nvdimm_bus->probe_active++;
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 
 static void nvdimm_bus_probe_end(struct nvdimm_bus *nvdimm_bus)
 {
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	guard(nvdimm_bus)(&nvdimm_bus->dev);
 	if (--nvdimm_bus->probe_active == 0)
 		wake_up(&nvdimm_bus->wait);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 
 static int nvdimm_bus_probe(struct device *dev)
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 51614651d2e7..309cd2cddb0e 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -34,11 +34,10 @@ void nd_detach_ndns(struct device *dev,
 
 	if (!ndns)
 		return;
-	get_device(&ndns->dev);
-	nvdimm_bus_lock(&ndns->dev);
+
+	struct device *ndev __free(put_device) = get_device(&ndns->dev);
+	guard(nvdimm_bus)(ndev);
 	__nd_detach_ndns(dev, _ndns);
-	nvdimm_bus_unlock(&ndns->dev);
-	put_device(&ndns->dev);
 }
 
 bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index eaa796629c27..5ba204113fe1 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -141,9 +141,8 @@ static void nvdimm_map_put(void *data)
 	struct nvdimm_map *nvdimm_map = data;
 	struct nvdimm_bus *nvdimm_bus = nvdimm_map->nvdimm_bus;
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	guard(nvdimm_bus)(&nvdimm_bus->dev);
 	kref_put(&nvdimm_map->kref, nvdimm_map_release);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 
 /**
@@ -158,13 +157,13 @@ void *devm_nvdimm_memremap(struct device *dev, resource_size_t offset,
 {
 	struct nvdimm_map *nvdimm_map;
 
-	nvdimm_bus_lock(dev);
-	nvdimm_map = find_nvdimm_map(dev, offset);
-	if (!nvdimm_map)
-		nvdimm_map = alloc_nvdimm_map(dev, offset, size, flags);
-	else
-		kref_get(&nvdimm_map->kref);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		nvdimm_map = find_nvdimm_map(dev, offset);
+		if (!nvdimm_map)
+			nvdimm_map = alloc_nvdimm_map(dev, offset, size, flags);
+		else
+			kref_get(&nvdimm_map->kref);
+	}
 
 	if (!nvdimm_map)
 		return NULL;
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 37b743acbb7b..ba4c409ede65 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -104,12 +104,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 		return -ENODEV;
 	}
 
-	nvdimm_bus_lock(&ndns->dev);
-	nd_dax = nd_dax_alloc(nd_region);
-	dax_dev = nd_dax_devinit(nd_dax, ndns);
-	nvdimm_bus_unlock(&ndns->dev);
-	if (!dax_dev)
-		return -ENOMEM;
+	scoped_guard(nvdimm_bus, &ndns->dev) {
+		nd_dax = nd_dax_alloc(nd_region);
+		dax_dev = nd_dax_devinit(nd_dax, ndns);
+		if (!dax_dev)
+			return -ENOMEM;
+	}
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 91d9163ee303..2f6c26cc6a3e 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -117,9 +117,8 @@ static void nvdimm_remove(struct device *dev)
 {
 	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
 
-	nvdimm_bus_lock(dev);
-	dev_set_drvdata(dev, NULL);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev)
+		dev_set_drvdata(dev, NULL);
 	put_ndd(ndd);
 }
 
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 21498d461fde..e1349ef5f8fd 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -226,10 +226,10 @@ void nvdimm_drvdata_release(struct kref *kref)
 	struct resource *res, *_r;
 
 	dev_dbg(dev, "trace\n");
-	nvdimm_bus_lock(dev);
-	for_each_dpa_resource_safe(ndd, res, _r)
-		nvdimm_free_dpa(ndd, res);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		for_each_dpa_resource_safe(ndd, res, _r)
+			nvdimm_free_dpa(ndd, res);
+	}
 
 	kvfree(ndd->data);
 	kfree(ndd);
@@ -319,23 +319,20 @@ static DEVICE_ATTR_RO(state);
 static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 {
 	struct device *dev;
-	ssize_t rc;
 	u32 nfree;
 
 	if (!ndd)
 		return -ENXIO;
 
 	dev = ndd->dev;
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	nfree = nd_label_nfree(ndd);
 	if (nfree - 1 > nfree) {
 		dev_WARN_ONCE(dev, 1, "we ate our last label?\n");
 		nfree = 0;
 	} else
 		nfree--;
-	rc = sprintf(buf, "%d\n", nfree);
-	nvdimm_bus_unlock(dev);
-	return rc;
+	return sprintf(buf, "%d\n", nfree);
 }
 
 static ssize_t available_slots_show(struct device *dev,
@@ -388,21 +385,15 @@ static ssize_t security_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 
 {
-	ssize_t rc;
-
 	/*
 	 * Require all userspace triggered security management to be
 	 * done while probing is idle and the DIMM is not in active use
 	 * in any region.
 	 */
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
-	rc = nvdimm_security_store(dev, buf, len);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
-
-	return rc;
+	return nvdimm_security_store(dev, buf, len);
 }
 static DEVICE_ATTR_RW(security);
 
@@ -454,9 +445,8 @@ static ssize_t result_show(struct device *dev, struct device_attribute *attr, ch
 	if (!nvdimm->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	result = nvdimm->fw_ops->activate_result(nvdimm);
-	nvdimm_bus_unlock(dev);
 
 	switch (result) {
 	case NVDIMM_FWA_RESULT_NONE:
@@ -483,9 +473,8 @@ static ssize_t activate_show(struct device *dev, struct device_attribute *attr,
 	if (!nvdimm->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	state = nvdimm->fw_ops->activate_state(nvdimm);
-	nvdimm_bus_unlock(dev);
 
 	switch (state) {
 	case NVDIMM_FWA_IDLE:
@@ -516,9 +505,8 @@ static ssize_t activate_store(struct device *dev, struct device_attribute *attr,
 	else
 		return -EINVAL;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nvdimm->fw_ops->arm(nvdimm, arg);
-	nvdimm_bus_unlock(dev);
 
 	if (rc < 0)
 		return rc;
@@ -545,9 +533,8 @@ static umode_t nvdimm_firmware_visible(struct kobject *kobj, struct attribute *a
 	if (!nvdimm->fw_ops)
 		return 0;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return 0;
@@ -641,11 +628,10 @@ void nvdimm_delete(struct nvdimm *nvdimm)
 	bool dev_put = false;
 
 	/* We are shutting down. Make state frozen artificially. */
-	nvdimm_bus_lock(dev);
-	set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
-	if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
-		dev_put = true;
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
+		dev_put = test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags);
+	}
 	cancel_delayed_work_sync(&nvdimm->dwork);
 	if (dev_put)
 		put_device(dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..e45ac4f6e7af 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -264,15 +264,13 @@ static ssize_t alt_name_store(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	ssize_t rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	rc = __alt_name_store(dev, buf, len);
 	if (rc >= 0)
 		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "%s(%zd)\n", rc < 0 ? "fail " : "", rc);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc < 0 ? rc : len;
 }
@@ -849,8 +847,8 @@ static ssize_t size_store(struct device *dev,
 	if (rc)
 		return rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	rc = __size_store(dev, val);
 	if (rc >= 0)
@@ -866,9 +864,6 @@ static ssize_t size_store(struct device *dev,
 
 	dev_dbg(dev, "%llx %s (%d)\n", val, rc < 0 ? "fail" : "success", rc);
 
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
-
 	return rc < 0 ? rc : len;
 }
 
@@ -891,13 +886,8 @@ resource_size_t __nvdimm_namespace_capacity(struct nd_namespace_common *ndns)
 
 resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns)
 {
-	resource_size_t size;
-
-	nvdimm_bus_lock(&ndns->dev);
-	size = __nvdimm_namespace_capacity(ndns);
-	nvdimm_bus_unlock(&ndns->dev);
-
-	return size;
+	guard(nvdimm_bus)(&ndns->dev);
+	return __nvdimm_namespace_capacity(ndns);
 }
 EXPORT_SYMBOL(nvdimm_namespace_capacity);
 
@@ -1044,8 +1034,8 @@ static ssize_t uuid_store(struct device *dev,
 	} else
 		return -ENXIO;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	if (to_ndns(dev)->claim)
 		rc = -EBUSY;
@@ -1059,8 +1049,6 @@ static ssize_t uuid_store(struct device *dev,
 		kfree(uuid);
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc < 0 ? rc : len;
 }
@@ -1119,20 +1107,30 @@ static ssize_t sector_size_store(struct device *dev,
 	} else
 		return -ENXIO;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
-	if (to_ndns(dev)->claim)
-		rc = -EBUSY;
-	if (rc >= 0)
-		rc = nd_size_select_store(dev, buf, lbasize, supported);
-	if (rc >= 0)
-		rc = nd_namespace_label_update(nd_region, dev);
-	dev_dbg(dev, "result: %zd %s: %s%s", rc, rc < 0 ? "tried" : "wrote",
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
+	if (to_ndns(dev)->claim) {
+		dev_dbg(dev, "namespace %s already claimed\n", dev_name(dev));
+		return -EBUSY;
+	}
+
+	rc = nd_size_select_store(dev, buf, lbasize, supported);
+	if (rc < 0) {
+		dev_dbg(dev, "size select fail: %zd tried: %s%s", rc,
 			buf, buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
+		return rc;
+	}
 
-	return rc ? rc : len;
+	rc = nd_namespace_label_update(nd_region, dev);
+	if (rc < 0) {
+		dev_dbg(dev, "label update fail: %zd tried: %s%s",
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+		return rc;
+	}
+
+	dev_dbg(dev, "wrote: %s%s", buf, buf[len - 1] == '\n' ? "" : "\n");
+
+	return len;
 }
 static DEVICE_ATTR_RW(sector_size);
 
@@ -1145,7 +1143,7 @@ static ssize_t dpa_extents_show(struct device *dev,
 	int count = 0, i;
 	u32 flags = 0;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
@@ -1154,7 +1152,7 @@ static ssize_t dpa_extents_show(struct device *dev,
 	}
 
 	if (!uuid)
-		goto out;
+		return sprintf(buf, "%d\n", count);
 
 	nd_label_gen_id(&label_id, uuid, flags);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
@@ -1166,8 +1164,6 @@ static ssize_t dpa_extents_show(struct device *dev,
 			if (strcmp(res->name, label_id.id) == 0)
 				count++;
 	}
- out:
-	nvdimm_bus_unlock(dev);
 
 	return sprintf(buf, "%d\n", count);
 }
@@ -1279,15 +1275,13 @@ static ssize_t holder_class_store(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	int rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	rc = __holder_class_store(dev, buf);
 	if (rc >= 0)
 		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "%s(%d)\n", rc < 0 ? "fail " : "", rc);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc < 0 ? rc : len;
 }
@@ -2152,31 +2146,38 @@ static int init_active_labels(struct nd_region *nd_region)
 					nd_region);
 }
 
+static int create_relevant_namespaces(struct nd_region *nd_region, int *type,
+				      struct device ***devs)
+{
+	int rc;
+
+	guard(nvdimm_bus)(&nd_region->dev);
+	rc = init_active_labels(nd_region);
+	if (rc)
+		return rc;
+
+	*type = nd_region_to_nstype(nd_region);
+	switch (*type) {
+	case ND_DEVICE_NAMESPACE_IO:
+		*devs = create_namespace_io(nd_region);
+		break;
+	case ND_DEVICE_NAMESPACE_PMEM:
+		*devs = create_namespaces(nd_region);
+		break;
+	}
+
+	return 0;
+}
+
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 {
 	struct device **devs = NULL;
 	int i, rc = 0, type;
 
 	*err = 0;
-	nvdimm_bus_lock(&nd_region->dev);
-	rc = init_active_labels(nd_region);
-	if (rc) {
-		nvdimm_bus_unlock(&nd_region->dev);
+	rc = create_relevant_namespaces(nd_region, &type, &devs);
+	if (rc)
 		return rc;
-	}
-
-	type = nd_region_to_nstype(nd_region);
-	switch (type) {
-	case ND_DEVICE_NAMESPACE_IO:
-		devs = create_namespace_io(nd_region);
-		break;
-	case ND_DEVICE_NAMESPACE_PMEM:
-		devs = create_namespaces(nd_region);
-		break;
-	default:
-		break;
-	}
-	nvdimm_bus_unlock(&nd_region->dev);
 
 	if (!devs)
 		return -ENODEV;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index cc5c8f3f81e8..b199eea3260e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,6 +632,9 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
+DEFINE_GUARD(nvdimm_bus, struct device *,
+	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
+
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8f3e816e805d..42b172fc5576 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -56,30 +56,26 @@ static ssize_t mode_store(struct device *dev,
 {
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc = 0;
+	size_t n = len - 1;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	if (dev->driver)
-		rc = -EBUSY;
-	else {
-		size_t n = len - 1;
+		return -EBUSY;
 
-		if (strncmp(buf, "pmem\n", n) == 0
-				|| strncmp(buf, "pmem", n) == 0) {
-			nd_pfn->mode = PFN_MODE_PMEM;
-		} else if (strncmp(buf, "ram\n", n) == 0
-				|| strncmp(buf, "ram", n) == 0)
-			nd_pfn->mode = PFN_MODE_RAM;
-		else if (strncmp(buf, "none\n", n) == 0
-				|| strncmp(buf, "none", n) == 0)
-			nd_pfn->mode = PFN_MODE_NONE;
-		else
-			rc = -EINVAL;
-	}
+	if (strncmp(buf, "pmem\n", n) == 0
+			|| strncmp(buf, "pmem", n) == 0) {
+		nd_pfn->mode = PFN_MODE_PMEM;
+	} else if (strncmp(buf, "ram\n", n) == 0
+			|| strncmp(buf, "ram", n) == 0)
+		nd_pfn->mode = PFN_MODE_RAM;
+	else if (strncmp(buf, "none\n", n) == 0
+			|| strncmp(buf, "none", n) == 0)
+		nd_pfn->mode = PFN_MODE_NONE;
+	else
+		rc = -EINVAL;
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc ? rc : len;
 }
@@ -125,14 +121,12 @@ static ssize_t align_store(struct device *dev,
 	unsigned long aligns[MAX_NVDIMM_ALIGN] = { [0] = 0, };
 	ssize_t rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_size_select_store(dev, buf, &nd_pfn->align,
 			nd_pfn_supported_alignments(aligns));
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc ? rc : len;
 }
@@ -168,13 +162,10 @@ static ssize_t namespace_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
-	rc = sprintf(buf, "%s\n", nd_pfn->ndns
+	guard(nvdimm_bus)(dev);
+	return sprintf(buf, "%s\n", nd_pfn->ndns
 			? dev_name(&nd_pfn->ndns->dev) : "");
-	nvdimm_bus_unlock(dev);
-	return rc;
 }
 
 static ssize_t namespace_store(struct device *dev,
@@ -183,13 +174,11 @@ static ssize_t namespace_store(struct device *dev,
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_namespace_store(dev, &nd_pfn->ndns, buf, len);
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc;
 }
@@ -639,10 +628,10 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 		return -ENODEV;
 	}
 
-	nvdimm_bus_lock(&ndns->dev);
-	nd_pfn = nd_pfn_alloc(nd_region);
-	pfn_dev = nd_pfn_devinit(nd_pfn, ndns);
-	nvdimm_bus_unlock(&ndns->dev);
+	scoped_guard(nvdimm_bus, &ndns->dev) {
+		nd_pfn = nd_pfn_alloc(nd_region);
+		pfn_dev = nd_pfn_devinit(nd_pfn, ndns);
+	}
 	if (!pfn_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 88dc062af5f8..2abbdcef8d33 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -87,13 +87,13 @@ static void nd_region_remove(struct device *dev)
 	device_for_each_child(dev, NULL, child_unregister);
 
 	/* flush attribute readers and disable */
-	nvdimm_bus_lock(dev);
-	nd_region->ns_seed = NULL;
-	nd_region->btt_seed = NULL;
-	nd_region->pfn_seed = NULL;
-	nd_region->dax_seed = NULL;
-	dev_set_drvdata(dev, NULL);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		nd_region->ns_seed = NULL;
+		nd_region->btt_seed = NULL;
+		nd_region->pfn_seed = NULL;
+		nd_region->dax_seed = NULL;
+		dev_set_drvdata(dev, NULL);
+	}
 
 	/*
 	 * Note, this assumes device_lock() context to not race
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index de1ee5ebc851..a5ceaf5db595 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -102,31 +102,44 @@ static int nd_region_invalidate_memregion(struct nd_region *nd_region)
 	return 0;
 }
 
-int nd_region_activate(struct nd_region *nd_region)
+static int get_flush_data(struct nd_region *nd_region, size_t *size, int *num_flush)
 {
-	int i, j, rc, num_flush = 0;
-	struct nd_region_data *ndrd;
-	struct device *dev = &nd_region->dev;
 	size_t flush_data_size = sizeof(void *);
+	int _num_flush = 0;
+	int i;
 
-	nvdimm_bus_lock(&nd_region->dev);
+	guard(nvdimm_bus)(&nd_region->dev);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-		if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
-			nvdimm_bus_unlock(&nd_region->dev);
+		if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags))
 			return -EBUSY;
-		}
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
-		num_flush = min_not_zero(num_flush, nvdimm->num_flush);
+		_num_flush = min_not_zero(_num_flush, nvdimm->num_flush);
 		if (!nvdimm->num_flush)
 			continue;
 		flush_data_size += nvdimm->num_flush * sizeof(void *);
 	}
-	nvdimm_bus_unlock(&nd_region->dev);
+
+	*size = flush_data_size;
+	*num_flush = _num_flush;
+
+	return 0;
+}
+
+int nd_region_activate(struct nd_region *nd_region)
+{
+	int i, j, rc, num_flush;
+	struct nd_region_data *ndrd;
+	struct device *dev = &nd_region->dev;
+	size_t flush_data_size;
+
+	rc = get_flush_data(nd_region, &flush_data_size, &num_flush);
+	if (rc)
+		return rc;
 
 	rc = nd_region_invalidate_memregion(nd_region);
 	if (rc)
@@ -327,8 +340,8 @@ static ssize_t set_cookie_show(struct device *dev,
 	 * the v1.1 namespace label cookie definition. To read all this
 	 * data we need to wait for probing to settle.
 	 */
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	if (nd_region->ndr_mappings) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
@@ -343,8 +356,6 @@ static ssize_t set_cookie_show(struct device *dev,
 						nsindex));
 		}
 	}
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	if (rc)
 		return rc;
@@ -393,7 +404,6 @@ static ssize_t available_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	unsigned long long available = 0;
 
 	/*
 	 * Flush in-flight updates and grab a snapshot of the available
@@ -401,14 +411,11 @@ static ssize_t available_size_show(struct device *dev,
 	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
 	 * problem to not race itself.
 	 */
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
-	available = nd_region_available_dpa(nd_region);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
-	return sprintf(buf, "%llu\n", available);
+	return sprintf(buf, "%llu\n", nd_region_available_dpa(nd_region));
 }
 static DEVICE_ATTR_RO(available_size);
 
@@ -416,16 +423,12 @@ static ssize_t max_available_extent_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	unsigned long long available = 0;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
-	available = nd_region_allocatable_dpa(nd_region);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
-	return sprintf(buf, "%llu\n", available);
+	return sprintf(buf, "%llu\n", nd_region_allocatable_dpa(nd_region));
 }
 static DEVICE_ATTR_RO(max_available_extent);
 
@@ -433,16 +436,12 @@ static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region_data *ndrd = dev_get_drvdata(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
-	if (ndrd)
-		rc = sprintf(buf, "%d/%d\n", ndrd->ns_active, ndrd->ns_count);
-	else
-		rc = -ENXIO;
-	nvdimm_bus_unlock(dev);
+	guard(nvdimm_bus)(dev);
+	if (!ndrd)
+		return -ENXIO;
 
-	return rc;
+	return sprintf(buf, "%d/%d\n", ndrd->ns_active, ndrd->ns_count);
 }
 static DEVICE_ATTR_RO(init_namespaces);
 
@@ -450,15 +449,12 @@ static ssize_t namespace_seed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->ns_seed)
-		rc = sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
-	else
-		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
-	return rc;
+		return sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
+
+	return sprintf(buf, "\n");
 }
 static DEVICE_ATTR_RO(namespace_seed);
 
@@ -466,16 +462,12 @@ static ssize_t btt_seed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->btt_seed)
-		rc = sprintf(buf, "%s\n", dev_name(nd_region->btt_seed));
-	else
-		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
+		return sprintf(buf, "%s\n", dev_name(nd_region->btt_seed));
 
-	return rc;
+	return sprintf(buf, "\n");
 }
 static DEVICE_ATTR_RO(btt_seed);
 
@@ -483,16 +475,12 @@ static ssize_t pfn_seed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->pfn_seed)
-		rc = sprintf(buf, "%s\n", dev_name(nd_region->pfn_seed));
-	else
-		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
+		return sprintf(buf, "%s\n", dev_name(nd_region->pfn_seed));
 
-	return rc;
+	return sprintf(buf, "\n");
 }
 static DEVICE_ATTR_RO(pfn_seed);
 
@@ -500,16 +488,12 @@ static ssize_t dax_seed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
-	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->dax_seed)
-		rc = sprintf(buf, "%s\n", dev_name(nd_region->dax_seed));
-	else
-		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
+		return sprintf(buf, "%s\n", dev_name(nd_region->dax_seed));
 
-	return rc;
+	return sprintf(buf, "\n");
 }
 static DEVICE_ATTR_RO(dax_seed);
 
@@ -581,9 +565,8 @@ static ssize_t align_store(struct device *dev,
 	 * times ensure it does not change for the duration of the
 	 * allocation.
 	 */
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	nd_region->align = val;
-	nvdimm_bus_unlock(dev);
 
 	return len;
 }
@@ -890,7 +873,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
  */
 void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 {
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->ns_seed == dev) {
 		nd_region_create_ns_seed(nd_region);
 	} else if (is_nd_btt(dev)) {
@@ -915,7 +898,6 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 		if (nd_region->ns_seed == &nd_dax->nd_pfn.ndns->dev)
 			nd_region_create_ns_seed(nd_region);
 	}
-	nvdimm_bus_unlock(dev);
 }
 
 /**
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index a03e3c45f297..4adce8c38870 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -219,12 +219,9 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 int nvdimm_security_unlock(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	int rc;
 
-	nvdimm_bus_lock(dev);
-	rc = __nvdimm_security_unlock(nvdimm);
-	nvdimm_bus_unlock(dev);
-	return rc;
+	guard(nvdimm_bus)(dev);
+	return __nvdimm_security_unlock(nvdimm);
 }
 
 static int check_security_state(struct nvdimm *nvdimm)
@@ -490,9 +487,8 @@ void nvdimm_security_overwrite_query(struct work_struct *work)
 	struct nvdimm *nvdimm =
 		container_of(work, typeof(*nvdimm), dwork.work);
 
-	nvdimm_bus_lock(&nvdimm->dev);
+	guard(nvdimm_bus)(&nvdimm->dev);
 	__nvdimm_security_overwrite_query(nvdimm);
-	nvdimm_bus_unlock(&nvdimm->dev);
 }
 
 #define OPS							\
-- 
2.51.0

