Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.201
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553658;
	b=CgrS2KePOMANbBr70yAElK36OChOsgvXOVLY5KC6PyX1nQWsm2KEV1qgj2y59ImrQ9mz
	 tkQy9HF2qeSQIKojCwK2f9YJBxZQY/P2yvu6onYsby8wzXXgMtEl0In5udlwk0IAmesr9
	 Cdn26T81UYMV76uPDDrqpsSYkHvqStoIoHdxrxsOE87t0KTASswuQYxgZtipaLOHROQW0
	 MkVj0G2Znx5On0A9gBbPv0zdRHGQyDJWbXLrz4G1nHcsGtUOj/gunhNaYPlkCn8pZgqZV
	 JwkcXMhuzscstY/i0JDt0onHbEcy6+l2KGkgXErLoDv13JUVwlkJpNBWlLLXldSxN3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553658;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KYrqfOt3WaM6xb5MUDSy7pQiGraRuXX8G5HzWKe5LoM=;
	b=JiEYhiHIvpwjPov7T5BjoQYI108qG3ob97laT02lj3UKZn854lZPrUO2oxnRgo7ydp+U
	 j9oZYy3WMMngWMuPzUY/80t5Hp9IEhQl3qBggoJShXIYlTcCB/uoPzMzoBlpY5vQGy7KQ
	 +GiyYyl8GWBT/P32pZa6RvdfhslN7dH2G/MiLD6c0h2LIckLA20+7p3CeMtBGR2L+3OS3
	 VfC1WA6OgEZylrkP6jb2Y3cjJhqVfR6gNUME6QxEBjL7P4aFn6EYG+CAT81kNHU7f1Sg4
	 Uh/cgAFNpHZmTtCvi+sjNaDpoS4IoFqEhuCIB41UALcp5h+CT65DbR1Z1LxQtbfWILg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ICj6LBSR;
	arc=none smtp.remote-ip=95.215.58.201
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C761E606A881
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 07:07:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C761E606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ICj6LBSR
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=FEKih65dVLqip/qvv/nnGzIKP8TulmlEVfQQ2ZV1WNs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553656; v=1; x=1795158456;
 b=ICj6LBSRZFTG4UFEful4TlQrRZZ3qe+p2f5HUj0XMsmJHmUG8GOf7G77USLC5uPvzc8KSAd5
 g0j0NHnJn9o9akg5j4yRuUiGQ6QlK3RRXUdZFGJH7SogXsJRpOpdCzcjwD+BE0DY8+WH0aaNa6t
 Spz8hgDt85V0sJ9zY9qunvgk=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 399a8e2f5a148472;
	Fri, 13 Nov 2026 07:07:35 +0000
X-Mizu-Trace-ID: 399a8e2f5a148472
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: [RFC PATCH v2 3/8] iomap: don't ask for a buffered fallback for dma-buf iterators
Date: Fri, 13 Nov 2026 15:06:16 +0800
Message-ID: <20261113070621.273953-4-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

-ENOTBLK tells the caller to retry with buffered I/O.  A dma-buf iterator
has no pages to copy, so the callers refuse that fallback, which would
turn the error into a successful transfer of zero bytes.

Report the reason instead: a busy folio becomes -EAGAIN, which the caller
can retry, any other invalidation failure keeps its error code, and
-ENOTBLK from ->iomap_begin() becomes -EOPNOTSUPP when nothing was
transferred.  A partial direct I/O still reports its progress.  Both
branches are reachable only through a file that opted into dma-buf I/O,
which ext4 does in the last patch.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 .../filesystems/iomap/operations.rst          |  3 +++
 fs/iomap/direct-io.c                          | 20 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index da982ca7e413..ca59716d225c 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -513,6 +513,9 @@ Return Values
    cache before issuing the I/O to storage.
    The ``->iomap_begin`` or ``->iomap_end`` functions may also return
    this value.
+   A dma-buf iterator cannot fall back to buffered I/O, so it gets
+   ``-EAGAIN`` when the failure is retryable and ``-EOPNOTSUPP`` when no
+   data could be transferred.
 
  * ``-EIOCBQUEUED``: The asynchronous direct I/O request has been
    queued and will be completed separately.
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4a2b0f9df5a7..83fda6973bb9 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -706,7 +706,9 @@ static int iomap_dio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
  * completing partial requests asynchronously.
  *
  * Returns -ENOTBLK In case of a page invalidation invalidation failure for
- * writes.  The callers needs to fall back to buffered I/O in this case.
+ * writes.  The callers needs to fall back to buffered I/O in this case.  A
+ * dma-buf iterator cannot use that fallback, so it gets -EAGAIN when the
+ * failure is retryable and -EOPNOTSUPP when nothing was transferred.
  */
 struct iomap_dio *
 __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
@@ -806,7 +808,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
 		 * If this invalidation fails, let the caller fall back to
-		 * buffered I/O.
+		 * buffered I/O unless the iterator cannot be handled there.
 		 */
 		ret = kiocb_invalidate_pages(iocb, iomi.len);
 		if (ret) {
@@ -820,6 +822,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 					 * the caller tries again.
 					 */
 					ret = -EAGAIN;
+				} else if (iov_iter_is_dmabuf_map(iter)) {
+					/*
+					 * A dma-buf iterator has no buffered
+					 * fallback, so -ENOTBLK would hide the
+					 * real failure.  A busy folio is retryable.
+					 */
+					if (ret == -EBUSY)
+						ret = -EAGAIN;
 				} else {
 					/* fall back to buffered write */
 					ret = -ENOTBLK;
@@ -867,6 +877,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (ret == -ENOTBLK) {
 		wait_for_completion = true;
 		ret = 0;
+		/*
+		 * A dma-buf iterator cannot use that fallback.  Anything
+		 * already transferred is still reported as a short I/O.
+		 */
+		if (!dio->size && iov_iter_is_dmabuf_map(iter))
+			ret = -EOPNOTSUPP;
 	}
 	if (ret < 0)
 		iomap_dio_set_error(dio, ret);
-- 
2.43.0

