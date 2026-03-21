Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E523921C9
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105461; cv=none; b=nWDmKPWo9NPJ9UrKOWQZtzwJ6IVfOQ7tfFffDKt44UCk8vAN41LTm6AwI05K6Ujk3SOlmj+3Zsl/wweK07Rjqvxgf5GZuEsfxO9mziN1Yk6a9JAIIKgWk6V+JFfeTkM8NBfTg6yevVrshFx1azUGHT0q4PHf2rURFxMuOhAuR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105461; c=relaxed/simple;
	bh=rF+DX+JfgUHRP6PxAjzMWPOUKYEy9HGwrNkxn2i6BO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4tWf5lI9b4dn4aW0D9o2u+lMbM2qrVmgl8HsKBL7mx3qGREWgiyM4uOrWkJDD+Ahd7UlEvOEhpspgMUR6IArTUwcrX9R3iI8RssMz/ahigx586qSikuE5kuZlY1nGiCtMo6cMlZrk8dk/1++cwY4TYbntxQqRDWtjjpatXyVSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=JdRrCKi1; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="JdRrCKi1"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c70b5594f4so333675685a.1
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105458; x=1774710258; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vvnYDBDYSd91JS5VlgcZ1pjC7MUK2Lw1jakydB3PHI=;
        b=JdRrCKi11ZZIUVB1IXHkf9lZCWean+Tzji19fpTEMgs2b2jCjGvLyLxyWGKkkaiXZY
         v1jlS4vTXHSrbjyVxhRwGR4AZwQ0nylU3tiRiBqrrY05FgJADBJRsZgd9fYAibzIzO0b
         wTl1zAghYaAwv9NEEO6exezBAPq/vJ5oieQEVcW8Ip23LJz+pAkKEnlfkXCpDBxEpx8q
         4+MecKj6PEOyrckgMnln2aJGGQgfs3jQ7HYdjFGO0N1GydIkYkdQL57GSZ0jwqkJbCTX
         p8iNO9WJP6M3SBt1BUxIInxX+quw8X39RYIk4qsyhPHgCvJt+440XjE3Ss7QHkdc6d89
         1Z6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105458; x=1774710258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9vvnYDBDYSd91JS5VlgcZ1pjC7MUK2Lw1jakydB3PHI=;
        b=livKntNsK0k1SlDfjtfGUfmv+TJMo2O+uR/tlZyk3BENN0yUl+griXavIiL9DcphX7
         zQAlbVi6giYI/8/q71GpouxXiEsHRL6/7vWNPsm/ELUMP1POXeTFdb8d5zOWgBL8efOt
         eTkAL/oeDwh7xTQKEjHIc2f4a9p6+t5XW7IZ49iGLvr/KOjiTDNGCk2IC8q9k1+w6ICp
         Xmt9oOKFRcXbs846daS8BbFw/9wSTy2sqyPFBZ288Zpc2gOanEswgaoej6dyST383DaP
         xz4Y7tfmNgCMaPLlBoR+VZpES6GdBH2ouuiTwqBSotct3sLk1m80cuoqrGiJ3lMRpUMP
         QHsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOM0+TAxx1z1+FJjk4WmTtmZmUNB3pFcSWrOUYJTY/rtKbNbuFFvWk1KhAH1A9IgBFFqdgC5I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxaFN97qTiVjlPVElAeeQiTkMvcZGPxr4F0ZVrqun4kuGwZSNY
	uGl6cbBrxuPTyY9Frm+RXALoeoye3idv7hjBAgwGPRE5qnx6Efm9Q0fGUB+fjACcHEs=
X-Gm-Gg: ATEYQzw1SnOvD36ruDvi8bjNrgy1Am1wfM+r9mkMSMxvHFI7WGdre6JJ9QTklkW5kMB
	SjUwjzrJTOYrUa+jU8zTy/Wbw7TvvOhd9P53lj+Z6gtFyk9tKyOXdnnoguV88PkweI1GxbKGwuM
	ikMaDAOAoB+B1n5V6nDFdalpe262ge6l8mPunQndfuGshO/CKkn8uhwrzHyaPmva9m11rsNW8qH
	FBhfr//0vdYVL6MUitshHY+++8zNpC0DP3QM2Nhhr7mBDCJYsYrUzuvl0y63SpcFo/QBhHmqPpf
	n/RnCOikDxdGtDU8KiC7lz7g2mLIYYqP9k56nTvadVUxx22q08LC8S3kRgdwO6sy3W6zThJ1dhn
	FZfx+6XAGPufg5L0cRAzcizekYxRVWwO86W8ctypbNdCbCDbF0PnnHR6lhc/dkVg6y0ra+c7OJ5
	/9lfHTlQeSYifxSgyiit80+gFPmXXTT4hfcuUPwmA5HMemAUS/N4SkkuPcAhv+gibK/uufhVNsm
	+bnQ42lTFT0DN55hA0hV5uRCg==
X-Received: by 2002:a05:620a:410c:b0:8a6:92d1:2dae with SMTP id af79cd13be357-8cfc795a1famr877339485a.5.1774105457588;
        Sat, 21 Mar 2026 08:04:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 5/8] mm/memory_hotplug: add __add_memory_driver_managed() with online_type arg
Date: Sat, 21 Mar 2026 11:04:01 -0400
Message-ID: <20260321150404.3288786-6-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
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

Refactor APIs to add a new interface which allows the dax kmem and
cxl_core modules to select a preferred policy.  Only expose this
interface to those modules to avoid confusion among existing API users
and to limit usage in out-of-tree modules.

Refactor add_memory_driver_managed, extract __add_memory_driver_managed
- Add proper kernel-doc for add_memory_driver_managed while refactoring
- New helper accepts an explicit online_type.
- New help validates online_type is between OFFLINE and ONLINE_MOVABLE

Refactor: add_memory_resource, extract __add_memory_resource
- new helper accepts an explicit online_type

Original APIs now explicitly pass the system-default to new helpers.

No functional change for existing users.

Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  3 ++
 mm/memory_hotplug.c            | 60 +++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index a8bcb36f93b8..1f19f08552ea 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -320,6 +320,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
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
index af9a6cb5a2f9..9081aad5078f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1492,10 +1492,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
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
@@ -1583,7 +1583,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
+	if (online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, &online_type,
 				   online_memory_block);
 
@@ -1601,7 +1601,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
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
@@ -1629,7 +1635,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
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
@@ -1649,9 +1663,12 @@ EXPORT_SYMBOL_GPL(add_memory);
  *
  * The resource_name (visible via /proc/iomem) has to have the format
  * "System RAM ($DRIVER)".
+ *
+ * Return: 0 on success, negative error code on failure.
  */
-int add_memory_driver_managed(int nid, u64 start, u64 size,
-			      const char *resource_name, mhp_t mhp_flags)
+int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				const char *resource_name, mhp_t mhp_flags,
+				enum mmop online_type)
 {
 	struct resource *res;
 	int rc;
@@ -1661,6 +1678,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	    resource_name[strlen(resource_name) - 1] != ')')
 		return -EINVAL;
 
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1669,7 +1689,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 		goto out_unlock;
 	}
 
-	rc = add_memory_resource(nid, res, mhp_flags);
+	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
 
@@ -1677,6 +1697,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	unlock_device_hotplug();
 	return rc;
 }
+EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem,cxl_core");
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
+					   mhp_flags,
+					   mhp_get_default_online_type());
+}
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
 /*
-- 
2.53.0

