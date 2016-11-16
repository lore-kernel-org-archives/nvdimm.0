Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63E6281EF3
 for <linux-nvdimm@lists.01.org>; Wed, 16 Nov 2016 03:05:05 -0800 (PST)
Date: Wed, 16 Nov 2016 12:05:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/21] mm: Use vmf->address instead of of
 vmf->virtual_address
Message-ID: <20161116110505.GF21785@quack2.suse.cz>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-3-git-send-email-jack@suse.cz>
 <20161115215531.GB23021@node>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161115215531.GB23021@node>
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 16-11-16 00:55:31, Kirill A. Shutemov wrote:
> On Fri, Nov 04, 2016 at 05:24:58AM +0100, Jan Kara wrote:
> > Every single user of vmf->virtual_address typed that entry to unsigned
> > long before doing anything with it so the type of virtual_address does
> > not really provide us any additional safety. Just use masked
> > vmf->address which already has the appropriate type.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  arch/powerpc/platforms/cell/spufs/file.c     |  4 ++--
> >  arch/x86/entry/vdso/vma.c                    |  4 ++--
> >  drivers/char/agp/alpha-agp.c                 |  2 +-
> >  drivers/char/mspec.c                         |  2 +-
> >  drivers/dax/dax.c                            |  2 +-
> >  drivers/gpu/drm/armada/armada_gem.c          |  2 +-
> >  drivers/gpu/drm/drm_vm.c                     | 11 ++++++-----
> >  drivers/gpu/drm/etnaviv/etnaviv_gem.c        |  7 +++----
> >  drivers/gpu/drm/exynos/exynos_drm_gem.c      |  6 +++---
> >  drivers/gpu/drm/gma500/framebuffer.c         |  2 +-
> >  drivers/gpu/drm/gma500/gem.c                 |  5 ++---
> >  drivers/gpu/drm/i915/i915_gem.c              |  2 +-
> >  drivers/gpu/drm/msm/msm_gem.c                |  7 +++----
> >  drivers/gpu/drm/omapdrm/omap_gem.c           | 20 +++++++++-----------
> >  drivers/gpu/drm/tegra/gem.c                  |  4 ++--
> >  drivers/gpu/drm/ttm/ttm_bo_vm.c              |  2 +-
> >  drivers/gpu/drm/udl/udl_gem.c                |  5 ++---
> >  drivers/gpu/drm/vgem/vgem_drv.c              |  2 +-
> >  drivers/media/v4l2-core/videobuf-dma-sg.c    |  5 ++---
> >  drivers/misc/cxl/context.c                   |  2 +-
> >  drivers/misc/sgi-gru/grumain.c               |  2 +-
> >  drivers/staging/android/ion/ion.c            |  2 +-
> >  drivers/staging/lustre/lustre/llite/vvp_io.c |  9 ++++++---
> >  drivers/xen/privcmd.c                        |  2 +-
> >  fs/dax.c                                     |  4 ++--
> >  include/linux/mm.h                           |  2 --
> >  mm/memory.c                                  |  7 +++----
> >  27 files changed, 59 insertions(+), 65 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
> > index 06254467e4dd..e8a31fffcdda 100644
> > --- a/arch/powerpc/platforms/cell/spufs/file.c
> > +++ b/arch/powerpc/platforms/cell/spufs/file.c
> > @@ -236,7 +236,7 @@ static int
> >  spufs_mem_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  {
> >  	struct spu_context *ctx	= vma->vm_file->private_data;
> > -	unsigned long address = (unsigned long)vmf->virtual_address;
> > +	unsigned long address = vmf->address & PAGE_MASK;
> 
> These "& PAGE_MASK" everewhere look unnecesary. I don't think we ever
> need sub-page address, do we?

Usually not AFAICT but I was not really sure in some cases (e.g. is
vm_insert_pfn() and friends really safe to call with unaligned address) so
I've decided to do a simple search-and-replace for such a wide-scale patch.
Later we can remove unnecessary masking from places where we are sure it is
not needed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
