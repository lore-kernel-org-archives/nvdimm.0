Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA76620359E99
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 10:09:20 -0800 (PST)
Subject: [PATCH v3 0/4] introduce get_user_pages_longterm()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 10:05:29 -0800
Message-ID: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Sean Hefty <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Jan Kara <jack@suse.cz>, Joonyoung Shim <jy0922.shim@samsung.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, hch@lst.de, Inki Dae <inki.dae@samsung.com>, linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>, Kyungmin Park <kyungmin.park@samsung.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:
* Add a comment for the vma_is_fsdax() check in get_vaddr_frames() (Jan)
* Collect Jan's Reviewed-by.
* Rebased on v4.15-rc1

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013295.html

The summary text below is unchanged from v2.

---

Andrew,

Here is a new get_user_pages api for cases where a driver intends to
keep an elevated page count indefinitely. This is distinct from usages
like iov_iter_get_pages where the elevated page counts are transient.
The iov_iter_get_pages cases immediately turn around and submit the
pages to a device driver which will put_page when the i/o operation
completes (under kernel control).

In the longterm case userspace is responsible for dropping the page
reference at some undefined point in the future. This is untenable for
filesystem-dax case where the filesystem is in control of the lifetime
of the block / page and needs reasonable limits on how long it can wait
for pages in a mapping to become idle.

Fixing filesystems to actually wait for dax pages to be idle before
blocks from a truncate/hole-punch operation are repurposed is saved for
a later patch series.

Also, allowing longterm registration of dax mappings is a future patch
series that introduces a "map with lease" semantic where the kernel can
revoke a lease and force userspace to drop its page references.

I have also tagged these for -stable to purposely break cases that might
assume that longterm memory registrations for filesystem-dax mappings
were supported by the kernel. The behavior regression this policy change
implies is one of the reasons we maintain the "dax enabled. Warning:
EXPERIMENTAL, use at your own risk" notification when mounting a
filesystem in dax mode.

It is worth noting the device-dax interface does not suffer the same
constraints since it does not support file space management operations
like hole-punch.

---

Dan Williams (4):
      mm: introduce get_user_pages_longterm
      mm: fail get_vaddr_frames() for filesystem-dax mappings
      [media] v4l2: disable filesystem-dax mapping support
      IB/core: disable memory registration of fileystem-dax vmas


 drivers/infiniband/core/umem.c            |    2 -
 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +-
 include/linux/fs.h                        |   14 ++++++
 include/linux/mm.h                        |   13 ++++++
 mm/frame_vector.c                         |   12 +++++
 mm/gup.c                                  |   64 +++++++++++++++++++++++++++++
 6 files changed, 107 insertions(+), 3 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
