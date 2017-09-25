Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 535422095E513
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 16:11:12 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/7] re-enable XFS per-inode DAX
Date: Mon, 25 Sep 2017 17:13:57 -0600
Message-Id: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This series does the work needed to safely re-enable the XFS per-inode DAX
flag.  This includes fixes to make use of the DAX inode flag more safe and
consistent, fixes to the read and write I/O path locking to make S_DAX
transitions safe, and some code that prevents the DAX inode flag from
transitioning when any mappings are set up.

This series has passed my fstests regression testing both with and without
DAX, and it also passes Christoph's regression test for the inode flag:

https://www.spinics.net/lists/linux-xfs/msg10124.html

My goal is to get feedback on this approach and on the XFS implementation,
and then to do a similar implementation for ext4 based on my previous ext4
DAX inode flag patches:

https://patchwork.kernel.org/patch/9939743/

These patches apply cleanly to v4.14-rc2.

Ross Zwisler (7):
  xfs: always use DAX if mount option is used
  xfs: validate bdev support for DAX inode flag
  xfs: protect S_DAX transitions in XFS read path
  xfs: protect S_DAX transitions in XFS write path
  xfs: introduce xfs_is_dax_state_changing
  mm, fs: introduce file_operations->post_mmap()
  xfs: re-enable XFS per-inode DAX

 fs/xfs/xfs_file.c  | 172 ++++++++++++++++++++++-------------------------------
 fs/xfs/xfs_ioctl.c |  47 ++++++++++++---
 include/linux/fs.h |   1 +
 mm/mmap.c          |   2 +
 4 files changed, 114 insertions(+), 108 deletions(-)

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
