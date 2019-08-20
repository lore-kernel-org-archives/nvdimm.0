Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 2/4] memremap: remove the dev field in struct dev_pagemap
Date: Tue, 20 Aug 2019 13:26:53 +0000
Message-ID: <20190820132649.GD29225@mellanox.com>
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-3-hch@lst.de>
 <CAPcyv4iYytOoX3QMRmvNLbroxD0szrVLauXFjnQMvtQOH3as_w@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4iYytOoX3QMRmvNLbroxD0szrVLauXFjnQMvtQOH3as_w@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A4A25E80EC9994BB15BAC6FDC6901E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Bharata B Rao <bharata@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Ira Weiny <ira.weiny@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 19, 2019 at 06:44:02PM -0700, Dan Williams wrote:
> On Sun, Aug 18, 2019 at 2:12 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The dev field in struct dev_pagemap is only used to print dev_name in
> > two places, which are at best nice to have.  Just remove the field
> > and thus the name in those two messages.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20
> Needs the below as well.
>=20
> /me goes to check if he ever merged the fix to make the unit test
> stuff get built by default with COMPILE_TEST [1]. Argh! Nope, didn't
> submit it for 5.3-rc1, sorry for the thrash.
>=20
> You can otherwise add:
>=20
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>=20
> [1]: https://lore.kernel.org/lkml/156097224232.1086847.946386192468337274=
1.stgit@dwillia2-desk3.amr.corp.intel.com/

Can you get this merged? Do you want it to go with this series?

Jason
