Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B039F1A1F77
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 17:38:54 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/5] Add alignment check for DAX mount
Date: Thu,  5 May 2016 18:29:51 -0600
Message-Id: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.  Add alignment check to ext4, ext2, and xfs.

- Patch 1-2 add bdev_supports_dax() which performs all the checks
  necessary for dax mount.
- Patch 3-5 change fillesystems to call bdev_supports_dax().

v3:
 - Remove boilerplate code from filesytems (Christoph Hellwig)
 - Add a helper function to perform all checks (Dave Chinner)

v2:
 - Use a helper function via ->direct_access for the check.
   (Christoph Hellwig)
 - Call bdev_direct_access() with sector 0 for the check.
   (Boaz Harrosh)

---
Toshi Kani (5):
 1/5 block: Add vfs_msg() interface
 2/5 block: Add bdev_supports_dax() for dax mount checks
 3/5 ext4: Add alignment check for DAX mount
 4/5 ext2: Add alignment check for DAX mount
 5/5 xfs: Add alignment check for DAX mount

---
 fs/block_dev.c         | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext2/super.c        | 11 ++--------
 fs/ext4/super.c        | 11 ++--------
 fs/xfs/xfs_super.c     | 12 +++++------
 include/linux/blkdev.h | 12 +++++++++++
 5 files changed, 75 insertions(+), 25 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
