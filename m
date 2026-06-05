Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346773C4561
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694369; cv=none; b=oeIrQF3OWDvzTM0M/xkZl5BRhWwkaXX2rek/8fngAIEhXk0ZUk0RR4x6wwjmqnhhaOYAuIzPE9JbCc8Bf6DupfXfseGBU/vUZ57kYvI16vL7k0YjK0wXZHXmmrJKVYbXbUzlv/ItVTldcu2ZvD5C7Grdvs+6JmGoi7joTGvdGD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694369; c=relaxed/simple;
	bh=8XSA39MWql4+HD8uM30BGvMeffgmWZcxL5DHKZ0ylW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh1ZU8/VxGziwEuxMOVhSlwQ9Wby+SPSW51zd7p+Y7XqeCoC4wmjTuDp1YOE3MXh89YNIUN2WBfyX+Ak4cMMw4r+x/kEE3LEwmzpAXiHYBaXagJAsi0bcKUgBF8LgkQVdAqDg4J7/vV1Afq/3rI5U0deBs36HDodXuxIP+58LhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=IHMlRkjv; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="IHMlRkjv"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ccdf8d4ac5so26223456d6.1
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694366; x=1781299166; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JknNzkAaj+qc6G+hjBE1CQp9oF9WvErr7R4W+FLnrFQ=;
        b=IHMlRkjvERgu5wmw1CMgxuNIsVhoycWtdoMaGBQT6Z3hcb1mQbM9ZgG8lnEDzfqj2b
         K2j+uRoM4OVd6LrtYwkKFhyaD+eoVfxwSj4ILdnTqqoy9ohtuE6MQIucCUdnLWxEpno2
         OT6ZKOXzg1xt2KpaH+sQ/gkCBXH7x+TkFLqr96kAD52/Fo2ispv0+K8MEYUS3FhzxBt4
         weNY2Qz6l3+cQKgkJTdnb30cCN5GM0B3lzBUZy0MngQYItpaUnFey8w6gPprP4rJ5pZC
         cOg/9aIpxQP5aHPXSBjXmFfDD43KC/e6D4G6cZsGfrNtst1Zb4OI+77q5NQFBZrWP6IN
         iTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694366; x=1781299166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JknNzkAaj+qc6G+hjBE1CQp9oF9WvErr7R4W+FLnrFQ=;
        b=mx69UGk+pjePKVxrcH3v97eSgHPrYQJw1CETjfccsax2N+4q/HMh85sw/JC4j93hHY
         W1h8e6l1sqOiGLgmFhnUpdaWmXmpXbZTIonn5rkddG8Rt8K3n9G2nUtMr2ZMvaEiET6+
         KzSpIkd0XmrUdM0QXPjXlp+M8oxkR3Ib/HBPv1gGU3jgLL3D/qRdFT/zTHDVniWr5+Iy
         1GuEAp3wAXDEaiC3qQqxSpkp4HwjHHXwnCnM1V7MCRGzjpdI0b1VfO0PVVf9gbvMGRYf
         S8YIzWzpwhW6Mo0SnNRNKNR3q5f+xWuDdSk9oPbOayEEStWzLrxuUwiPauaAksIcgToa
         pjig==
X-Forwarded-Encrypted: i=1; AFNElJ8rl65xmRwh8Swwo4O9GgbLFn/MzFJEDaUf9YjDngmatgvkbAbHygeNwN1AQRn+R+6Wd6EVio8=@lists.linux.dev
X-Gm-Message-State: AOJu0YziS3pGWdEuHV7Mqg7JL20sHccmEFOOekJrptvdd2ysdwxbgVno
	Yxurw3/SFvaGTE6f6X39FKJcFfxH7mYm5UzeDAfRi7ezxZ9g6HLmnO0HZUyar8G+whM=
X-Gm-Gg: Acq92OGAC+Rf5An+DlZxqyzeX/IJ+u/VngmHEM+pmXiNbxqAcD56FEGOF0emLAF/pl0
	srPMC3jJQo7pDW6ctD+rOjENG0uQhYAJBJv9iqd5MKcr+nzTcsFkXNZZoErBvko8DaJGYjmydGr
	AtoZWIJhOYNtAL2caEeupJA8jGWyvkEQFk478m2cSWaBbzzb+gNpl2OM1Ejhe92jw0DIrN3Alu7
	sWzyZT9dEX58NZmo8+t1+T2YaerA3rZEsMY1SbAKquONlq1Y0uSuRhBIIzxzikNz6f0V6lKDSU3
	YKwWJ+rDnqIKCDqc5nwnUK74ZekrxySZukyf6EMxvnmOJbF8279X/G4i4mz4yPs05QFLSuS5ijn
	ntg0InpxPWpEDjn7DM+Av2No0DEw9nvCa/57hsgG53o89ODcRm51cYzUmBYL0/G43MdLo9AAqsr
	3cVzJisF+axKZld7Rj4iOmPpE8vCBUpG5thdr5bvaDvcf4iqMA9chnBZcdCG6vxCgUeG7i0wTjO
	o3FmDCE5ZYTJndqWc8S3kM=
