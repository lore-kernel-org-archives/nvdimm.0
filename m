Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH] dax, pmem: add support for msync
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150831233803.GO3902@dastard> <20150901070608.GA5482@lst.de>
 <20150901222120.GQ3902@dastard> <20150902031945.GA8916@linux.intel.com>
 <20150902051711.GS3902@dastard> <55E6CF15.4070105@plexistor.com>
 <55E70653.4090302@linux.intel.com> <55E7132E.104@plexistor.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <55E7184B.3020104@linux.intel.com>
Date: Wed, 2 Sep 2015 08:39:55 -0700
MIME-Version: 1.0
In-Reply-To: <55E7132E.104@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/02/2015 08:18 AM, Boaz Harrosh wrote:
> On 09/02/2015 05:23 PM, Dave Hansen wrote:
>> > I'd be curious what the cost is in practice.  Do you have any actual
>> > numbers of the cost of doing it this way?
>> > 
>> > Even if the instruction is a "noop", I'd really expect the overhead to
>> > really add up for a tens-of-gigabytes mapping, no matter how much the
>> > CPU optimizes it.
> What tens-of-gigabytes mapping? I have yet to encounter an application
> that does that. Our tests show that usually the mmaps are small.

We are going to have 2-socket systems with 6TB of persistent memory in
them.  I think it's important to design this mechanism so that it scales
to memory sizes like that and supports large mmap()s.

I'm not sure the application you've seen thus far are very
representative of what we want to design for.

> I can send you a micro benchmark results of an mmap vs direct-io random
> write. Our code will jump over holes in the file BTW, but I'll ask to also
> run it with falloc that will make all blocks allocated.

I'm really just more curious about actual clflush performance on large
ranges.  I'm curious how good the CPU is at optimizing it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
