Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513631E834
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854343; cv=none; b=qEqRRNXsSjk8lESvo/UzHm0eaXSlOseoUC3z7ajVQUKou8EZAvgxe1YKa/6+jQes159WEMbTuxa+L6mawg1qy2cdEM7h7XPw79ovKh4oSLrf+HTw6TZHGeDCWScGR6Tk6oLUutVs817wMueD7XFwRCzW+dtrdXmYpN6opqnmNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854343; c=relaxed/simple;
	bh=rpppi1L4EyTdLWFQGiVuS22x/FK8l3zfXc2OeomuJHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUPlMMPTx0C13i/vHpkRmRu3XgnEjQcK2aq9Tl/QFmgZRthq280bGI8SHmAN4r30OFYP6ZRZWU93J7UCvZjUZNdczwocgNDAsCHpw1eShcAeUNDilL9wo80nH2SLirf+882HrhWaZBSFvO0tHyO1SVvSxJUhwq7pfjn3SdR+mPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=iFtqCQox; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="iFtqCQox"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e663c828dso94589485a.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854339; x=1783459139; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlH3KkL8/9MzSzFxKUCH14o1Ashb5MOZ1jESfo9s8Rg=;
        b=iFtqCQoxn5aTxwHC1Nblf96Jzh2s3b0XxIi29OdcBOs/Cz+tGV0i/fn+RBqe6dIRlz
         VT96qHkMmyKNNxgfHCfub+9QdwYj4p3P+KETSpBYOf6JL0yFuWM0IIgtT/z7b39D5iLN
         hGnTqxNY6flArX/4wK/9ee/NDSCG+DaiAA+zM5jbXE5Mp7xGKBEdzv8/CILmX4lpIVbj
         T1s6uD85YdVxkkVMxi3DFhHADxkzy3bWXUZ2OP6Ya2Vv472CsFRwpucb3zRQlTnfHw8m
         y3whyUOyNmM8yd9Rlfojh1X4mcrJRQB0NViq0vEefwLNuMhp0Q0oyGA4S6tWMczSwdsU
         C2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854339; x=1783459139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IlH3KkL8/9MzSzFxKUCH14o1Ashb5MOZ1jESfo9s8Rg=;
        b=ZwvFuoIs/j9eXWmn5eynl+rnScB2as7OeKiKjjxxzl4XlhTQiSSv8N+kueotUBDBtc
         juP62guh+ew3HjKcSrqpbKQlbWIJnOiHr+dgKptmo9Sq3BR+x3MQHY+Dfvzil9xkWrDN
         Kqerh5oMhG/C6QJujdXTsjRCu9TrWAxqYozS4L/7RJnef8Qm2KqhzKAJ6FvRoyaoFvDz
         gIt5bv1WmYJ3L7tXcNztcq77at3ufiXZYWecGHiMDJNBxZxDubjrn87uvruiSR6/AxXa
         PPHk/m+l5wNC2x6xWcwRA3P0pecxVmChSfd9ogEbu9CLJ2NCdg10VvQJwhZvvU2B5JjU
         a9Eg==
X-Gm-Message-State: AOJu0YzG1zw8A2xMaIx0O/QNHHc9cpY6DPXovcfakPiWT+XR7rnd+tRC
	XO3wx/+ZYsyrYEh6mBff4wF2pM33YYL4rYw7AsLxCSw5+m72GPJcfOT/vGnQY6wGqyk=
X-Gm-Gg: AfdE7cm1vGpvFDQMeD0nfoOAiE5pSQ9ztPSFQYMPnTsQ99E4IR9OmIEFF98iQ9YO64m
	aPA9QBKFpt+1TUbafM93EgTPQxSRpBrczuEjSKEbNrIXvKGHFyxmUvsLQ25P/rHCAl85xzTcFe+
	M4LIvP3PTaNe1XlkAC5xK2TJGU86qx3JvJozO5raHF2g/XSzZmALb4sepnCZljW7U/rnifrrOuJ
	0BbL9wJJwSKyMR21jX2KO4MhkuJZc033y1zj2v2KFTov0fHrEAr/LG/+ksyyoS9jsxJ/KG6R16r
	/d1Bx9ysXzxA7VTZqloCUBmysGloeJd3eBCtYRKln2eDU1BWOdBEOOuE2kKvtCGybKfGXQgubT3
	dk6voUpoAvEQY+umqv5AnTtuwKHqfib4aWcF57h8SkWNINLWC3UC5IUfj+tIcfu9fEfOAE4nwrw
	nDJXOAdq8TI96jATKYBNWlsvSRqtGS0LjBhhiD/frpdivh/fjoATJIz0d/OxVwg80io8DQv85YC
	g==
X-Received: by 2002:a05:620a:29cb:b0:92e:5b63:224e with SMTP id af79cd13be357-92e697c18camr444975285a.22.1782854339094;
        Tue, 30 Jun 2026 14:18:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:58 -0700 (PDT)
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
	apopple@nvidia.com
Subject: [PATCH v6 06/10] mm/memory_hotplug: add offline_and_remove_memory_ranges()
Date: Tue, 30 Jun 2026 17:18:38 -0400
Message-ID: <20260630211842.2252800-7-gourry@gourry.net>
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
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  8 +++
 mm/memory_hotplug.c            | 93 ++++++++++++++++++++++++----------
 2 files changed, 73 insertions(+), 28 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index ff3b865ea7e7..db10d50f30ae 100644
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
index a66346def504..3225364bec2f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2429,58 +2429,95 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
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
+ * Return: 0 on success, negative errno otherwise.  On failure no range has
+ * been removed.
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
 
+	/* Phase 1: offline every block in every range. */
 	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
-
-	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
-	 */
-	if (!rc) {
-		rc = try_remove_memory(start, size);
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

