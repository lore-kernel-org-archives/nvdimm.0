Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795687667;
	b=eIPEIsnJsr+UpBFGpLgOUQ6Mf275laJIcKtEzWvenZo5VbhTkRASFWiQPFGDls6HLUTs
	 mhRn4oxi5x9l2NEswdhxKtK3txuU60X3mEOkx9k6Xnw18JvMJf8BunCQ+TVCHKnn6T73/
	 28K5jmZSbznjiOXYxMFS0kwwNF4kuTMs5qJbjgDlcj5J6BEaNJX5lworV73Rvu3Y2mvFe
	 n1WKB/HGqjVhosvO4cPq1B0Ap6H3r98gHzDEjrwmK7fkpnumE63xZlKUL9iEROaxxBgkC
	 E+4v71dCid6hZLnYOIElDdG2EsGk49Fp9pqr/hyr3WtqxTa+2nZtIAFPwj67NraXIzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795687667;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2FQzcmdWuR6mzCWiHNw819pdvBvln6aeaDVrWUxMTqU=;
	b=uXnb81avD9oNCbsNdsBM6qn/uwy6aZEDNqjMHr9qfMCGn4f52IHzLLiDYsrSxACcYlAA
	 qfUYHF26cHqfHrCXgIgfrzbxBQENjVau2xEAqdmGPU5KQnr5i/9fh/svOjOEKeBLI3F2S
	 z2JzfKDxrkKoNb/OExbo/pTrhRAqTQ7PvqqQHCLu38QKpILoHnBF3JkzYfXeRXrOMqj0K
	 D9702GqyzQjhcNYJlM/Xny9B5dUFIhKNPsH1nfSOP6TD1tTH9xlYiumOkQ9LckvSnZ1F4
	 eqU/kUMf1u+nFbLRwjd8aZUMauMxMpLCyCDkJ169+CahkAvBD/5L++ZVTIDwekYOL7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q2ZsT1LY;
	arc=none smtp.remote-ip=95.215.58.73
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408E7606A32E
	for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 10:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 408E7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q2ZsT1LY
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GI1XpP+ljsyfP43UHLv7NCLXQmakxhCuFxYt4ZNGCiQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795687665; v=1; x=1796292465;
 b=q2ZsT1LYL7XNWQlSSK245hDe30mzFMYXHMpjfIFgyJKLOOdn7rfuNq7K2u2B01yqAx+su3Zo
 2gsrnYb6Qp0Z+NE2EwidQ/OutEvG7gnh1Zof7AhYCaS5RnUFBOJabmLvAxvr461VWbcupMUMxXW
 0BU0HA/NoGaLUfCueUC0jG7E=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2480f8a893a63f48;
	Thu, 26 Nov 2026 10:07:44 +0000
X-Mizu-Trace-ID: 2480f8a893a63f48
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: arsenova@a7snv.com
Cc: adilger.kernel@dilger.ca,
	anuj1072538@gmail.com,
	anuj20.g@samsung.com,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	christian.koenig@amd.com,
	corbet@lwn.net,
	djbw@kernel.org,
	dri-devel@lists.freedesktop.org,
	hch@lst.de,
	jack@suse.cz,
	libaokun@linux.alibaba.com,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	liwang@kylinos.cn,
	mcgrof@kernel.org,
	mengmeng.zhao@linux.dev,
	nj.shetty@samsung.com,
	nvdimm@lists.linux.dev,
	ojaswin@linux.ibm.com,
	phasta@kernel.org,
	rdunlap@infradead.org,
	ritesh.list@gmail.com,
	skhan@linuxfoundation.org,
	sumit.semwal@linaro.org,
	tytso@mit.edu,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	yi.zhang@huawei.com,
	zhaomengmeng@kylinos.cn
Subject: [RFC PATCH v3 2/8] iomap: add dma-buf direct I/O guards
Date: Thu, 26 Nov 2026 18:07:21 +0800
Message-ID: <20261126100721.313677-1-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125171600.4053585-1-arsenova@a7snv.com>
References: <20261125171600.4053585-1-arsenova@a7snv.com>
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

From: Nitesh Shetty <nj.shetty@samsung.com>

Direct I/O copies data from the CPU in four places, zero-filling
holes, inline data, bounce pages and integrity metadata. A dma-buf
iterator has no pages behind it, so refuse it there.

Reads that encounter a hole or unwritten extent before i_size
therefore return -EOPNOTSUPP for the entire operation, even if I/O
for an earlier mapped extent was already submitted.

Holes that start at or beyond i_size are stepped over since reads
are truncated to i_size before completion.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Co-developed-by: Yun Wang <arsenova@a7snv.com>
Signed-off-by: Yun Wang <arsenova@a7snv.com>
Reviewed-by: Li Wang <liwang@kylinos.cn>
[Mengmeng Zhao: remove the registration helper and fold in
Yun Wang's past-EOF step-over fix]
Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
---
 fs/iomap/direct-io.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ad041ac3252a..de07a4efcbf7 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -425,6 +425,11 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	unsigned int alignment;
 	ssize_t ret = 0;
 
+	/* integrity metadata is generated from the data pages */
+	if (iov_iter_is_dmabuf_map(dio->submit.iter) &&
+	    (iomap->flags & IOMAP_F_INTEGRITY))
+		return -EOPNOTSUPP;
+
 	/*
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
@@ -589,7 +594,24 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied;
+
+	if (iov_iter_is_dmabuf_map(dio->submit.iter)) {
+		u64 length = iomap_length(iter);
+
+		/* zero-filling walks the data pages */
+		if (iter->pos < dio->i_size)
+			return -EOPNOTSUPP;
+		/*
+		 * Past EOF there is nothing to zero: the read is truncated to
+		 * i_size before it is reported, so step over the hole.
+		 */
+		iov_iter_advance(dio->submit.iter, length);
+		dio->size += length;
+		return iomap_iter_advance(iter, length);
+	}
+
+	copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED) {
 		loff_t aligned_copied = round_down(copied,
@@ -619,6 +641,10 @@ static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
 	loff_t pos = iomi->pos;
 	u64 copied;
 
+	/* inline data is copied from the CPU */
+	if (iov_iter_is_dmabuf_map(iter))
+		return -EOPNOTSUPP;
+
 	if (WARN_ON_ONCE(!inline_data))
 		return -EIO;
 
@@ -717,6 +743,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		return NULL;
 
+	/* bouncing copies the data from the CPU */
+	if (iov_iter_is_dmabuf_map(iter) && (dio_flags & IOMAP_DIO_BOUNCE))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	dio = kmalloc_obj(*dio);
 	if (!dio)
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0

