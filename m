Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <5501BF2F.6010303@plexistor.com>
Date: Thu, 12 Mar 2015 18:30:39 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] brd: Ensure that bio_vecs have size <= PAGE_SIZE
References: <1426093353-23709-1-git-send-email-ross.zwisler@linux.intel.com>	 <550078AB.5030203@plexistor.com> <1426113739.18821.2.camel@theros.lm.intel.com>
In-Reply-To: <1426113739.18821.2.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, "Roger C. Pao (Enmotus)" <rcpao.enmotus@gmail.com>, linux-nvdimm@lists.01.org, Nick Piggin <npiggin@kernel.dk>
List-ID: <linux-nvdimm@lists.01.org>

On 03/12/2015 12:42 AM, Ross Zwisler wrote:
<>
> 
> Anyway, I thought your response to the original bug report against PMEM was
> that you were alright with this one line change since it didn't hurt anything,
> and perhaps it helped someone.  Do you have the same stance for BRD, 

No what I did in pmem is remove the BUG that was borrowed from brd, because
in pmem we can support any imaginary bv_len since we are always contiguous
in memory. (And Kernel mapping of a contiguous physical pages is also
contiguous physical in virtual space)

> or do you
> think we need to track down if or how bio_vecs can make it to the driver with
> more than one page of data first?
> 

OK So I have (again) audited every instance of *max_segment_size* and call
me slow and stupid but all I can see is that:

All this "coalesce"ing behavior and any reference to max_segment_size that
you guys are talking about happen when translating the bio to an sg_list.

In fact think about it the block layer must not touch the bio+biovec because
it is a contract with upper layer. for each page submission there must be a
one-to-one end_io notification for instance an FS might have taken a page_lock
on the page.
So if what you are saying is true and "bios are coalesced" it means that you
need to copy the original bio-list to a new compacted one. This does not
happen the copy to a new list happens from the move from bio to an sg_list,
and the original bio is untouched.

That said this is all up to Jens he is the maintainer of the block layer, if
you are correct and bv_len may ever be > PAGE_SIZE then he will gladly take
this patch I'm sure.

> - Ross

Just that I would really like to understand, that's all

Thanks
Boaz

