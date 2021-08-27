Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC513FCE
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jzYOtCWATAY/QPQDMVi4thNHaE7QBEtJ34Au5e0E3sY=; b=NGugnaXzgKO6Z0LTp/maSzbHCI
	U1Pv2fbRzAJNKgHx+R1PcMKo8uKSrgNlQix8oa8+K/HTha83E2mjqGnrSagG+ONnMAFMGLYtn2PNe
	44srzTowUzh4ka5s84uHYFW/HOBtfUpMoE0PLBnDtbqqm8TmqnPx5RKDFqaaFTEw0A10vtOcAGog8
	s3kmxVpMLBGvEEyhgCLpkdmj9S06UEdmTMQCo1Nwra6wRObz47JLIzPDf3ciTJiFUmRYdKNCEMx93
	/RmF44E3FegHXxtVo6avCvgPzF7TiKeyMgBT3BlZk/PF5la1GXJhEiw3DATVEgKTEH2u5aQi1PQpl
	Km4814lA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJhMh-00D5Ay-6k; Fri, 27 Aug 2021 19:18:11 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	konrad.wilk@oracle.com,
	roger.pau@citrix.com,
	boris.ostrovsky@oracle.com,
	jgross@suse.com,
	sstabellini@kernel.org,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org
Cc: xen-devel@lists.xenproject.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 04/10] nvdimm/btt: do not call del_gendisk() if not needed
Date: Fri, 27 Aug 2021 12:18:03 -0700
Message-Id: <20210827191809.3118103-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We know we don't need del_gendisk() if we haven't added
the disk, so just skip it. This should fix a bug on older
kernels, as del_gendisk() became able to deal with
disks not added only recently, after the patch titled
"block: add flag for add_disk() completion notation".

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 92dec4952297..3fd1bdb9fc05 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1538,7 +1538,6 @@ static int btt_blk_init(struct btt *btt)
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
 		if (rc) {
-			del_gendisk(btt->btt_disk);
 			blk_cleanup_disk(btt->btt_disk);
 			return rc;
 		}
-- 
2.30.2

