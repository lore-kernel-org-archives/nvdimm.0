Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sat, 15 Aug 2015 11:19:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 7/7] pmem, dax: have direct_access use __pmem
	annotation
Message-ID: <20150815091950.GA21487@lst.de>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com> <1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Omar Sandoval <osandov@osandov.com>, Boaz Harrosh <boaz@plexistor.com>, Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>, Wolfram Sang <wsa@the-dreams.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Ameen Ali <ameenali023@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Shaohua Li <shli@fb.com>, Ming Lei <ming.lei@canonical.com>, linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 13, 2015 at 10:51:11AM -0600, Ross Zwisler wrote:
> Update the annotation for the kaddr pointer returned by direct_access()
> so that it is a __pmem pointer.  This is consistent with the PMEM driver
> and with how this direct_access() pointer is used in the DAX code.

IFF we stick to the __pmem annotations this looks good.

That beeing said I start to really dislike them.  We don't special
accesors to read/write from pmem, we just need to explicitly commit
it if we want to make it persistent.  So I really don't see the need
to treat it special and require all the force casts to and from the
attribute.
