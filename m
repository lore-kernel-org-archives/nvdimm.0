Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99ED279DC9
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 21:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758575638; cv=none; b=rRnmRkrHA7EJCNcmcQrQLDQpQCS7l6nteGiALIy0cqhsC5P9G7R5lgBkzT4ZJOsgOCmdQqSyoGGBlzSdsmoYYJiUb0oc44kxP1E10N5USCAEI/c5J1xgrNMPIg7UaNH88jVtpbm16wcfP09juWDd/qVp+L7l1semRmlusVUELts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758575638; c=relaxed/simple;
	bh=kDCAlxUmybzIoyhLIhzm+s2bKJVchUd6ZbrnSWAYuk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lqip04ZlghB80vID7uke9760PeIhVKubY98E6wK7hSuNj2tcXiqxsqW1bBPUHwMG9UG/Xax55D6Ubbz5NgLdB4a0RmMzcuLBQtcEp1Hl+w8xlTJxixAm8zrw8W0Yv6JheM4Ci9gTWLbXPFkADsy1iDCC3WtiQ2smKTocbJU0MJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD41C4CEF0;
	Mon, 22 Sep 2025 21:13:58 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev
Cc: ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	jonathan.cameron@huawei.com,
	s.neeraj@samsung.com
Subject: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
Date: Mon, 22 Sep 2025 14:13:30 -0700
Message-ID: <20250922211330.1433044-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
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
Ira, up to you if you want to take this cleanup.
---
 drivers/nvdimm/badrange.c       |  3 +-
 drivers/nvdimm/btt_devs.c       | 20 +++-----
 drivers/nvdimm/bus.c            | 17 +++----
 drivers/nvdimm/claim.c          |  5 +-
 drivers/nvdimm/core.c           | 17 ++++---
 drivers/nvdimm/dax_devs.c       |  8 ++--
 drivers/nvdimm/dimm.c           | 17 ++++---
 drivers/nvdimm/dimm_devs.c      | 43 ++++++++---------
 drivers/nvdimm/namespace_devs.c | 81 +++++++++++++++------------------
 drivers/nvdimm/nd.h             |  2 +
 drivers/nvdimm/pfn_devs.c       | 29 +++++-------
 drivers/nvdimm/region.c         | 14 +++---
 drivers/nvdimm/region_devs.c    | 72 ++++++++++++++---------------
 drivers/nvdimm/security.c       |  6 +--
 14 files changed, 149 insertions(+), 185 deletions(-)

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
index 497fd434a6a1..b35bcbe5db7f 100644
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
@@ -95,10 +93,9 @@ static ssize_t namespace_show(struct device *dev,
 	struct nd_btt *nd_btt = to_nd_btt(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	rc = sprintf(buf, "%s\n", nd_btt->ndns
 			? dev_name(&nd_btt->ndns->dev) : "");
-	nvdimm_bus_unlock(dev);
 	return rc;
 }
 
@@ -108,13 +105,11 @@ static ssize_t namespace_store(struct device *dev,
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
@@ -351,9 +346,8 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
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
index 0ccf4a9e523a..d2c2d71e7fe0 100644
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
@@ -1177,15 +1175,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		goto out;
 	}
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
 	if (rc)
-		goto out_unlock;
+		goto out;
 
 	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
 	if (rc < 0)
-		goto out_unlock;
+		goto out;
 
 	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
 		struct nd_cmd_clear_error *clear_err = buf;
@@ -1197,9 +1195,6 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
 
-out_unlock:
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 out:
 	kfree(in_env);
 	kfree(out_env);
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 51614651d2e7..e53a2cc04695 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -35,9 +35,8 @@ void nd_detach_ndns(struct device *dev,
 	if (!ndns)
 		return;
 	get_device(&ndns->dev);
-	nvdimm_bus_lock(&ndns->dev);
-	__nd_detach_ndns(dev, _ndns);
-	nvdimm_bus_unlock(&ndns->dev);
+	scoped_guard(nvdimm_bus, &ndns->dev)
+		__nd_detach_ndns(dev, _ndns);
 	put_device(&ndns->dev);
 }
 
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
index 37b743acbb7b..a5d44b5c9452 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -104,10 +104,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 		return -ENODEV;
 	}
 
