Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 16/25] device-dax: use the dev_pagemap internal refcount
Date: Fri, 28 Jun 2019 17:02:25 +0000
Message-ID: <20190628170219.GA3608@mellanox.com>
References: <20190626122724.13313-1-hch@lst.de>
 <20190626122724.13313-17-hch@lst.de> <20190628153827.GA5373@mellanox.com>
 <CAPcyv4joSiFMeYq=D08C-QZSkHz0kRpvRfseNQWrN34Rrm+S7g@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4joSiFMeYq=D08C-QZSkHz0kRpvRfseNQWrN34Rrm+S7g@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F315CA51D2C30A40AD4C5447E0263858@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 28, 2019 at 09:27:44AM -0700, Dan Williams wrote:
> On Fri, Jun 28, 2019 at 8:39 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > On Wed, Jun 26, 2019 at 02:27:15PM +0200, Christoph Hellwig wrote:
> > > The functionality is identical to the one currently open coded in
> > > device-dax.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > >  drivers/dax/dax-private.h |  4 ----
> > >  drivers/dax/device.c      | 43 -------------------------------------=
--
> > >  2 files changed, 47 deletions(-)
> >
> > DanW: I think this series has reached enough review, did you want
> > to ack/test any further?
> >
> > This needs to land in hmm.git soon to make the merge window.
>=20
> I was awaiting a decision about resolving the collision with Ira's
> patch before testing the final result again [1]. You can go ahead and
> add my reviewed-by for the series, but my tested-by should be on the
> final state of the series.

The conflict looks OK to me, I think we can let Andrew and Linus
resolve it.

Thanks,
Jason
