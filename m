Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84A257A
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ub/NqoO4nrj7/CmhK+7Df7o2NLjdTjVuu2uglnNK6zU=; b=igUi7tuNh2ZEVpsTLWJ2mUfsso
	/agiH9BlTOdVnjHdC5CP7jvaMLnN0yMuR0L/cUS8cCaVotLH6KMLpU9wMqUK9tg5fLresZQ0ResoO
	qhgIVJenDLh9+Hq/MxySQTD8U38ChmdA0/wpZjAGnJU+nV/2vA9fQ5kC6DVa50/8eImse5I4lmsjK
	RvGEtZsA6SjM24gurJTX3ltM16oJEuw2PjJ37+MpvrMzbNTs1nxC+zue1HISRBXKVaQyOFmELIyvL
	naCxtOCKlEygyT4OQWCOKsE6keEVzXnJ9aD9SVX5/tcHsnVaIVSHzUuR3a9N4FskdJDJPYw7eZijX
	mpcvweBA==;
Received: from [2001:4bb8:19a:27af:c78f:9b0d:b95c:d248] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pKfvD-007P0o-SE; Wed, 25 Jan 2023 13:34:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: remove ->rw_page
Date: Wed, 25 Jan 2023 14:34:29 +0100
Message-Id: <20230125133436.447864-1-hch@lst.de>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series removes the ->rw_page block_device_operation, which is an old
and clumsy attempt at a simple read/write fast path for the block layer.
It isn't actually used by the fastest block layer operations that we
support (polled I/O through io_uring), but only used by the mpage buffered
I/O helpers which are some of the slowest I/O we have and do not make any
difference there at all, and zram which is a block device abused to
duplicate the zram functionality.  Given that zram is heavily used we
need to make sure there is a good replacement for synchronous I/O, so
this series adds a new flag for drivers that complete I/O synchronously
and uses that flag to use on-stack bios and synchronous submission for
them in the swap code.

Diffstat:
 block/bdev.c                  |   78 ------------------
 drivers/block/brd.c           |   15 ---
 drivers/block/zram/zram_drv.c |   61 --------------
 drivers/nvdimm/btt.c          |   16 ---
 drivers/nvdimm/pmem.c         |   24 -----
 fs/mpage.c                    |   10 --
 include/linux/blkdev.h        |   12 +-
 mm/page_io.c                  |  182 ++++++++++++++++++++++--------------------
 mm/swap.h                     |    9 --
 mm/swapfile.c                 |    2 
 10 files changed, 114 insertions(+), 295 deletions(-)