-	nvdimm_bus_lock(&ndns->dev);
-	nd_dax = nd_dax_alloc(nd_region);
-	dax_dev = nd_dax_devinit(nd_dax, ndns);
-	nvdimm_bus_unlock(&ndns->dev);
+	scoped_guard(nvdimm_bus, &ndns->dev) {
+		nd_dax = nd_dax_alloc(nd_region);
+		dax_dev = nd_dax_devinit(nd_dax, ndns);
+	}
 	if (!dax_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 91d9163ee303..2018458a3dba 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -95,13 +95,13 @@ static int nvdimm_probe(struct device *dev)
 
 	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
 
-	nvdimm_bus_lock(dev);
-	if (ndd->ns_current >= 0) {
-		rc = nd_label_reserve_dpa(ndd);
-		if (rc == 0)
-			nvdimm_set_labeling(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		if (ndd->ns_current >= 0) {
+			rc = nd_label_reserve_dpa(ndd);
+			if (rc == 0)
+				nvdimm_set_labeling(dev);
+		}
 	}
-	nvdimm_bus_unlock(dev);
 
 	if (rc)
 		goto err;
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
index 21498d461fde..4b293c4ad15c 100644
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
@@ -326,7 +326,7 @@ static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 		return -ENXIO;
 
 	dev = ndd->dev;
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	nfree = nd_label_nfree(ndd);
 	if (nfree - 1 > nfree) {
 		dev_WARN_ONCE(dev, 1, "we ate our last label?\n");
@@ -334,7 +334,6 @@ static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 	} else
 		nfree--;
 	rc = sprintf(buf, "%d\n", nfree);
-	nvdimm_bus_unlock(dev);
 	return rc;
 }
 
@@ -395,12 +394,10 @@ static ssize_t security_store(struct device *dev,
 	 * done while probing is idle and the DIMM is not in active use
 	 * in any region.
 	 */
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	rc = nvdimm_security_store(dev, buf, len);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc;
 }
@@ -454,9 +451,8 @@ static ssize_t result_show(struct device *dev, struct device_attribute *attr, ch
 	if (!nvdimm->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
-	result = nvdimm->fw_ops->activate_result(nvdimm);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev)
+		result = nvdimm->fw_ops->activate_result(nvdimm);
 
 	switch (result) {
 	case NVDIMM_FWA_RESULT_NONE:
@@ -483,9 +479,8 @@ static ssize_t activate_show(struct device *dev, struct device_attribute *attr,
 	if (!nvdimm->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
-	state = nvdimm->fw_ops->activate_state(nvdimm);
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev)
+		state = nvdimm->fw_ops->activate_state(nvdimm);
 
 	switch (state) {
 	case NVDIMM_FWA_IDLE:
@@ -516,9 +511,8 @@ static ssize_t activate_store(struct device *dev, struct device_attribute *attr,
 	else
 		return -EINVAL;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nvdimm->fw_ops->arm(nvdimm, arg);
-	nvdimm_bus_unlock(dev);
 
 	if (rc < 0)
 		return rc;
@@ -545,9 +539,8 @@ static umode_t nvdimm_firmware_visible(struct kobject *kobj, struct attribute *a
 	if (!nvdimm->fw_ops)
 		return 0;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return 0;
@@ -641,11 +634,11 @@ void nvdimm_delete(struct nvdimm *nvdimm)
 	bool dev_put = false;
 
 	/* We are shutting down. Make state frozen artificially. */
-	nvdimm_bus_lock(dev);
-	set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
-	if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
-		dev_put = true;
-	nvdimm_bus_unlock(dev);
+	scoped_guard(nvdimm_bus, dev) {
+		set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
+		if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
+			dev_put = true;
+	}
 	cancel_delayed_work_sync(&nvdimm->dwork);
 	if (dev_put)
 		put_device(dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..38933abfb2a6 100644
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
 
@@ -893,9 +888,8 @@ resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns)
 {
 	resource_size_t size;
 
-	nvdimm_bus_lock(&ndns->dev);
+	guard(nvdimm_bus)(&ndns->dev);
 	size = __nvdimm_namespace_capacity(ndns);
-	nvdimm_bus_unlock(&ndns->dev);
 
 	return size;
 }
@@ -1044,8 +1038,8 @@ static ssize_t uuid_store(struct device *dev,
 	} else
 		return -ENXIO;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	if (to_ndns(dev)->claim)
 		rc = -EBUSY;
@@ -1059,8 +1053,6 @@ static ssize_t uuid_store(struct device *dev,
 		kfree(uuid);
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc < 0 ? rc : len;
 }
@@ -1119,8 +1111,8 @@ static ssize_t sector_size_store(struct device *dev,
 	} else
 		return -ENXIO;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	if (to_ndns(dev)->claim)
 		rc = -EBUSY;
 	if (rc >= 0)
@@ -1129,8 +1121,6 @@ static ssize_t sector_size_store(struct device *dev,
 		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "result: %zd %s: %s%s", rc, rc < 0 ? "tried" : "wrote",
 			buf, buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc ? rc : len;
 }
@@ -1145,7 +1135,7 @@ static ssize_t dpa_extents_show(struct device *dev,
 	int count = 0, i;
 	u32 flags = 0;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
@@ -1167,8 +1157,6 @@ static ssize_t dpa_extents_show(struct device *dev,
 				count++;
 	}
  out:
-	nvdimm_bus_unlock(dev);
-
 	return sprintf(buf, "%d\n", count);
 }
 static DEVICE_ATTR_RO(dpa_extents);
@@ -1279,15 +1267,13 @@ static ssize_t holder_class_store(struct device *dev,
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
@@ -2152,31 +2138,38 @@ static int init_active_labels(struct nd_region *nd_region)
 					nd_region);
 }
 
+static int __create_namespaces(struct nd_region *nd_region, int *type,
+			       struct device ***devs)
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
+	rc = __create_namespaces(nd_region, &type, &devs);
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
index cc5c8f3f81e8..a8013033509c 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,6 +632,8 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
+DEFINE_GUARD(nvdimm_bus, struct device *, nvdimm_bus_lock(_T), nvdimm_bus_unlock(_T));
+
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8f3e816e805d..f2a44d1f62be 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -57,8 +57,8 @@ static ssize_t mode_store(struct device *dev,
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc = 0;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	if (dev->driver)
 		rc = -EBUSY;
 	else {
@@ -78,8 +78,6 @@ static ssize_t mode_store(struct device *dev,
 	}
 	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
 			buf[len - 1] == '\n' ? "" : "\n");
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return rc ? rc : len;
 }
@@ -125,14 +123,12 @@ static ssize_t align_store(struct device *dev,
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
@@ -170,10 +166,9 @@ static ssize_t namespace_show(struct device *dev,
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	rc = sprintf(buf, "%s\n", nd_pfn->ndns
 			? dev_name(&nd_pfn->ndns->dev) : "");
-	nvdimm_bus_unlock(dev);
 	return rc;
 }
 
@@ -183,13 +178,11 @@ static ssize_t namespace_store(struct device *dev,
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
@@ -639,10 +632,10 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
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
index de1ee5ebc851..b2b4519e9f4c 100644
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
@@ -401,12 +412,10 @@ static ssize_t available_size_show(struct device *dev,
 	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
 	 * problem to not race itself.
 	 */
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	available = nd_region_available_dpa(nd_region);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", available);
 }
@@ -418,12 +427,10 @@ static ssize_t max_available_extent_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	unsigned long long available = 0;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	wait_nvdimm_bus_probe_idle(dev);
 	available = nd_region_allocatable_dpa(nd_region);
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
 
 	return sprintf(buf, "%llu\n", available);
 }
@@ -435,12 +442,11 @@ static ssize_t init_namespaces_show(struct device *dev,
 	struct nd_region_data *ndrd = dev_get_drvdata(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (ndrd)
 		rc = sprintf(buf, "%d/%d\n", ndrd->ns_active, ndrd->ns_count);
 	else
 		rc = -ENXIO;
-	nvdimm_bus_unlock(dev);
 
 	return rc;
 }
@@ -452,12 +458,11 @@ static ssize_t namespace_seed_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->ns_seed)
 		rc = sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
 	else
 		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
 	return rc;
 }
 static DEVICE_ATTR_RO(namespace_seed);
@@ -468,12 +473,11 @@ static ssize_t btt_seed_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->btt_seed)
 		rc = sprintf(buf, "%s\n", dev_name(nd_region->btt_seed));
 	else
 		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
 
 	return rc;
 }
@@ -485,12 +489,11 @@ static ssize_t pfn_seed_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->pfn_seed)
 		rc = sprintf(buf, "%s\n", dev_name(nd_region->pfn_seed));
 	else
 		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
 
 	return rc;
 }
@@ -502,12 +505,11 @@ static ssize_t dax_seed_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	ssize_t rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->dax_seed)
 		rc = sprintf(buf, "%s\n", dev_name(nd_region->dax_seed));
 	else
 		rc = sprintf(buf, "\n");
-	nvdimm_bus_unlock(dev);
 
 	return rc;
 }
