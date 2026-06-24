Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1E73D9DBE
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313088; cv=none; b=G+nHwAEgNALJzq3MPj03+Sguo1u4ZyrIQoX/Mi2/p1z2mVcsi85gNQ7GQ2try7TT4h0XChGU9lZ2TwklwZ7z427EVxJs94CzTbPfIbnKoI+ATb5gK34OKGYbV9PHnfGWEqnnoy7YkW0gN/xEYHailJgUXu1zareUU5vb4tDLoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313088; c=relaxed/simple;
	bh=1SN6XJVoKoHKUZTH//sJI/EbzT5E03VpQ6l9/BnrPjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozwicL+t3rXl3DTEaskfpK8qcrst7lZQ3wQGNEhvf8SJ2BzKDmUoPZgvRamwQ9Oy3K6uAcMYjaQZIdp+fBqqcQiK1TIjP7poRjE0kkLaJdfB5nRVWqoOMmSOgTf4T8+YTIRrNcEKLZFIfbe+iyQvafLJe312dpdZYxqy0zyydkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=sSPbxh9w; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="sSPbxh9w"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51a0188b92fso11689661cf.3
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313085; x=1782917885; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LbNsCaF8AqQRerBXt6jCH2X6FSKJPEhWXxoYu5Er/s=;
        b=sSPbxh9wLJPutPiw+JgygJXfnTyrzMrp1dj0UmgumjtfTzauwSDvgAQfJgYfLxdLGz
         yrZetJ5JSWG1bF364Mwi6JQXBwM3awrRs0WbVUFuRGuhNXeT0on7nqrHN2CZ+jWD2sjA
         WiZyY9DKU4tjECFWWkzM132rpmmVhO2qVcPLmaSiwznpfdoj1MgminjbFEeJWDCiltvX
         2n2HQUnrZCDvK27rEbJ9uIPq8ZY/VjLKaGXi58YRfZTkwCNtA/4lOhP2S7YzIPQGDUHl
         bmDR+vDzFYlLtCAumYnBAJimo/Vi4XPw6i2Yw9RtxeEggwuyzYcCYWF946Szmbl1Pgsk
         scNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313085; x=1782917885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+LbNsCaF8AqQRerBXt6jCH2X6FSKJPEhWXxoYu5Er/s=;
        b=jOtmPOTGHT6oTBziqhaHtNcdxjJArehpbx8V1pfW23MahGT4wbjhhvGR346S3wCkSj
         51Ldw5qgIUw4RJXuhvR7YXY04y+XVtxYzZM6oqcMwcsFUruFwJcFGDziyySfSG3HWMSn
         fU8Dt9TeFxpmJ/ltn7/GXLXNygd2/hkaJKLwoZ8ZJ5QGjumSUCMTS7fg2d8fl0QaS8nY
         9IklAPgWcRR1vmw7lCaemPWKfrzFC4qY6sopIAuWRf+AdoBolMa0bH+aYIwHfoi6idY5
         OEwHxGP2ZZsoQuh7lP8wju5YTJMtGF0MXM1ScfMFvMo89llwY2DKtdehHXm1A7yu/oTj
         9oAA==
X-Forwarded-Encrypted: i=1; AFNElJ/fkFzT5jkTT0Fxnllp72uFGTAvbpRbrB+vCqnWGK4d1UW+3If4pz5ZtSoXClf1n1JG8DKIbDI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0DCJgE7shZdgvMGVXiIxdEh1B/DJNTQxohnf3gVJFdTL4T9Lq
	LgBhfxWwMcIIyG546OdtWODhf6ffLz06GtRWfiH9kNvJ3sxVnTJF1R5B0+adMbuLb+0=
X-Gm-Gg: AfdE7cm/Ua6mK0t4P0GkLqluzEN1mDV6EksPxszZVspwKAX3GxT0Wy2cvMG+8cGbmqV
	aFbuVqSakNI98OJWzOGxpy/br60J8C21TyBvzQtWJys9y9h9hnnFVm9Yf+pG4DJ8frVBMYr5snl
	Wo1jfCyRhC3b0481fDCtFAbF9j+n3/iBxk3dEMKA0cHtSCdxI695lVLPMp79PMm5diqe1t5nW5A
	es5omNTbUqx+ChRfXo2ZAnZSOfSo1DVpwueJvLE4gLn12neUHK/SC9W1mHuqI9c2PKokth4h9rp
	AGSvhz+1qe8QEGENrC6/QKK1p9lweFWkYuUQvL5lgrPEtVUEkFEYQtgCug70E9wZ+/ChnaUyFEA
	ZZftA37ne3hPKWN4wb6asbWs1iyFfnEI01A/88V/rQYaG8hnf0/hbc2DXk1WrY/qkDMpjyl2602
	4HzgReg525PjDS/0Oy+IPob0+ziDB4OCswjQFK0fF0u6wWUSWjH2F3MBPJ8ogC104GkQvm5M9xS
	g==
X-Received: by 2002:a05:622a:2297:b0:50e:6182:b4c with SMTP id d75a77b69052e-51a61e49d5emr54674141cf.25.1782313085460;
        Wed, 24 Jun 2026 07:58:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 5/9] mm/memory_hotplug: offline_and_remove_memory_ranges()
Date: Wed, 24 Jun 2026 10:57:40 -0400
Message-ID: <20260624145744.3532049-6-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
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
 include/linux/memory_hotplug.h |  7 +++
 mm/memory_hotplug.c            | 94 ++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 27 deletions(-)

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
index a66346def504..7d56e0c6ede0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2429,58 +2429,98 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
  */
 int offline_and_remove_memory(u64 start, u64 size)
 {
-	const unsigned long mb_count = size / memory_block_size_bytes();
+	struct range range = { .start = start, .end = start + size - 1 };
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
+int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
+{
+	unsigned long mb_total = 0;
 	uint8_t *online_types, *tmp;
-	int rc;
+	int i, rc = 0;
 
-	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+	if (!ranges || nr_ranges <= 0)
 		return -EINVAL;
 
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
 	/*
-	 * We'll remember the old online type of each memory block, so we can
-	 * try to revert whatever we did when offlining one memory block fails
-	 * after offlining some others succeeded.
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
 	 */
-	online_types = kmalloc_array(mb_count, sizeof(*online_types),
+	online_types = kmalloc_array(mb_total, sizeof(*online_types),
 				     GFP_KERNEL);
 	if (!online_types)
 		return -ENOMEM;
-	/*
-	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
-	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
-	 * try_reonline_memory_block().
-	 */
-	memset(online_types, MMOP_OFFLINE, mb_count);
+	memset(online_types, MMOP_OFFLINE, mb_total);
 
 	lock_device_hotplug();
 
+	/* Phase 1: offline every block in every range. */
 	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
+		if (rc)
+			break;
+	}
 
 	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
+	 * Phase 2: Remove each range. This essentially cannot fail as we hold
+	 * the hotplug lock . WARN if that assumption is ever broken.
 	 */
 	if (!rc) {
-		rc = try_remove_memory(start, size);
-		if (rc)
-			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+		for (i = 0; i < nr_ranges; i++) {
+			rc = try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i]));
+			if (WARN_ON_ONCE(rc)) {
+				pr_err("%s: Failed to remove memory: %d",
+				       __func__, rc);
+				break;
+			}
+		}
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
+	/* On fail: roll back. Blocks that were already offline are skipped */
 	if (rc) {
 		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
 	}
 	unlock_device_hotplug();
 
 	kfree(online_types);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.54.0

