Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <56BB758D.1000704@plexistor.com>
Date: Wed, 10 Feb 2016 19:38:21 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: Another proposal for DAX fault locking
References: <20160209172416.GB12245@quack.suse.cz>
In-Reply-To: <20160209172416.GB12245@quack.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 02/09/2016 07:24 PM, Jan Kara wrote:
> Hello,
> 
> I was thinking about current issues with DAX fault locking [1] (data
> corruption due to racing faults allocating blocks) and also races which
> currently don't allow us to clear dirty tags in the radix tree due to races
> between faults and cache flushing [2]. Both of these exist because we don't
> have an equivalent of page lock available for DAX. While we have a
> reasonable solution available for problem [1], so far I'm not aware of a
> decent solution for [2]. After briefly discussing the issue with Mel he had
> a bright idea that we could used hashed locks to deal with [2] (and I think
> we can solve [1] with them as well). So my proposal looks as follows:
> 
> DAX will have an array of mutexes (the array can be made per device but
> initially a global one should be OK). We will use mutexes in the array as a
> replacement for page lock - we will use hashfn(mapping, index) to get
> particular mutex protecting our offset in the mapping. On fault / page
> mkwrite, we'll grab the mutex similarly to page lock and release it once we
> are done updating page tables. This deals with races in [1]. When flushing
> caches we grab the mutex before clearing writeable bit in page tables
> and clearing dirty bit in the radix tree and drop it after we have flushed
> caches for the pfn. This deals with races in [2].
> 
> Thoughts?
> 

You could also use one of the radix-tree's special-bits as a bit lock.
So no need for any extra allocations.

[latest page-lock is a bit-lock so performance is the same]

Thanks
Boaz


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
