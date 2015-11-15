Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <564859A6.2080406@plexistor.com>
Date: Sun, 15 Nov 2015 12:08:38 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] nvdimm: proper NID in e820_pmem_probe
References: <5643B043.3010103@plexistor.com>	<CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com>	<5643BB8D.4080202@plexistor.com>	<56448FDE.4020404@plexistor.com>	<56449AF3.70606@plexistor.com> <CAPcyv4gabAY-8vuK+DZv0o9OdMCpY+ayC4bXqz7PWw-C5NTs2Q@mail.gmail.com>
In-Reply-To: <CAPcyv4gabAY-8vuK+DZv0o9OdMCpY+ayC4bXqz7PWw-C5NTs2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stable Tree <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/12/2015 07:13 PM, Dan Williams wrote:
<>
> 
> Thanks for the test!  There's a small compile fix I need to add that
> 0day discovered, but I'll get this into a pull request before the end
> of the week.
> 

Thanks

<>
> 
> Really?  How do you achieve these 3 features without get_user_pages()
> for DAX mappings?  Do you have a custom driver in the kernel that is
> just going pfn_to_page()?
> 

Yes both Target and Initiator are Kernel based. The target is currently
a driver that receives a /dev/pmemX parameter to operate on. (The initiator
is inside this pmem cluster FS, half Kernel half user-space)

<>
>>
>> We still carry a few of our own persistent assembly calls, but just because
>> the Kernel's ones are a bit of a mixed mess.
> 
> Would be interested to see them.  We're currently looking at
> performance enhancements in this area.
> 

I have an old patch to clean up pmem.h and stuff but is old and will not patch.
Is there anything beyond what Linus pulled for 4.4-rc1 ? I'll try to base it
on your tree. But no promises this is low priority for me.

performance wise we are using the regular __copy_from_user_inatomic_nocache()
as you do.
Only difference is the: "No need for memory-barrier with clflush" and our
clflush loop with some fixes.
(And our own clean implementation of copy_from_iter_persistent inside
 iov_iter.c for also KVEC and BVEC NT support)

Actually we are counting on your future patches to not FAULT on memory
errors and return with an error code.

<>
> 
> I agree that the ADR situation is a bit of a mess since ACPI provides
> no mechanism to tell you that it is available.  I wouldn't be opposed
> to whitelisting certain platforms or use a sideband mechanism to check
> for ADR.  It's just not clear to me how to reliably determine if ADR
> is available and functional.
> 

I think that for now the presence of ACPI both type-12 and NFIT is a clear
indication of an ADR system. Do you know of any system in existence that this
is not true? (Why talk about theoretical none existent systems?).

Any system builder will not provide ACPI NvDIMM tables if it would not work,
otherwise what is the point to provide it? so just trust the system builder
I think.

I think the all warning is mute. The chain of events that need to happen so
a pmem driver will actually appear already means the system is capable of
NvDIMM. So please let us just remove this warning. Also with emulated memmap=ss!aa
the warning means nothing.

[BTW Also with (none-existent) pcommit you do not actually know that the system
 actually works, the CPU might have it, but not the firmware]

> How about a kernel parameter like "libnvdimm.adr=1" to tell the kernel
> to ignore the absence of pcommit?
> 

Again I think the presence of NFIT or type-12 already means this.
For x86 this is ADR. For other ARCHs they will need to provide there
own Software or firmware support down the ARCH space. I think

The only real point is ARCHs that do not define any pmem support, but
for those we will BUG() so fast that the warning is pointless there too.

<>
> 
> The QEMU NFIT enabling is progressing, but not yet merged it seems.
> 
> http://marc.info/?l=qemu-devel&m=144645659908290&w=2
> 

I will make an attempt to compile this, and produce a document.

Thanks Dan, good day
Boaz

