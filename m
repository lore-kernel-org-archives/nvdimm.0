Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v2 3/5] dax: improve documentation for fsync/msync
Date: Fri, 22 Jan 2016 16:17:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BF38AA1@G9W0745.americas.hpqcorp.net>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
 <1453398364-22537-4-git-send-email-ross.zwisler@linux.intel.com>
 <20160122150129.GL16898@quack.suse.cz>
 <20160122155828.GA22112@linux.intel.com>
In-Reply-To: <20160122155828.GA22112@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



---
Robert Elliott, HPE Persistent Memory


> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Ross Zwisler
> Sent: Friday, January 22, 2016 9:58 AM
> To: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>; linux-nvdimm@lists.01.org;
> Dave Chinner <david@fromorbit.com>; linux-kernel@vger.kernel.org;
> Alexander Viro <viro@zeniv.linux.org.uk>; Jan Kara <jack@suse.com>; linux-
> fsdevel@vger.kernel.org
> Subject: Re: [PATCH v2 3/5] dax: improve documentation for fsync/msync
> 
> On Fri, Jan 22, 2016 at 04:01:29PM +0100, Jan Kara wrote:
> > On Thu 21-01-16 10:46:02, Ross Zwisler wrote:
...
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index d589113..55ae394 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -350,6 +350,13 @@ static int dax_radix_entry(struct address_space
> *mapping, pgoff_t index,
> > >
> > >  		if (!pmd_entry || type == RADIX_DAX_PMD)
> > >  			goto dirty;
> > > +
> > > +		/*
> > > +		 * We only insert dirty PMD entries into the radix tree.  This
> > > +		 * means we don't need to worry about removing a dirty PTE
> > > +		 * entry and inserting a clean PMD entry, thus reducing the
> > > +		 * range we would flush with a follow-up fsync/msync call.
> > > +		 */
> >
> > May be acompany this with:
> >
> > 		WARN_ON(pmd_entry && !dirty);
> >
> > somewhere in dax_radix_entry()?
> 
> Sure, I'll add one.

If this is something that could trigger due to I/O traffic, please
use WARN_ONCE rather than WARN_ON to avoid the risk of swamping
the serial output.

