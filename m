Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151127101611.GA1087@gmail.com>
References: <cover.1447093568.git.tony.luck@intel.com>
	<02ef9e0e0b73591aa8ec37aae2409274d108af60.1447093569.git.tony.luck@intel.com>
	<20151112075313.GA5984@gmail.com>
	<20151112200106.GA32073@agluck-desk.sc.intel.com>
	<20151127101611.GA1087@gmail.com>
Date: Tue, 8 Dec 2015 13:30:19 -0800
Message-ID: <CAA9_cmcGbnzKLufKwT-LE_=82L2PTJ8bjfQCkPUhMxDA31ixmg@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, ras: Add mcsafe_memcpy() function to recover
 from machine checks
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Jens Axboe <axboe@fb.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, Jeff Moyer <jmoyer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding nvdimm folks ]

On Fri, Nov 27, 2015 at 2:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Luck, Tony <tony.luck@intel.com> wrote:
>
>> On Thu, Nov 12, 2015 at 08:53:13AM +0100, Ingo Molnar wrote:
>> > > +extern phys_addr_t mcsafe_memcpy(void *dst, const void __user *src,
>> > > +                         unsigned size);
>> >
>> > So what's the longer term purpose, where will mcsafe_memcpy() be used?
>>
>> The initial plan is to use this for file systems backed by NVDIMMs. They will
>> have a large amount of memory, and we have a practical recovery path - return
>> -EIO just like legacy h/w.
>>
>> We can look for other places in the kernel where we read large amounts of memory
>> and have some idea how to recover if the memory turns out to be bad.
>
> I see, that's sensible!
>
> Thanks,
>
>         Ingo

Is that an "Acked-by"?  I'd like to pull this plus Vishal's
gendisk-badblocks patches into a unified libnvdimm-error-handling
branch.  We're looking to have v4.5 able to avoid or survive nvdimm
media errors through the pmem driver and DAX paths.
