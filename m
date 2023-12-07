Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF3282EB
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 21:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0+CB4S6w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0r4nfZqHPYRDR+n8ZIS2wR0AC5uZQeIIwrgxcaNxyuo=; b=0+CB4S6w5xhh+1K/c5OxSyVyNl
	o0iymSgjnk2U1Z5uxRjnjiilkPrDJ86FlxNmJpIQbjMWtGG6CuqMpUs7g4XimCTMHmTpnQfzjDNKw
	AM/AO8mD/PhNroTpaGBYVyC8rNRZJxRqYgPkMHOCtdxh4pq8gxMTotXGk8lbW5hFyyDNax+8MtzlP
	dtHIZQvl4E8SEZB21YjWK0+7oSkpPL6g1JfalihCfyM/jdwhLDyAajnll/8DDxI1AbfD0p/pBOHCS
	b15lPPkX+JiTh87rxHtSW4YeNqVbgPu310yapfAL77ltc3W/QXLlnk8VUFdc98FfMHjZqiNbssn2/
	Fyx/xVHQ==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rBLZ5-00Duw1-2p;
	Thu, 07 Dec 2023 21:05:47 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH 1/3] nvdimm/btt: fix btt_blk_cleanup() kernel-doc
Date: Thu,  7 Dec 2023 13:05:43 -0800
Message-ID: <20231207210545.24056-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct the function parameters to prevent kernel-doc warnings:

btt.c:1567: warning: Function parameter or member 'nd_region' not described in 'btt_init'
btt.c:1567: warning: Excess function parameter 'maxlane' description in 'btt_init'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
---
 drivers/nvdimm/btt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1550,7 +1550,7 @@ static void btt_blk_cleanup(struct btt *
  * @rawsize:	raw size in bytes of the backing device
  * @lbasize:	lba size of the backing device
  * @uuid:	A uuid for the backing device - this is stored on media
- * @maxlane:	maximum number of parallel requests the device can handle
+ * @nd_region:	&struct nd_region for the REGION device
  *
  * Initialize a Block Translation Table on a backing device to provide
  * single sector power fail atomicity.
