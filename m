Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90011341065
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434670; cv=none; b=B2AZqND8EHmxY27INKG9oNo4jd5DkS1FjSIzASiV3bLv9tSTTgLYKoQXTtcCPnAqsK7YLxH7MUoEe2cIOJ7ihLJSqYUhJEbOIBvipi2i/Oux6xqqZL1pcU+dwrLv8EXstpuKW5v0/Ao1Q3LSa6O/la4UCbjqh3iUp3JBxvExDo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434670; c=relaxed/simple;
	bh=2HJXstFWbA8JKzmFLrV4EYZca67gOgm6jsl+V+jc43U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGoIpJ8w596DUPcw2M4GisUHkM/hyLO/bJyhdegmqCdcXKm58+ylBW83vzG+gEOYEmmlEHd1+5Tc3UWXQvzYat/htlLkl216wpO9y9uPUBo8M44Cg0C62cFFyIMvEVce66qen+Z4OP8BF4njXh1dwwtHxmFNn8VASQh684FNnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=UGrbKMft; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="UGrbKMft"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a2b99d8c5so2319636d6.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434666; x=1769039466; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HO1V54BeeL6soGWklBzHc2sknfCRHcpjkYKQEUfGCuc=;
        b=UGrbKMftZMHNnIA9LfrbqaAsDr2a1h5aougs89ztxqqIIQnpU0Iy1RUZD5DbHvzIrC
         GDiOcijjk0THsZqyUtxW5FhHMM9Phl+4gBN8q8yOqtaGPXi1FhRmCX1FJVkXk+iuSiAK
         au+IYMl9ntUr1nG9Y7lc+FI9sNe0d6P1uZ5p63CFcwT/v0J+fT6EyXSKuAlZG3gF4GCI
         wyeJOFevMC8GrcdVv0805ikGxnFJ9Qc4oKp9hGCmkd92/wZ4GN4z5Iq8ANU3+4kM+aEH
         fqEccD1nNYcYPRZ8FMQg/1mrf3QJcaLg17JkbhYhKiI/aMCXo+BgaN5j8MY4g1KlT1F/
         fo/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434666; x=1769039466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HO1V54BeeL6soGWklBzHc2sknfCRHcpjkYKQEUfGCuc=;
        b=B5VSXlpP8XMVxuEA/dPih1I8mnqVDOgdNjYcyNopQN6P0SoixgXEzycAgE27q0HBJP
         pMk/JhJ2R/XHmT/eA19AOMS8JLBYU56ddbW1ZWjXwgzo3Uh0pcFAB/pM3otUgi+oHDxn
         ZlfwXf510y0Dnl4u1MuW8Q+RLRdgGwBXbXHUOg0QSlDtYmbgDQGWguNSDRYaNUJKC35Z
         RLxOg4jnHN74QjAjYbgx/QMrZ/lQmW5R+2lcnPGlizh4DLDKuo8Xup3vPJ/La2AIh0+u
         6O8EJps1bDvfuFFjrjajon2WJk11Fq3HCSS0c+ayQ368N9MmphGGzp1iT7b9C9JXDNuX
         grsw==
X-Forwarded-Encrypted: i=1; AJvYcCVNrdD77wgVGwuWsyfw38STKU2fRylhw+IdjrhNITv9MXn7orT+7rZ12j02QDSc5Z8nf+uU6j8=@lists.linux.dev
X-Gm-Message-State: AOJu0YypEqsCGFm3f5uGQ8W7rv9Tl/okKuQOOicLphdoZJLemKyjV853
	A494fw1D4Jhegbur986XuLE0qQqhq69J8onkLiJAqicFsUcdVjaFseDqNRQiZUBaJ9M=
X-Gm-Gg: AY/fxX7O3qHmzYnup0tgWq+fpdBgsH8ke8YV6AqkbmTpxxRn8P99afkZyBNon+TF/ZN
	rY0cD4ryEoMoiEmsaUOaA2n+ov+sbZC3SlglqlbkDJld47zvk/O/5qrelJyXH6a9m7gUw06BhJi
	/cu24vp8O97FSp1KxC8PmPMYbCXGQkMISzmvt5SjDEodHUMqOP0H91oYDFYFSpsTxSJuf1vm03i
	N/s3Mphh6ktffxMzCwwxyHxhKoW6PRIFocNSpZ8HCIX1sR7o9B3hH1sXCcnO/MwEpToys5XluB8
	NeGOFPt8xzaRnzSB5UKj9+bFGHFf7k1r5afNndA9O6SclXQOjjdmWERz/fBfqhjt06BaVmgnKNu
	dYhrHbk2rE+ed7npTlVsXbGfnl2haF8JXcFpvBtcLXg/I7ry4oBu/prfCfEk4varLkx4IknV0r+
	UYyJF/3ZhwrsEHxVa2MEF+zUJ/IZBZuNZTJcEvtCaLUe6+FTdj7g9jeSTEVDPyjdBpIU/rJPMZF
	Go=
