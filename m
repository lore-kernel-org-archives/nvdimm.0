Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821F937F8D2
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380774; cv=none; b=llVYRuTbLBPvh85940g2tJj5Wpgwm8gdDLUrKD4H8Vyj3hNJfwIufvrvAZ2SlP4VTLOgodbWZKsOasIPvNYIB+BTVOMPBkeuDgd9doCf8+3mebOCw0mmtn/7HLiYOOTTazsbvl1eIVmSjtmiTd9tBe3iiNI+4sMXDj38lReYBDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380774; c=relaxed/simple;
	bh=J918bJZtOV4I5js6nJXyAUGdt4ECz0JfHm1xc2oVlZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaYNjDzCV7wHalZ72dZDjo3R8vxt7jaXdHzOBraL/Xee2SRcsycp27kkbFg2UKYc9cXDarmyprhP9RrPgxCH/P26XAfh8K5uQ+Df+o0LRopLVyMDYyyS6d9yDaEW17HM44XQRll+JYJuVKyaZynKjpVN02xKGh9kS/aDopm34ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=bNRk1mos; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="bNRk1mos"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014e8a42aeso1235291cf.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380760; x=1768985560; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3pYyw670e7Ltu41laZTVJfsj8n3YRVUYoWc2KV2zc8=;
        b=bNRk1mosv5IZP0Uuqe0MP6MquvNViKJHBmZq31XDg3WrIDaDh6mN2V5I0BpWp5Xb4W
         gszPEMhQk6umSrB1xeqcLn2dU313ZNBaHgTDbDSkMiPpPXWxVS2D5GRuoIU8l3/C4AJy
         43OkBOzODNXzmvnWSjJVVjzZfUmQQNZkaGI4ltRHmzQqxu/n5wLmzjWd4IKPVzryakN2
         RZDbUih+gXsQtTKkdLxaPnIGqceXcTszVf15QaPV4cS4W/ocgm96ZTbyf242XrWYX49x
         69H9p2YRdHvAjKP8luxFJD7Nfl7w0YgqpPs0gOgVhbl0APWvfHxURGgMscGFWS3URxw+
         320w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380760; x=1768985560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v3pYyw670e7Ltu41laZTVJfsj8n3YRVUYoWc2KV2zc8=;
        b=mGBoZsmxTrbpMtKadXPGN5Fk8FM7QQdQRgTW3eM4tY/adYNEEe8KzoBT0p2X7YLjYk
         Ue7C8n/ErA9I4E2rHhOnm6FwgGIq+1pO2fBUPyjrQKkLLPmO/v8t4Yo1q4M6wf6KkCC6
         MSCM5OhONbOoM6HaVk7DF/S0sbKj8MH8GBLOXuPfcMY11dPmut+oAf5mdev3IvodnVWW
         LlJPMqzFJHWekKf+L0Q6xn/yp9LBEdvaPc2DEpkZQL2vrYoxvza7v+11wZC8HmSiaBs2
         x66mXU6y8jAiq9triePblREOuzvhB/ba0LyBHQzf7y/DwFX/DvAE+f8kNh76WW9LZbFC
         VhhQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4Bhhtsd7NhhqlMcGmEj3VUS7VWdz5I74NiS20ii+xWtyHcQ064QjnUtY+mUEkBjQGT+VPAiw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW0j2orkzmokoI/m5FyWTh5Jn8hlGFvnxn3WL4sJtlQjKxKw9z
	+vOCPTCQ1ls90Kc7QwEzjOA8xGsi9wss65pwngbjYWvrXcF3iXGIScFUi6pKEmBO/gA=
X-Gm-Gg: AY/fxX469HuTMWkwUy8dh7yLV1QjMjwBEQpmN/+cutJOyq0Iw88jPfe4chjDeFdgYpH
	70DeI9tqV485s/xu/+4MQYjRm4kiNQId3/ooKowjE/69+S09AhQCnyjq6p+OEB7pnyTAQ8sJlSr
	IUdvsN7Gg4dq2Iquv9jslcxnNvR1NNozgTxlO1Sznxg2x7U7QT/kdLSZ1tOgD+sQ2JvbCUUc3tV
	+t71A6/vmmBE6qtJjY2lUVUZTJ6plG9C7iRtq7sJxNiMVe0V9UXCYWsUMOfUIC3cvsFvx9cH4O3
	6recykXRWc5cef5aIocBpiVZfJ3V86o7mbVZyfdsLmv3Bdf4KQ3T3lUS1YBLlz8y1ZmagUk3O+Y
	65QJuo7KhRg2GJtanNzrMQ9V+cOBVx1MwJ8rRgyGV8jfS1CYzBJD4prrHXpkFQxfglifVPlH3wQ
	prfThHuprns7TEB10wAKNMsvuWU+eDxqgXDNCE+Lcv7C34KCx4wVSb0Qcnkx7ZYXIHpvZIApeM9
	kE=
