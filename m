Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <56484DA1.5060506@plexistor.com>
Date: Sun, 15 Nov 2015 11:17:21 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [RFC 1/1] memremap: devm_memremap_pages has wrong nid
References: <5643B043.3010103@plexistor.com>	 <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com> <1447430433.21443.85.camel@hpe.com>
In-Reply-To: <1447430433.21443.85.camel@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/13/2015 06:00 PM, Toshi Kani wrote:
<>
> 
> Agreed.  memory_add_physaddr_to_nid() uses the SRAT info, which does not work
> with the NFIT case. 
> 

Thanks Toshi, I did not know that NFIT would not work. (As I already ranted NFIT
is hard to find)

Would it be hard to fix? I mean the way it is today NvDIMM is always put at the
*end* of the NUMA address range, so all the NUMA boundaries (start) are there, all
we need is to make sure max_pfn is advanced behind the last NvDIMM range.

(Ok and we might have a slight problem with an NFIT only Node, where there
 is no volatile memory at all)

I think it is worth fixing there are surprising places this might be used.
I know that it works with type-12 and emulated pmem.

(Once I set up my NFIT QEMU I'll see what I can find)

> Thanks,
> -Toshi 
> 

Thanks
Boaz

