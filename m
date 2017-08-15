Return-Path: <linux-ext4-owner@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
 <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
 <20170813092556.GA19019@infradead.org>
 <ccf82f19-7693-25da-eaa6-a654830ca81e@netapp.com>
 <CAPcyv4jWW5EH8KrGWe-9oAT7RvFryh1ci6CcGeDb-zcOS9QMxw@mail.gmail.com>
 <2ac0880f-d661-2493-0f80-1b930a8b858b@netapp.com>
From: Boaz Harrosh <boazh@netapp.com>
Message-ID: <13c329d6-ba79-be04-28b1-4d845271533e@netapp.com>
Date: Tue, 15 Aug 2017 12:44:40 +0300
MIME-Version: 1.0
In-Reply-To: <2ac0880f-d661-2493-0f80-1b930a8b858b@netapp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Amit Golander <amitg@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On 15/08/17 12:06, Boaz Harrosh wrote:
> On 14/08/17 19:03, Dan Williams wrote:
>> On Mon, Aug 14, 2017 at 7:04 AM, Boaz Harrosh <boazh@netapp.com> wrote:
>>>
>>> Thank you Jan, I'm patiently waiting for this MAP_SYNC flag since I asked for
>>> it in 2014. I'm so glad its time is finally do.
>>>
> 
> <>
> 
>>> 4] Once we have this flag. And properly implemented at least in one FS
>>>    and optionally in /dev/pmemX we no longer have any justification for
>>>    /dev/daxX and it can die a slow and happy death.
>>
>> I'm all for replacing /dev/dax with filesystem equivalent
>> functionality, but I don't think MAP_SYNC gets us fully there. That's
>> what the MAP_DIRECT proposal [1] is meant to address.
>>
> 
> OK This is true. Could you please summarise for us the exact semantics of both
> proposed flags?
> 
> That said I think the big difference is the movability of physical blocks
> underneath the mmap mapping. Now for swap files that is a problem. because
> of the deadlocks that can happen with memory needed if blocks start moving.
> But for an application like nvml? why does it care. Why can't an nvml image file
> not be cloned and COWed underneath the NVM application transparently.
> 

OK Sorry didn't do my homework. Struck this out, it is all about RDMA and friends
from an "immutable" file.

I'll go dig into this now. 

Thanks
Boaz

> Sorry for being slow but I don't see why you need MAP_DIRECT from user-mode
> If you have MAP_SYNC. Please advise
> 
> (not that the immutable patchset is not a very needed fixing)
> 
>> [1]: https://lkml.org/lkml/2017/8/13/160
>>
> 
> Thanks
> Boaz
> 
