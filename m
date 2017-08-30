Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AED821E70D40
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 12:50:08 -0700 (PDT)
Subject: [PATCH v3 0/4] fs, dax: lookup dax_device at mount time
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 12:43:47 -0700
Message-ID: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:
* Split fs_dax_get_by_bdev() to its own patch (Christoph)

* Push dax_device reference management into <fs>_{fill,put}_super()
  rather than the generic vfs. (Christoph)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-August/012133.html

---

Christoph notes:

    I just noticed that we now do a fs_dax_get_by_host in every
    iomap_begin call for DAX. This function iterates a list, does a
    string compared and igrab. I really think we need to cache this in
    the superblock (possible even the fs superblock) similar to what we
    do for the block device.

This passes the libnvdimm unit tests.

---

Dan Williams (4):
      dax: introduce a fs_dax_get_by_bdev() helper
      xfs: perform dax_device lookup at mount
      ext2: perform dax_device lookup at mount
      ext4: perform dax_device lookup at mount


 drivers/dax/super.c |   10 ++++++++++
 fs/ext2/ext2.h      |    1 +
 fs/ext2/inode.c     |   11 +++--------
 fs/ext2/super.c     |    5 +++++
 fs/ext4/ext4.h      |    1 +
 fs/ext4/inode.c     |   11 +++--------
 fs/ext4/super.c     |    5 +++++
 fs/xfs/xfs_aops.c   |   13 +++++++++++++
 fs/xfs/xfs_aops.h   |    1 +
 fs/xfs/xfs_buf.c    |    4 +++-
 fs/xfs/xfs_buf.h    |    3 ++-
 fs/xfs/xfs_iomap.c  |   10 +---------
 fs/xfs/xfs_super.c  |   25 +++++++++++++++++++++----
 include/linux/dax.h |    6 ++++++
 14 files changed, 75 insertions(+), 31 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
