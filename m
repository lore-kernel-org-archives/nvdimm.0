Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 16/25] device-dax: use the dev_pagemap internal refcount
Date: Fri, 28 Jun 2019 18:29:29 +0000
Message-ID: <20190628182922.GA15242@mellanox.com>
References: <20190626122724.13313-1-hch@lst.de>
 <20190626122724.13313-17-hch@lst.de> <20190628153827.GA5373@mellanox.com>
 <CAPcyv4joSiFMeYq=D08C-QZSkHz0kRpvRfseNQWrN34Rrm+S7g@mail.gmail.com>
 <20190628170219.GA3608@mellanox.com>
 <CAPcyv4ja9DVL2zuxuSup8x3VOT_dKAOS8uBQweE9R81vnYRNWg@mail.gmail.com>
 <CAPcyv4iWTe=vOXUqkr_CguFrFRqgA7hJSt4J0B3RpuP-Okz0Vw@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4iWTe=vOXUqkr_CguFrFRqgA7hJSt4J0B3RpuP-Okz0Vw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <14F6B0C5B925FB4B8ECAEFC2C0B435B0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 28, 2019 at 10:10:12AM -0700, Dan Williams wrote:
> On Fri, Jun 28, 2019 at 10:08 AM Dan Williams <dan.j.williams@intel.com> =
wrote:
> >
> > On Fri, Jun 28, 2019 at 10:02 AM Jason Gunthorpe <jgg@mellanox.com> wro=
te:
> > >
> > > On Fri, Jun 28, 2019 at 09:27:44AM -0700, Dan Williams wrote:
> > > > On Fri, Jun 28, 2019 at 8:39 AM Jason Gunthorpe <jgg@mellanox.com> =
wrote:
> > > > >
> > > > > On Wed, Jun 26, 2019 at 02:27:15PM +0200, Christoph Hellwig wrote=
:
> > > > > > The functionality is identical to the one currently open coded =
in
> > > > > > device-dax.
> > > > > >
> > > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > > > >  drivers/dax/dax-private.h |  4 ----
> > > > > >  drivers/dax/device.c      | 43 -------------------------------=
--------
> > > > > >  2 files changed, 47 deletions(-)
> > > > >
> > > > > DanW: I think this series has reached enough review, did you want
> > > > > to ack/test any further?
> > > > >
> > > > > This needs to land in hmm.git soon to make the merge window.
> > > >
> > > > I was awaiting a decision about resolving the collision with Ira's
> > > > patch before testing the final result again [1]. You can go ahead a=
nd
> > > > add my reviewed-by for the series, but my tested-by should be on th=
e
> > > > final state of the series.
> > >
> > > The conflict looks OK to me, I think we can let Andrew and Linus
> > > resolve it.
> >
> > Andrew's tree effectively always rebases since it's a quilt series.
> > I'd recommend pulling Ira's patch out of -mm and applying it with the
> > rest of hmm reworks. Any other git tree I'd agree with just doing the
> > late conflict resolution, but I'm not clear on what's the best
> > practice when conflicting with -mm.

What happens depends on timing as things arrive to Linus. I promised
to send hmm.git early, so I understand that Andrew will quilt rebase
his tree to Linus's and fix the conflict in Ira's patch before he
sends it.

> Regardless the patch is buggy. If you want to do the conflict
> resolution it should be because the DEVICE_PUBLIC removal effectively
> does the same fix otherwise we're knowingly leaving a broken point in
> the history.

I'm not sure I understand your concern, is there something wrong with
CH's series as it stands? hmm is a non-rebasing git tree, so as long
as the series is correct *when I apply it* there is no broken history.

I assumed the conflict resolution for Ira's patch was to simply take
the deletion of the if block from CH's series - right?

If we do need to take Ira's patch into hmm.git it will go after CH's
series (and Ira will have to rebase/repost it), so I think there is
nothing to do at this moment - unless you are saying there is a
problem with the series in CH's git tree?

Regards,
Jason
