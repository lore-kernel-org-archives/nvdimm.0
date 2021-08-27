Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE643FD3
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+haEytmu63y3zWbWZRI3xhnFTvWyZ+JIjCoqN6FFLWY=; b=K2x3pPY1MjMXFVBKWItW/EUmz3
	oXTuPhFDfnmLiBjDzjBod7BEzvqr8kGcf5ytJZUzzsGuIUfqyRpJhcX80zL0lRzDZAS9amWITcPsM
	XVvA+RKxBCvgNSjP0X1szvA7ZlpF/3YjoBZ33+dmPNEx+hJ1CCVAsBc4AYNyAlx/cVlQ6F2TbPjmu
	7C6yudMpOkpOSu4bkqcbhoJA70i0CfddYCZwj22VzG6stQYi8XFhm14+Dp+G+0cLOSi3k21VwV2Xi
	ADNTqx7RTt769nCMLIQRhz78hIfqIY3Fg7E30rRJeeLZOxfb1Xp0sNZYlrB6721r6oUAljCk750jK
	ihFnTrMQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJhMg-00D5Ao-Ti; Fri, 27 Aug 2021 19:18:10 +0000
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
Subject: [PATCH 00/10] block: first batch of add_disk() error handling conversions
Date: Fri, 27 Aug 2021 12:17:59 -0700
Message-Id: <20210827191809.3118103-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This is my second batch of driver conversions to use add_disk() error
handling. Please review and let me know if you spot any issues. This is
part of a larger effort to covert all drivers over to use the new
add_disk() error handling. The entire work can be found on my branch
dedicated for this work [0]

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210827-for-axboe-add-disk-error-handling-next-2nd

Luis Chamberlain (10):
  block/brd: add error handling support for add_disk()
  bcache: add error handling support for add_disk()
  nvme-multipath: add error handling support for add_disk()
  nvdimm/btt: do not call del_gendisk() if not needed
  nvdimm/btt: use goto error labels on btt_blk_init()
  nvdimm/btt: add error handling support for add_disk()
  nvdimm/blk: avoid calling del_gendisk() on early failures
  nvdimm/blk: add error handling support for add_disk()
  xen-blkfront: add error handling support for add_disk()
  zram: add error handling support for add_disk()

 drivers/block/brd.c           | 10 ++++++++--
 drivers/block/xen-blkfront.c  |  8 +++++++-
 drivers/block/zram/zram_drv.c |  6 +++++-
 drivers/md/bcache/super.c     | 17 ++++++++++++-----
 drivers/nvdimm/blk.c          | 21 +++++++++++++++------
 drivers/nvdimm/btt.c          | 24 +++++++++++++++---------
 drivers/nvme/host/multipath.c | 10 +++++++---
 7 files changed, 69 insertions(+), 27 deletions(-)

-- 
2.30.2

