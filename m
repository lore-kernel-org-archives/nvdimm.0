Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27C8B21E62BB3
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 14:06:12 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] xfs: some DAX fixes
Date: Thu,  7 Sep 2017 15:08:30 -0600
Message-Id: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

These two fixes are to the now-disabled per-inode DAX support in XFS.  I
started working on these in the v4.13 timeframe before the per-inode
DAX feature was turned off.

I realize that they may not be critical right now since the per-inode DAX
feature is turned off, but I think that if we ever do re-enable that
feature we will want these two issues to have been fixed.

I also do think that they are both vaulable for stable kernels.

These used to be part of my ext4 per-inode enabling:

https://lkml.org/lkml/2017/9/5/748

But I've since split that into a series of XFS bug fixes (these two) and a
series of ext4 bug fixes.

Ross Zwisler (2):
  xfs: always use DAX if mount option is used
  xfs: validate bdev support for DAX inode flag

 fs/xfs/xfs_ioctl.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
