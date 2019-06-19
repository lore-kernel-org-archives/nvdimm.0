Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
Date: Wed, 19 Jun 2019 19:27:25 +0000
Message-ID: <20190619192719.GO9374@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-19-hch@lst.de> <20190613194430.GY22062@mellanox.com>
 <a27251ad-a152-f84d-139d-e1a3bf01c153@nvidia.com>
 <20190613195819.GA22062@mellanox.com>
 <20190614004314.GD783@iweiny-DESK2.sc.intel.com>
 <d2b77ea1-7b27-e37d-c248-267a57441374@nvidia.com>
In-Reply-To: <d2b77ea1-7b27-e37d-c248-267a57441374@nvidia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <081C2DB7B7A13A4A93487CC051D6E961@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Ralph Campbell <rcampbell@nvidia.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 06:23:04PM -0700, John Hubbard wrote:
> On 6/13/19 5:43 PM, Ira Weiny wrote:
> > On Thu, Jun 13, 2019 at 07:58:29PM +0000, Jason Gunthorpe wrote:
> >> On Thu, Jun 13, 2019 at 12:53:02PM -0700, Ralph Campbell wrote:
> >>>
> ...
> >> Hum, so the only thing this config does is short circuit here:
> >>
> >> static inline bool is_device_public_page(const struct page *page)
> >> {
> >>         return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
> >>                 IS_ENABLED(CONFIG_DEVICE_PUBLIC) &&
> >>                 is_zone_device_page(page) &&
> >>                 page->pgmap->type =3D=3D MEMORY_DEVICE_PUBLIC;
> >> }
> >>
> >> Which is called all over the place..=20
> >=20
> > <sigh>  yes but the earlier patch:
> >=20
> > [PATCH 03/22] mm: remove hmm_devmem_add_resource
> >=20
> > Removes the only place type is set to MEMORY_DEVICE_PUBLIC.
> >=20
> > So I think it is ok.  Frankly I was wondering if we should remove the p=
ublic
> > type altogether but conceptually it seems ok.  But I don't see any user=
s of it
> > so...  should we get rid of it in the code rather than turning the conf=
ig off?
> >=20
> > Ira
>=20
> That seems reasonable. I recall that the hope was for those IBM Power 9
> systems to use _PUBLIC, as they have hardware-based coherent device (GPU)
> memory, and so the memory really is visible to the CPU. And the IBM team
> was thinking of taking advantage of it. But I haven't seen anything on
> that front for a while.

Does anyone know who those people are and can we encourage them to
send some patches? :)

Jason
