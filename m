Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/2] block drivers + dax vs driver unbind
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Sep 2015 20:41:25 -0400
Message-ID: <20150930002927.37133.331.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Keith Busch <keith.busch@intel.com>, ross.zwisler@linux.intel.com, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Auditing pmem driver teardown operations, while developing
get_user_pages() support for dax [1], revealed that we can trivially
crash the kernel by triggering new i/o requests after unbinding the pmem
driver.  In fact, any bio-based driver is susceptible to this crash
because the queue draining done at shutdown uses in flight 'struct
request' objects to pin the queue active.

Solve the problem generically for all drivers and export the new
blk_queue_enter() and blk_queue_exit() helpers for dax to indicate when
the "request queue" is busy (i.e. we are actively using an address
returned by ->direct_access()).

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002199.html

---

Dan Williams (2):
      block: generic request_queue reference counting
      block, dax: fix lifetime of in-kernel dax mappings


 block/blk-core.c       |   71 +++++++++++++++++++++++---
 block/blk-mq-sysfs.c   |    6 --
 block/blk-mq.c         |   80 +++++++++---------------------
 block/blk-sysfs.c      |    3 -
 block/blk.h            |   12 ++++
 fs/dax.c               |  130 +++++++++++++++++++++++++++++++-----------------
 include/linux/blk-mq.h |    1 
 include/linux/blkdev.h |    4 +
 8 files changed, 185 insertions(+), 122 deletions(-)
