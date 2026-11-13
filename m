Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553691;
	b=f3JezLSpQuKOkocUv5Cz0Z3U8ovEh2dy04iexbTSTokq7Vv8EHdAvOQPsEXVxx9R/E7X
	 Teh0vZvx8nDWf7ZYWVGtRAj80XHayZzj2bEbItBbDgUddZCVBVSiwnUGXUx6sBqyTALPJ
	 6AfSSjM1NhHXlypLcDV24r5YiJFfkZd3kNyYSDumfZdAHLfhLWRjBmUnQCbAtgu3NiRsj
	 QrG9pLSxthFUcq4WInRA7xMu3dB++NrMjVxYv7vVZ5AfcCMJfq4xJkpbY5ay6+43y79M0
	 nkjIfepUN8k9o/IsI0qh8/x2ck+zUt5cy03lc2mVlQVRsH1IbJmAoNfvdXo2vaIIxcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oE2P4TXXbwbeZXnmaDd39X4I7W+VRQ8H2a+gqtaKE6M=;
	b=vUI+j46soARYL/twuAy9Yp0Nlk/iUHCpB8U+5O+tkFF1uPqQVosWKONJU7AIKy1bgy0W
	 Geu8JA4P34KNJg/aeBDiWMLv/1Vpn7E/37FTAqlu8nF3z/XKr56NgP3u2dT7ODdn1l22u
	 ybPrJDXB3eS5PtsDQlFQZN+jS7bO0sUfQWlb6dEbUofDqlhlh/cEee27SxBL9TQTZ7fOn
	 4fEU3cHWik32agHEoDX75PNfAPpqu8WugUfnyRqJiXNXLsWN16pliB3iieAZyDZYqxr5P
	 fJRPfkIhg/NrellTiInt9WtynrHwkGIa3Vj7avuGM5LhnrkDzBFA4SXLfBXrI6AEHhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc;
	arc=none smtp.remote-ip=95.215.58.232
Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672A606A33A
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 07:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D672A606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nKxRPFkc
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TGEyrdi/pv1jc6teZ+wM/XGPkjaMpK/OOKnCVbRJDcg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553689; v=1; x=1795158489;
 b=nKxRPFkcrzPC7ZgkWruNcPuZqp1vlKz1pSass6D1zhpeWU/BBB78IxjJXoYSiRXWR3S/RBIh
 pTYcDSfp7qwzJP6QdsnXUceKvQPByHKrDddl4aN+Hy4zIc6Mi84vxB4uw2NZLDSf1+dwOPop5Pp
 0EP0xibP82F/nsdxwbJaCiDw=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 32332e07033e4feb;
	Fri, 13 Nov 2026 07:08:08 +0000
X-Mizu-Trace-ID: 32332e07033e4feb
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
Subject: [RFC PATCH v2 5/8] blk-crypto: refuse dma-buf bios in the fallback path
Date: Fri, 13 Nov 2026 15:06:18 +0800
Message-ID: <20261113070621.273953-6-mengmeng.zhao@linux.dev>
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

The inline encryption fallback encrypts through the data pages of a bio,
which a dma-buf bio does not have: its vec pointer holds the
driver-private dma_buf_io_map.  A crypt context the device supports
natively is programmed from the request instead, so refuse only where
the fallback is about to run.

blk_mq_submit_bio() is too late for this: submit_bio_noacct() has already
rejected a context the device does not support natively, while submitters
reach the fallback before the bio is queued.  No in-tree submitter builds
such a bio today.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index bc3a9f59574b..01b8d26040dc 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -271,6 +271,14 @@ bool __blk_crypto_submit_bio(struct bio *bio)
 			bio_endio_status(bio, BLK_STS_NOTSUPP);
 			return false;
 		}
+		/*
+		 * The fallback encrypts from the data pages, which a dma-buf
+		 * bio does not have.
+		 */
+		if (op_is_dmabuf(bio->bi_opf)) {
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
+			return false;
+		}
 		return blk_crypto_fallback_bio_prep(bio);
 	}
 
-- 
2.43.0

