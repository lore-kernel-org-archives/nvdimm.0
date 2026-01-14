Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079E3318EE4
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380774; cv=none; b=Y4r0zQhy6SgW8oW9R0QOZL6Ud9b6y1fklqLZdpLzdqx60odHsl4VD3Er07sOg+4ir9mApFlGvG9U9uJQ+wxnIU9u5MtqrHIDRx6m17wka0voyjm0rFUq9Qc6X8I9zSpJCaErd7wxX8w8flAp3RuJt+55tqxnsP4R2/0VcXx+86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380774; c=relaxed/simple;
	bh=FsQUnYFZ1fQiA+aZch6G+g+4CkoxB/nrp/owVOXh0ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RK5/waZhQZW9qQLGwu49z6r4n2ahZwnuh486+2YQvSSfyXYJpXNxhJ9rHgvabfAUW+RzMHUK5kpezvTo/R+gODjnqSXjHrGk6474xwSKb1DhRvBz1j5aYbdzMQMh0KOPu++Zhi6CoitTpnXv8zed+jhzS+t/vRgiGiyOdYYVXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=uvJWKkoy; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="uvJWKkoy"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50146fcf927so5863951cf.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380766; x=1768985566; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGjo3d8od0EJeDwSRFttWxrOsN7h7xRi4Y20WwxuEh0=;
        b=uvJWKkoykRuyhy+uGubA/1VWB79Et/iERJrkVnoFZKGnwOOh8rnxQZcmtcV1SIMPnp
         QuUiIPWhsA1aERnwXvj/QckZVhb9ECXgHe5NDhqDYw7GmHJknuVZta0u9TczMMzGWCLv
         fjbpDnqwKMGqS1YTmSl1ldZBD7V7gScFow2nRMUJvz+1uoePxcggKicvMqnazQclXdam
         Cg8Lvha/6OHJnAgHZ2FApk1ZyRLAVtQ/dHB/slJlBW6U37BJksjv5QCUV7evdCkgeJ+g
         VYUeb6bLiN91SdLOjqvgWM4Xf4f8P/chxEU5C5ogcsH2f9Gc804tGqbt1eN6awyTCGfB
         g/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380766; x=1768985566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aGjo3d8od0EJeDwSRFttWxrOsN7h7xRi4Y20WwxuEh0=;
        b=OBUdFji8I6PnQbbDHQjFEmcs5hvxQ99Yrf22WpUo5Ap0m9xfc/KeVDrxG2ILeiBSNc
         qITx/BvQwI06G3PxzQEQWR6T4qEHmIaz4W2MNP/ms7G/5YZrNKU/maZg1EjR4U4/Rdw4
         K3p5fxVGGnA3r8Q9AF5ad5r0rz9Z375bur7VOxUaV80LXp5ERJY7QdF2iI7IWGMdyZm5
         XEKSz1L6Ohu8oLNRHkP/vi/gbLHorm28tXJHH3g8ZToDt4cTkUEaDsAWsKOgKO+M8d5I
         W8ECp8yH2OBPQNPIXwYhgm+75pNF9PGz1mjF1dJ9OY/vBWtQaV10DGlfT/Uz1DG4uIMG
         5Y5w==
X-Forwarded-Encrypted: i=1; AJvYcCWmxOVFOKALS02Xlu85LWdEBh58rETzW4d59L5trZvucCgJR0JZlcPJHM0Yc0gPvsbQ27pHtPY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwWf0faZ+PJ0bdaFm0yJM3DoeCw0KOjfGdWz5jq25ohAVpx5m5
	paeiAV5fgkO+5Gb/iklTJgTyQRfCjC9ZW1JeoJa53cx+Gwj3lvbodGzJvTad60lL+vM=
X-Gm-Gg: AY/fxX7cDWWaB9u09wx6nBi3DsPBYL+RN2fVuUW6jNU/31CbkUAnrGxV5M834LUu+ux
	DJIZQrShM+ggumhtQu2IyXMSUvYCzt4x0kwP02In9GdTEAvCUs4ECYsiJPgw51xU1UQw4O1zEN5
	p6sv1TNtHlAgWcESlCWw97mUBQrKKqaLVXMcELLlApFxqPa9l/QnP4ZHBzFw2gU+AmKGL6BOFkg
	OnqueaBryey0jZ5nMmzFiMPCxMHPtRDaXhl+xTYsKNXpjf5/Vr/1zNaXW2uSXYhuRx6xyRd6eGE
	zjbu/9hQq08qLqH6Xq0xHNJVIijkl5X9cuibVfs+gyw5ceSYVKmwm/i+QyDBZW1ZQCX1hcK1k0H
	YqJ8ImgjWsgEpNiUVtAu5DDmjU38z0lkTjvFJ/Atszo/L6MGCoYZ99iCVI7jcOHp2g3K1HqFuZu
	qbLvFXPmQ7E981AZqyw5Oy6iSvvY1FWlIE46CSh6M1PwJaVUwPrGgQxqV4Lq3VdKy673gooOOER
	kM=
