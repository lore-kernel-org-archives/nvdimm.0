Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALCETrWq4NYqYomAVDZB6NBheLp-zA6yJXmcN244skYweAGaBg@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182417.35812.92834.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CALCETrWq4NYqYomAVDZB6NBheLp-zA6yJXmcN244skYweAGaBg@mail.gmail.com>
Date: Tue, 28 Apr 2015 13:57:25 -0700
Message-ID: <CAPcyv4h3w2V6iNDbwddQzrV+jdT06m28O1_H6cj7y2B9i1gZTA@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] e820, efi: add ACPI 6.0 persistent memory types
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 1:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 28, 2015 at 11:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 11cc7d54ec3f..d38b53a7e9b2 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -149,6 +149,7 @@ static void __init e820_print_type(u32 type)
>>         case E820_UNUSABLE:
>>                 printk(KERN_CONT "unusable");
>>                 break;
>> +       case E820_PMEM:
>>         case E820_PRAM:
>>                 printk(KERN_CONT "persistent (type %u)", type);
>>                 break;
>
> I'd kind of like to make it more clear what's going on here.  It
> doesn't help that the spec chose poor names.
>
> How about "NVDIMM physical aperture" for E820_PMEM and "legacy
> persistent RAM" for E820_PRAM?

The term "aperture" to me implies this BLK (mmio-windowed) mode of
accessing persistent media that the NFIT specification introduces.  In
fact, those ranges are mapped E820_RESERVED.  E820_PMEM really is a
memory range that happens to be persistent.

> Otherwise this looks generaly sensible, although I don't really
> understand why e820_type_to_string and e820_print_type are different.

 e820_type_to_string() appears in /proc/iomem and seems to afford
being more descriptive than e820_print_type() that just scrolls by in
dmesg, but I'm just guessing.
