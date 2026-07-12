Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970728136F
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871127; cv=none; b=BFpZrJB7OVpN+27JpTer/GF+JcbnZM/+gcEbqh6cmO9Pm3CsqW+sPeFOgX+uOssWJNnm2YpPXyAsthBkrYTbkbpMJPiaUt108IY0LM7fnWH/VBZVgumhFv0QrqVJxf17oDHBQROBwFvP5mqEkQQS39djvYiamvcWzmtuyKovgqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871127; c=relaxed/simple;
	bh=EKPuuIUD6wUc5+OroNJRPEyMtD/v/hjeTMdbe72dyRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+zYkSdbVdaOFzzVSiFwgzmqXDAoWhC5hzRTGelSLtvXkbUu6aFQ0ff9SzdIGDWCN4XWbbZZjLfne4c1JItq/o3ixwfte8u3apVDkxwoWeO1g6/tfLmDF/ZewBVpd/o1pobeG77xMFZao7NvukdqatliG6Mu16J/FRI3WRczd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=hAVU0y76; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="hAVU0y76"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92edb12cdf2so132865985a.3
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871124; x=1784475924; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DYjx2PN1x6uh3R9+6IQFG7Hc6bZQLBpnO2wEgzswHD4=;
        b=hAVU0y76V8RDzDuarZdTs0l8lqpXoQg7vlq1K+HCJrSjuQS3BjiDL4wa79dmlg/g85
         o6BM3BJPI67epixB5jxe1UL5O/Wq/fcyZuUe+JaNxw2+rrC6hGi88l9CDBZEbVXfCCKG
         PUbFbTpZawWmx1PFPI4swzA+X/UsayudYPkRVz6I0upoTbVOwHoRdK6RcQOozAR+OkNb
         xlS+soJXoQRCPpsZOnGBNJibp0NwaB5usPI8P+9ZCyegfcQmYOH6/g3mwtTRGjp887a1
         pU48FcnC0sexVsLH5sH1csdSgitOpJfM3XpfPXufOGjujIs+W3RUGlj7eU7vPQ56MSMQ
         0z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871124; x=1784475924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DYjx2PN1x6uh3R9+6IQFG7Hc6bZQLBpnO2wEgzswHD4=;
        b=LTt+VPn7Yyu8cyBAUY9L3V5C0awms97mQPGP+oF5gdN1QFl1Fcm3z0JdH4SeUgR3g7
         8EQQoeeMSCWlEGT5YJepPSv3NCh+aFNBhsWz7myE/16aRZ2A7ohXZ/5H5AXCEQ+7ipgn
         GqcIl4lmU/wpQpSXX0It17aYVu1KkUTyblg+BStMvIiCKuRvXbv8ny6ccRGR4Cr4E4s+
         zSNFreOi889zCdNa2cREnEE+nAnGZbIlwym3xCMUVZdleYsxNnodjkA4iK0Ouu89A6qx
         ITSX3UggTAK5lxoiAGBV9jn4t2WZNDMzOlzBoL9H0jCucT9VEcEkl8MHlCZ1BSeJNZMP
         hy2A==
X-Forwarded-Encrypted: i=1; AHgh+RouVkbbdbWWNsRVZzidDrg0Q1EKUoTd60vDi1cIrDG9m58tQXktBaWwkIMdK9yDJ82BxwGaUUM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbDDf/25fr7ymGXHk5r29JYUWCBXhJZiy/EGbGX8VujNTrQGJq
	K6p36VcSG67j0+qZIBtF//jtLTknLwFTcRCN13Ti596dCBQIjChpurqHBYSX0UA2BC4=
