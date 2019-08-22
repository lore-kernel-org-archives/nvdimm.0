Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C17620213F1C
 for <linux-nvdimm@lists.01.org>; Wed, 21 Aug 2019 20:40:51 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id n1so3317538oic.3
 for <linux-nvdimm@lists.01.org>; Wed, 21 Aug 2019 20:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-3-hch@lst.de>
 <CAPcyv4iYytOoX3QMRmvNLbroxD0szrVLauXFjnQMvtQOH3as_w@mail.gmail.com>
 <20190820132649.GD29225@mellanox.com>
 <CAPcyv4hfowyD4L0W3eTJrrPK5rfrmU6G29_vBVV+ea54eoJenA@mail.gmail.com>
 <20190821162420.GI8667@mellanox.com> <20190821235055.GQ8667@mellanox.com>
In-Reply-To: <20190821235055.GQ8667@mellanox.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Aug 2019 20:39:32 -0700
Message-ID: <CAPcyv4iiuFD+5qNEpU9Cpg7ry-tLu2ycvLv8Hfomnuu+857sww@mail.gmail.com>
Subject: Re: [PATCH 2/4] memremap: remove the dev field in struct dev_pagemap
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 21, 2019 at 4:51 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Wed, Aug 21, 2019 at 01:24:20PM -0300, Jason Gunthorpe wrote:
> > On Tue, Aug 20, 2019 at 07:58:22PM -0700, Dan Williams wrote:
> > > On Tue, Aug 20, 2019 at 6:27 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
> > > >
> > > > On Mon, Aug 19, 2019 at 06:44:02PM -0700, Dan Williams wrote:
> > > > > On Sun, Aug 18, 2019 at 2:12 AM Christoph Hellwig <hch@lst.de> wrote:
> > > > > >
> > > > > > The dev field in struct dev_pagemap is only used to print dev_name in
> > > > > > two places, which are at best nice to have.  Just remove the field
> > > > > > and thus the name in those two messages.
> > > > > >
> > > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > > >
> > > > > Needs the below as well.
> > > > >
> > > > > /me goes to check if he ever merged the fix to make the unit test
> > > > > stuff get built by default with COMPILE_TEST [1]. Argh! Nope, didn't
> > > > > submit it for 5.3-rc1, sorry for the thrash.
> > > > >
> > > > > You can otherwise add:
> > > > >
> > > > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > > >
> > > > > [1]: https://lore.kernel.org/lkml/156097224232.1086847.9463861924683372741.stgit@dwillia2-desk3.amr.corp.intel.com/
> > > >
> > > > Can you get this merged? Do you want it to go with this series?
> > >
> > > Yeah, makes some sense to let you merge it so that you can get
> > > kbuild-robot reports about any follow-on memremap_pages() work that
> > > may trip up the build. Otherwise let me know and I'll get it queued
> > > with the other v5.4 libnvdimm pending bits.
> >
> > Done, I used it already to test build the last series from CH..
>
> It failed 0-day, I'm guessing some missing kconfig stuff
>
> For now I dropped it, but, if you send a v2 I can forward it toward
> 0-day again!

The system works!

Sorry for that thrash, I'll track it down.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
