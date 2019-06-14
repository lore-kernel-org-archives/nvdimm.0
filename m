Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0430212909FB
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 17:41:54 -0700 (PDT)
Date: Thu, 13 Jun 2019 17:43:15 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
Message-ID: <20190614004314.GD783@iweiny-DESK2.sc.intel.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-19-hch@lst.de>
 <20190613194430.GY22062@mellanox.com>
 <a27251ad-a152-f84d-139d-e1a3bf01c153@nvidia.com>
 <20190613195819.GA22062@mellanox.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190613195819.GA22062@mellanox.com>
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
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 07:58:29PM +0000, Jason Gunthorpe wrote:
> On Thu, Jun 13, 2019 at 12:53:02PM -0700, Ralph Campbell wrote:
> > 
> > On 6/13/19 12:44 PM, Jason Gunthorpe wrote:
> > > On Thu, Jun 13, 2019 at 11:43:21AM +0200, Christoph Hellwig wrote:
> > > > The code hasn't been used since it was added to the tree, and doesn't
> > > > appear to actually be usable.  Mark it as BROKEN until either a user
> > > > comes along or we finally give up on it.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > >   mm/Kconfig | 1 +
> > > >   1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > > index 0d2ba7e1f43e..406fa45e9ecc 100644
> > > > +++ b/mm/Kconfig
> > > > @@ -721,6 +721,7 @@ config DEVICE_PRIVATE
> > > >   config DEVICE_PUBLIC
> > > >   	bool "Addressable device memory (like GPU memory)"
> > > >   	depends on ARCH_HAS_HMM
> > > > +	depends on BROKEN
> > > >   	select HMM
> > > >   	select DEV_PAGEMAP_OPS
> > > 
> > > This seems a bit harsh, we do have another kconfig that selects this
> > > one today:
> > > 
> > > config DRM_NOUVEAU_SVM
> > >          bool "(EXPERIMENTAL) Enable SVM (Shared Virtual Memory) support"
> > >          depends on ARCH_HAS_HMM
> > >          depends on DRM_NOUVEAU
> > >          depends on STAGING
> > >          select HMM_MIRROR
> > >          select DEVICE_PRIVATE
> > >          default n
> > >          help
> > >            Say Y here if you want to enable experimental support for
> > >            Shared Virtual Memory (SVM).
> > > 
> > > Maybe it should be depends on STAGING not broken?
> > > 
> > > or maybe nouveau_svm doesn't actually need DEVICE_PRIVATE?
> > > 
> > > Jason
> > 
> > I think you are confusing DEVICE_PRIVATE for DEVICE_PUBLIC.
> > DRM_NOUVEAU_SVM does use DEVICE_PRIVATE but not DEVICE_PUBLIC.
> 
> Indeed you are correct, never mind
> 
> Hum, so the only thing this config does is short circuit here:
> 
> static inline bool is_device_public_page(const struct page *page)
> {
>         return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
>                 IS_ENABLED(CONFIG_DEVICE_PUBLIC) &&
>                 is_zone_device_page(page) &&
>                 page->pgmap->type == MEMORY_DEVICE_PUBLIC;
> }
> 
> Which is called all over the place.. 

<sigh>  yes but the earlier patch:

[PATCH 03/22] mm: remove hmm_devmem_add_resource

Removes the only place type is set to MEMORY_DEVICE_PUBLIC.

So I think it is ok.  Frankly I was wondering if we should remove the public
type altogether but conceptually it seems ok.  But I don't see any users of it
so...  should we get rid of it in the code rather than turning the config off?

Ira

> 
> So, yes, we really don't want any distro or something to turn this on
> until it has a use.
> 
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> Jason
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
