Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553675;
	b=zXgXHeF7TxwbSmLa7erxGGckvvYXB9FF/SERzNpKnouJTAtYksI+qIQ9DAHeMtTN5sOf
	 fQ1dbmN4cqGyLBjJWZcM3XNGOrsQBxLFvyzJZR24JM5mJrp4u16NBbW+X3tEgDSoHjYC+
	 DcGkm8ZrpWM15b4T85hiTCsYzpQWf1HdfdZNDpbwL2K+ixd+TKfdffwAFaZyoS5m2azLA
	 aQK2iU7kqCNkK7hMYeKZSx/cMx1HEsKsSojSkvzMUY0ZEueov9ToFon3gTX8LZe+SwizZ
	 zYR1j83+JAVHgMvlosVG2XVXgxjkvBxqq9zNkgWTCE0Tm2B7Bq3x/p7HiUV1psk1FHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553675;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y5c7omIAneSZefT9dfmZbyqefVv1syPKSN+V7Y2Kmgg=;
	b=VK7HCPuZxhCvsgnakad6jI6Ipjl+B06YxJ4hLZplDY5DKtFA15o0+nd4IzgTRBJ7svHT
	 59wZNX4f5bxiC6tSIo2kmp6Wpf3s75qcMFVyL8rltltJCRnkPT1BoIMdo8uWvU+JLVbRW
	 1Dc0xp8FVtsWoDNITRbEgUPHJN8wD6FivbY09evupu9I9T5MV25q3GJF6sp+oKWnYvvy2
	 G5B3Ws7Q1kVvxmIul/mx3EfCxG6OUl5YmUZdM7kLwVHb0xXPPD7/arSBk78o3CimeMiA/
	 yf26/xfdlaSbGWgkQt73O9Bs3HAztLL4RNKjekV3G3tw2NvFGtTsXsswm7jOZtuvDNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WNlQBVSH;
	arc=none smtp.remote-ip=91.218.175.241
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F9606A33E
	for <nvdimm@lists.linux.dev>; Fri, 13 Nov 2026 07:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 976F9606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WNlQBVSH
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=wlo9vUd47ggH1TaP4OgfLMAqjSMe1zHTjJ3E73DhNZo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553672; v=1; x=1795158472;
 b=WNlQBVSHUn78Tk1zyoGzZguis4FrUmM+7toVhjkmVF7vHaufAvvP/DUBQ2hWyoDYbo+dfJfH
 yx3jnllnOeZ+YFiQIwqC6hOC6R79M13L88FOVxjQq/TLd0yf8sWgD94jLFoBxG5+4oJ9w6RZ9zF
 8xncwf8wAG+3QsOQDVCG3ud8=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c98b5bb3fe46bebc;
	Fri, 13 Nov 2026 07:07:52 +0000
X-Mizu-Trace-ID: c98b5bb3fe46bebc
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
Subject: [RFC PATCH v2 4/8] blk-mq: factor out a dma-buf bio refusal helper
Date: Fri, 13 Nov 2026 15:06:17 +0800
Message-ID: <20261113070621.273953-5-mengmeng.zhao@linux.dev>
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

Move the dma-buf integrity check out of blk_mq_submit_bio() into
bio_dmabuf_should_reject(), so that such checks have one place to grow.

No functional change.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-mq.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5ae22d556540..887d5cc5bb5e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3099,6 +3099,20 @@ static bool bio_unaligned(const struct bio *bio, struct request_queue *q)
 	return false;
 }
 
+/*
+ * A dma-buf bio carries a driver-private map instead of pages, so the block
+ * layer cannot generate or verify integrity metadata for it.  Only reject when
+ * it would have to do that itself, not if the submitter attached its own
+ * payload or if generation or verification is turned off for the device.
+ */
+static bool bio_dmabuf_should_reject(struct bio *bio)
+{
+	if (!op_is_dmabuf(bio->bi_opf))
+		return false;
+	return bdev_has_integrity_csum(bio->bi_bdev) &&
+	       (bio_integrity_action(bio) & BI_ACT_CHECK);
+}
+
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -3160,15 +3174,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
-	/*
-	 * The block layer cannot generate or verify PI for a dma-buf bio, as
-	 * that walks the data pages.  Only fail the bio if it needs that, not
-	 * if the submitter attached its own integrity payload or if PI
-	 * generation or verification is turned off for the device.
-	 */
-	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
-		     bdev_has_integrity_csum(bio->bi_bdev) &&
-		     (bio_integrity_action(bio) & BI_ACT_CHECK))) {
+	if (unlikely(bio_dmabuf_should_reject(bio))) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
-- 
2.43.0

