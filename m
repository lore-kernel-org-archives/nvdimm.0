Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 22B321A1E2C
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 12:09:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/7] re-enable DAX PMD support
Date: Mon, 15 Aug 2016 13:09:11 -0600
Message-Id: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
locking.  This series allows DAX PMDs to participate in the DAX radix tree
based locking scheme so that they can be re-enabled.

This series restores DAX PMD functionality back to what it was before it
was disabled.  There is still a known issue between DAX PMDs and hole
punch, which I am currently working on and which I plan to address with a
separate series.

Ross Zwisler (7):
  ext2: tell DAX the size of allocation holes
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  dax: rename 'ret' to 'entry' in grab_mapping_entry
  dax: lock based on slot instead of [mapping, index]
  dax: re-enable DAX PMD support
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 301 ++++++++++++++++++++++++++--------------------------
 fs/ext2/inode.c     |   6 ++
 fs/ext4/inode.c     |   3 +
 include/linux/dax.h |  30 +++++-
 mm/filemap.c        |   7 +-
 6 files changed, 191 insertions(+), 157 deletions(-)

-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