X-Received: by 2002:a05:622a:4087:b0:4ff:b0e0:7b66 with SMTP id d75a77b69052e-501487decb6mr24730871cf.21.1768380766023;
        Wed, 14 Jan 2026 00:52:46 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:45 -0800 (PST)
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
	akpm@linux-foundation.org
Subject: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug state control
Date: Wed, 14 Jan 2026 03:51:59 -0500
Message-ID: <20260114085201.3222597-8-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the memory state at runtime. Users cannot change
the online type after probe, and there's no atomic way to offline and
remove memory blocks together.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the memory state. The interface supports the following states:

  - "offline": memory is added but not online
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE
  - "unplug": memory is offlined and removed

The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
backwards compatibility - existing systems with auto-online policies
will continue to work as before.

The state machine enforces valid transitions:
  - From offline: can transition to online, online_movable, or unplug
  - From online/online_movable: can transition to offline or unplug
  - Cannot switch directly between online and online_movable

Implementation changes:
  - Add state tracking to struct dax_kmem_data
  - Extend dax_kmem_do_hotplug() to accept online_type parameter
  - Use add_memory_driver_managed() with explicit online_type parameter
  - Use MMOP_SYSTEM_DEFAULT at probe for backwards compatibility
  - Use offline_and_remove_memory() for atomic offline+remove
  - Add stub for dax_kmem_do_hotremove() when !CONFIG_MEMORY_HOTREMOVE

This enables userspace memory managers to implement sophisticated
policies such as changing CXL memory zone type based on workload
characteristics, or atomically unplugging memory without races against
auto-online policies.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c  | 167 +++++++++++++++++++++++++++++++++++++++++---
 mm/memory_hotplug.c |   1 +
 2 files changed, 158 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 30429f2d5a67..6d73c44e4e08 100644
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
 
@@ -69,13 +75,15 @@ static void kmem_put_memory_types(void)
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_OFFLINE, MMOP_ONLINE, or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
 static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
-			       struct dax_kmem_data *data)
+			       struct dax_kmem_data *data, int online_type)
 {
 	struct device *dev = &dev_dax->dev;
 	int i, rc, mapped = 0;
@@ -124,10 +132,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		/*
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
+		 *
+		 * Use add_memory_driver_managed() with explicit online_type
+		 * to control the online state and avoid surprises from
+		 * system auto-online policy.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
 					       range_len(&range), kmem_name,
-					       mhp_flags, MMOP_SYSTEM_DEFAULT);
+					       mhp_flags, online_type);
 
 		if (rc < 0) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
@@ -151,14 +163,13 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
 {
-	struct device *dev = &dev_dax->dev;
 	int i, success = 0;
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
@@ -173,7 +184,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
 			kfree(data->res[i]);
@@ -182,12 +193,19 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 			continue;
 		}
 		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx offline failed\n",
+		dev_err(&dev_dax->dev,
+			"mapping%d: %#llx-%#llx offline and remove failed\n",
 			i, range.start, range.end);
 	}
 
 	return success;
 }
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 /**
@@ -288,11 +306,117 @@ static int dax_kmem_do_offline(struct dev_dax *dev_dax,
 			continue;
 
 		/* Best effort rollback - ignore failures */
-		online_memory_range(range.start, range_len(&range), MMOP_ONLINE);
+		online_memory_range(range.start, range_len(&range), data->state);
 	}
 	return rc;
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "offline"))
+		return MMOP_OFFLINE;
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
+	case MMOP_OFFLINE:
+		state_str = "offline";
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
+	if (online_type == MMOP_OFFLINE) {
+		/* Can only offline from an online state */
+		if (data->state != MMOP_ONLINE && data->state != MMOP_ONLINE_MOVABLE)
+			return -EINVAL;
+		rc = dax_kmem_do_offline(dev_dax, data);
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		data->state = MMOP_OFFLINE;
+		return len;
+	}
+
+	/* online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE */
+
+	/* Cannot switch between online types without offlining first */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
+
+	if (data->state == MMOP_OFFLINE)
+		rc = dax_kmem_do_online(dev_dax, data, online_type);
+	else
+		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+
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
@@ -360,12 +484,29 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
-	rc = dax_kmem_do_hotplug(dev_dax, data);
+	/*
+	 * Hotplug the memory using the system default online policy.
+	 * This preserves backwards compatibility for existing users who
+	 * rely on auto-online behavior.
+	 */
+	rc = dax_kmem_do_hotplug(dev_dax, data, MMOP_SYSTEM_DEFAULT);
 	if (rc < 0)
 		goto err_hotplug;
+	/*
+	 * dax_kmem_do_hotplug returns the count of mapped ranges on success.
+	 * Query the system default to determine the actual memory state.
+	 */
+	data->state = mhp_get_default_online_type();
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -389,6 +530,8 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
 	 * offline prior to calling this function remove_memory() will fail, and
@@ -417,6 +560,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 41974a1ccb91..3adc05d2df52 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ int mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(int online_type)
 {
-- 
2.52.0

