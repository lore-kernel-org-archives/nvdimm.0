Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo11.lge.com (LGEAMRELO11.lge.com [156.147.23.51])
 by ml01.01.org (Postfix) with ESMTP id 6244D21D490F3
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 22:15:25 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 0/7] Replace rw_page with on-stack bio
Date: Fri, 11 Aug 2017 14:17:20 +0900
Message-Id: <1502428647-28928-1-git-send-email-minchan@kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Recently, there was a dicussion about removing rw_page due to maintainance
burden[1] but the problem was zram because zram has a clear win for the
benchmark at that time. The reason why only zram have a win is due to
bio allocation wait time from mempool under extreme memory pressure.

Christoph Hellwig suggested we can use on-stack-bio for rw_page devices.
This patch implements it and replace rw_page operations with on-stack-bio
and then finally, remove rw_page interface completely.

This patch is based on linux-next-20170804

[1] http://lkml.kernel.org/r/<20170728165604.10455-1-ross.zwisler@linux.intel.com>

* from v1
  * Fix trivial mistake
  * simplify on-stack bio code - Matthew

Minchan Kim (7):
  zram: set BDI_CAP_STABLE_WRITES once
  bdi: introduce BDI_CAP_SYNCHRONOUS_IO
  fs: use on-stack-bio if backing device has BDI_CAP_SYNCHRONOUS
    capability
  mm:swap: remove end_swap_bio_write argument
  mm:swap: use on-stack-bio for BDI_CAP_SYNCHRONOUS device
  zram: remove zram_rw_page
  fs: remove rw_page

 drivers/block/brd.c           |  2 +
 drivers/block/zram/zram_drv.c | 68 +++-----------------------------
 drivers/nvdimm/btt.c          |  3 ++
 drivers/nvdimm/pmem.c         |  2 +
 fs/block_dev.c                | 76 ------------------------------------
 fs/mpage.c                    | 56 ++++++++++++++++++---------
 include/linux/backing-dev.h   |  8 ++++
 include/linux/blkdev.h        |  4 --
 include/linux/swap.h          |  6 +--
 mm/page_io.c                  | 90 ++++++++++++++++++++++++-------------------
 mm/swapfile.c                 |  3 ++
 mm/zswap.c                    |  2 +-
 12 files changed, 116 insertions(+), 204 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
