Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6262EEE9B
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854343; cv=none; b=Y5CkiqLrG5LUxpNNzhb/Ig/r3v2iCAt4TL2g4nkQvMvSfWI2YmcsIGOOi3HUhQhWGb0LdvU5nmWEHb8KLYF8qPYJ0FCZ/tQvJ5skZ1eleOWhAaR28UYSh0ySr4PPWHA/kCZxLhUFSJoPpQ99LDQ+RSIJRr3pU2r+dU3D3uLPwAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854343; c=relaxed/simple;
	bh=QQdGZlXCYCZOvFB4GLgzXeg7krXvgyvohqhbpXFKHlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN43GxiUt1Cbo+JFoAP6/iJLEhQMyh9NTofXzNU+hU9HeibHNrfifn+cKvqyg1nA9fgxSNAVwJSaW17HDRtoWxW4JAxUqtiBV8ZBYFpnxDX+WgJMk7jEJrLqxv7zCDe+87pAatl0zaWppq1tNi30CxCbOWl6GDA3lU36pwZqw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=FJrF+fMo; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="FJrF+fMo"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9159951f05aso601552985a.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854337; x=1783459137; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAW3T42N8LQZC9syVg1ZuijfUaTs4bm/TuOp9AH8qpo=;
        b=FJrF+fMo5bzQQNwpnmyWe5HDjzCRn64hOkE2NMVg28wlCBTnFK5MEy0kr+Byr+OTDt
         kXZ1JUhiFpyjPmr7ehuu4kwIqfex8gEcFXrSPgXWYIsDkf5ZHFMtQEhj80I/kVnCdWAX
         2XsnFYW9CTgoUUvBNsqetJhRyriSuIaOBFR81l4Y3xoOUpZ3STlj5S34NWDqX94jsauu
         MaEFiGQFP0dd1gir1xxiH6NsTq0NA5KrGiCU2p7JfV2clUiTLoeqFzEKkkSZmBhpRqEd
         dXYaloMlJLtBhK4N3H1MdxCR2+NqZXfGsAG5Mt02qSp0F8yeFWFZUpJzzkCnkdKvi5gy
         NnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854337; x=1783459137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JAW3T42N8LQZC9syVg1ZuijfUaTs4bm/TuOp9AH8qpo=;
        b=NRnfTSxuRFh0J9xaN575f6PXMDl2SOLTjcqhlP1Uyqub8xv42KT5wy9LA/M8H3SxJo
         /69p5cJ8F2YMX77n927fAGm6Ug+bl/630KnrlbzmS3iJbNX4biRTovTC7rc+d9HoUsR7
         J+HKzjKDUSJ1a0n15W8FJYZ6c8kZXSXlVzTF9zx7x87jep6ZBv2sqQ+1JRBYw9FDUQ64
         Slew8UVa4m8WZ4Hj3f3oMIi7BFbTT9pI+JDKqUdQ0wQKCHPTDBfc362QZLpN+4WD6zsy
         OmI2vG0Xi18FG/kReRIRRdfNE6ePW8GuW4B+yChLhE6XP0BobpqqYzQGjlLjxxfGkjJp
         NNzA==
X-Gm-Message-State: AOJu0YzLRdeIVDF1GcGB0oZYT9pQ7chAi7NH/RdSk9zQqQ2eLuH32/S2
	9ep7zWKrAv4/OKRaTu++gMNNYSt/RFvJp+J+0R0bTpCJyae+xbFOOro2tZzdX/EW97o=
X-Gm-Gg: AfdE7ckH4+zJvqJQHRONgaxntUBfxQ6fxMr4DnFUmonZfUHXtgVs7kvL10FQqf6pMUv
	18BsQwNxbDrvUGseBv7CWR/AkySr+pHVt4YPUYp6SbfPL3bB0YwAcVjLiimL58b6J/IF88nwssd
	DhPUULfBvPH80R8wlxnFdUT219g3lhNkbWvzyBW1qbBQtuqMVp9WZZUeYK4m3DQTNm6jvFOo3ky
	h+5C8+sjXgmJZbIL7WIErgorPlouU463sY6kLu6Llsq861xQrDyLuqH5jngiJ2THyS2lSwT0Ip7
	gtZWICXhlWqMGrF3zQ0G0N7PSfEGEDdsJu0QCrX+Kz6VzZSZayJNTv/tlHprIKPEhQMV8V/5MwI
	lCy10c19iPX4vMZuf2lkT5SSK3E/f2cyPwJwaHKd6DrAHxYFLRZfAOnsl/IAud4/UgTQ9zrg1Fc
	Ws+LLOEQ3cSwFva/QsOcYKKozgygEylLcE/D/fFzCx3tClg9NDw40JDDsg9XS8OoA5/2JmwB07B
	z9Q/+YeixTI
X-Received: by 2002:a05:620a:394b:b0:92a:bbf6:717e with SMTP id af79cd13be357-92e6279c3c2mr869717085a.34.1782854337312;
        Tue, 30 Jun 2026 14:18:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:56 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 05/10] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Tue, 30 Jun 2026 17:18:37 -0400
Message-ID: <20260630211842.2252800-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
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
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 4d51fcb93a37..ff3b865ea7e7 100644
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
index 494257054095..a66346def504 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1494,10 +1494,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
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
@@ -1585,7 +1585,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1603,7 +1603,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1631,7 +1637,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
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
@@ -1639,6 +1653,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * Reasons why this memory should not be used for the initial memmap of a
  * kexec kernel or for placing kexec images:
+ *
  * - The booting kernel is in charge of determining how this memory will be
  *   used (e.g., use persistent memory as system RAM)
  * - Coordination with a hypervisor is required before this memory
@@ -1651,9 +1666,12 @@ EXPORT_SYMBOL_GPL(add_memory);
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
@@ -1663,6 +1681,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1671,7 +1692,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1679,6 +1700,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
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

