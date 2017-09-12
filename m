Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6B3A20945C0D
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 22:02:33 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/5] ext4: DAX data corruption fixes
Date: Mon, 11 Sep 2017 23:05:21 -0600
Message-Id: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
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
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

This series prevents a pair of data corruptions with ext4 + DAX.  The first
such corruption happens when combining the inline data feature with DAX,
and the second happens when combining data journaling with DAX.

Both can be reliably reproduced with the fstests that I have posted here:

https://patchwork.kernel.org/patch/9948377/
https://patchwork.kernel.org/patch/9948381/

My opinion is that the first three patches in this series should be applied
to the v4.14 RC series and backported to stable.  The last two patches in
this series are just cleanup and can probably wait until v4.15.

Ross Zwisler (5):
  ext4: prevent data corruption with inline data + DAX
  ext4: prevent data corruption with journaling + DAX
  ext4: add sanity check for encryption + DAX
  ext4: add ext4_should_use_dax()
  ext4: remove duplicate extended attributes defs

 fs/ext4/ext4.h   | 37 -------------------------------------
 fs/ext4/inline.c | 10 ----------
 fs/ext4/inode.c  | 24 ++++++++++++++++--------
 fs/ext4/ioctl.c  | 16 +++++++++++++---
 fs/ext4/super.c  |  8 ++++++++
 5 files changed, 37 insertions(+), 58 deletions(-)

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