@@ -581,9 +583,8 @@ static ssize_t align_store(struct device *dev,
 	 * times ensure it does not change for the duration of the
 	 * allocation.
 	 */
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	nd_region->align = val;
-	nvdimm_bus_unlock(dev);
 
 	return len;
 }
@@ -890,7 +891,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
  */
 void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 {
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	if (nd_region->ns_seed == dev) {
 		nd_region_create_ns_seed(nd_region);
 	} else if (is_nd_btt(dev)) {
@@ -915,7 +916,6 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 		if (nd_region->ns_seed == &nd_dax->nd_pfn.ndns->dev)
 			nd_region_create_ns_seed(nd_region);
 	}
-	nvdimm_bus_unlock(dev);
 }
 
 /**
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index a03e3c45f297..e70dc3b08458 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -221,9 +221,8 @@ int nvdimm_security_unlock(struct device *dev)
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	int rc;
 
-	nvdimm_bus_lock(dev);
+	guard(nvdimm_bus)(dev);
 	rc = __nvdimm_security_unlock(nvdimm);
-	nvdimm_bus_unlock(dev);
 	return rc;
 }
 
@@ -490,9 +489,8 @@ void nvdimm_security_overwrite_query(struct work_struct *work)
 	struct nvdimm *nvdimm =
 		container_of(work, typeof(*nvdimm), dwork.work);
 
-	nvdimm_bus_lock(&nvdimm->dev);
+	guard(nvdimm_bus)(&nvdimm->dev);
 	__nvdimm_security_overwrite_query(nvdimm);
-	nvdimm_bus_unlock(&nvdimm->dev);
 }
 
 #define OPS							\

base-commit: 07e27ad16399afcd693be20211b0dfae63e0615f
-- 
2.51.0

