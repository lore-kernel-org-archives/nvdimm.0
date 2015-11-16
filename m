Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1447694386.21443.140.camel@hpe.com>
Subject: Re: [RFC 1/1] memremap: devm_memremap_pages has wrong nid
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 16 Nov 2015 10:19:46 -0700
In-Reply-To: <56484DA1.5060506@plexistor.com>
References: <5643B043.3010103@plexistor.com>
		 <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com>
	 <1447430433.21443.85.camel@hpe.com> <56484DA1.5060506@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2015-11-15 at 11:17 +0200, Boaz Harrosh wrote:
> On 11/13/2015 06:00 PM, Toshi Kani wrote:
> <>
> > 
> > Agreed.  memory_add_physaddr_to_nid() uses the SRAT info, which does not 
> > work with the NFIT case.
> > 
> 
> Thanks Toshi, I did not know that NFIT would not work. (As I already ranted 
> NFIT is hard to find)
> 
> Would it be hard to fix? I mean the way it is today NvDIMM is always put at 
> the *end* of the NUMA address range, so all the NUMA boundaries (start) are 
> there, all we need is to make sure max_pfn is advanced behind the last NvDIMM
> range.

I understand that both memory_add_physaddr_to_nid() and max_pfn cover NVDIMM
ranges on platforms with legacy E820_PRAM (12), which differs from the NFIT
case.  I agree that such difference is not desirable.

NFIT FW I have does not put NVDIMM ranges into SRAT, but ACPI spec is not very
clear about it [1].  We currently consider NVDIMM as device memory, not regular
memory.  So, this depends on how we define the "memory" info.

As for max_pfn, yes, it may make sense to cover NVDIMM when ZONE_DEVICE is used.

> (Ok and we might have a slight problem with an NFIT only Node, where there
>  is no volatile memory at all)

The NFIT driver sets it to the closest on-line node (i.e. where regular memory
resides) in this case.

> I think it is worth fixing there are surprising places this might be used.
> I know that it works with type-12 and emulated pmem.
> 
> (Once I set up my NFIT QEMU I'll see what I can find)

Thanks,
-Toshi

[1] https://lkml.org/lkml/2015/9/1/484

