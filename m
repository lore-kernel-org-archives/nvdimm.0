Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD5DA21F6A6D9
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 16:46:09 -0800 (PST)
Subject: [PATCH v3 0/6] vfio,
 dax: prevent long term filesystem-dax pins and other fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Feb 2018 16:43:05 -0800
Message-ID: <151943298533.29249.14597996053028346159.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, kbuild test robot <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

* Fix yet more compile breakage in the FS_DAX=n and DEV_DAX=y case.
  (0day robot)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-February/014046.html

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

---

Dan Williams (6):
      dax: fix vma_is_fsdax() helper
      dax: fix dax_mapping() definition in the FS_DAX=n + DEV_DAX=y case
      xfs, dax: introduce IS_FSDAX()
      dax: fix S_DAX definition
      dax: short circuit vma_is_fsdax() in the CONFIG_FS_DAX=n case
      vfio: disable filesystem-dax page pinning


 drivers/vfio/vfio_iommu_type1.c |   18 +++++++++++++++---
 fs/xfs/xfs_file.c               |   14 +++++++-------
 fs/xfs/xfs_ioctl.c              |    4 ++--
 fs/xfs/xfs_iomap.c              |    6 +++---
 fs/xfs/xfs_reflink.c            |    2 +-
 include/linux/dax.h             |    9 ++++++---
 include/linux/fs.h              |    8 ++++++--
 7 files changed, 40 insertions(+), 21 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
