Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 06/22] mm: factor out a devm_request_free_mem_region
 helper
Date: Thu, 13 Jun 2019 19:16:35 +0000
Message-ID: <20190613191626.GR22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-7-hch@lst.de>
In-Reply-To: <20190613094326.24093-7-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4BAAE06211A39D40A138C3AEA8033A18@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:09AM +0200, Christoph Hellwig wrote:
> Keep the physical address allocation that hmm_add_device does with the
> rest of the resource code, and allow future reuse of it without the hmm
> wrapper.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  include/linux/ioport.h |  2 ++
>  kernel/resource.c      | 39 +++++++++++++++++++++++++++++++++++++++
>  mm/hmm.c               | 33 ++++-----------------------------
>  3 files changed, 45 insertions(+), 29 deletions(-)
>=20
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index da0ebaec25f0..76a33ae3bf6c 100644
> +++ b/include/linux/ioport.h
> @@ -286,6 +286,8 @@ static inline bool resource_overlaps(struct resource =
*r1, struct resource *r2)
>         return (r1->start <=3D r2->end && r1->end >=3D r2->start);
>  }
> =20
> +struct resource *devm_request_free_mem_region(struct device *dev,
> +		struct resource *base, unsigned long size);
> =20
>  #endif /* __ASSEMBLY__ */
>  #endif	/* _LINUX_IOPORT_H */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 158f04ec1d4f..99c58134ed1c 100644
> +++ b/kernel/resource.c
> @@ -1628,6 +1628,45 @@ void resource_list_free(struct list_head *head)
>  }
>  EXPORT_SYMBOL(resource_list_free);
> =20
> +#ifdef CONFIG_DEVICE_PRIVATE
> +/**
> + * devm_request_free_mem_region - find free region for device private me=
mory
> + *
> + * @dev: device struct to bind the resource too
> + * @size: size in bytes of the device memory to add
> + * @base: resource tree to look in
> + *
> + * This function tries to find an empty range of physical address big en=
ough to
> + * contain the new resource, so that it can later be hotpluged as ZONE_D=
EVICE
> + * memory, which in turn allocates struct pages.
> + */
> +struct resource *devm_request_free_mem_region(struct device *dev,
> +		struct resource *base, unsigned long size)
> +{
> +	resource_size_t end, addr;
> +	struct resource *res;
> +
> +	size =3D ALIGN(size, 1UL << PA_SECTION_SHIFT);
> +	end =3D min_t(unsigned long, base->end, (1UL << MAX_PHYSMEM_BITS) - 1);

Even fixed it to use min_t

> +	addr =3D end - size + 1UL;
> +	for (; addr > size && addr >=3D base->start; addr -=3D size) {
> +		if (region_intersects(addr, size, 0, IORES_DESC_NONE) !=3D
> +				REGION_DISJOINT)
> +			continue;

The FIXME about the algorithm cost seems justified though, yikes.

> +
> +		res =3D devm_request_mem_region(dev, addr, size, dev_name(dev));
> +		if (!res)
> +			return ERR_PTR(-ENOMEM);
> +		res->desc =3D IORES_DESC_DEVICE_PRIVATE_MEMORY;

I wonder if IORES_DESC_DEVICE_PRIVATE_MEMORY should be a function
argument?

Not really any substantive remark, so

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
