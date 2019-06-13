Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 04/22] mm: don't clear ->mapping in hmm_devmem_free
Date: Thu, 13 Jun 2019 19:05:07 +0000
Message-ID: <20190613190501.GQ22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-5-hch@lst.de>
In-Reply-To: <20190613094326.24093-5-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7BF6B23DFB21B24C9129FD14A4ED8C15@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:07AM +0200, Christoph Hellwig wrote:
> ->mapping isn't even used by HMM users, and the field at the same offset
> in the zone_device part of the union is declared as pad.  (Which btw is
> rather confusing, as DAX uses ->pgmap and ->mapping from two different
> sides of the union, but DAX doesn't use hmm_devmem_free).
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/hmm.c | 2 --
>  1 file changed, 2 deletions(-)

Hurm, is hmm following this comment from mm_types.h?

 * If you allocate the page using alloc_pages(), you can use some of the
 * space in struct page for your own purposes.  The five words in the main
 * union are available, except for bit 0 of the first word which must be
 * kept clear.  Many users use this word to store a pointer to an object
 * which is guaranteed to be aligned.  If you use the same storage as
 * page->mapping, you must restore it to NULL before freeing the page.

Maybe the assumption was that a driver is using ->mapping ?

However, nouveau is the only driver that uses this path, and it never
touches page->mapping either (nor in -next).

It looks like if a driver were to start using mapping then the driver
should be responsible to set it back to NULL before being done with
the page.

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
