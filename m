Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 881412095D9CE
 for <linux-nvdimm@lists.01.org>; Sat, 29 Jul 2017 12:47:48 -0700 (PDT)
Subject: [PATCH 0/3] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 29 Jul 2017 12:43:29 -0700
Message-ID: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: darrick.wong@oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

tl;dr: The proposed S_IOMAP_IMMUTABLE mechanism

The daxfile proposal a few weeks back [1] sought to piggy back on the
swapfile implementation to approximate a block map immutable file. This
is an idea Dave originated last year to solve the dax "flush from
userspace" problem [2].

The discussion yielded several results. First, Christoph pointed out that
swapfiles are subtly broken [3].  Second, Darrick [4]
and Dave [5] proposed how to properly implement a block map immutable file.
Finally, Dave identified some improvements to swapfiles that can be
built on the block-map-immutable mecahanism. These patches seek to
implement the first part of the proposal and save the swapfile work to
build on top once the base mechanism is complete.

While the initial motivation for this feature is support for
byte-addressable updates of persistent memory and managing cache
maintenance from userspace, the applications of the feature are broader.
In addition to being the start of a better swapfile mechanism it can
also support a DMA-to-storage use case.  This use case enables
data-acquisition hardware to DMA directly to a storage device address
while being safe in the knowledge that storage mappings will not change.

These patches are relative to Darrick's 'devel' tree. Patch 3 is likely
wrong in the way it sets the new XFS_DIFLAG2_IOMAP_IMMUTABLE flag, but
seems to work with a basic test. The test just turns the flag on and
off, checks that the file is fully allocated and immutable, and
validates that the state persists over a umount / mount cycle. A proper
xfstest is in the works, but comments on this first draft are welcome.

[1]: https://lkml.org/lkml/2017/6/16/790
[2]: https://lkml.org/lkml/2016/9/11/159
[3]: https://lkml.org/lkml/2017/6/18/31
[4]: https://lkml.org/lkml/2017/6/20/49
[5]: https://www.spinics.net/lists/linux-xfs/msg07871.html

---

Dan Williams (3):
      fs, xfs: introduce S_IOMAP_IMMUTABLE
      fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
      xfs: persist S_IOMAP_IMMUTABLE in di_flags2


 fs/attr.c                   |   10 ++++
 fs/namei.c                  |    3 +
 fs/open.c                   |   28 ++++++++++++
 fs/read_write.c             |    3 +
 fs/xfs/libxfs/xfs_format.h  |    5 ++
 fs/xfs/xfs_bmap_util.c      |   98 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_util.h      |    4 +-
 fs/xfs/xfs_file.c           |   14 ++++--
 fs/xfs/xfs_ioctl.c          |   10 ++++
 fs/xfs/xfs_iops.c           |    8 ++--
 include/linux/falloc.h      |    3 +
 include/linux/fs.h          |    2 +
 include/uapi/linux/falloc.h |   19 ++++++++
 mm/filemap.c                |    9 ++++
 14 files changed, 200 insertions(+), 16 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
