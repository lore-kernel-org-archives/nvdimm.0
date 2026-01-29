Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF5A35C193
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720696; cv=none; b=fX1oTTBru1+Ipq8o9/0hUWqK4Q3/Mk2ozdHZsoT2m4Gv/4ygQmM6NhgJJ91wlTAImLfnYmjc6bwDIb9zGQCcrLK8o3cBUs1tvEodnjSs/v6hIRJj1Jmm7BtaIXjChh+G7S1BGX1lsYaLC4h3Wa2D1wahy5f3f6eWpc2g9heF4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720696; c=relaxed/simple;
	bh=VOKzczjoSR9IzZunD6EwkPNtZXVw3ooO/qAH8uc28p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpqIjfL5IF8Jaz/HVqw9lGn/ulHY+jk/kI2+GkBr/75bTkMikAV2mGfU/xNRaba/IafTorrOXDcHFyJ/Xy7CLvY1fNfnmQ6dl0H5ah7ZZyUPWlvmjpCFBwUc6HvjwEuGoK2XIayWDFGzo+xQoZOKheJOV6iOVtqwziJiBx2nfiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=OBh1zSJa; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="OBh1zSJa"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c7146b0854so155239885a.2
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720693; x=1770325493; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Szb3YY2E1e7FJPUVmrsEdEEkJjq+khES1iOhgbFItPA=;
        b=OBh1zSJagOm7wZfoV6ze3qzoniITW6vxnpG+F5QRqTur1DYiD2YGDvxo9b9gdXRxPy
         D4t7L1f49Tk2Vw+ApYAL7+oHYoIpBw+C6nXdhAk0IfrbafwgFpteeGecm8aKxI9hUXrc
         as+HmScNYgXhTYFI9qFj8j5qb3BX6EgeH37dwt0Wdzbmk/lz729pg0NRwnHcy+9laQZc
         7Jj6pL0ZI1tetVHO8tBgN6y0t7siB3v3Yiov0oJ0l15h7C1ghkv8sC+bFZvrE+BpRimu
         aKUiJFMJNh/XRlu9DWM1xnzduSjsa6n3RyDnK1SDV/dJreGpS8nmrAy3sxVjoFgv1V09
         z4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720693; x=1770325493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Szb3YY2E1e7FJPUVmrsEdEEkJjq+khES1iOhgbFItPA=;
        b=i9+D56iLd4mmDJEqxhbBLW3MzNrb5dNjAlbLucxhLG++RG/l510MB/9Mr3LOIgP+Sg
         esVo9m/0uNCM56qtNTMw80fq0OXa8v2EOoP9TOUyYCbf4JErIwLh04kLjs//3OHmtvXn
         kQrt45oOs9hKzrMZltAAcYBdpgPC340VWaVfwEmKvC2SMTfHt5a1gZI4XUVQmUlLoj6T
         8v/Dj7lmO30uxmqKt3gmLiZ+wbkKYJAir54QjQ2VhB1326DxFA92/V4nVKyPzQcziVqj
         ozUYsnD8w2SvuV7JedV826DoQks0Dc5by9bTvFFoLz40NQS3vADpjpdBhgmFy1zD96a5
         niPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa1TqSQuECCWszzQEAfYi6x6NCq/BVkrWJCdG6kCygq3McLEwcZ8+3r6tPF0No0eDB1c8p24s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeLAkFX3RjDwRlUCz85e0SAaw7EJeVXNH1EXOkOEGMIaMOKvG8
	IqLsZUr7tO3ULQMtrWQrKNSSoScKshk5dkjmnwfWo/3X9E+Y/Hb82YckzU5pCc9pKzs=
X-Gm-Gg: AZuq6aImbZrILzFtdsOtu0k5jZzibOvhSvuu4PGHyqWhNR3X8ho5tdGv2g/EG3BCfFS
	2CM03qVVcnkD878Fh6RDHE1KtlW/P2wy6C2yu8COO6m2xvEu6FLoIF4t9LW1mT/u/8AiUV20u7a
	DV1A1hrlXnILXfkcimHITZ00qMDgI/76QZ75tr0/mW/tRgVvja+bFCaiIFzMLCY8rA/H6wVtM29
	OyJlHunbhacCvZgSZ8lDJb1Pe595K9MnUnJXrOvw3CFlETM0LitPNz9HTKk7YrspuBMZz+uqcAw
	X2CAoF1XvgwQk0Zx3k4g1hmKpjwVIkHTo0maUktgrddVYNp6gfX4XH+hRCCKlhnO9CSif/69Wkm
	hm38hil/k0PL9mvPfD+6o0lOcM9vJprWvljM1KRY2V0I+aP1rc5tMQS4YjQV0qTzCIPuFNUsRys
	zyVhg5ddYJKDZHTsrGDLZIUFt5qtzQlL4Ob9WqFXQtj0nV0wgXrzA790kFSSzTpV3VbWDvzBYlw
	xsxrGUxa1SVRA==
