Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B7027AC2E
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871516; cv=none; b=D0nKgaWq9bOdBPa4Kjk9QgjyVSULcPCoa7DUwd2/0BMRzaIiW2PHVeJVQps2C60YqYcf510AlHxTCkZc7Xi3VDLl8mz6R2eytfmKlssWIUX/+WCeE0R6H3RMCzJiIg2seUTgJtghmK5huKkiUaOAjLT1F1mFkoqpEEYCev5i9Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871516; c=relaxed/simple;
	bh=FATaHSYkQKTtWt9pSwK+X/lCfYVbu/ZC1K1hdRMeA8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulxZkMfAE/cRkv1XcmJG4oVsFA/asot/quoG7TBEo/w20AEEpxIIFXdbE2LcGqaaR+uGK2OPavgCL7WNWUFxbFvFSRtrf+PzzEcPysXemQl07GXz7a7CtWybqr4Wa6f3IKTOCt+++8u2AMWtKyzLt5/m9lsCgV5M9FxTwjowtWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qde3l70b; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qde3l70b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mnhGELqlFAoDw+QfbOprESKx0FUv4r2hl6H/rVUFq1U=;
	b=Qde3l70bsXDB6SHohpwBCvapDvpFCkGzPDf48e8NJHyK+dybmEZBbFqKCQ8Ixpl6Q4v1Ji
	q6PMd87lC433+/tvgupyaX8WOTZRDz4fYZCnjhwzfKPR0aoiyGOxpkoCgtbriOR/VN8iF3
	OA/vZ+rZJMFlEmF7LnYwCwBbKXb9yXk=
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
Subject: [PATCH v2 01/11] dm-pcache: add pcache_internal.h
Date: Mon,  7 Jul 2025 06:57:59 +0000
Message-ID: <20250707065809.437589-2-dongsheng.yang@linux.dev>
In-Reply-To: <20250707065809.437589-1-dongsheng.yang@linux.dev>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
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
 drivers/md/dm-pcache/pcache_internal.h | 117 +++++++++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 drivers/md/dm-pcache/pcache_internal.h

diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
new file mode 100644
index 000000000000..d427e534727c
--- /dev/null
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -0,0 +1,117 @@
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
+		/* Skip if CRC check fails, which means corrupted */
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
+	if (!latest)
+		return NULL;
+
+	if (copy_mc_to_kernel(meta_ret, latest, meta_size)) {
+		pcache_err("hardware memory error");
+		return ERR_PTR(-EIO);
+	}
+
+	return latest;
+}
+
+#endif /* _PCACHE_INTERNAL_H */
-- 
2.43.0

