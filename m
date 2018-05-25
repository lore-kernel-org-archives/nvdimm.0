Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD1132096184C
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 19:55:22 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/7] Fix DM DAX handling
Date: Thu, 24 May 2018 20:55:11 -0600
Message-Id: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This series fixes a few issues that I found with DM's handling of DAX
devices.  Here are some of the issues I found:

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a raw PMEM namespace but which can hold a
   filesystem mounted with the -o dax mount option.  DAX operations to
   the raw PMEM namespace part lack struct page and can fail in
   interesting/unexpected ways when doing things like fork(), examining
   memory with gdb, etc.

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
   mounted with the -o dax mount option.  All I/O to this filesystem
   will fail.

 * In DM you can't transition a dm target which could possibly support
   DAX (mode DM_TYPE_DAX_BIO_BASED) to one which can't support DAX
   (mode DM_TYPE_BIO_BASED), even if you never use DAX.

The first 2 patches in this series are prep work from Darrick and Dave
which improve bdev_dax_supported().  The last 5 problems fix the above
mentioned problems in DM.  I feel that this series simplifies the
handling of DAX devices in DM, and the last 5 DM-related patches have a
net code reduction of 50 lines.


Darrick J. Wong (1):
  fs: allow per-device dax status checking for filesystems

Dave Jiang (1):
  dax: change bdev_dax_supported() to support boolean returns

Ross Zwisler (5):
  dm: fix test for DAX device support
  dm: prevent DAX mounts if not supported
  dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
  dm-snap: remove unnecessary direct_access() stub
  dm-error: remove unnecessary direct_access() stub

 drivers/dax/super.c           | 44 +++++++++++++++++++++----------------------
 drivers/md/dm-ioctl.c         | 16 ++++++----------
 drivers/md/dm-snap.c          |  8 --------
 drivers/md/dm-table.c         | 29 +++++++++++-----------------
 drivers/md/dm-target.c        |  7 -------
 drivers/md/dm.c               |  7 ++-----
 fs/ext2/super.c               |  3 +--
 fs/ext4/super.c               |  3 +--
 fs/xfs/xfs_ioctl.c            |  3 ++-
 fs/xfs/xfs_iops.c             | 30 ++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c            | 10 ++++++++--
 include/linux/dax.h           | 12 ++++--------
 include/linux/device-mapper.h |  8 ++++++--
 13 files changed, 88 insertions(+), 92 deletions(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
