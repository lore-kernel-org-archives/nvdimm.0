Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 329F521DFC897
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:39:32 -0700 (PDT)
Subject: [PATCH 0/2] fs: cache dax_device lookup result
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 17:35:43 -0700
Message-ID: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Christoph notes:

    I just noticed that we now do a fs_dax_get_by_host in every
    iomap_begin call for DAX.  This function iterates a list, does a
    string compared and igrab.  I really think we need to cache this in
    the superblock (possible even the fs superblock) similar to what we
    do for the block device.

Fix this up to cache the result of the dax_device lookup in 'struct
xfs_mount' for xfs and 'struct super_block' for ext2/ext4.

---

Dan Williams (2):
      xfs: cache dax_device lookup result
      ext2, ext4: cache dax_device lookup result


 fs/ext2/inode.c    |   11 +++++++----
 fs/ext4/inode.c    |   11 +++++++----
 fs/xfs/xfs_aops.c  |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_aops.h  |    1 +
 fs/xfs/xfs_buf.h   |    1 +
 fs/xfs/xfs_iomap.c |    9 +--------
 include/linux/fs.h |    3 +++
 7 files changed, 44 insertions(+), 16 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
