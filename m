Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 12/25] memremap: add a migrate_to_ram method to struct
 dev_pagemap_ops
Date: Thu, 27 Jun 2019 16:29:45 +0000
Message-ID: <20190627162439.GD9499@mellanox.com>
References: <20190626122724.13313-1-hch@lst.de>
 <20190626122724.13313-13-hch@lst.de>
In-Reply-To: <20190626122724.13313-13-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D936285C7F16454CABEEFE9D1BD77309@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ralph Campbell <rcampbell@nvidia.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 26, 2019 at 02:27:11PM +0200, Christoph Hellwig wrote:
> This replaces the hacky ->fault callback, which is currently directly
> called from common code through a hmm specific data structure as an
> exercise in layering violations.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
> ---
>  include/linux/hmm.h      |  6 ------
>  include/linux/memremap.h |  6 ++++++
>  include/linux/swapops.h  | 15 ---------------
>  kernel/memremap.c        | 35 ++++-------------------------------
>  mm/hmm.c                 | 13 +++++--------
>  mm/memory.c              |  9 ++-------
>  6 files changed, 17 insertions(+), 67 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
=20
I'ver heard there are some other use models for fault() here beyond
migrate to ram, but we can rename it if we ever see them.

> +static vm_fault_t hmm_devmem_migrate_to_ram(struct vm_fault *vmf)
>  {
> -	struct hmm_devmem *devmem =3D page->pgmap->data;
> +	struct hmm_devmem *devmem =3D vmf->page->pgmap->data;
> =20
> -	return devmem->ops->fault(devmem, vma, addr, page, flags, pmdp);
> +	return devmem->ops->fault(devmem, vmf->vma, vmf->address, vmf->page,
> +			vmf->flags, vmf->pmd);
>  }

Next cycle we should probably rename this fault to migrate_to_ram as
well and pass in the vmf..

Jason
