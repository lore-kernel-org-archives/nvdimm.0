Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 19 Nov 2015 18:12:27 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
Message-ID: <20151119171227.GC25804@quack.suse.cz>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
 <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
 <20151118150945.GE6097@quack.suse.cz>
 <1447892533.13153.8.camel@intel.com>
 <20151119125541.GC18581@quack.suse.cz>
 <CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "jack@suse.com" <jack@suse.com>, "david@fromorbit.com" <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 19-11-15 08:55:48, Dan Williams wrote:
> On Thu, Nov 19, 2015 at 4:55 AM, Jan Kara <jack@suse.cz> wrote:
> > Also are you sure that your unmapping cannot race with other process
> > mapping the pfns again?
> 
> You're right, there is indeed a gap between the unmap and when
> get_blocks() will start returning errors in the fault path.  I think I
> need to defer the unmapping until after blk_cleanup_queue() where we
> know that no new I/o to the device is possible.

Yeah, you need to squeeze it somewhere after the point where get_blocks()
start returning errors and before the point where pfn can go away.

> > BTW what happens when you access a DAX pfn that got removed?
> 
> SIGBUS.  I don't see a way to be any kinder to the application.  After
> the ->remove() method for the block_device is complete we can't be
> sure that the pfn is valid or even present in the system (think brd,
> or VM hot provisioning).

I see. So if we kept the PFN mapped, it could result e.g. in memory
corruption (at least in case of brd). So we really need this to be 100%
reliable. That's what I was interested in.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