X-Received: by 2002:a05:622a:341:b0:4ed:b5d8:a192 with SMTP id d75a77b69052e-501484689b1mr23203311cf.38.1768380759657;
        Wed, 14 Jan 2026 00:52:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:39 -0800 (PST)
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
Subject: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type control
Date: Wed, 14 Jan 2026 03:51:55 -0500
Message-ID: <20260114085201.3222597-4-gourry@gourry.net>
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

Add new memory hotplug APIs that allow callers to explicitly control
the online type when adding or managing memory:

  - Extend add_memory_driver_managed() with an online_type parameter:
    Callers can now specify MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
    MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave
    memory offline, or MMOP_SYSTEM_DEFAULT to use the system default
    policy. Update virtio_mem to pass MMOP_SYSTEM_DEFAULT to maintain
    existing behavior.

  - online_memory_range(): online a previously-added memory range with
    a specified online type (MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
    MMOP_ONLINE_MOVABLE). Validates that the type is valid for onlining.

  - offline_memory(): offline a memory range without removing it. This
    is a wrapper around the internal __offline_memory() that handles
    locking. Useful for drivers that want to offline memory blocks
    before performing other operations.

These APIs enable drivers like dax_kmem to implement sophisticated
memory management policies, such as adding memory offline and deferring
the online decision to userspace.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c             |  3 +-
 drivers/virtio/virtio_mem.c    |  3 +-
 include/linux/memory_hotplug.h |  4 ++-
 mm/memory_hotplug.c            | 63 ++++++++++++++++++++++++++++++++--
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..5e0cf94a9620 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -175,7 +175,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * this as RAM automatically.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+				range_len(&range), kmem_name, mhp_flags,
+				MMOP_SYSTEM_DEFAULT);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 1688ecd69a04..b1ec8f2b9e31 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -654,7 +654,8 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
 	/* Memory might get onlined immediately. */
 	atomic64_add(size, &vm->offline_size);
 	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
-				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID);
+				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
+				       MMOP_SYSTEM_DEFAULT);
 	if (rc) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d5407264d72a..0f98bea6da65 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -265,6 +265,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			 struct zone *zone, struct memory_group *group);
+extern int offline_memory(u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
@@ -297,7 +298,8 @@ extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
-				     mhp_t mhp_flags);
+				     mhp_t mhp_flags, int online_type);
+extern int online_memory_range(u64 start, u64 size, int online_type);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ab73c8fcc0f1..515ff9d18039 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1343,6 +1343,34 @@ static int online_memory_block(struct memory_block *mem, void *arg)
 	return device_online(&mem->dev);
 }
 
+/**
+ * online_memory_range - online memory blocks in a range
+ * @start: physical start address of memory region
+ * @size: size of memory region
+ * @online_type: MMOP_ONLINE, MMOP_ONLINE_KERNEL, or MMOP_ONLINE_MOVABLE
+ *
+ * Online all memory blocks in the specified range with the given online type.
+ * The memory must have already been added to the system.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int online_memory_range(u64 start, u64 size, int online_type)
+{
+	int rc;
+
+	if (online_type == MMOP_OFFLINE ||
+	    online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	lock_device_hotplug();
+	rc = walk_memory_blocks(start, size, &online_type,
+				online_memory_block);
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(online_memory_range);
+
 #ifndef arch_supports_memmap_on_memory
 static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 {
@@ -1656,9 +1684,16 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * @online_type specifies the online behavior: MMOP_ONLINE, MMOP_ONLINE_KERNEL,
+ * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
+ * or MMOP_SYSTEM_DEFAULT to use the system default policy.
+ *
+ * Returns 0 on success, negative error code on failure.
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+			      const char *resource_name, mhp_t mhp_flags,
+			      int online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1668,6 +1703,13 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	/* Convert system default to actual online type */
+	if (online_type == MMOP_SYSTEM_DEFAULT)
+		online_type = mhp_get_default_online_type();
+
+	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1676,7 +1718,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -2412,6 +2454,23 @@ static int __offline_memory(u64 start, u64 size)
 	return rc;
 }
 
+/*
+ * Try to offline a memory range. Might take a long time to finish in case
+ * memory is still in use. In case of failure, already offlined memory blocks
+ * will be re-onlined.
+ */
+int offline_memory(u64 start, u64 size)
+{
+	int rc;
+
+	lock_device_hotplug();
+	rc = __offline_memory(start, size);
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(offline_memory);
+
 /*
  * Try to offline and remove memory. Might take a long time to finish in case
  * memory is still in use. Primarily useful for memory devices that logically
-- 
2.52.0

