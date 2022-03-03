Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D233C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ss0aqO+LCHTJbh8lRYeCKR0T6gWpPWKe33M5LaRso80=; b=KQp48Ew8u2NsZnCrLX/iHBqpFy
	daDEOxZ2iyqjxtxGT8ctF47MZV9nd6quauQG6A+2v9x0jXgo7/z57eE/IoeiksJ8EevmXLprAFdM+
	PiKIz/F0GQEMdQ6PKkBgE2BeIMrMNcXga9eaCw5NaiCus3OWsiM+na4feR9uVAYde0NmabEM5gfTN
	P7o2VkzNfn1IaNdKRFfxbESxWSW+H436TUOFTrWNVh77C7yW8p8iYV0poutCkdV1fsc9lIes31JHt
	kShVvs81GfeVlLvagBtC01Zkua8ly2L04xIVI/gZyJ5WgSFa8gYoaDcrv/zovlbC8L0AUGUmiDPTb
	82BCAUYA==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjVK-006CBG-P1; Thu, 03 Mar 2022 11:20:20 +0000
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
Subject: [PATCH 10/10] floppy: use memcpy_{to,from}_bvec
Date: Thu,  3 Mar 2022 14:19:05 +0300
Message-Id: <20220303111905.321089-11-hch@lst.de>
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

Use the helpers instead of open coding them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/floppy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 19c2d0327e157..8c647532e3ce9 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2485,11 +2485,9 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		}
 
 		if (CT(raw_cmd->cmd[COMMAND]) == FD_READ)
-			memcpy_to_page(bv.bv_page, bv.bv_offset, dma_buffer,
-				       size);
+			memcpy_to_bvec(&bv, dma_buffer);
 		else
-			memcpy_from_page(dma_buffer, bv.bv_page, bv.bv_offset,
-					 size);
+			memcpy_from_bvec(dma_buffer, &bv);
 
 		remaining -= size;
 		dma_buffer += size;
-- 
2.30.2

