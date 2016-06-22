Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1AB51A1E0A
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 17:05:43 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/3] Support DAX for device-mapper dm-linear devices
Date: Wed, 22 Jun 2016 17:54:51 -0600
Message-Id: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

This patch-set adds DAX support to device-mapper dm-linear devices
used by LVM.  It works with LVM commands as follows:
 - Creation of a logical volume with all DAX capable devices (such
   as pmem) sets the logical volume DAX capable as well.
 - Once a logical volume is set to DAX capable, the volume may not
   be extended with non-DAX capable devices.

The direct_access interface is added to dm and dm-linear to map
a request to a target device.

The patches replace v1 series at:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

v2:
 - Fix issue with partitioning.
 - Change to add DAX flag to a request queue.

---
Toshi Kani (3):
 1/3 block: add QUEUE_FLAG_DAX for devices to advertise their DAX support
 2/3 dm: add infrastructure for DAX support
 3/3 dm linear: add DAX support

---
 drivers/block/brd.c           |  4 +++-
 drivers/md/dm-linear.c        | 23 ++++++++++++++++++++++-
 drivers/md/dm-table.c         | 23 ++++++++++++++++++++---
 drivers/md/dm.c               | 36 +++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |  1 +
 drivers/nvdimm/pmem.c         |  1 +
 drivers/s390/block/dcssblk.c  |  1 +
 fs/block_dev.c                |  5 +++--
 include/linux/blkdev.h        |  2 ++
 include/linux/device-mapper.h | 16 ++++++++++++++++
 10 files changed, 104 insertions(+), 8 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
