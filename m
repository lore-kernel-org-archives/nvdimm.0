Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 2E5531A1EC1
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 15:51:00 -0700 (PDT)
Date: Mon, 14 Mar 2016 16:50:17 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/4] Remove un-needed 'major' registration when
 alloc_disk(0) is used.
Message-ID: <20160314225017.GC19926@linux.intel.com>
References: <20160309215702.20904.61407.stgit@noble>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160309215702.20904.61407.stgit@noble>
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
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@fb.com>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 08:59:28AM +1100, NeilBrown wrote:
> When alloc_disk(0) is used, the ->major number is ignored and
> irrelevant.  Yet several drivers register a major number anyway.
> 
> This series of patches removes the pointless registrations.  The pmem
> driver also does this, but a patch has already been sent for that
> driver.
> 
> Note that I am not in a position to test these beyond simple compile
> testing.
> 
> Thanks,
> NeilBrown
> 
> 
> ---
> 
> NeilBrown (4):
>       nvdimm/blk: don't allocate unused major device number
>       nvdimm/btt: don't allocate unused major device number
>       memstick: don't allocate unused major for ms_block
>       NVMe: don't allocate unused nvme_major
> 
> 
>  drivers/memstick/core/ms_block.c |   17 ++---------------
>  drivers/nvdimm/blk.c             |   18 +-----------------
>  drivers/nvdimm/btt.c             |   19 ++-----------------
>  drivers/nvme/host/core.c         |   16 +---------------
>  4 files changed, 6 insertions(+), 64 deletions(-)

There are several other drivers that allocate a major, but then use it for
some small number of minors (1 for null_blk.c and 16 for virtio_blk.c).  They
both have GENHD_FL_EXT_DEVT set, so I think what happens is that after we
exhaust the allocated minors they hop over to having BLOCK_EXT_MAJOR as a
major and a dynamically assigned minor.

It seems like these could easily be converted in the same way so they'd use
BLOCK_EXT_MAJOR for their major and have a bunch of dynamically assigned
minors.

Does this break something I'm not seeing?

Yay for this series, by the way. :) 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
