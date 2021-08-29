Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727893FC1
	for <nvdimm@lists.linux.dev>; Sun, 29 Aug 2021 12:25:42 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AhtUtwa27tAqbjRTnawv0fAqjBI4kLtp133Aq?=
 =?us-ascii?q?2lEZdPU1SL39qynKppkmPHDP5gr5J0tLpTntAsi9qBDnhPtICOsqTNSftWDd0Q?=
 =?us-ascii?q?PGEGgI1/qB/9SPIU3D398Y/aJhXow7M9foEGV95PyQ3CCIV/om3/mLmZrFudvj?=
X-IronPort-AV: E=Sophos;i="5.84,361,1620662400"; 
   d="scan'208";a="113656446"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Aug 2021 20:25:31 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 6759A4D0D4A1;
	Sun, 29 Aug 2021 20:25:27 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Sun, 29 Aug 2021 20:25:23 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Sun, 29 Aug 2021 20:25:21 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <djwong@kernel.org>, <hch@lst.de>, <linux-xfs@vger.kernel.org>
CC: <ruansy.fnst@fujitsu.com>, <dan.j.williams@intel.com>,
	<david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, <rgoldwyn@suse.de>,
	<viro@zeniv.linux.org.uk>, <willy@infradead.org>
Subject: [PATCH v8 0/7] fsdax,xfs: Add reflink&dedupe support for fsdax
Date: Sun, 29 Aug 2021 20:25:10 +0800
Message-ID: <20210829122517.1648171-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 6759A4D0D4A1.A01A4
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

This patchset is attempt to add CoW support for fsdax, and take XFS,
which has both reflink and fsdax feature, as an example.

Changes from V7:
 - Patch 3: Update to iter model[1]
 - Patch 4: Add the missing memset() in CoW case
 - Remove iomap_iter2(), use 2 nested iomap_iter() instead
 - Patch 6: Remove dax_iomap_ops, handle end CoW operations in
      ->iomap_end()
 - Update docs, comments

One of the key mechanism need to be implemented in fsdax is CoW.  Copy
the data from srcmap before we actually write data to the destance
iomap.  And we just copy range in which data won't be changed.

Another mechanism is range comparison.  In page cache case, readpage()
is used to load data on disk to page cache in order to be able to
compare data.  In fsdax case, readpage() does not work.  So, we need
another compare data with direct access support.

With the two mechanisms implemented in fsdax, we are able to make reflink
and fsdax work together in XFS.

(Rebased on v5.14-rc4 and Christoph's "switch iomap to an iterator model v2"[1])
[1]: https://lore.kernel.org/linux-xfs/20210809061244.1196573-1-hch@lst.de/
==

Shiyang Ruan (7):
  fsdax: Output address in dax_iomap_pfn() and rename it
  fsdax: Introduce dax_iomap_cow_copy()
  fsdax: Replace mmap entry in case of CoW
  fsdax: Add dax_iomap_cow_copy() for dax_iomap_zero
  fsdax: Dedup file range to use a compare function
  xfs: support CoW in fsdax mode
  xfs: Add dax dedupe support

 fs/dax.c               | 319 ++++++++++++++++++++++++++++++++++-------
 fs/iomap/buffered-io.c |   7 +-
 fs/remap_range.c       |  39 +++--
 fs/xfs/xfs_bmap_util.c |   3 +-
 fs/xfs/xfs_file.c      |   6 +-
 fs/xfs/xfs_inode.c     |  57 ++++++++
 fs/xfs/xfs_inode.h     |   1 +
 fs/xfs/xfs_iomap.c     |  32 ++++-
 fs/xfs/xfs_iomap.h     |  32 +++++
 fs/xfs/xfs_iops.c      |   7 +-
 fs/xfs/xfs_reflink.c   |  15 +-
 include/linux/dax.h    |  15 +-
 include/linux/fs.h     |  12 +-
 include/linux/iomap.h  |   1 +
 14 files changed, 460 insertions(+), 86 deletions(-)

-- 
2.32.0