X-Received: by 2002:a05:620a:690d:b0:8c9:ea1c:f21c with SMTP id af79cd13be357-8c9eb2fd583mr157489485a.63.1769720693221;
        Thu, 29 Jan 2026 13:04:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:52 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Thu, 29 Jan 2026 16:04:35 -0500
Message-ID: <20260129210442.3951412-3-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable dax kmem driver to select how to online the memory rather than
implicitly depending on the system default.  This will allow users of
dax to plumb through a preferred auto-online policy for their region.

Refactor and new interface:
Add __add_memory_driver_managed() which accepts an explicit online_type
and export mhp_get_default_online_type() so callers can pass it when
they want the default behavior.

Refactor:
Extract __add_memory_resource() to take an explicit online_type parameter,
and update add_memory_resource() to pass the system default.

No functional change for existing users.

Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 91 ++++++++++++++++++++++++----------
 2 files changed, 67 insertions(+), 27 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f2f16cdd73ee..1eb63d1a247d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -293,6 +293,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				int online_type);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 87796b617d9e..d3ca95b872bd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ int mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(int online_type)
 {
@@ -1490,7 +1491,8 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
+				 int online_type)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
@@ -1580,12 +1582,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
-		int online_type = mhp_get_default_online_type();
-
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
-	}
 
 	return ret;
 error:
@@ -1601,7 +1600,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	return ret;
 }
 
-/* requires device_hotplug_lock, see add_memory_resource() */
+int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+{
+	return __add_memory_resource(nid, res, mhp_flags,
+				     mhp_get_default_online_type());
+}
+
+/* requires device_hotplug_lock, see __add_memory_resource() */
 int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 {
 	struct resource *res;
@@ -1629,29 +1634,24 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
-/*
- * Add special, driver-managed memory to the system as system RAM. Such
- * memory is not exposed via the raw firmware-provided memmap as system
- * RAM, instead, it is detected and added by a driver - during cold boot,
- * after a reboot, and after kexec.
- *
- * Reasons why this memory should not be used for the initial memmap of a
- * kexec kernel or for placing kexec images:
- * - The booting kernel is in charge of determining how this memory will be
- *   used (e.g., use persistent memory as system RAM)
- * - Coordination with a hypervisor is required before this memory
- *   can be used (e.g., inaccessible parts).
+/**
+ * __add_memory_driver_managed - add driver-managed memory with explicit online_type
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: Online behavior (MMOP_ONLINE, MMOP_ONLINE_KERNEL,
+ *               MMOP_ONLINE_MOVABLE, or MMOP_OFFLINE)
  *
- * For this memory, no entries in /sys/firmware/memmap ("raw firmware-provided
- * memory map") are created. Also, the created memory resource is flagged
- * with IORESOURCE_SYSRAM_DRIVER_MANAGED, so in-kernel users can special-case
- * this memory as well (esp., not place kexec images onto it).
+ * Add driver-managed memory with explicit online_type specification.
+ * The resource_name must have the format "System RAM ($DRIVER)".
  *
- * The resource_name (visible via /proc/iomem) has to have the format
- * "System RAM ($DRIVER)".
+ * Return: 0 on success, negative error code on failure.
  */
-int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				int online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1661,6 +1661,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1669,7 +1672,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1677,6 +1680,40 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
+
+/*
+ * Add special, driver-managed memory to the system as system RAM. Such
+ * memory is not exposed via the raw firmware-provided memmap as system
+ * RAM, instead, it is detected and added by a driver - during cold boot,
+ * after a reboot, and after kexec.
+ *
+ * Reasons why this memory should not be used for the initial memmap of a
+ * kexec kernel or for placing kexec images:
+ * - The booting kernel is in charge of determining how this memory will be
+ *   used (e.g., use persistent memory as system RAM)
+ * - Coordination with a hypervisor is required before this memory
+ *   can be used (e.g., inaccessible parts).
+ *
+ * For this memory, no entries in /sys/firmware/memmap ("raw firmware-provided
+ * memory map") are created. Also, the created memory resource is flagged
+ * with IORESOURCE_SYSRAM_DRIVER_MANAGED, so in-kernel users can special-case
+ * this memory as well (esp., not place kexec images onto it).
+ *
+ * The resource_name (visible via /proc/iomem) has to have the format
+ * "System RAM ($DRIVER)".
+ *
+ * Memory will be onlined using the system default online type.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int add_memory_driver_managed(int nid, u64 start, u64 size,
+			      const char *resource_name, mhp_t mhp_flags)
+{
+	return __add_memory_driver_managed(nid, start, size, resource_name,
+					   mhp_flags,
+					   mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.52.0

