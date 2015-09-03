Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <55E7EBA2.50200@plexistor.com>
Date: Thu, 03 Sep 2015 09:41:38 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] dax, pmem: add support for msync
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com> <20150831233803.GO3902@dastard> <20150901070608.GA5482@lst.de> <20150901222120.GQ3902@dastard> <20150902031945.GA8916@linux.intel.com> <20150902051711.GS3902@dastard> <55E6CF15.4070105@plexistor.com> <55E70653.4090302@linux.intel.com> <55E7132E.104@plexistor.com> <55E7184B.3020104@linux.intel.com> <55E71D00.4050103@plexistor.com> <55E7217B.2090803@linux.intel.com>
In-Reply-To: <55E7217B.2090803@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/02/2015 07:19 PM, Dave Hansen wrote:
> On 09/02/2015 09:00 AM, Boaz Harrosh wrote:
>>>> We are going to have 2-socket systems with 6TB of persistent memory in
>>>> them.  I think it's important to design this mechanism so that it scales
>>>> to memory sizes like that and supports large mmap()s.
>>>>
>>>> I'm not sure the application you've seen thus far are very
>>>> representative of what we want to design for.
>>>>
>> We have a patch pending to introduce a new mmap flag that pmem aware
>> applications can set to eliminate any kind of flushing. MMAP_PMEM_AWARE.
> 
> Great!  Do you have a link so that I can review it and compare it to
> Ross's approach?
> 

Ha? I have not seen a new mmap flag from Ross, yet I have been off lately
so it is logical that I might have missed it.

Could you send me a link?

(BTW my patch I did not release yet, I'll cc you once its done)

Thanks
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
