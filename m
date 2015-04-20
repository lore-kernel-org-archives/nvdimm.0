Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <55335D5E.40806@plexistor.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013519.25237.16129.stgit@dwillia2-desk3.amr.corp.intel.com>
	<55335D5E.40806@plexistor.com>
Date: Mon, 20 Apr 2015 10:08:24 -0700
Message-ID: <CAPcyv4gXNSxO80whoCm=cKiqbYkcR29Gh3xU3D9Ork92cB70WA@mail.gmail.com>
Subject: Re: [PATCH 01/21] e820, efi: add ACPI 6.0 persistent memory types
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Apr 19, 2015 at 12:46 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 04/18/2015 04:35 AM, Dan Williams wrote:
[..]
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 11cc7d54ec3f..410af501a941 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -137,6 +137,8 @@ static void __init e820_print_type(u32 type)
>>       case E820_RESERVED_KERN:
>>               printk(KERN_CONT "usable");
>>               break;
>> +     case E820_PMEM:
>> +     case E820_PRAM:
>
> NACK!
>
> This is the most important print in the system and it is a pure
> user Interface. It has no effect what so ever on functionality
> It is to Inform the user through dmesg what is the content of the
> table.

It still describes how the memory is used which is "reserved" for a
driver, I don't see how increasing the verbosity here improves debug
given the alternatives, see below...

>
>>       case E820_RESERVED:
>>               printk(KERN_CONT "reserved");
>>               break;
>> @@ -149,9 +151,6 @@ static void __init e820_print_type(u32 type)
>>       case E820_UNUSABLE:
>>               printk(KERN_CONT "unusable");
>>               break;
>
> +       case E820_PMEM:
>> -     case E820_PRAM:
>> -             printk(KERN_CONT "persistent (type %u)", type);
>> -             break;
>
> Just add the new (7) entry here please. Here Christoph has bike shed
> it for you.

/proc/iomem has these details to differentiate PRAM and PMEM as well
as show which driver(s)/device(s) have claimed the range(s).

>>       default:
>>               printk(KERN_CONT "type %u", type);
>>               break;

Here is where you can see undefined/unknown types.

>> @@ -919,10 +918,26 @@ static inline const char *e820_type_to_string(int e820_type)
>>       case E820_NVS:  return "ACPI Non-volatile Storage";
>>       case E820_UNUSABLE:     return "Unusable memory";
>>       case E820_PRAM: return "Persistent RAM";
>> +     case E820_PMEM: return "Persistent I/O Memory";
>>       default:        return "reserved";
>>       }
>>  }
>>
>> +static bool do_mark_busy(u32 type, struct resource *res)
>> +{
>> +     if (res->start < (1ULL<<20))
>> +             return true;
>> +
>> +     switch (type) {
>> +     case E820_RESERVED:
>> +     case E820_PRAM:
>> +     case E820_PMEM:
>> +             return false;
>> +     default:
>> +             return true;
>> +     }
>
> Sigh. Again an unknown type comes out busy. Busy means
> resource used. It does *not* mean "unknown type".
>
> It just forces researchers to ignore the return value of
> request_region. And not be protected by double lock. It
> does not really prevent anything

You're free to submit a standalone patch to change this policy... see
the new "OEM-reserved" memory types in ACPI 6.

That said, I think we're better off with the current policy.  If
unknown memory types were treated as permanently-busy back when we
initially started experimenting with NVDIMM support (2010) then I
doubt the e820-type-12 prototype would ever have escaped the lab.  We
could have avoided a good amount of confusion.
