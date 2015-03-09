Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FD7BF6.70405@plexistor.com>
Date: Mon, 09 Mar 2015 12:54:46 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
References: <54F82CE0.4040502@plexistor.com>	<54F82DD7.90600@plexistor.com> <CAPcyv4heW8L+nQir_DNwN6LfWVVwX6jZRUufsnTYMSSibWXd=w@mail.gmail.com>
In-Reply-To: <CAPcyv4heW8L+nQir_DNwN6LfWVVwX6jZRUufsnTYMSSibWXd=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/05/2015 10:41 PM, Dan Williams wrote:
> On Thu, Mar 5, 2015 at 2:20 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>>
>> There is something not very nice (Gentlemen nice) In current
>> e820.c code.
>>
>> At Multiple places for example @memblock_x86_fill() it will
>> add the different memory resources *except the E820_RESERVED type*
>>
>> Then at e820_reserve_resources() it will mark all !E820_RESERVED
>> as busy.
>>
>> This is all fine when we have only the known types one of:
>>         E820_RESERVED_KERN:
>>         E820_RAM:
>>         E820_ACPI:
>>         E820_NVS:
>>         E820_UNUSABLE:
>>         E820_RESERVED:
>>
>> But if the system encounters a brand new memory type it will
>> not add it to any memory list, But will proceed to mark it
>> BUSY. So now any other Driver in the system that does know
>> how to deal with this new type, is not able to call
>> request_mem_region_exclusive() on this new type because it is
>> hard coded BUSY even though nothing really uses it.
>>
>> So make any unknown type behave like E820_RESERVED memory,
>> it will show up as available to first caller of
>> request_mem_region_exclusive().
>>
>> I Also change the string representation of an unknown type
>> from "reserved" (So to not confuse with memmap "reserved"
>> region). And call it "reserved-unknown"
>> I wish I could return "reserved-type-X" But this is not possible
>> because one must return a constant, code-segment, string.
>>
>> (NOTE: These unknown-types where called "reserved" in
>>  /proc/iomem and in dmesg but behaved differently. What this
>>  patch does is name them differently but let them behave
>>  the same)
>>
>> By Popular demand An Extra WARNING message is printed if
>> an "UNKNOWN" is found. It will look like this:
>>   e820: WARNING [mem 0x100000000-0x1ffffffff] is unknown type 12
>>
>> An example of such "UNKNOWN" type is the not Standard type-12
>> DDR3-NvDIMM which is used by multiple vendors for a while
>> now. (Estimated 100ds of thousands sold world wide)
>>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: x86@kernel.org
>> CC: Dan Williams <dan.j.williams@intel.com>
>> CC: Matthew Wilcox <willy@linux.intel.com>
>> CC: Christoph Hellwig <hch@infradead.org>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>> ---
>>  arch/x86/kernel/e820.c | 31 +++++++++++++++++++++++++++++--
>>  1 file changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 46201de..c3a11cd 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -104,6 +104,21 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
>>         return 0;
>>  }
>>
>> +static bool _is_unknown_type(int e820_type)
> 
> Any reason for the leading "_"?
> 

I have a style guide that says that any static function starts with a _ and
need not a global prefix like e820_ so to not conflict when compiled in-kernel.

But This is not the style in this file. So sorry, do I must send a new version
patch?

>> +{
>> +       switch (e820_type) {
>> +       case E820_RESERVED_KERN:
>> +       case E820_RAM:
>> +       case E820_ACPI:
>> +       case E820_NVS:
>> +       case E820_UNUSABLE:
>> +       case E820_RESERVED:
>> +               return false;
>> +       default:
>> +               return true;
>> +       }
>> +}
>> +
>>  /*
>>   * Add a memory region to the kernel e820 map.
>>   */
>> @@ -119,6 +134,11 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
>>                 return;
>>         }
>>
>> +       if (unlikely(_is_unknown_type(type)))
> 
> Unnecessary unlikely()?
> 

Its more for a programmer's communication then CPU optimization. Though also for
the CPU it is, "don't waste space at branch predictor", in anyway it can not hurt.

But I like it here for the reading code flow that communicates. "Even if this happens
%100 of the time the code flow should be not to take this error branch"

>> +               pr_warn("e820: WARNING [mem %#010llx-%#010llx] is unknown type %d\n",
>> +                      (unsigned long long) start,
>> +                      (unsigned long long) (start + size - 1), type);
> 
> I still think this warning can go and 

I did not have it at first, but Ingo felt it has merit, I trust his experience and
instincts. I kind of like it now in the lab logs, for machines that actually have
NvDIMMs in them.

> we can just fold patch 2 into this one, but other than that this looks ok to me.
> 

No! we cannot.

1. For one it is two different subsystems and maintainers. You want them separate
   So they might go in through different trees, also conflict in different way if
   code advances.

2. These are two different topics. This patch is about fixing a bug, The resource being
   busy was not intentional.
   The second patch is about a global WARNING for when some mem resource is used, which
   is independent of this here problem and is a new fixture.

Thanks
Boaz

