Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150420070624.GB13876@gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150420070624.GB13876@gmail.com>
Date: Mon, 20 Apr 2015 01:14:42 -0700
Message-ID: <CAPcyv4g8wAzWq34onfYKreoh+qEv6KWzaAmAmGnvW5KhoB07xA@mail.gmail.com>
Subject: Re: [PATCH 02/21] ND NFIT-Defined/NVIDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 20, 2015 at 12:06 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Maintainer information and documenation for drivers/block/nd/
>>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Boaz Harrosh <boaz@plexistor.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Jens Axboe <axboe@fb.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  Documentation/blockdev/nd.txt |  867 +++++++++++++++++++++++++++++++++++++++++
>>  MAINTAINERS                   |   34 +-
>>  2 files changed, 895 insertions(+), 6 deletions(-)
>>  create mode 100644 Documentation/blockdev/nd.txt
>>
>> diff --git a/Documentation/blockdev/nd.txt b/Documentation/blockdev/nd.txt
>> new file mode 100644
>> index 000000000000..bcfdf21063ab
>> --- /dev/null
>> +++ b/Documentation/blockdev/nd.txt
>> @@ -0,0 +1,867 @@
>> +                 The NFIT-Defined/NVDIMM Sub-system (ND)
>> +
>> +      nd - kernel abi / device-model & ndctl - userspace helper library
>> +                         linux-nvdimm@lists.01.org
>> +                            v9: April 17th, 2015
>> +
>> +
>> +  Glossary
>> +
>> +  Overview
>> +    Supporting Documents
>> +    Git Trees
>> +
>> +  NFIT Terminology and NVDIMM Types
>>
>> [...]
>>
>> +The “NVDIMM Firmware Interface Table” (NFIT) [...]
>
> Ok, I'll bite.
>
> So why on earth is this whole concept and the naming itself
> ('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving
> around a specific 'firmware' mindset and revolving around specific,
> weirdly named, overly complicated looking firmware interfaces that
> come with their own new weird glossary??

There's only three core properties of NVDIMMs that this implementation
cares about.

1/ directly mapped interleaved persistent memory (PMEM)
2/ indirect mmio aperture accessed (windowed) persistent memory (BLK)
3/ the possibility that those 2 access modes may alias the same
on-media addresses

Most of complexity of the implementation is dealing with aspect 3, but
that complexity can and is bypassed in places.

> Firmware might be a discovery method - or not. A non-volatile device
> might be e820 enumerated, or PCI discovered - potentially with all
> discovery handled by the driver.

PCI attached non-volatile memory is NVMe.  ND is handling address
ranges that support direct cpu load store.

> Why do you restrict this driver to a naming and design that is so
> firmware centric?

PMEM, BLK, and the fact that they may alias are the generic properties
that are independent of the specification.  Granted some of the NFIT
terminology has leaked past the point of initial table parsing, but
its too early to start claiming "restrictive" design.  We already
support three ways of attaching PMEM with varying degrees of backing
complexity, and we're more than willing to beat NFIT back where it
makes sense to accommodate more non-NFIT NVDIMM implementations.

> Discovery matters, but what matters _most_ to devices is actually its
> runtime properties and runtime implementation - and I sure hope
> firmware has no active role in that!

It doesn't.  Once PMEM and BLK aliasing are resolved the firmware is
out of the picture.  In some cases this aliasing is resolved from the
outset (simple memory range, type-12 etc...), the bulk of the
implementation is bypassed in that case.

> I really think this is backwards from the get go, it gives me a
> feeling of someone having spent way too much time in committee and too
> little time spent thinking about simple, proper kernel design and
> reusing existing terminology ...

The simple paths are there, in addition to support for the rest of the
spec.  Do we have an existing term for a dimm-relative-address in the
kernel?  Some of this is simply novel to the kernel.

> Also:
>
> +      nd - kernel abi / device-model & ndctl - userspace helper library
>
> WTF is a 'kernel ABI'??

"ABI" like Documentation/ABI/, the sysfs layout and ioctls for passing
a handful of management commands to firmware.  Wherever possible all
the slow path configuration is done with sysfs.
