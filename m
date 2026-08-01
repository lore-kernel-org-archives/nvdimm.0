Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEBB35C19D
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599260; cv=none; b=NZyKnGd5DcUpi4LewoN0dIk/dD9Z9aUafksT/m1h9eRvSsU6XDw4ODEkY5gVQ1r9qRY0qvwgWJmmFkx2xU9jqDtSh6fQPFddEV8G3nQmdtdXeu3pTg16h9Njrn3bAAWHlVvmJE9EWVWmGt+mrOtHyC5d7uMKzJRDnJxGpP2isDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599260; c=relaxed/simple;
	bh=Sk885w4deQUdDIZkngs+gEwd3P7jw50PmIJ0N6VNkjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTMsMaRMCxCVKPyqk+Ty3SMWJWxPIoaQKOL7cCWgqi69/DUEiChMK6WYBfBaWoAw+8zx3XWS/D8k9UJqv80kCyudNfP7ovKzEuh0axDrqKgYQSfz1FsNpFdiISwPdVltnBxBZ7fWzOeGz8yIISO3iPuJ3thC5T+HixRIxD9xoC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMSivQfM; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMSivQfM"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cee9b74ee1so15558645ad.3
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599255; x=1786204055; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JlAMfxnCI+4aukUkFCGEvLd7cna91lGu4ajCL8U6GrU=;
        b=GMSivQfMoHmwe1LOdPPB092CQGlX2fEBm/5QqEKIOdKI+y+erFgmVpfvDnLHf8TAV1
         QL2MWmKYCAo/8XcsXba+8FK6ivpzHjyH4/IA1OMkmKFx8y5PLVL90YACu26P/NAMOu1m
         iXcQJmdKWAL7Drkvs2gF/8I7r+38DmZ+grTD0YF4VorfZ5xKSksXcWWP1Dg0BQ/idLbB
         cWnqS8U8ycw5ILuboYOjbcMJopocDRpy/K6KLQOO1aVwP+iihN8xWQz5+9O+9otuyDrl
         q0TadY+3Jo2wjR2oHn7tJksXJBgOfUO6/NTajBqWPHXdoONs4T3EBiynL4/s4eZLQQJl
         wYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599255; x=1786204055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JlAMfxnCI+4aukUkFCGEvLd7cna91lGu4ajCL8U6GrU=;
        b=mkOZSVwd6WhjS650oCM+aR14FZDql46W60eo/zvjSyxbP+W9M2q04RnT4hOvgci5mz
         1fcoHRFOPgPhBLlubNXJzFMaJn3y1JCobp8N7Rf42N37TP2dndEEzESBMwDQt4169ddu
         6akVaEK6uWs4b7Qtxv8FwwNXWmUe6FFSZB/+OVKlWBe7RwhCb+hBCVbttvxOlF+be3A7
         ETP1Vnm6icQt/WjlUnlY8osrdIFh7pYOU/wKANe8nMev7eBvWmZmQAVrUn8yTE6ILYYO
         tJoWOoF00auEOFEfQKvhSgpiPPVJRw8L8EQ5vBZTIdUL50DFWoYSFG5UTHq2gJvNn45+
         bvlg==
X-Forwarded-Encrypted: i=1; AHgh+RpfjoNsgjSrYVJyQ3RRgzqOiMmQjj5M/3Uz3BeuWt3fp08optIHe1aXV8Sm2a0SFUaxC2N3wjA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH4gj3JCcxDIFR8Tnc6fsfUjv/gHGA3bO/eU7drPZdyrnY9byE
	DAp5unvYBq577sUeVFjqMWf+rwu7vSxZpnv/O+jAZGKUxebw+mnWfEO3
X-Gm-Gg: AR+sD13ztu+orEy0NnocIeE23+Gx3+6LBbSTUHNsz4K4i9tKnmPY24T3MGdh3GrKDzV
	34iseGSRwVxa6/hFs8+t5A9V5EY9OMNstT4hi8kmIBl0l6/TmqfjxMGSZoed32k7bar/UOVX+OS
	FlpN34DByeY6Q7FS2pe3hdzpM43KGjODf6elU4RX+C1X7Sjg1tzRFhfOICRtwdo2Ski7JbrSfgM
	3OOMokKeGZY191FsVzRnAz/lDvk5mAXFS2r5xWqaahKbhPt0T2rTVVSMbC04Tf2FChEkx3zzu9m
	9BTiFQmiJ/gSJHChB41xTZaEriFu2sewEiKF+eh044mUSP69f3+yHo5atm1D6uI/1pdwU9Dueln
	FJZ+x1oK+wUQVYsiwFf2SG9LBvyoDjF3P3RyIoS/5vgUcwH+voMwTnW/iXQZGyLSJu67uzwaOIs
	2B7UwDT14VrnI8Ykn3GdZM/2kAxL9jmTPjrpbyiT+qmI5KNEgKxw9uHjmpUOBxjI1AfROqC91cJ
	rBlZCa714x8kaBwWJMbGGCmSL2H/yOwqvXCpvOG2xyMaAH1Kdh7PJVCbyM=
