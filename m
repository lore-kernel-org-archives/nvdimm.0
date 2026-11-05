Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793861968;
	b=niisMtB9gzKe0gSV7IsONcQeCMNpcTFmS1fOUeidDlB56AJykl7AFWUeZFIT+3OoMD+3
	 1+WqTnbsWF+2UJHCFMaxMXiNRR2HA0aM7Qtw144s0M1JvdwN744ieGhiprPALgbidv6/T
	 J3qdgnZWvw9IDwns6g7YVHMbsED6eqrUGbJqfvsVfnt6Y4HQ953K4SFWcrRj0ga3Y+4Eu
	 DlrrcUfT9qc6i1jPZpTR+NVuaqgXQ8ijMyrjHRRPiyqrAR4cd85oOlx+2Th68DrXq0u9H
	 xPVzy5XLFQQxvKWFqxFbIx/WnlTcExzmuHnlqOdWTx2DnG4XPOub9x1oBTFTfgrnwXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793861968;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nIzPxp67nycIcgpn1aR+9cX2c2A9Fk/9SrE7eGQSDVI=;
	b=xyODP/oCm1TYacmkTspb9dLLFG0wJahoCZmGaNiTH0QWPJsGObvg9g+Sv5fB3Swz3tud
	 8PgKAquq6QKw7x8ys5ZOp76/ZEzpp2PzicCth25elMiSgqcn1rXr2cJ3GzUDIm+lIindj
	 cXiwX6+lTMouXBdDWYXKuNQgquZF7dTa7SpyPuMs2tEgy2owMKaJWyYqqsQPZ/gcbMWp3
	 /UBGzmDWCMVXfTgqMoeShExo62H+e7P8/yvX9EQMe713PlIe6xXHQlr71YZTLSlA20dzp
	 k0SRJfyMTqqRi6Pmk0TOsZYTBUUWOywvz2IuZsCRqHi075OK8t/LmYh2irv3YaUukcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo;
	arc=none smtp.remote-ip=91.218.175.157
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE50606A330
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 06:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FE50606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xVc3emtqQK3gdjiaDH2/ozjRn5r+zA/0E88efrFuawg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861965; v=1; x=1794466765;
 b=URJ69ifo97ROruZ6pmwjXf0aKmSur7mh2uvlDandRG7mz4fCmrISF3oG8QPrDgE6EtbpnoLX
 DDOkrLFAjlHrjyterio5ErE9cY4DTjD2rrmzaqCHaS/HCXbs+pcE5kLsyhLVR0lxf7DWy2zDiJH
 ybQo4+FLjg9nVwpWWXkCsyjQ=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7015cdc676c618de;
	Thu, 05 Nov 2026 06:59:25 +0000
X-Mizu-Trace-ID: 7015cdc676c618de
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
Subject: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto context
Date: Thu,  5 Nov 2026 14:58:42 +0800
Message-ID: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
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

A dma-buf bio has no pages for the crypto layer to walk: the
software fallback would read the map as bio_vecs.  Refuse it in
blk_mq_submit_bio() before it can reach that path.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index be5671966787..f0d978b1724f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3138,8 +3138,10 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
+	/* a dma-buf bio has no pages for integrity work or contents crypto */
 	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
-		bdev_has_integrity_csum(bio->bi_bdev))) {
+	    (bdev_has_integrity_csum(bio->bi_bdev) ||
+	     bio_has_crypt_ctx(bio)))) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
-- 
2.43.0

