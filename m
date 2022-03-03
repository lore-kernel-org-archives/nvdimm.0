Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E502933C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QVVaIqgGyDnx9ueY7z/hzj3O9uq8fALFMD1DXm83SrU=; b=OOGFiYRrrPZgXxgrDmd0Ot5+++
	J2ACUC7ZfBTAnB/yKwzsccoWtvqn3jk9jM8Kxj+XQ7PpfC7zK79z8grscIPB9Q5JO2ik15NUcjXg+
	koSBXepexshcqqANRhAoZNg/u8pu9oN6bTTVoEa/V7QCZBlUOSthPFdVPX8r6KsrPN+9nycK9X3NL
	ucbuggOoCDs+VbIj1t5Zq6H1tHDnNC+KXv/DqZQhNi7iMDGfBgh0+7ytTharPyxZj5+2SRjOBEdkh
	xgI0DBTGQMtLVqu2G8rNjnMPAZkZhZcP1l6n8gtl2M01qs78nSKfQYzl4difO/6jtf+vCzKM2xQcG
	2IJ34mXg==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjUS-006Bum-TO; Thu, 03 Mar 2022 11:19:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-xtensa@linux-xtensa.org,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in simdisk_submit_bio
Date: Thu,  3 Mar 2022 14:18:56 +0300
Message-Id: <20220303111905.321089-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220303111905.321089-1-hch@lst.de>
References: <20220303111905.321089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/xtensa/platforms/iss/simdisk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 8eb6ad1a3a1de..0f0e0724397f4 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -108,13 +108,13 @@ static void simdisk_submit_bio(struct bio *bio)
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	bio_for_each_segment(bvec, bio, iter) {
-		char *buffer = kmap_atomic(bvec.bv_page) + bvec.bv_offset;
+		char *buffer = bvec_kmap_local(&bvec);
 		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
 
 		simdisk_transfer(dev, sector, len, buffer,
 				bio_data_dir(bio) == WRITE);
 		sector += len;
-		kunmap_atomic(buffer);
+		kunmap_local(buffer);
 	}
 
 	bio_endio(bio);
-- 
2.30.2

