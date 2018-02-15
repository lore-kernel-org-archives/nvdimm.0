Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85A91220F33D1
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 13:34:45 -0800 (PST)
Subject: [PATCH v5 0/3] minimal DAX support for XFS realtime device
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Feb 2018 14:40:37 -0700
Message-ID: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Darrick,
After reading the comments from you, Dave Chinner, and Dan, it looks like
the dyanmic S_DAX flag support won't be coming or not any time soon at the
least. Here are the the collection of patches so far to address yours and
Dave C's comments for minimal support. Please let me know what else I am
missing. Thanks!

v5:
- Removed sb parameter for bdev_dax_supported() since we only use it for
  debug output per Christoph comment.

v4:
- Removed setting of error return in ext2 and ext4 per Ross's comments
- Rebased against 4.16-rc1 with updates

---

Darrick J. Wong (1):
      fs: allow per-device dax status checking for filesystems

Dave Jiang (2):
      dax: change bdev_dax_supported() to support boolean returns
      xfs: reject removal of realtime flag when datadev doesn't support DAX


 drivers/dax/super.c |   44 ++++++++++++++++++++++----------------------
 fs/ext2/super.c     |    3 +--
 fs/ext4/super.c     |    3 +--
 fs/xfs/xfs_ioctl.c  |   17 ++++++++++++++++-
 fs/xfs/xfs_iops.c   |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c  |   10 ++++++++--
 include/linux/dax.h |   12 ++++--------
 7 files changed, 77 insertions(+), 42 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
