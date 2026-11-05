Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861981;
	b=mKLBnGsukkk6FQNZZcY5I+gYVvDYfOR35Y27y0Jqp+gzRKKCUUT6xiV7fqeGemX+95Gz
	 nzhKaCsVNE/MVdQ57yMPpIAkFdJp0L5BythUcuV2remGoKGFVP4ZUNUuz2dSvcH8wp/9e
	 dZOCSfj6aZPuLsDa5qQ9cJ7w9OyyGyQgBfhXQIdp5QrwnAYYaQSP6WLrJLqZNjAcKfaKP
	 430uxILYxwtcNS1Diuyj3m8FrrQlpffEaUKB0PLHXCo2iyG1D2cmrncmSmx4+fXfsrEmc
	 FFDUbam0WRYjzdk7ANDD1kcbQGxTTKZzg0VQpuyxi8cm7h1JWrG/uucNnKwDrvdDThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861981;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=V6jXYvV9dka+3jN4FlL/QeRxDjLIKwLo+qsWJ9KiY6Q=;
	b=18L0KKOJ31msLEL45WbkNYeJaHwQjnihqQtsqyPZo8rDnpMj9r5Vnwbxy/StYLu1LPkp
	 R8Iv/9jCM1HaCCugV3m3+8M0HqcwICrx+fxonP3LZ9w2qtx2GE1wkTE5puyfEspVthvfY
	 WUN6iPY7LkZy7VmmfSUvX5XM0549BVfctjdchq344lWXQsQWRzIeZ4rPo1L/eirHYda3A
	 xo2JOz9qrc+5C7RpY2ZsMb8ZCVZWCchUap2ZFkWkHqneOUujyep9aoUi353ZwClNzFnCR
	 H8AxMnl/c/tBY7NWjqZ0VIbymmmm6rw0qPUr21KYKKi0J6RJJTevpFkDV90bMHvvTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QaWf9wb7;
	arc=none smtp.remote-ip=95.215.58.220
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4529C606D801
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 06:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4529C606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QaWf9wb7
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BRMlNTa2IFz117u+LpOsOZxcnQTogf6s+dFMFzcP0xM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861978; v=1; x=1794466778;
 b=QaWf9wb7wFivbY4mUbRehlCWWKN3tB0cW4ajPirSzhAocmjyx9TuV37CtcFab/80djMAdLFe
 jRYRmmPTKw1NfQidftHLvJl0yYWgWkAWXm2oWhCr421bGdGGf0wTAUxeGgQ/rZbnokP26pzIvY7
 ddWpsDXwlLWg655twgRVJAOQ=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 724bcf4c5e474fe1;
	Thu, 05 Nov 2026 06:59:38 +0000
X-Mizu-Trace-ID: 724bcf4c5e474fe1
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
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
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic read/write copy paths
Date: Thu,  5 Nov 2026 14:58:43 +0800
Message-ID: <20261105065847.196540-3-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
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

The generic copy helpers cannot touch device memory.  Refuse a
dmabuf iterator in generic_perform_write() and the filemap_read()
fallback while keeping any direct-I/O progress, and report a busy
folio from generic_file_direct_write() as -EAGAIN instead of asking
for the buffered fallback such an iterator cannot take.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 mm/filemap.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..ab8a5391a699 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3013,6 +3013,14 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 			return retval;
 	}
 
+	/*
+	 * Buffered I/O read is not supported for dmabuf; a short direct
+	 * read before this point stands on its own, as in
+	 * direct_write_fallback().
+	 */
+	if (iov_iter_is_dmabuf_map(iter))
+		return retval > 0 ? retval : -EOPNOTSUPP;
+
 	return filemap_read(iocb, iter, retval);
 }
 EXPORT_SYMBOL(generic_file_read_iter);
@@ -4300,8 +4308,14 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	 */
 	written = kiocb_invalidate_pages(iocb, write_len);
 	if (written) {
-		if (written == -EBUSY)
+		if (written == -EBUSY) {
+			/*
+			 * Avoid fallback to buffered write for dmabuf.
+			 */
+			if (iov_iter_is_dmabuf_map(from))
+				return -EAGAIN;
 			return 0;
+		}
 		return written;
 	}
 
@@ -4353,6 +4367,12 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 	long status = 0;
 	ssize_t written = 0;
 
+	/*
+	 * Buffered write is not supported for dmabuf.
+	 */
+	if (iov_iter_is_dmabuf_map(i))
+		return -EOPNOTSUPP;
+
 	do {
 		struct folio *folio;
 		size_t offset;		/* Offset into folio */
-- 
2.43.0