X-Received: by 2002:a17:902:d2c4:b0:2ca:e5c:7fba with SMTP id d9443c01a7336-2d0524da9d3mr35313785ad.39.1785599254851;
        Sat, 01 Aug 2026 08:47:34 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:47:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 02/16] iov_iter: add iterator type for dmabuf maps
Date: Sat,  1 Aug 2026 16:46:14 +0100
Message-ID: <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new iterator type for dmabuf maps. The map in an opaque
object with internals and format specific to the subsystem / driver, and
only it can use that subsystem / driver for issuing IO. The task of the
middle layers is to pass the map / iterator further down, maybe doing
basic splitting and length checking. The iterator can only be used by
operations of the file the associated map was created for.

Suggested-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 11 +++++++++++
 lib/iov_iter.c      | 29 +++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index fe2e985d74d2..638c1116e912 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -12,6 +12,7 @@
 
 struct page;
 struct folio_queue;
+struct dma_buf_io_map;
 
 typedef unsigned int __bitwise iov_iter_extraction_t;
 
@@ -29,6 +30,7 @@ enum iter_type {
 	ITER_FOLIOQ,
 	ITER_XARRAY,
 	ITER_DISCARD,
+	ITER_DMABUF_MAP,
 };
 
 #define ITER_SOURCE	1	// == WRITE
@@ -71,6 +73,7 @@ struct iov_iter {
 				const struct folio_queue *folioq;
 				struct xarray *xarray;
 				void __user *ubuf;
+				struct dma_buf_io_map *dmabuf_map;
 			};
 			size_t count;
 		};
@@ -155,6 +158,11 @@ static inline bool iov_iter_is_xarray(const struct iov_iter *i)
 	return iov_iter_type(i) == ITER_XARRAY;
 }
 
+static inline bool iov_iter_is_dmabuf_map(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_DMABUF_MAP;
+}
+
 static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 {
 	return i->data_source ? WRITE : READ;
@@ -300,6 +308,9 @@ void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
 			  unsigned int first_slot, unsigned int offset, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
+void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
+			struct dma_buf_io_map *map,
+			loff_t off, size_t count);
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 34a52e9ba9e1..de5c1040a4a0 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -575,7 +575,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(i->count < size))
 		size = i->count;
-	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i))) {
+	if (likely(iter_is_ubuf(i)) || unlikely(iov_iter_is_xarray(i)) ||
+	    unlikely(iov_iter_is_dmabuf_map(i))) {
 		i->iov_offset += size;
 		i->count -= size;
 	} else if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i))) {
@@ -631,7 +632,8 @@ void iov_iter_revert(struct iov_iter *i, size_t unroll)
 		return;
 	}
 	unroll -= i->iov_offset;
-	if (iov_iter_is_xarray(i) || iter_is_ubuf(i)) {
+	if (iov_iter_is_xarray(i) || iter_is_ubuf(i) ||
+	    iov_iter_is_dmabuf_map(i)) {
 		BUG(); /* We should never go beyond the start of the specified
 			* range since we might then be straying into pages that
 			* aren't pinned.
@@ -775,6 +777,20 @@ void iov_iter_xarray(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_xarray);
 
+void iov_iter_dmabuf_map(struct iov_iter *i, unsigned int direction,
+			 struct dma_buf_io_map *map,
+			 loff_t off, size_t count)
+{
+	WARN_ON(direction & ~(READ | WRITE));
+	*i = (struct iov_iter){
+		.iter_type = ITER_DMABUF_MAP,
+		.data_source = direction,
+		.dmabuf_map = map,
+		.count = count,
+		.iov_offset = off,
+	};
+}
+
 /**
  * iov_iter_discard - Initialise an I/O iterator that discards data
  * @i: The iterator to initialise.
@@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const struct iov_iter *i)
 
 unsigned long iov_iter_alignment(const struct iov_iter *i)
 {
-	if (likely(iter_is_ubuf(i))) {
+	if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
 		size_t size = i->count;
 		if (size)
 			return ((unsigned long)i->ubuf + i->iov_offset) | size;
@@ -872,7 +888,7 @@ unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
 	size_t size = i->count;
 	unsigned k;
 
-	if (iter_is_ubuf(i))
+	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
 		return 0;
 
 	if (WARN_ON(!iter_is_iovec(i)))
@@ -1469,11 +1485,12 @@ EXPORT_SYMBOL_GPL(import_ubuf);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
 	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
-			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i))
+			 !iter_is_ubuf(i) && !iov_iter_is_kvec(i) &&
+			 !iov_iter_is_dmabuf_map(i)))
 		return;
 	i->iov_offset = state->iov_offset;
 	i->count = state->count;
-	if (iter_is_ubuf(i))
+	if (iter_is_ubuf(i) || iov_iter_is_dmabuf_map(i))
 		return;
 	/*
 	 * For the *vec iters, nr_segs + iov is constant - if we increment
-- 
2.54.0

