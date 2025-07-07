Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672427D773
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871536; cv=none; b=em8TwPwyUuOABcaqDv6Yr7TzZNy90vWO4j2AjyC2gdOZRQ8TbIbqReV9hQWw9diGeMjKDFqdWuRaSy83fezOMFOBkWukSwGvRY5MPl/MXmk/PTDFLQuwWBUpjM7//duTdX9ttj5Bvjmnq9wEr8YesElKP1f/9PnoSTQM3RSXVMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871536; c=relaxed/simple;
	bh=ot1HrIYVODNI7Mpms/ts/9xjJzQcl6zJQJoFhEmyi4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvDM1VD7h2GRCsFxErB9Dlq1J1uoavUW8IkSvYiq/Et2Uqc1zdnv5gsAQx5w/X69T8KkN9svNf+TwZ2HX5j0W3YPjNSCT3TbVA9jFD2mH+h20jnRdmG/Cx/4pKNmyktcg+kWnw0hOVmyPvh3flG3PRBJwjz0sUAkWlYee8jpm6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wflk3b1Z; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wflk3b1Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1k4ThIK6HiFXxzP6uiT8FVeRFHMtgqKY+36f0fU2iaM=;
	b=wflk3b1ZS/QXNxmTbqXLvbBK6/vSkILkkH4i7CfThU5Cdsgu4nCSkBxaZk3jzUQ7eLww13
	Z+YD9fit8Z/2Z4mm3ruy5cscMCYbXFb+wVdqXpb7hOjGcUHjKTo0hbbxx4pUCV3pjEljd4
	DnB9m6cfWQCL7FEuTXN8mlOOK6ULMI4=
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
Subject: [PATCH v2 04/11] dm-pcache: add segment layer
Date: Mon,  7 Jul 2025 06:58:02 +0000
Message-ID: <20250707065809.437589-5-dongsheng.yang@linux.dev>
In-Reply-To: <20250707065809.437589-1-dongsheng.yang@linux.dev>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce segment.{c,h}, an internal abstraction that encapsulates
everything related to a single pcache *segment* (the fixed-size
allocation unit stored on the cache-device).

* On-disk metadata (`struct pcache_segment_info`)
  - Embedded `struct pcache_meta_header` for CRC/sequence handling.
  - `flags` field encodes a “has-next” bit and a 4-bit *type* class
    (`CACHE_DATA` added as the first type).

* Initialisation
  - `pcache_segment_init()` populates the in-memory
    `struct pcache_segment` from a given segment id, data offset and
    metadata pointer, computing the usable `data_size` and virtual
    address within the DAX mapping.

* IO helpers
  - `segment_copy_to_bio()` / `segment_copy_from_bio()` move data
    between pmem and a bio, using `_copy_mc_to_iter()` and
    `_copy_from_iter_flushcache()` to tolerate hw memory errors and
    ensure durability.
  - `segment_pos_advance()` advances an internal offset while staying
    inside the segment’s data area.

These helpers allow upper layers (cache key management, write-back
logic, GC, etc.) to treat a segment as a contiguous byte array without
knowing about DAX mappings or persistence details.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/segment.c | 61 ++++++++++++++++++++++++++++
 drivers/md/dm-pcache/segment.h | 73 ++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)
 create mode 100644 drivers/md/dm-pcache/segment.c
 create mode 100644 drivers/md/dm-pcache/segment.h

diff --git a/drivers/md/dm-pcache/segment.c b/drivers/md/dm-pcache/segment.c
new file mode 100644
index 000000000000..7e9818701445
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dax.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "segment.h"
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *src;
+
+	iov_iter_bvec(&iter, ITER_DEST, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	src = segment->data + data_off;
+	copied = _copy_mc_to_iter(src, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+
+	return 0;
+}
+
+int segment_copy_from_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *dst;
+
+	iov_iter_bvec(&iter, ITER_SOURCE, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	dst = segment->data + data_off;
+	copied = _copy_from_iter_flushcache(dst, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+	pmem_wmb();
+
+	return 0;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options)
+{
+	segment->seg_info = options->seg_info;
+	segment_info_set_type(segment->seg_info, options->type);
+
+	segment->cache_dev = cache_dev;
+	segment->seg_id = options->seg_id;
+	segment->data_size = PCACHE_SEG_SIZE - options->data_off;
+	segment->data = CACHE_DEV_SEGMENT(cache_dev, options->seg_id) + options->data_off;
+}
diff --git a/drivers/md/dm-pcache/segment.h b/drivers/md/dm-pcache/segment.h
new file mode 100644
index 000000000000..cab53504f1d7
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_SEGMENT_H
+#define _PCACHE_SEGMENT_H
+
+#include <linux/bio.h>
+
+#include "pcache_internal.h"
+
+struct pcache_segment_info {
+	struct pcache_meta_header	header;
+	__u32			flags;
+	__u32			next_seg;
+};
+
+#define PCACHE_SEG_INFO_FLAGS_HAS_NEXT		BIT(0)
+
+#define PCACHE_SEG_INFO_FLAGS_TYPE_MASK         GENMASK(4, 1)
+#define PCACHE_SEGMENT_TYPE_CACHE_DATA		1
+
+static inline bool segment_info_has_next(struct pcache_segment_info *seg_info)
+{
+	return (seg_info->flags & PCACHE_SEG_INFO_FLAGS_HAS_NEXT);
+}
+
+static inline void segment_info_set_type(struct pcache_segment_info *seg_info, u8 type)
+{
+	seg_info->flags &= ~PCACHE_SEG_INFO_FLAGS_TYPE_MASK;
+	seg_info->flags |= FIELD_PREP(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, type);
+}
+
+static inline u8 segment_info_get_type(struct pcache_segment_info *seg_info)
+{
+	return FIELD_GET(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, seg_info->flags);
+}
+
+struct pcache_segment_pos {
+	struct pcache_segment	*segment;	/* Segment associated with the position */
+	u32			off;		/* Offset within the segment */
+};
+
+struct pcache_segment_init_options {
+	u8			type;
+	u32			seg_id;
+	u32			data_off;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+struct pcache_segment {
+	struct pcache_cache_dev	*cache_dev;
+
+	void			*data;
+	u32			data_size;
+	u32			seg_id;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		      u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+int segment_copy_from_bio(struct pcache_segment *segment,
+			u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+
+static inline void segment_pos_advance(struct pcache_segment_pos *seg_pos, u32 len)
+{
+	BUG_ON(seg_pos->off + len > seg_pos->segment->data_size);
+
+	seg_pos->off += len;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options);
+#endif /* _PCACHE_SEGMENT_H */
-- 
2.43.0

