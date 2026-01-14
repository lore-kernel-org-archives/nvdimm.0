Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1273803FC
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380771; cv=none; b=bZ4LIHWg71ii2EVgVHS+Jat86UkPd+oOKg+rP9TfEqz3LBWC/9OigMhQb8QhSlnw8ZQ1GF3lHRnohc/Zu/eYZCSxuXueKNLlsEmcnAsA7DdlKx5iWwqEuQd1jqcytP2ZyiVap7ng+ooT93AIbVsZOs9Avjl09e2csddEFfzVFPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380771; c=relaxed/simple;
	bh=WuxU623lbbMTdGzzm+5bCzIY7yeXdH6a4+PbwDkCxIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjmBgCgsATm6cwmx2P7WGJgk31GD9/6GLSN1Hd8Q7FpgxyYy+FvyWIxiD8k4qt5U4+gjxoHxgPhNs6SoYloJfaoCbN5XUUn6oGmMPEXMB6IwRsJlibWtieDoAceMq3sFAGSqRA7hGKp43hL1h5sY9DXmIQgdgbC1h9st9MP5bnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=OoCXDXdd; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="OoCXDXdd"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee158187aaso91211801cf.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380761; x=1768985561; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHib3jWzP7kVcnP0SE1eJQabXI1WWwo6ABSGI/iwYvU=;
        b=OoCXDXddnOY+AncYAVGNCyTqgbOq1RMKt9HEgKaII5Z6c2JSOmWr7cfcFt0gXUZVxb
         SkYckvZ1yzOI/NHY8WVghcAxrnMVdJxXae1SyvkZ3+usDJTTqNrtK28D1aIvqOyp5QIM
         u4lkKd4eDHqADWn0mqay5vc2xtWnxQsTulWsAMn4Zp2CB7ktGFmDAHcPG0EQfHfDlFOi
         MVcbb5m9HSORP5rHa4u7wgeagMNDHzgbEMSONqGZpZZTvNi5J5p5FCaaEslyfYLTxWA4
         RwlhzR2nOSEo0R56VN7rqeSFV6sbHuCc63aqolJ5Gz1EMvaBpCHHw8L26oNczBd616Xb
         MsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380761; x=1768985561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AHib3jWzP7kVcnP0SE1eJQabXI1WWwo6ABSGI/iwYvU=;
        b=DF0xGqAD3MkFKMfsefL5WO4ZaITK+nVjDBJeOmazj6DPyuy9aKP4Mk2xBlsjtcry9E
         itSsNBoXFSwXWdAcYE5Y2KIILR0ahvi+eJhay2ikv1fczasFW55MELtpamN/spbBSYTm
         kYY01NiOPmU/p2qY39HrkIu73xjwrZ2x6Qkk5Nm6F+6XSPPovJ9HYwoaW1Wm7d2whB3H
         ocY0+HvSzRDTBSD1Qo0yajejohO/VmpMHPx1NGh6Kc3Kra6yChf546dT254V3kQzyXOq
         a3JJ+pQZWYnlOeOV9byq07ajr3pswdl9eaHZxbiqNYTf+lKLOfF1gfNkuxhbRNqVWE5x
         BkDw==
X-Forwarded-Encrypted: i=1; AJvYcCUgT9n0oSoIUYkh2lsQ47DYfmvMvE4YPYm9eZczZUttCa7eFU/1gRr2VlLNGPQTf7ONqRIRG7w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeN4zcG//vvSSEvpJc6ZSTI2l1R1/WFdViVGLkxIEH5oSgbZUU
	61Oh7ibLXpTuKhdf+HYsmXJA4GNNw86Uzb/9yZXj0MMnMfn5GNMfgBEh8gJm4cN6B8w=
X-Gm-Gg: AY/fxX6v9An6cewVqD/SZLxx4OabAJnQX/SxaCDuPj2+VslWuL8sRxRFBjS1QAgm8rL
	BKmx90B/Bj0d+B63231YXoB8ArthRRRNPRIf1zwHVdAU5DvYi96c1PbiUX1KjsNI9x9cNVVS34f
	4WVj+WdMIdw2BFF8njbFc+sOC1D33kRVen/y8Px+4QB/933btpVcSOlbLYvmHFBP0cXZOAAc+PO
	aj4OwlPiuVznZIWkwVWhKErEBChHqSsEHQsWlLxFGkQEik77BA1KOMMDkJ171zCh2nN7kMjAFF+
	2l+t9li2XFNCH2PSL8F8Dl5jxsHb53lDsaJzCzZb4iPdSwdWELxPaerucz0jr0heoeKqrW7bZXu
	QMFdZhTjssubJfZ1ASLAOszpRDp9+RYaXQloNuDgQB2Yf0Uo0AbByiBoDkIlSR9ikFyNOjn1go/
	cwkWPaG4VraEe1oryE25/XmUUoZcHyN6coPH6GN3s06FUB3oNSUQyosOHUk7PxDPJ8rkRK/PSJl
	/w=
X-Received: by 2002:ac8:7f0a:0:b0:4ee:228d:d6b8 with SMTP id d75a77b69052e-50148482933mr21948301cf.70.1768380761194;
        Wed, 14 Jan 2026 00:52:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:40 -0800 (PST)
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
Subject: [PATCH 4/8] mm/memory_hotplug: return online type from add_memory_driver_managed()
Date: Wed, 14 Jan 2026 03:51:56 -0500
Message-ID: <20260114085201.3222597-5-gourry@gourry.net>
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

Change add_memory_driver_managed() to return the online type (MMOP_*)
on success instead of 0. This allows callers to determine the actual
online state of the memory after addition, which is important when
MMOP_SYSTEM_DEFAULT is used and the actual online type depends on the
system default policy.

Update virtio_mem to handle the new return value semantics by checking
for rc < 0 to detect errors.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c          | 2 +-
 drivers/virtio/virtio_mem.c | 5 +++--
 mm/memory_hotplug.c         | 4 +++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5e0cf94a9620..d0dd36c536a0 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -178,7 +178,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 				range_len(&range), kmem_name, mhp_flags,
 				MMOP_SYSTEM_DEFAULT);
 
-		if (rc) {
+		if (rc < 0) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
 			remove_resource(res);
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index b1ec8f2b9e31..4decb44f5a43 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -656,15 +656,16 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
 	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
 				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
 				       MMOP_SYSTEM_DEFAULT);
-	if (rc) {
+	if (rc < 0) {
 		atomic64_sub(size, &vm->offline_size);
 		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
 		/*
 		 * TODO: Linux MM does not properly clean up yet in all cases
 		 * where adding of memory failed - especially on -ENOMEM.
 		 */
+		return rc;
 	}
-	return rc;
+	return 0;
 }
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 515ff9d18039..41974a1ccb91 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1689,7 +1689,7 @@ EXPORT_SYMBOL_GPL(add_memory);
  * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
  * or MMOP_SYSTEM_DEFAULT to use the system default policy.
  *
- * Returns 0 on success, negative error code on failure.
+ * Returns the online type (MMOP_*) on success, negative error code on failure.
  */
 int add_memory_driver_managed(int nid, u64 start, u64 size,
 			      const char *resource_name, mhp_t mhp_flags,
@@ -1721,6 +1721,8 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
 	if (rc < 0)
 		release_memory_resource(res);
+	else
+		rc = online_type;
 
 out_unlock:
 	unlock_device_hotplug();
-- 
2.52.0

