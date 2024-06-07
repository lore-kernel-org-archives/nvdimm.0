Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF65614E2F7;
	Fri,  7 Jun 2024 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739969; cv=none; b=jOCNNoMbvoyFqU8KqKUyoJGhXFf4FxT4f+5jg9lS1nlgDVQOWo+yPEdBEi2IpCfVIYYR5uIDhqIMAj8Ktv2ZT/OQNXl5LldXxpsMBn1es1jci+mjtvf5AtdpfFrfftF7uWqS/kQAMcAjKv9pztd2fBcs8+GoliM7TTaZaHHTI4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739969; c=relaxed/simple;
	bh=B/4mle7WXocEOg/XFXGqmOukUqKiwytL8k0bx0tZoF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MB67Q9/H9oZDlDoTJIH7CTg+d0zOedY5RuJb86NxSMRK4RQju2HNZ5KcnMPDBhLBKpA5tfrM0sm9OQ/A5GO561X7wkQ5VH0+bGc08m8ZOpovi1p/4SaChfQtAyiey4ClOMSuaLZRjWhNVAcU0W7NYF80uvuYuPM+nndNr1Aog+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aKv0Qlwm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aKv0Qlwm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=hJg1IHT6ctz5VzmbhBIsMLqfKq0fiJuOtJ2q4VPULPg=; b=aKv0QlwmA6DShU/lZP4syMuQoz
	j6ztPTmrRChC6AJEQ9G++BeSTdlw0LpBQ7MlYqRYwOHjj1jXygnzwG07K+OYChvlnb0SXKrU50DGg
	n9R9dj1+rgyFZA9hWJLqEvdfddQVgm+9KEAIm7KmWY2IkXV7piJSTTGgsM1NpuWLCu3HGyzoPP5H9
	fod2TDgpXpDVAM6uHopnFTr+YUlAgr/X4xh+KgXYK+v+escoAUI6EdKcHXESLSNQxgxgRv5l6tGMb
	MX4DmC+rWcAf8JCubL95yE6LN2g9fUYmGVo1JK2TVWyx0JbZGo8V9O5xj/gAklm5lqUDKy0W2Mwns
	ceyCqLPA==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSd9-0000000CZy7-13zQ;
	Fri, 07 Jun 2024 05:59:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: move integrity settings to queue_limits v2
Date: Fri,  7 Jun 2024 07:58:54 +0200
Message-ID: <20240607055912.3586772-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens, hi Martin,

this series converts the blk-integrity settings to sit in the queue
limits and be updated through the atomic queue limits API.

I've mostly tested this with nvme, scsi is only covered by simple
scsi_debug based tests.

For MD I found an pre-existing error handling bug when combining PI
capable devices with not PI capable devices.  The fix was posted here
(and is included in the git branch below):

   https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/

For dm-integrity my testing showed that even the baseline fails to create
the luks-based dm-crypto with dm-integrity backing for the authentication
data.  As the failure is non-fatal I've not addressed it here.

Note that the support for native metadata in dm-crypt by Mikulas will
need a rebase on top of this, but as it already requires another
block layer patch and the changes in this series will simplify it a bit
I hope that is ok.

The series is based on top of my previously sent "convert the SCSI ULDs
to the atomic queue limits API v2" API.

A git tree is available here:

   git://git.infradead.org/users/hch/block.git block-integrity-limits

Gitweb:

   http://git.infradead.org/?p=users/hch/block.git;a=shortlog;h=refs/heads/block-integrity-limits

Changes since v1:
 - keep generating (empty) non-PI metadata
 - use a packed enum for the csum type
 - remove an unused flag left in the code

Diffstat:
 Documentation/block/data-integrity.rst |   49 ------
 block/Kconfig                          |    8 -
 block/Makefile                         |    3 
 block/bio-integrity.c                  |   33 +---
 block/blk-integrity.c                  |  229 ++++++++----------------------
 block/blk-mq.c                         |   13 -
 block/blk-settings.c                   |  118 ++++++++++++++-
 block/blk.h                            |    8 +
 block/t10-pi.c                         |  249 +++++++++++----------------------
 drivers/md/dm-core.h                   |    1 
 drivers/md/dm-crypt.c                  |    4 
 drivers/md/dm-integrity.c              |   47 +-----
 drivers/md/dm-table.c                  |  161 +++------------------
 drivers/md/md.c                        |   72 ++-------
 drivers/md/md.h                        |    5 
 drivers/md/raid0.c                     |    7 
 drivers/md/raid1.c                     |   10 -
 drivers/md/raid10.c                    |   10 -
 drivers/md/raid5.c                     |    2 
 drivers/nvdimm/btt.c                   |   13 -
 drivers/nvme/host/Kconfig              |    1 
 drivers/nvme/host/core.c               |   71 ++++-----
 drivers/nvme/host/multipath.c          |    3 
 drivers/nvme/target/Kconfig            |    1 
 drivers/nvme/target/io-cmd-bdev.c      |   16 +-
 drivers/scsi/Kconfig                   |    1 
 drivers/scsi/sd.c                      |   28 +--
 drivers/scsi/sd.h                      |   12 -
 drivers/scsi/sd_dif.c                  |   45 ++---
 drivers/target/target_core_iblock.c    |   49 +++---
 include/linux/bio.h                    |    7 
 include/linux/blk-integrity.h          |   62 ++------
 include/linux/blkdev.h                 |   26 ++-
 include/linux/t10-pi.h                 |   20 --
 34 files changed, 523 insertions(+), 861 deletions(-)
