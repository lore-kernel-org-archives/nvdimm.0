Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150815091154.GA21290@lst.de>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
	<1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j=h1FULCnmLbwNv6E0ySyZNKniM3GZEnNCpGeiqCb+Kg@mail.gmail.com>
	<1439571318.16263.3.camel@linux.intel.com>
	<CAPcyv4gBwa=ud7FZcAK=uq8F-9RVdZNf+-=ROB0K7G3SkiP1FQ@mail.gmail.com>
	<20150815091154.GA21290@lst.de>
Date: Sat, 15 Aug 2015 08:49:14 -0700
Message-ID: <CAPcyv4hKsew+pNS+2i9rvfR+JCsXcKFURaQ2Cf3t5HZoTWWsvg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] pmem, dax: have direct_access use __pmem annotation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@primarydata.com>, Andrew Morton <akpm@linux-foundation.org>, Omar Sandoval <osandov@osandov.com>, Boaz Harrosh <boaz@plexistor.com>, Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>, Wolfram Sang <wsa@the-dreams.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Ameen Ali <ameenali023@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Shaohua Li <shli@fb.com>, Ming Lei <ming.lei@canonical.com>, linux-doc@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 15, 2015 at 2:11 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Aug 14, 2015 at 09:58:16AM -0700, Dan Williams wrote:
>> > I'll merge with your code for v3.
>>
>> Sounds, let me go rebase the __pfn_t patches on -mm so we'all lined up
>> and collision free.
>
> I'm doubt that we'll have PFN mapping ready for 4.3.  I'd rather see
> Ross series goes first, and move the patch to remove the size argument
> from ->direct access [1] over to this series as well.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/commit/?h=pfn&id=8e15e69fb9e61ac563c5a7ffd9dd9a7b545cced3

Yes, let's do it.  The need for DAX persistence guarantees is a higher
priority than solving the DAX vs PMEM unbind bug.  Especially if we
can defer __pfn_t and get some basic struct page mapping into 4.3 as
well.
