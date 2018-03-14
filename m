Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F2B420954B9B
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 21:06:37 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id w38-v6so1937814ota.8
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 21:13:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net>
 <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
 <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Mar 2018 21:12:58 -0700
Message-ID: <CAPcyv4h3SPqx879nnvQt0rvwanKksxLTqChCQa9ZQH8hsd_7yg@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce
 wait_var_event()/wake_up_var()
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 13, 2018 at 3:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Mar 11, 2018 at 10:15:55AM -0700, Dan Williams wrote:
>> On Sun, Mar 11, 2018 at 4:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
>> >> Add a generic facility for awaiting an atomic_t to reach a value of 1.
>> >>
>> >> Page reference counts typically need to reach 0 to be considered a
>> >> free / inactive page. However, ZONE_DEVICE pages allocated via
>> >> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
>> >> done at init time to assign pages to the page allocator is skipped.
>> >>
>> >> These pages will have their reference count elevated > 1 by
>> >> get_user_pages() when they are under DMA. In order to coordinate DMA to
>> >> these pages vs filesytem operations like hole-punch and truncate the
>> >> filesystem-dax implementation needs to capture the DMA-idle event i.e.
>> >> the 2 to 1 count transition).
>> >>
>> >> For now, this implementation does not have functional behavior change,
>> >> follow-on patches will add waiters for these page-idle events.
>> >
>> > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
>> > trainwreck already and now you're making it worse still.
>> >
>> > Please have a look here:
>> >
>> >   https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net
>>
>> That thread seems to be worried about the object disappearing the
>> moment it's reference count reaches a target. That isn't the case with
>> the memmap / struct page objects for ZONE_DEVICE pages. I understand
>> wait_for_atomic_one() is broken in the general case, but as far as I
>> can see it works fine specifically for ZONE_DEVICE page busy tracking,
>> just not generic object lifetime.
>
> How's this, compile tested (x86_64-allmodconfig) only.
>
> This allows you to write:
>
>         wait_var_event(&your_atomic, atomic_read(&your_atomic) == 1);

Nice!

I'll give this a shot. I will need to add
wait_var_event_interruptible(), but other than that it looks workable
to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
