Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28CC18178C
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:06:58 -0800 (PST)
Subject: [RFC PATCH v2 0/2] block: fix backing_dev_info lifetime
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:02:51 -0800
Message-ID: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-block@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>, Rabin Vincent <rabinv@axis.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, Wei Fang <fangwei1@huawei.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

v1 of these changes [1] was a one line change to bdev_get_queue() to
prevent a shutdown crash when del_gendisk() races the final
__blkdev_put().

While it is known at del_gendisk() time that the queue is still alive,
Jan Kara points to other paths [2] that are racing __blkdev_put() where
the assumption that ->bd_queue, or inode->i_wb is valid does not hold.

Fix that broken assumption, make it the case that if you have a live
block_device, or block_device-inode that the corresponding queue and
inode-write-back data is still valid.

These changes survive a run of the libnvdimm unit test suite which puts
some stress on the block_device shutdown path.

---

Changes since v1 [1]:

* Introduce "block: fix lifetime of request_queue / backing_dev_info
  relative to bdev" to keep the queue allocated and the inode attached
  for writeback until ->destroy_inode() time.

* Rework the comments in "block: fix blk_get_backing_dev_info() crash,
  use bdev->bd_queue" to reflect the assumptions about the liveness of
  ->bd_queue.

[1]: http://marc.info/?l=linux-block&m=148366637105761&w=2
[2]: http://www.spinics.net/lists/linux-fsdevel/msg105153.html

---

Dan Williams (2):
      block: fix lifetime of request_queue / backing_dev_info relative to bdev
      block: fix blk_get_backing_dev_info() crash, use bdev->bd_queue


 block/blk-core.c       |    7 ++++---
 fs/block_dev.c         |   25 +++++++++++++++----------
 include/linux/blkdev.h |    6 +++++-
 include/linux/fs.h     |    1 +
 4 files changed, 25 insertions(+), 14 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
