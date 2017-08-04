Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x232.google.com (mail-vk0-x232.google.com
 [IPv6:2607:f8b0:400c:c05::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38E0221AEB0CD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 19:36:00 -0700 (PDT)
Received: by mail-vk0-x232.google.com with SMTP id d124so1496503vkf.2
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 19:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Aug 2017 19:38:11 -0700
Message-ID: <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

[ adding linux-api to the cover letter for notification, will send the
full set to linux-api for v3 ]

On Thu, Aug 3, 2017 at 7:28 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Changes since v1 [1]:
> * Add IS_IOMAP_IMMUTABLE() checks to xfs ioctl paths that perform block
>   map changes (xfs_alloc_file_space and xfs_free_file_space) (Darrick)
>
> * Rather than complete a partial write, fail all writes that would
>   attempt to extend the file size (Darrick)
>
> * Introduce FALLOC_FL_UNSEAL_BLOCK_MAP as an explicit operation type for
>   clearing S_IOMAP_IMMUTABLE (Dave)
>
> * Rework xfs_seal_file_space() to first complete hole-fill and unshare
>   operations and then check the file for suitability under
>   XFS_ILOCK_EXCL. (Darrick)
>
> * Add an FS_XFLAG_IOMAP_IMMUTABLE flag so the immutable state can be
>   seen by xfs_io. (Dave)
>
> * Move the setting of S_IOMAP_IMMUTABLE to be atomic with respect to the
>   successful transaction that records XFS_DIFLAG2_IOMAP_IMMUTABLE.
>   (Darrick, Dave)
>
> * Switch to a 'goto out_unlock' style in xfs_seal_file_space() to
>   cleanup 'if / else' tree, and use the mapping_mapped() helper. (Dave)
>
> * Rely on XFS_MMAPLOCK_EXCL for reading a stable state of
>   mapping->i_mmap. (Dave)
>
> [1]: http://marc.info/?l=linux-fsdevel&m=150135785712967&w=2
>
> ---
>
> The daxfile proposal a few weeks back [2] sought to piggy back on the
> swapfile implementation to approximate a block map immutable file. This
> is an idea Dave originated last year to solve the dax "flush from
> userspace" problem [3].
>
> The discussion yielded several results. First, Christoph pointed out
> that swapfiles are subtly broken [4].  Second, Darrick [5] and Dave [6]
> proposed how to properly implement a block map immutable file.  Finally,
> Dave identified some improvements to swapfiles that can be built on the
> block-map-immutable mechanism. These patches seek to implement the first
> part of the proposal and save the swapfile work to build on top once the
> base mechanism is complete.
>
> While the initial motivation for this feature is support for
> byte-addressable updates of persistent memory and managing cache
> maintenance from userspace, the applications of the feature are broader.
> In addition to being the start of a better swapfile mechanism it can
> also support a DMA-to-storage use case.  This use case enables
> data-acquisition hardware to DMA directly to a storage device address
> while being safe in the knowledge that storage mappings will not change.
>
> [2]: https://lkml.org/lkml/2017/6/16/790
> [3]: https://lkml.org/lkml/2016/9/11/159
> [4]: https://lkml.org/lkml/2017/6/18/31
> [5]: https://lkml.org/lkml/2017/6/20/49
> [6]: https://www.spinics.net/lists/linux-xfs/msg07871.html
>
> ---
>
> Dan Williams (5):
>       fs, xfs: introduce S_IOMAP_IMMUTABLE
>       fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
>       fs, xfs: introduce FALLOC_FL_UNSEAL_BLOCK_MAP
>       xfs: introduce XFS_DIFLAG2_IOMAP_IMMUTABLE
>       xfs: toggle XFS_DIFLAG2_IOMAP_IMMUTABLE in response to fallocate
>
>
>  fs/attr.c                   |   10 ++
>  fs/open.c                   |   22 +++++
>  fs/read_write.c             |    3 +
>  fs/xfs/libxfs/xfs_format.h  |    5 +
>  fs/xfs/xfs_bmap_util.c      |  181 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_util.h      |    5 +
>  fs/xfs/xfs_file.c           |   16 +++-
>  fs/xfs/xfs_inode.c          |    2
>  fs/xfs/xfs_ioctl.c          |    7 ++
>  fs/xfs/xfs_iops.c           |    8 +-
>  include/linux/falloc.h      |    4 +
>  include/linux/fs.h          |    2
>  include/uapi/linux/falloc.h |   20 +++++
>  include/uapi/linux/fs.h     |    1
>  mm/filemap.c                |    5 +
>  15 files changed, 282 insertions(+), 9 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
