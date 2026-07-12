Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271DD34040A
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871129; cv=none; b=H0/E19gYGKoqtlC3RMSH7GSDtVrarBpjpiKTQCkkGxSlAnaEGiap3k9+Fwnijqpu5hKyrvuw/J6Lea9A9mVM+EGRpcJNiib979KQpKX9ZgjC3JpCEZ59v6eUsO/qCdQoNg5FCblbwgBf9w4hgkOib0BExbP8uxmRS3xyAMQ+As0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871129; c=relaxed/simple;
	bh=7pKyukvwZ/FT8fQ4NbS4CNhbpoehsks/UJ+HJxEbx0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HijU7nvXiYq0hiAJnYDMN3+sVuWQiXMUGodWCr54MPLPvkVCkUR3Iuy7MNidzMDHoBv4WxUde68iE6++EP6PzUz/YFoC2va1y2iYr/pQqejZQRYCRGcViUUY85/1Y+z7qrOWYEM4gFAkl5CkHwKoOFfsE82T2pzyf1GKhmFSXpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KhNbsJLm; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KhNbsJLm"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92b21f65b60so199012785a.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871126; x=1784475926; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WZHBBH+ENtj6q7i5GiJzA/uzY8S0pYXEvHqndwIIRnQ=;
        b=KhNbsJLmYObiWERJ2ekKZI6jq3YZGF7W1we7WpQR8M/xt4JQ26nFD6OBiXuX9QR6st
         yZpsV3mT8O+eXqGg0jA/h4TM5O9zy2XWe7sxY4msk7XJc51TPTt4goe9HDrqxjja+MZu
         hzv/g14B+nw8cHiIOJqH5Sg8SzMVlkPJZceGXwivC2GFnWuydrdL3vUbFBMKubnjdax6
         zJjVoMfdpplyIWpzX1SUF4kFaMm/xPIyiFgSWtD4g1T2DTpNhZjq7I1lFyr+RgGOeFMW
         6BEkRQKZqIYQ5JgfZqqOD38BmWQJzJzQWFIEK4qN1LELjraUeghL9LxZRthDBgrudf8T
         178w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871126; x=1784475926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WZHBBH+ENtj6q7i5GiJzA/uzY8S0pYXEvHqndwIIRnQ=;
        b=Ej0cKmidksp+nEg3V7Eov8+e2OVh8C0YGiQ6HHAN/rQcryb+WJfuxPE/C58+Fo+hU+
         uO49UfZFUrnvHoL42GbHXBjI924UHQwUa4YXi1ROJAwWIgVLB791LvxOCNC6LctRnbEK
         WDsSql0yZ1n+idxAHM4MjYZBCrJ9hCciSZdUjPJtrSTG1R7qzTp0sCTy+4F+L8jkS2Ym
         JTM9VSh5yPlUQ6lDrbtPUdEKVmdHF6Svieg9th86FEwDt7Du7VuJZOh9Ypp2fVYmjpzy
         gg753VjD26YLJb5gqSWmA/lVT2VaDnn1pbwtVddIkrShCk/uyDF7resgWegd6hVs0GTI
         Ht8Q==
X-Forwarded-Encrypted: i=1; AHgh+RrScWYrvHgqXGjkXxhjt1iElLEliBzWP3lvEX4c34+FFFmMP1H6Qhinxnu99KcIpMpR+ez4iXo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVWFBWJm9Np6jr6a95gK35MJly4s52w4cUdAljWvznbRC8qs9k
	Cj5L0x3+hHUNbCmkm6BuQactE5cA17GJqpTO1JEvInNpEwJ3MJWTwf55b+Q4cfGRJ0A=
X-Gm-Gg: AfdE7cnf6TuH3mVRyaG/OAKGvmFeZ1rMnXOhdjAsHA8AtPQ1EVtGtHfmgCq0yY5kiJR
	1krfxO2riTHfLI8md8AlwQ82rsCoRJGQThJQxarmnCQ+xIk8gbJF7sPmBLKhOHnKy7IhydhEgct
	FVSJ1plInquw5VNm6k8j9u7sJHwBvYcpN5ENsiSw+XM2zmCfBqH8AWDNhwSm82HpDUIaLQQzrOp
	Ksavy9wSYbLTg8vurqcoaipK9bAzfs9UBusJrDLMsBZWwtqAgMDMWBoQAesUwmXKLhr7JVQMIax
	0d13e4dy39XoJumW3s4DDg2AtsmKvhURPuvhHnRTmCOqk6TEEp4D5Cers+df6CASDbWUZjEdLtT
	MYDDFJFkRb3oK/7UcSVBChDGrPPNL5JWqGI+rxlBkUMEeGCFwLLcFq7y+Irtg8/8XLehbXNlInw
	1RwhJJD9WSlAMv50ggby5hPcb3R4r1rZYiVzmQQKD86R+97OvF7pICKtw10N1Ha1yyRePceRE+3
	oV739ukUgeZ
