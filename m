Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D3B32237A4DE
 for <linux-nvdimm@lists.01.org>; Sun,  4 Feb 2018 15:08:40 -0800 (PST)
Subject: [PATCH 0/3] vfio, dax: disable filesystem-dax and minor fixups
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 04 Feb 2018 15:05:15 -0800
Message-ID: <151778551496.7139.17808629759104553625.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: alex.williamson@redhat.com
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Alex, here is a change to vaddr_get_pfn() that we discussed in this
thread: https://lists.nongnu.org/archive/html/qemu-devel/2018-01/msg07117.html

Namely, drop support for passing Filesystem-DAX mappings through to
guests. Perhaps in the future we can create some para-virtualized
passthrough interface to coordinate guest-DMA vs host-filesystem
operations. For now, this needs to be disabled for data-integrity and
guaranteeing forward progress of filesystem operations.

If you want to take this through your tree please grab the other dax
fixups as well. Otherwise, let me know and I'll take the lot through the
nvdimm tree.

---

Dan Williams (3):
      dax: fix S_DAX definition
      dax: short circuit vma_is_fsdax() in the CONFIG_FS_DAX=n case
      vfio: disable filesystem-dax page pinning


 drivers/vfio/vfio_iommu_type1.c |   18 +++++++++++++++---
 include/linux/fs.h              |    4 +++-
 2 files changed, 18 insertions(+), 4 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
