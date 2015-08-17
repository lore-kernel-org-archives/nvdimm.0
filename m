Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1439842038.11296.1.camel@linux.intel.com>
Subject: Re: [PATCH v2 7/7] pmem, dax: have direct_access use __pmem
 annotation
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Mon, 17 Aug 2015 14:07:18 -0600
In-Reply-To: <CAPcyv4gHatJxtJ_Utc07L-EiX0f=SnkEoAVsB9PNDhtwmxrobQ@mail.gmail.com>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
	 <20150815091950.GA21487@lst.de>
	 <CAPcyv4gHatJxtJ_Utc07L-EiX0f=SnkEoAVsB9PNDhtwmxrobQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@primarydata.com>, Andrew Morton <akpm@linux-foundation.org>, Omar Sandoval <osandov@osandov.com>, Boaz Harrosh <boaz@plexistor.com>, Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>, Wolfram Sang <wsa@the-dreams.de>, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Ameen Ali <ameenali023@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Shaohua Li <shli@fb.com>, Ming Lei <ming.lei@canonical.com>, linux-doc@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2015-08-15 at 08:44 -0700, Dan Williams wrote:
> On Sat, Aug 15, 2015 at 2:19 AM, Christoph Hellwig <hch@lst.de> wrote:
> > On Thu, Aug 13, 2015 at 10:51:11AM -0600, Ross Zwisler wrote:
> >> Update the annotation for the kaddr pointer returned by direct_access()
> >> so that it is a __pmem pointer.  This is consistent with the PMEM driver
> >> and with how this direct_access() pointer is used in the DAX code.
> >
> > IFF we stick to the __pmem annotations this looks good.
> >
> > That beeing said I start to really dislike them.  We don't special
> > accesors to read/write from pmem, we just need to explicitly commit
> > it if we want to make it persistent.  So I really don't see the need
> > to treat it special and require all the force casts to and from the
> > attribute.
> 
> I'm not going to put up much of a fight if it's really getting in the way....
> 
> That said, while we don't need special accessors we do need guarantees
> that anything that has written to a persistent memory address has done
> so in a way that wmb_pmem() is able to flush it.  It's more of a "I've
> audited this code path for wmb_pmem() compatibility so use this api to
> write to pmem."
> 
> Perhaps a better way to statically check for missed flushes might be
> to have acquire_pmem_for_write() + release() annotations and the final
> release does a wmb_pmem(), but as far as I can tell the sparse
> acquire/release annotations don't stack.

FWIW I've been on the fence about the __pmem annotations, but my current
thought is that we really do need a way of saying that stores to these
pointers need special care for wmb_pmem() to do its thing and that __pmem does
a reasonably good job of that.  If we can figure out a cooler way, such as the
write() + release() flow Dan is talking about, great.  But I think we need
something to keep us from making errors by storing to PMEM pointers and
leaving data in the processor cache.