X-Received: by 2002:a05:620a:6017:b0:92e:c0ac:aeb4 with SMTP id af79cd13be357-92ef4109ce0mr592095785a.38.1783871126035;
        Sun, 12 Jul 2026 08:45:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:25 -0700 (PDT)
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
	gourry@gourry.net
Subject: [PATCH v7 06/10] mm/memory_hotplug: add offline_and_remove_memory_ranges()
Date: Sun, 12 Jul 2026 11:45:00 -0400
Message-ID: <20260712154505.3564379-7-gourry@gourry.net>
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

offline_and_remove_memory() handles a single contiguous range.

Callers that manage a device composed of several ranges (dax/kmem)
currently have to call it in a loop, which gives up atomicity.

In addition to pushing rollback logic into the driver, the lack
of atomicity creates a race condition between system daemons trying
to manage the same resource:

   - Manager 1:  Offlines memory blocks.    Removes device.
                                        ^^^^
   - Manager 2:  Detects offline memory blocks, re-onlines them.

Add offline_and_remove_memory_ranges(), which takes an array of ranges
and processes them as one operation under a single lock_device_hotplug():

  - Phase 1 offlines every block of every range.
  - Phase 2 removes the ranges only if all ranges are offline.
  - If any offline fails, the whole operation is reverted.

This gives callers all-or-nothing semantics for the offline step, so a
failed or interrupted unplug leaves the device in a consistent state.

This also resolves the battling managers race - the second manager's
operation simply fails when the block is destroyed / cannot be onlined.

offline_and_remove_memory() becomes a thin wrapper that passes its single
range to the new helper, so the offline/rollback logic lives in one place.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  8 +++
 mm/memory_hotplug.c            | 94 ++++++++++++++++++++++++----------
 2 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 593e42c221ada..645d781b36a6a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index aaee8470eb2ad..8bfcaa9517bf3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2430,58 +2430,98 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
  */
 int offline_and_remove_memory(u64 start, u64 size)
 {
-	const unsigned long mb_count = size / memory_block_size_bytes();
+	struct range range = {
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return offline_and_remove_memory_ranges(&range, 1);
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
+ * @ranges: array of physical address ranges to offline and remove
+ * @nr_ranges: number of entries in @ranges
+ *
+ * Offline and remove several memory ranges as one operation, serialized
+ * against other hotplug operations by a single lock_device_hotplug().
+ *
+ * This offlines all ranges before removing any of them.  If offlining any
+ * range fails, the entire process is reverted and nothing is removed.
+ * This provides a fully atomic semantic for unplugging an entire device.
+ *
+ * Each range must be memory-block aligned in start and size.
+ *
+ * Return: 0 on success, negative errno on failure (never positive).  On
+ * failure no range has been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	unsigned long mb_count = 0;
 	uint8_t *online_types, *tmp;
-	int rc;
+	unsigned int i;
+	int rc = 0;
 
-	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+	if (!ranges || !nr_ranges)
 		return -EINVAL;
 
+	for (i = 0; i < nr_ranges; i++) {
+		const u64 start = ranges[i].start;
+		const u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_count += size / memory_block_size_bytes();
+	}
+
 	/*
-	 * We'll remember the old online type of each memory block, so we can
-	 * try to revert whatever we did when offlining one memory block fails
-	 * after offlining some others succeeded.
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
 	 */
 	online_types = kmalloc_array(mb_count, sizeof(*online_types),
 				     GFP_KERNEL);
 	if (!online_types)
 		return -ENOMEM;
-	/*
-	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
-	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
-	 * try_reonline_memory_block().
-	 */
 	memset(online_types, MMOP_OFFLINE, mb_count);
 
 	lock_device_hotplug();
 
-	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
-
 	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
+	 * Phase 1: offline every block in every range.  An already-offline
+	 * block folds to success, so out-of-band offlining never blocks unplug.
 	 */
-	if (!rc) {
-		rc = try_remove_memory(start, size);
+	tmp = online_types;
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
 		if (rc)
-			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+			break;
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
+	/* If any failure occurred at all, rollback any changes and bail */
 	if (rc) {
 		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
+		goto out_unlock;
 	}
+
+	/* Phase 2: Remove. This should never fail holding the hotplug lock */
+	for (i = 0; i < nr_ranges; i++)
+		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i])));
+
+out_unlock:
 	unlock_device_hotplug();
 
 	kfree(online_types);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.53.0-Meta

