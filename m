Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 154BF21E1452F
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 23:16:06 -0700 (PDT)
Subject: [PATCH v4 0/3] MAP_DIRECT and block-map sealed files
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Aug 2017 23:12:05 -0700
Message-ID: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:
* Move from an fallocate(2) interface to a new mmap(2) flag and rename
  'immutable' to 'sealed'.

* Do not record the sealed state in permanent metadata it is now purely
  a temporary state for as long as a MAP_DIRECT vma is referencing the
  inode (Christoph)

* Drop the CAP_IMMUTABLE requirement, but do require a PROT_WRITE
  mapping.

[1]: https://lwn.net/Articles/730570/

---

This is the next revision of a patch series that aims to enable
applications that otherwise need to resort to DAX mapping a raw device
file to instead move to a filesystem.

In the course of reviewing a previous posting, Christoph said:

    That being said I think we absolutely should support RDMA memory
    registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
    helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure all
    the blocks are populated and all ptes are set up.  Second we need to
    make sure get_user_page works, which for now means we'll need a struct
    page mapping for the region (which will be really annoying for PCIe
    mappings, like the upcoming NVMe persistent memory region), and we need
    to guarantee that the extent mapping won't change while the
    get_user_pages holds the pages inside it.  I think that is true due to
    side effects even with the current DAX code, but we'll need to make it
    explicit.  And maybe that's where we need to converge - "sealing" the
    extent map makes sense as such a temporary measure that is not persisted
    on disk, which automatically gets released when the holding process
    exits, because we sort of already do this implicitly.  It might also
    make sense to have explicitly breakable seals similar to what I do for
    the pNFS blocks kernel server, as any userspace RDMA file server would
    also need those semantics.

So, this is an attempt to converge on the idea that we need an explicit
and process-lifetime-temporary mechanism for a process to be able to
make assumptions about the mapping to physical page to dax-file-offset
relationship. The "explicitly breakable seals" aspect is not addressed
in these patches, but I wonder if it might be a voluntary mechanism that
can implemented via userfaultfd.

These pass a basic smoke test and are meant to just gauge 'right track'
/ 'wrong track'. The main question it seems is whether the pinning done
in this patchset is too early (applies before get_user_pages()) and too
coarse (applies to the whole file). Perhaps this is where I discarded
too easily Jan's suggestion to look at Peter Z's mm_mpin() syscall [2]? On
the other hand, the coarseness and simple lifetime rules of MAP_DIRECT
make it an easy mechanism to implement and explain.

Another reason I kept the scope of S_IOMAP_SEALED coarsely defined was
to support Dave's desired use case of sealing for operating on reflinked
files [3].

Suggested mmap(2) man page edits are included in the changelog of patch
3.

[2]: https://lwn.net/Articles/600502/
[3]: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1467677.html

---

Dan Williams (3):
      fs, xfs: introduce S_IOMAP_SEALED
      mm: introduce MAP_VALIDATE a mechanism for adding new mmap flags
      fs, xfs: introduce MAP_DIRECT for creating block-map-sealed file ranges


 fs/attr.c                              |   10 +++
 fs/dax.c                               |    2 +
 fs/open.c                              |    6 ++
 fs/read_write.c                        |    3 +
 fs/xfs/libxfs/xfs_bmap.c               |    5 +
 fs/xfs/xfs_bmap_util.c                 |    3 +
 fs/xfs/xfs_file.c                      |  107 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h                     |    1 
 fs/xfs/xfs_ioctl.c                     |    6 ++
 fs/xfs/xfs_super.c                     |    1 
 include/linux/fs.h                     |    9 +++
 include/linux/mm.h                     |    2 -
 include/linux/mm_types.h               |    1 
 include/linux/mman.h                   |    3 +
 include/uapi/asm-generic/mman-common.h |    2 +
 mm/filemap.c                           |    5 +
 mm/mmap.c                              |   22 ++++++-
 17 files changed, 183 insertions(+), 5 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
