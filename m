Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9335B25229C
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750750462; cv=none; b=Jksf3ALnJmJii9qRYPmvFrG1mNJRO98pMctQlpDMncpWknEohzcQMq312aqrmbMOyWW39kDNx6xIaqBmnT1I8BRBPHpioQHU31zy6E+4lGdQ/j9hJ8fV2GVghTI7q0W50ZJlnaMlms17+Qmu5l8hopDKM29YXF3MjhJegOe1PbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750750462; c=relaxed/simple;
	bh=YTXRCkvu7qSZ/EDO3CbMr8KTG59gWoO+OL9yjRDnS20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMm96KNGiNjhU7nA7cfglA1H9ed/tCu2S4JGmvYRpJ747tmP5+1XKNDw4hL8BzVHGL3c3rxCYJnKaSb45q97ljkPN4UF4aIsLYpA4ynuGT2UcIxHdUP916ZhLovX6jBVOuXUNk7LHMxwkAWgR0fitoXz1NYrq3zgl14L13ShHEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WBp45qX8; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WBp45qX8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750750456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YQ6o0gaAmTShG6pgXKTsFdI+bf++XYLB8FSp+/GC1c=;
	b=WBp45qX8iJNubO30r1BQXDfA0jQdD7M633OBgLxIHab96qkHzFetiMrytfqmQimesVXVbV
	LUfl7fUDW4cbjGluGqFUWP7sd+cZAT/XKDWVl+BNxJkgKDKpRPd4pD4wXZDWL+7JbPmRnb
	7Eu4QjtBkplKUap9Lj+keOR1FhgA2MU=
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
Subject: [PATCH v1 01/11] dm-pcache: add pcache_internal.h
Date: Tue, 24 Jun 2025 07:33:48 +0000
Message-ID: <20250624073359.2041340-2-dongsheng.yang@linux.dev>
In-Reply-To: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
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
index 000000000000..4d3b55a22638
--- /dev/null
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_INTERNAL_H
+#define _PCACHE_INTERNAL_H
+
+#include <linux/delay.h>
+#include <linux/crc32c.h>
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
+	return crc32c(PCACHE_CRC_SEED, (void *)header + 4, meta_size - 4);
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
2.43.0