X-Received: by 2002:ad4:5aa4:0:b0:880:48e4:198a with SMTP id 6a1803df08f44-89275c0aef3mr46108836d6.32.1768434666420;
        Wed, 14 Jan 2026 15:51:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:05 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 4/5] dax/kmem: add sysfs interface for runtime hotplug state control
Date: Wed, 14 Jan 2026 18:50:20 -0500
Message-ID: <20260114235022.3437787-5-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

There is no atomic to offline and remove memory blocks together.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the entire memory region state.

The interface supports the following states:
  - "unplug": memory is offline and blocks are not present
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged -> online
  - unplugged -> online_movable
  - online    -> unplugged
  - online_movable -> unplugged

"offline" (memory blocks exist but are offline by default) is not
supported because it's functionally equivalent to "unplugged" and
entices races between offlining and unplugging.

The initial state after probe uses mhp_get_default_online_type() to
preserve backwards compatibility - existing systems with auto-online
policies will continue to work as before.

As with any hot-remove mechanism, the removal can fail and if rollback
fails the system can be left in an inconsistent state.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED.

  The resources are still leaked but this prevents deadlock on unbind
  if a memory region happens to be impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  17 +++
 drivers/dax/kmem.c                      | 159 +++++++++++++++++++++---
 2 files changed, 156 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..faf6f63a368c 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,20 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/hotplug
+Date:		January, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls what hotplug state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+                States: [unplugged, online, online_movable]
+                Arguments:
+		  "unplug": memory is offline and blocks are not present
+		  "online": memory is online as normal system RAM
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		Devices must unplug to online into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 3929cb8576de..c222ae9d675d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -44,9 +44,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -69,8 +75,10 @@ static void kmem_put_memory_types(void)
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -82,6 +90,12 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 	int i, rc, onlined = 0;
 	mhp_t mhp_flags;
 
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	if (online_type != MMOP_ONLINE && online_type != MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -174,9 +188,9 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes all ranges in the dev_dax region.
  *
- * Returns the number of successfully removed ranges.
+ * Returns the number of successfully removed ranges, or negative error.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
@@ -196,7 +210,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			success++;
 			continue;
@@ -228,6 +242,21 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
+	 *
+	 * This WARN used to be a BUG called by remove_memory().
+	 *
+	 * Note: This leaks the resources.
+	 */
+	if (data->state != DAX_KMEM_UNPLUGGED) {
+		WARN(data->state != DAX_KMEM_UNPLUGGED,
+		     "Hotplug memory regions stuck online until reboot");
+		return;
+	}
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		if (!data->res[i])
 			continue;
@@ -237,6 +266,91 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
+	if (sysfs_streq(buf, "online_movable"))
+		return MMOP_ONLINE_MOVABLE;
+	return -EINVAL;
+}
+
+static ssize_t hotplug_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	switch (data->state) {
+	case DAX_KMEM_UNPLUGGED:
+		state_str = "unplugged";
+		break;
+	case MMOP_ONLINE:
+		state_str = "online";
+		break;
+	case MMOP_ONLINE_MOVABLE:
+		state_str = "online_movable";
+		break;
+	default:
+		state_str = "unknown";
+		break;
+	}
+
+	return sysfs_emit(buf, "%s\n", state_str);
+}
+
+static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int online_type;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	online_type = dax_kmem_parse_state(buf);
+	if (online_type < DAX_KMEM_UNPLUGGED)
+		return online_type;
+
+	guard(mutex)(&data->lock);
+
+	/* Already in requested state */
+	if (data->state == online_type)
+		return len;
+
+	if (online_type == DAX_KMEM_UNPLUGGED) {
+		rc = dax_kmem_do_hotremove(dev_dax, data);
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/*
+	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+	 * Cannot switch between online types without unplugging first
+	 */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
+
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(hotplug);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -246,6 +360,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	int i, rc;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int online_type;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -304,6 +419,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -315,9 +434,17 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	 * Hotplug using the system default policy - this preserves backwards
 	 * for existing users who rely on the default auto-online behavior.
 	 */
-	rc = dax_kmem_do_hotplug(dev_dax, data, mhp_get_default_online_type());
-	if (rc < 0)
-		goto err_hotplug;
+	online_type = mhp_get_default_online_type();
+	if (online_type != MMOP_OFFLINE) {
+		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+		if (rc < 0)
+			goto err_hotplug;
+		data->state = online_type;
+	}
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -338,23 +465,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
-	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
-	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
-		return;
-	}
-
+	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
@@ -372,6 +487,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
-- 
2.52.0

