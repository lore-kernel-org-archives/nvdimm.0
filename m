Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B1EF212108E3
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:09 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v3 00/18] btrfs dax support
Date: Tue, 16 Apr 2019 11:41:36 -0500
Message-Id: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This patch set adds support for dax on the BTRFS filesystem.
In order to support for CoW for btrfs, there were changes which had to be
made to the dax handling. The important one is copying blocks into the
same dax device before using them which is performed by iomap
type IOMAP_DAX_COW.

Snapshotting and CoW features are supported (including mmap preservation
across snapshots).

Git: https://github.com/goldwynr/linux/tree/btrfs-dax

Changes since v2:
 - Created a new type IOMAP_DAX_COW as opposed to flag IOMAP_F_COW
 - CoW source address is presented in iomap.inline_data
 - Split the patches to more elaborate dax/iomap patches

Changes since v1:
 - use iomap instead of redoing everything in btrfs
 - support for mmap writeprotecting on snapshotting


 fs/btrfs/Makefile            |    1 
 fs/btrfs/ctree.h             |   38 +++++
 fs/btrfs/dax.c               |  288 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/disk-io.c           |    4 
 fs/btrfs/file.c              |   37 ++++-
 fs/btrfs/inode.c             |  114 ++++++++++++-----
 fs/btrfs/ioctl.c             |   29 +++-
 fs/btrfs/send.c              |    4 
 fs/btrfs/super.c             |   30 ++++
 fs/dax.c                     |  152 ++++++++++++++++++++--
 fs/iomap.c                   |    9 -
 fs/ocfs2/file.c              |    2 
 fs/read_write.c              |   10 -
 fs/xfs/xfs_reflink.c         |    2 
 include/linux/dax.h          |   13 +
 include/linux/fs.h           |    7 -
 include/linux/iomap.h        |    7 +
 include/trace/events/btrfs.h |   56 ++++++++
 18 files changed, 717 insertions(+), 86 deletions(-)

-- 
Goldwyn


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