X-Received: by 2002:a05:6214:4ed0:b0:8cc:dd20:7a46 with SMTP id 6a1803df08f44-8cee6137878mr86899206d6.37.1780694366285;
        Fri, 05 Jun 2026 14:19:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:25 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 5/9] mm/memory_hotplug: add multi-range hotunplug
Date: Fri,  5 Jun 2026 22:19:07 +0100
Message-ID: <20260605211911.2160954-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

offline_and_remove_memory() handles a single contiguous range.

Callers that manage a device composed of several ranges (e.g. dax/kmem)
currently have to call it in a loop, which gives up atomicity.

This creates a race condition where another daemon can online a block
that was just offlined while other blocks are being offlined, causing
the eventual (original) unplug operation to fail.

Add offline_and_remove_memory_ranges(), which takes an array of ranges
and processes them as one operation under a single lock_device_hotplug():

  - Phase 1 offlines every block of every range, remembering each block's
    previous online type.
  - Phase 2 removes the ranges only once all of them are offline.
  - If any offline fails, the offlining done so far is reverted and
    nothing is removed.

This gives callers all-or-nothing semantics for the offline step, so a
failed or interrupted unplug leaves every range online as before rather
than in an inconsistent partially-removed state.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  7 +++
 mm/memory_hotplug.c            | 95 ++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d3edeb80aadb..7f1da7c428dc 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -267,6 +267,7 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+						   int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7d145217adc6..e486d35c22b2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2483,4 +2483,99 @@ int offline_and_remove_memory(u64 start, u64 size)
 	return rc;
 }
 EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
+ * @ranges: array of physical address ranges to offline and remove
+ * @nr_ranges: number of entries in @ranges
+ *
+ * Offline and remove several memory ranges as one operation, serialized
+ * against other hotplug operations by a single lock_device_hotplug().
+ *
+ * Unlike calling offline_and_remove_memory() in a loop, this offlines *all*
+ * ranges before removing any of them.  If offlining any range fails, the
+ * offlining of the ranges processed so far is reverted and nothing is
+ * removed, leaving every range online as it was before the call.  This gives
+ * callers all-or-nothing semantics for the offline step, so a failed unplug
+ * does not leave a device split between online and removed ranges.
+ *
+ * Each range must be memory-block aligned in start and size.
+ *
+ * Return: 0 on success, negative errno otherwise.  On failure no range has
+ * been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
+{
+	unsigned long mb_total = 0;
+	uint8_t *online_types, *tmp;
+	int i, rc = 0;
+
+	if (!ranges || nr_ranges <= 0)
+		return -EINVAL;
+
+	for (i = 0; i < nr_ranges; i++) {
+		u64 start = ranges[i].start;
+		u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_total += size / memory_block_size_bytes();
+	}
+
+	/*
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
+	 */
+	online_types = kmalloc_array(mb_total, sizeof(*online_types),
+				     GFP_KERNEL);
+	if (!online_types)
+		return -ENOMEM;
+	memset(online_types, MMOP_OFFLINE, mb_total);
+
+	lock_device_hotplug();
+
+	/* Phase 1: offline every block in every range. */
+	tmp = online_types;
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
+		if (rc)
+			break;
+	}
+
+	/*
+	 * Phase 2: only once everything is offline, remove it.  This cannot
+	 * fail as the memory can no longer be onlined in the meantime.
+	 */
+	if (!rc) {
+		for (i = 0; i < nr_ranges; i++) {
+			rc = try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i]));
+			if (rc) {
+				pr_err("%s: Failed to remove memory: %d",
+				       __func__, rc);
+				break;
+			}
+		}
+	}
+
+	/*
+	 * Roll back the offlining if anything failed.  Blocks we never offlined
+	 * are marked MMOP_OFFLINE and skipped by try_reonline_memory_block().
+	 */
+	if (rc) {
+		tmp = online_types;
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
+	}
+	unlock_device_hotplug();
+
+	kfree(online_types);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.54.0