X-Gm-Gg: AfdE7cm2KIPpPg6guTHN97qRYeVLWKIQ6xPPCvpYbi9DMDBZtOj0zqDXRhDxO+iGstr
	+3PdNzrFWIy0ABK1Ij6uorrzjbbwCLBXJNcg1Om8eEnAcLZeRfV5kegAodQqMSJFRJpQJrXplGq
	n9CVvOUS0gr1MknPIXaykIALhJuv930FCNPeq/pY6jO47cgKsXoGG/g3Vi+Waher0h3ORANZtlW
	/QS6SBu3tj264ETiY54ToZcI5GEYFnW2usJEbhr+weTyHSYCXuuusWirBph1PXH/R4xseO1k/k4
	0V2/VE6NFY0zZ1JN83nclXgV7MrgSdvPtpNriFEfdD0mgCiTv2K3ixAIagZN8mTIK1jOQtOd3w1
	fIPVNx3VT1jpsDNrcOAwqZAFJznbUOdGSMb3cvSPEycdab2XHelfwYvOpRXBHyOdKieMO7gGrN2
	PAfmubmp2IDpage77NVHikbJDi+3v3Cpbd0i2Qr4eRNXRnldMpUcn9k1dPCU9j81RrMvATcAuTd
	A==
X-Received: by 2002:a05:620a:2894:b0:92e:7533:ef67 with SMTP id af79cd13be357-92ef2be4e04mr657175885a.20.1783871124238;
        Sun, 12 Jul 2026 08:45:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:23 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v7 05/10] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Sun, 12 Jul 2026 11:44:59 -0400
Message-ID: <20260712154505.3564379-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing callers of add_memory_driver_managed cannot select the
preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
hot-add memory as offline blocks, and then follow up by onlining each
memory block individually.

Most drivers prefer the system default, but the CXL driver wants to
plumb a preferred policy through the dax kmem driver.

Refactor APIs to add a new interface which allows the dax kmem module
to select a preferred policy.

Overriding the configured auto-online policy is only safe for known
in-tree modules, where we know the override reflects a different,
user-requested policy.  We do not want arbitrary out-of-tree drivers
silently overriding the system-wide onlining policy, so restrict the
new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
cxl_core) can be added to the allowed list as the need arises.

Refactor add_memory_driver_managed, extract __add_memory_driver_managed
- Add proper kernel-doc for add_memory_driver_managed while refactoring
- New helper accepts an explicit online_type.
- New helper validates online_type is between OFFLINE and ONLINE_MOVABLE

Refactor: add_memory_resource, extract __add_memory_resource
- new helper accepts an explicit online_type

Original APIs now explicitly pass the system-default to new helpers.

No functional change for existing users.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f19893f5fa948..593e42c221ada 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -295,6 +295,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				enum mmop online_type);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index be8e8e2cd1535..aaee8470eb2ad 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1495,10 +1495,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
  *
  * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
  */
-int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
+static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
+				 enum mmop online_type)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
-	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1586,7 +1586,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1604,7 +1604,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1632,7 +1638,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
 }
 EXPORT_SYMBOL_GPL(add_memory);
 
-/*
+/**
+ * __add_memory_driver_managed - add driver-managed memory with explicit online_type
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: Auto-Online behavior (offline, online, kernel, movable)
+ *
  * Add special, driver-managed memory to the system as system RAM. Such
  * memory is not exposed via the raw firmware-provided memmap as system
  * RAM, instead, it is detected and added by a driver - during cold boot,
@@ -1640,6 +1654,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * Reasons why this memory should not be used for the initial memmap of a
  * kexec kernel or for placing kexec images:
+ *
  * - The booting kernel is in charge of determining how this memory will be
  *   used (e.g., use persistent memory as system RAM)
  * - Coordination with a hypervisor is required before this memory
@@ -1652,9 +1667,12 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * Return: 0 on success, negative error code on failure.
  */
-int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+		const char *resource_name, mhp_t mhp_flags,
+		enum mmop online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1664,6 +1682,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1672,7 +1693,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1680,6 +1701,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
+
+/**
+ * add_memory_driver_managed - add driver-managed memory
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ *
+ * Add driver-managed memory with the system default online type set by
+ * build config or kernel boot parameter.
+ *
+ * See __add_memory_driver_managed for more details.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int add_memory_driver_managed(int nid, u64 start, u64 size,
+			      const char *resource_name, mhp_t mhp_flags)
+{
+	return __add_memory_driver_managed(nid, start, size, resource_name,
+			mhp_flags,
+			mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.53.0-Meta

