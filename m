Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 453C41A1F35
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 14:05:15 -0800 (PST)
From: NeilBrown <neilb@suse.com>
Date: Thu, 10 Mar 2016 08:59:28 +1100
Subject: [PATCH 0/4] Remove un-needed 'major' registration when
 alloc_disk(0) is used.
Message-ID: <20160309215702.20904.61407.stgit@noble>
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
To: Keith Busch <keith.busch@intel.com>, Maxim Levitsky <maximlevitsky@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>, Jens Axboe <axboe@fb.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When alloc_disk(0) is used, the ->major number is ignored and
irrelevant.  Yet several drivers register a major number anyway.

This series of patches removes the pointless registrations.  The pmem
driver also does this, but a patch has already been sent for that
driver.

Note that I am not in a position to test these beyond simple compile
testing.

Thanks,
NeilBrown


---

NeilBrown (4):
      nvdimm/blk: don't allocate unused major device number
      nvdimm/btt: don't allocate unused major device number
      memstick: don't allocate unused major for ms_block
      NVMe: don't allocate unused nvme_major


 drivers/memstick/core/ms_block.c |   17 ++---------------
 drivers/nvdimm/blk.c             |   18 +-----------------
 drivers/nvdimm/btt.c             |   19 ++-----------------
 drivers/nvme/host/core.c         |   16 +---------------
 4 files changed, 6 insertions(+), 64 deletions(-)

--
Signature

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
