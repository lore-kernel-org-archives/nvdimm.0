Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6541DF759
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133428; cv=none; b=sDb0mt/EKlX9IuXFf/mo+TODqSD97B79VlQYOH8NK4nwmZA89+675dRS2Z8JuJ4Va13wumpIzvDb+6H6RzQ/qGL7bmTCP52jG069G03M9j+N+yOo9IIsizsL+oJIvgeGWHYxDahLQoXBsTmORn+bKyFzwxqnrzXAsUXbdPjcTpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133428; c=relaxed/simple;
	bh=lYRkZhQBY7rM54PhCzUAs0b0+r6IE+g4xglvZLomP+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rVnAuyR6wIW9EPGOD/6pLtlQ8xmlBrZphHEOWgfmcVzVcdU0jc03yYZChHUS+zjDiTCpy1NjrNFjUVoscfU1SGzGPY/wO59RI+FVPZ3+vyfmKLJfiFd9SBmAYvIGIV0YPvNysg2sm+kYBKBSr9uk0Mf/rgeNf1OCFmK/JAN7fdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h1N7JdR/; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h1N7JdR/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749133423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1M2tBKBbeKXLu/4cIvcX9m56b7K69DMomtz0rxWRMM=;
	b=h1N7JdR/z8i7fN6fyDQyTP4xFykrTDLCgE3sGXG529h7G/cm4MZOabq56va9ibi5nYzmFU
	jjMvPrqIYrFv8myNEwBu4nV8E/uckVRIxvWIzhDar87EgFwppJduht/HfabO66oepwQUf8
	d9ELrFuv+z3vwgls8y9HvyBd1dLRrPA=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	Jonathan.Cameron@Huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 01/11] dm-pcache: add pcache_internal.h
Date: Thu,  5 Jun 2025 14:22:56 +0000
Message-Id: <20250605142306.1930831-2-dongsheng.yang@linux.dev>
In-Reply-To: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Consolidate common PCACHE helpers into a new header so that subsequent
patches can include them without repeating boiler-plate.

- Logging macros with unified prefix and location info.
- Common constants (KB/MB helpers, metadata replica count, CRC seed).
- On-disk metadata header definition and CRC helper.
- Sequence-number comparison that handles wrap-around.
- pcache_meta_find_latest() to pick the newest valid metadata copy.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/pcache_internal.h | 116 +++++++++++++++++++++++++
 1 file changed, 116 insertions(+)
 create mode 100644 drivers/md/dm-pcache/pcache_internal.h

diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
new file mode 100644
index 000000000000..389d1fa667c9
--- /dev/null
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_INTERNAL_H
+#define _PCACHE_INTERNAL_H
+
+#include <linux/delay.h>
+#include <linux/crc32.h>
+
+#define pcache_err(fmt, ...)							\
+	pr_err("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_info(fmt, ...)							\
+	pr_info("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_debug(fmt, ...)							\
+	pr_debug("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+
+#define PCACHE_KB			(1024ULL)
+#define PCACHE_MB			(1024 * PCACHE_KB)
+
+/* Maximum number of metadata indices */
+#define PCACHE_META_INDEX_MAX		2
+
+#define PCACHE_CRC_SEED			0x3B15A
+/*
+ * struct pcache_meta_header - PCACHE metadata header structure
+ * @crc: CRC checksum for validating metadata integrity.
+ * @seq: Sequence number to track metadata updates.
+ * @version: Metadata version.
+ * @res: Reserved space for future use.
+ */
+struct pcache_meta_header {
+	__u32 crc;
+	__u8  seq;
+	__u8  version;
+	__u16 res;
+};
+
+/*
+ * pcache_meta_crc - Calculate CRC for the given metadata header.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of the metadata structure.
+ *
+ * Returns the CRC checksum calculated by excluding the CRC field itself.
+ */
+static inline u32 pcache_meta_crc(struct pcache_meta_header *header, u32 meta_size)
+{
+	return crc32(PCACHE_CRC_SEED, (void *)header + 4, meta_size - 4);
+}
+
+/*
+ * pcache_meta_seq_after - Check if a sequence number is more recent, accounting for overflow.
+ * @seq1: First sequence number.
+ * @seq2: Second sequence number.
+ *
+ * Determines if @seq1 is more recent than @seq2 by calculating the signed
+ * difference between them. This approach allows handling sequence number
+ * overflow correctly because the difference wraps naturally, and any value
+ * greater than zero indicates that @seq1 is "after" @seq2. This method
+ * assumes 8-bit unsigned sequence numbers, where the difference wraps
+ * around if seq1 overflows past seq2.
+ *
+ * Returns:
+ *   - true if @seq1 is more recent than @seq2, indicating it comes "after"
+ *   - false otherwise.
+ */
+static inline bool pcache_meta_seq_after(u8 seq1, u8 seq2)
+{
+	return (s8)(seq1 - seq2) > 0;
+}
+
+/*
+ * pcache_meta_find_latest - Find the latest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Finds the latest valid metadata by checking sequence numbers. If a
+ * valid entry with the highest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_header *header,
+					u32 meta_size, u32 meta_max_size,
+					void *meta_ret)
+{
+	struct pcache_meta_header *meta, *latest = NULL;
+	u32 i, seq_latest = 0;
+	void *meta_addr;
+
+	meta = meta_ret;
+
+	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
+		meta_addr = (void *)header + (i * meta_max_size);
+		if (copy_mc_to_kernel(meta, meta_addr, meta_size)) {
+			pcache_err("hardware memory error when copy meta");
+			return ERR_PTR(-EIO);
+		}
+
+		/* Skip if CRC check fails */
+		if (meta->crc != pcache_meta_crc(meta, meta_size))
+			continue;
+
+		/* Update latest if a more recent sequence is found */
+		if (!latest || pcache_meta_seq_after(meta->seq, seq_latest)) {
+			seq_latest = meta->seq;
+			latest = (void *)header + (i * meta_max_size);
+		}
+	}
+
+	if (latest) {
+		if (copy_mc_to_kernel(meta_ret, latest, meta_size)) {
+			pcache_err("hardware memory error");
+			return ERR_PTR(-EIO);
+		}
+	}
+
+	return latest;
+}
+
+#endif /* _PCACHE_INTERNAL_H */
-- 
2.34.1

