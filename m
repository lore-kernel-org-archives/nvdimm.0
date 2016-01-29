Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 0/2] block: fix raw block device dax support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jan 2016 07:18:35 -0800
Message-ID: <20160129151835.18752.9423.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@fb.com, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The dax support for a raw block device did not account for page cache
entries established by the kernel for partition reads.  This breaks dax
as it assumes that page cache entries are limited to covering holes in
files, or are exceptional entries marking dirty pages.

Additionally, the facility to toggle dax at runtime fails to handle
evacuating the page cache when switching from non-dax-mode to dax-mode.
It needs to be rethought as enabling dax needs to be atomic with
flushing the page cache.

---

Dan Williams (2):
      block: revert runtime dax control of the raw block device
      block: use DAX for partition table reads


 block/ioctl.c             |   38 --------------------------------------
 block/partition-generic.c |   18 +++++++++++++++---
 fs/block_dev.c            |   28 ----------------------------
 fs/dax.c                  |   20 ++++++++++++++++++++
 include/linux/blkdev.h    |   10 ++++++++++
 include/linux/fs.h        |    3 ---
 include/uapi/linux/fs.h   |    1 -
 7 files changed, 45 insertions(+), 73 deletions(-)
