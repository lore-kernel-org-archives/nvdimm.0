Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664E13E03A;
	Thu, 13 Jun 2024 08:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268531; cv=none; b=mg+O/9V82/R/DJPnLMGVRIwIanrRSCAEzt6Flx4AaPHYeQf6ixeW3U7BaY9/Ce3ZxN9j0YP5FDgDu7aoN2a2YY/H65HFtBbt0vA1TNXd3zPjbydsdMLFLEEE8JIFZzOVIbOTJKlkyXPGbdgGUXdbPQO9cBJlhAtAHNzaJ4SMaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268531; c=relaxed/simple;
	bh=UPEjs62Wpn3evlgSlGdUkWowj524r9sG34zhnPm7Qnc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fH0yhKdkI7ekgUICvmOZqmQ6pjYBBxLgFC0hFA8klW48yoBDTt4gSK5Dk7lobz2xAVF4vRT4Dd9delmyuU2/tCAlAf94VZadYl4t3VVAQWSCsmVE6R0CDycvYECj71hw9iql7YUITA07F1MYtlqPdnxGGPXJ8SgH6dV6zj/LnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ykiDuOwv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ykiDuOwv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=69hwmAUSv/j+TXHCdy2rjSQIuzs0bMCzQe9fsw0+Ub0=; b=ykiDuOwvx6p8cUetLkOCo0P7RB
	skRoIHtaL2glXqiaMZrVeosdp5Y0Yt7WNh0UTqIkjHww3+Ur15CEjtAQcIasQ7FEGvQK1Kt7cCsHb
	UMWn9yWoXeXWtYWCBSj96wQz+INhOv9nJ3ZSI82+ERRbOgnJDOF+yiEBs3q8NT9ttQpamIxBaNJf9
	MvshqTiVMaW7d8YWXsIdNPWOspwDlT7eQZQ9sIEhkr5JTIHkHbdMtPfWPH7StMBiH9M+/Jv9pHNTg
	U3y7YD0k8Q5RNxywux3OCEWZaIZwxuIur8X2h983r+0NyLwaocPB2T6iJw1btlJ50OglxS341PGBi
	LAKyvdXQ==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8Q-0000000Fmy7-1TRu;
	Thu, 13 Jun 2024 08:48:42 +0000
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
Subject: move integrity settings to queue_limits v3
Date: Thu, 13 Jun 2024 10:48:10 +0200
Message-ID: <20240613084839.1044015-1-hch@lst.de>
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

Changes since v2:
 - keep the unused BIP_CTRL_NOCHECK, BIP_DISK_NOCHECK and
   BIP_IP_CHECKSUM flags for now

Changes since v1:
 - keep generating (empty) non-PI metadata
 - use a packed enum for the csum type
 - remove an unused flag left in the code

Diffstat:
 Documentation/block/data-integrity.rst |   49 ------
 block/Kconfig                          |    8 -
 block/Makefile                         |    3 
 block/bio-integrity.c                  |   43 +++--
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
 drivers/md/raid0.c                     |   28 +--
 drivers/md/raid1.c                     |   24 +--
 drivers/md/raid10.c                    |   10 -
 drivers/md/raid5.c                     |    2 
 drivers/nvdimm/btt.c                   |   13 -
 drivers/nvme/host/Kconfig              |    1 
 drivers/nvme/host/core.c               |   71 ++++-----
 drivers/nvme/host/multipath.c          |    3 
 drivers/nvme/target/Kconfig            |    1 
 drivers/nvme/target/io-cmd-bdev.c      |   16 +-
 drivers/scsi/Kconfig                   |    1 
 drivers/scsi/sd.c                      |    8 -
 drivers/scsi/sd.h                      |   12 -
 drivers/scsi/sd_dif.c                  |   45 ++---
 drivers/target/target_core_iblock.c    |   49 +++---
 include/linux/blk-integrity.h          |   62 ++------
 include/linux/blkdev.h                 |   25 ++-
 include/linux/t10-pi.h                 |   20 --
 33 files changed, 533 insertions(+), 868 deletions(-)
