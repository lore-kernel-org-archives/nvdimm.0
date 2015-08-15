Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150815160055.GB26248@lst.de>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
	<1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
	<20150815091950.GA21487@lst.de>
	<CAPcyv4gHatJxtJ_Utc07L-EiX0f=SnkEoAVsB9PNDhtwmxrobQ@mail.gmail.com>
	<20150815160055.GB26248@lst.de>
Date: Sat, 15 Aug 2015 11:05:26 -0700
Message-ID: <CAPcyv4gp8bnQpMn1yAVJpu3ZtEtBjmyZrO2SW9OhRJj92y0w1w@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] pmem, dax: have direct_access use __pmem annotation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@primarydata.com>, Andrew Morton <akpm@linux-foundation.org>, Omar Sandoval <osandov@osandov.com>, Boaz Harrosh <boaz@plexistor.com>, Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>, Wolfram Sang <wsa@the-dreams.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Ameen Ali <ameenali023@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Shaohua Li <shli@fb.com>, Ming Lei <ming.lei@canonical.com>, linux-doc@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 15, 2015 at 9:00 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Sat, Aug 15, 2015 at 08:44:27AM -0700, Dan Williams wrote:
>> That said, while we don't need special accessors we do need guarantees
>> that anything that has written to a persistent memory address has done
>> so in a way that wmb_pmem() is able to flush it.  It's more of a "I've
>> audited this code path for wmb_pmem() compatibility so use this api to
>> write to pmem."
>
> I'm more worried about things where don't just do plain loads and stores
> to a pmem region but DMA, which will end up as a nightmare of casts.
>
> But we can wait and see how that evolves in the end..

It's already not possible to do something like dma_map_single() on an
ioremap()'d address, so there currently are't any __iomem/DMA
collisions.  As long as DMA setup is relative to a physical address
resource I think we're ok.

Making sure a DMA is both complete and persistent though is a different problem.
