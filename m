Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 08/22] memremap: pass a struct dev_pagemap to ->kill
Date: Thu, 13 Jun 2019 19:26:20 +0000
Message-ID: <20190613192615.GT22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-9-hch@lst.de>
In-Reply-To: <20190613094326.24093-9-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6555DEAFF3F4AF4A941D63DB429D69BC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:11AM +0200, Christoph Hellwig wrote:
> Passing the actual typed structure leads to more understandable code
> vs the actual references.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  drivers/dax/device.c              | 7 +++----
>  drivers/nvdimm/pmem.c             | 6 +++---
>  drivers/pci/p2pdma.c              | 6 +++---
>  include/linux/memremap.h          | 2 +-
>  kernel/memremap.c                 | 4 ++--
>  mm/hmm.c                          | 4 ++--
>  tools/testing/nvdimm/test/iomap.c | 6 ++----
>  7 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 4adab774dade..e23fa1bd8c97 100644
> +++ b/drivers/dax/device.c
> @@ -37,13 +37,12 @@ static void dev_dax_percpu_exit(void *data)
>  	percpu_ref_exit(ref);
>  }
> =20
> -static void dev_dax_percpu_kill(struct percpu_ref *data)
> +static void dev_dax_percpu_kill(struct dev_pagemap *pgmap)
>  {

Looks like it was always like this, but I also can't see a reason to
use the percpu as a handle for a dev_pagemap callback.

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
