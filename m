Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9E711A1F05
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 11:51:54 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/3] Add alignment check for DAX mount
Date: Mon,  2 May 2016 12:42:55 -0600
Message-Id: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.

Add alignment check to ext4, ext2, and xfs.

v2:
 - Use a helper function via ->direct_access for the check.
   (Christoph Hellwig)
 - Call bdev_direct_access() with sector 0 for the check.
   (Boaz Harrosh)

---
Toshi Kani (3):
 1/3 ext4: Add alignment check for DAX mount
 2/3 ext2: Add alignment check for DAX mount
 3/3 xfs: Add alignment check for DAX mount

---
 fs/ext2/super.c    | 21 +++++++++++++++++++--
 fs/ext4/super.c    | 20 ++++++++++++++++++--
 fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
 3 files changed, 56 insertions(+), 8 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
