Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAD6B21F6A6C9
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 20:22:54 -0800 (PST)
Subject: [PATCH v4 00/12] vfio,
 dax: prevent long term filesystem-dax pins and other fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Feb 2018 20:19:54 -0800
Message-ID: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jane Chu <jane.chu@oracle.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, linux-mm@kvack.org, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The following series implements...
Changes since v3 [1]:

* Kill IS_DAX() in favor of explicit IS_FSDAX() and IS_DEVDAX() helpers.
  Jan noted, "having IS_DAX() and IS_FSDAX() doing almost the same, just
  not exactly the same, is IMHO a recipe for confusion", and I agree. A
  nice side effect of this elimination is a cleanup to remove occasions of
  "#ifdef CONFIG_FS_DAX" in C files, it is all moved to header files
  now. (Jan)

---

The vfio interface, like RDMA, wants to setup long term (indefinite)
pins of the pages backing an address range so that a guest or userspace
driver can perform DMA to the with physical address. Given that this
pinning may lead to filesystem operations deadlocking in the
filesystem-dax case, the pinning request needs to be rejected.

The longer term fix for vfio, RDMA, and any other long term pin user, is
to provide a 'pin with lease' mechanism. Similar to the leases that are
hold for pNFS RDMA layouts, this userspace lease gives the kernel a way
to notify userspace that the block layout of the file is changing and
the kernel is revoking access to pinned pages.

Related to this change is the discovery that vma_is_fsdax() was causing
device-dax inode detection to fail. That lead to series of fixes and
cleanups to make sure that S_DAX is defined correctly in the
CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case.

---

Dan Williams (12):
      dax: fix vma_is_fsdax() helper
      dax: introduce IS_DEVDAX() and IS_FSDAX()
      ext2, dax: finish implementing dax_sem helpers
      ext2, dax: define ext2_dax_*() infrastructure in all cases
      ext4, dax: define ext4_dax_*() infrastructure in all cases
      ext2, dax: replace IS_DAX() with IS_FSDAX()
      ext4, dax: replace IS_DAX() with IS_FSDAX()
      xfs, dax: replace IS_DAX() with IS_FSDAX()
      mm, dax: replace IS_DAX() with IS_DEVDAX() or IS_FSDAX()
      fs, dax: kill IS_DAX()
      dax: fix S_DAX definition
      vfio: disable filesystem-dax page pinning


 drivers/vfio/vfio_iommu_type1.c |   18 ++++++++++++++--
 fs/ext2/ext2.h                  |    6 +++++
 fs/ext2/file.c                  |   19 +++++------------
 fs/ext2/inode.c                 |   10 ++++-----
 fs/ext4/file.c                  |   18 +++++-----------
 fs/ext4/inode.c                 |    4 ++--
 fs/ext4/ioctl.c                 |    2 +-
 fs/ext4/super.c                 |    2 +-
 fs/iomap.c                      |    2 +-
 fs/xfs/xfs_file.c               |   14 ++++++-------
 fs/xfs/xfs_ioctl.c              |    4 ++--
 fs/xfs/xfs_iomap.c              |    6 +++--
 fs/xfs/xfs_reflink.c            |    2 +-
 include/linux/dax.h             |   12 ++++++++---
 include/linux/fs.h              |   43 ++++++++++++++++++++++++++++-----------
 mm/fadvise.c                    |    3 ++-
 mm/filemap.c                    |    4 ++--
 mm/huge_memory.c                |    4 +++-
 mm/madvise.c                    |    3 ++-
 19 files changed, 102 insertions(+), 74 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
