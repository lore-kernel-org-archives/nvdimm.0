Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6220.austin.hp.com (g1t6220.austin.hp.com [15.73.96.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC5191A1E8B
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 14:42:18 -0700 (PDT)
Subject: Re: [PATCH 00/14] libnvdimm: support sub-divisions of pmem for 4.9
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1338e517-99a4-43c3-b3c4-4ca2f27a290c@hpe.com>
 <CAPcyv4gOO83VuD+4068bCo_uN4sLMioZA+s=-_Zciw70arGD_Q@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <35b6fb07-3250-7fad-9c40-e68ce72c2be0@hpe.com>
Date: Fri, 7 Oct 2016 17:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gOO83VuD+4068bCo_uN4sLMioZA+s=-_Zciw70arGD_Q@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 10/7/2016 3:52 PM, Dan Williams wrote:
> On Fri, Oct 7, 2016 at 11:19 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> Hi Dan,
>>
>> A couple of general questions...
>>
>> On 10/7/2016 12:38 PM, Dan Williams wrote:
>>> With the arrival of the device-dax facility in 4.7 a pmem namespace can
>>> now be configured into a total of four distinct modes: 'raw', 'sector',
>>> 'memory', and 'dax'. Where raw, sector, and memory are block device
>>> modes and dax supports the device-dax character device. With that degree
>>> of freedom in the use cases it is overly restrictive to continue the
>>> current limit of only one pmem namespace per-region, or "interleave-set"
>>> in ACPI 6+ terminology.
>>
>> If I understand correctly, at least some of the restrictions were
>> part of the Intel NVDIMM Namespace spec rather than ACPI/NFIT restrictions.
>> The most recent namespace spec on pmem.io hasn't been updated to remove
>> those restrictions.  Is there a different public spec?
> 
> Yes, this is Linux specific and use of this capability needs to be
> cognizant that it could create a configuration that is not understood
> by EFI, or other OSes (including older Linux implementations).  I plan
> to add documentation to ndctl along these lines.  This is similar to
> the current situation with 'pfn' and 'dax' info blocks that are also
> Linux specific.  However, I should note that this implementation
> changes none of the interpretation of the fields nor layout of the
> existing label specification.  It simply allows two pmem labels that
> happen to appear in the same region to result in two namespaces rather
> than 0.

Ok, but the namespace spec says that's not allowed.  It seemed like an odd
restriction to be in the label spec but it is there.
> 
>>> This series adds support for reading and writing configurations that
>>> describe multiple pmem allocations within a region.  The new rules for
>>> allocating / validating the available capacity when blk and pmem regions
>>> alias are (quoting space_valid()):
>>>
>>>    BLK-space is valid as long as it does not precede a PMEM
>>>    allocation in a given region. PMEM-space must be contiguous
>>>    and adjacent to an existing existing allocation (if one
>>>    exists).
>>
>> Why is this new rule necessary?  Is this a HW-specific rule or something
>> related to how Linux could possibly support something?  Why do we care
>> whether blk-space is before or after pmem-space? If it's a HW-specific
>> rule, then shouldn't the enforcement be in the management tool that
>> configures the namespaces?
> 
> It is not HW specific, and it's not new in the sense that we already
> arrange for pmem to be allocated from low addresses and blk to be
> allocated from high addresses.  

Who's the "we"?  Does the location within the region come from the OS
or from the tool that created the namespace?  (I should probably know
this but not having labels, I've never looked at this.)

If we're relaxing some of the rules, it seems like one could have
pmem, then block, then free space, and later want to use free space
for another pmem range.  If hardware supported it and the management
tool created it, would the kernel allow it?

> If another implementation violated
> this constraint Linux would parse it just fine. The constraint is a
> Linux decision to maximize available pmem capacity when blk and pmem
> alias.  So this is a situation where Linux is liberal in what it will
> accept when reading labels, but conservative on the configurations it
> will create when writing labels.

Is it ndctl that's being conservative?  It seems like the kernel shouldn't care.
> 
>>> Where "adjacent" allocations grow an existing namespace.  Note that
>>> growing a namespace is potentially destructive if free space is consumed
>>> from a location preceding the current allocation.  There is no support
>>> for dis-continuity within a given namespace allocation.
>>
>> Are you talking about DPAs here?
> 
> No, this is referring to system-physical-address partitioning.
> 
>>> Previously, since there was only one namespace per-region, the resulting
>>> pmem device would be named after the region.  Now, subsequent namespaces
>>> after the first are named with the region index and a
>>> ".<namespace-index>" suffix. For example:
>>>
>>>       /dev/pmem0.1
>>
>> According to the existing namespace spec, you can already have multiple
>> block namespaces on a device. I've not see a system with block namespaces
>> so what do those /dev entries look like?  (The dots are somewhat unattractive.)
> 
> Block namespaces result in devices with names like "/dev/ndblk0.0"
> where the X.Y numbers are <region-index>.<namespace-index>.  This new
> naming for pmem devices is following that precedent.  The "dot" was
> originally adopted from Linux USB device naming.

Does this mean that if someone updates their kernel then their /dev/pmem0
becomes /dev/pmem0.0?  Or do you only get the dot if there is more
than one namespace per region?

-- ljk


> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
