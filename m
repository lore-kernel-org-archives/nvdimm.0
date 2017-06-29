Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46B1721C8F620
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 15:11:34 -0700 (PDT)
Subject: Re: [PATCH v4 12/16] libnvdimm, nfit: enable support for volatile
 ranges
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
Date: Thu, 29 Jun 2017 18:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 6/29/2017 5:50 PM, Dan Williams wrote:
> On Thu, Jun 29, 2017 at 2:16 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 06/29/2017 04:42 PM, Dan Williams wrote:
>>> On Thu, Jun 29, 2017 at 12:20 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> On 06/29/2017 01:54 PM, Dan Williams wrote:
>>>>> Allow volatile nfit ranges to participate in all the same infrastructure
>>>>> provided for persistent memory regions.
>>>>
>>>> This seems to be a bit more than "other rework".
>>>
>>> It's part of the rationale for having a "write_cache" control
>>> attribute. There's only so much I can squeeze into the subject line,
>>> but it is mentioned in the cover letter.
>>>
>>>>> A resulting resulting namespace
>>>>> device will still be called "pmem", but the parent region type will be
>>>>> "nd_volatile".
>>>>
>>>> What does this look like to a user or admin?  How does someone know that
>>>> /dev/pmemX is persistent memory and /dev/pmemY isn't?  Someone shouldn't
>>>> have to weed through /sys or ndctl some other interface to figure that out
>>>> in the future if they don't have to do that today.  We have different
>>>> names for BTT namespaces.  Is there a different name for volatile ranges?
>>>
>>> No, the block device name is still /dev/pmem. It's already the case
>>> that you need to check behind just the name of the device to figure
>>> out if something is actually volatile or not (see memmap=ss!nn
>>> configurations),
>>
>> I don't have any experience with using memmap but if it's primarily used
>> by developers without NVDIMMs, they'd know it's not persistent.  Or is it
>> primarily used by administrators using non-NFIT NVDIMMs, in which case it
>> is persistent?
>>
>> In any case, how exactly does one determine whether the device is volatile
>> or not?  I'm dumb so tell me the command line or API.
>
> Especially with memmap= or e820-defined memory it's unknowable from
> the kernel. We don't know if the user is using it to cover for a
> platform where there is no BIOS support for advertising persistent
> memory, or if they have a BIOS that does not produce an NFIT as is the
> case here [1], or if it is some developer just testing with no
> expectation of persistence.
>
> [1]: https://github.com/pmem/ndctl/issues/21

Ok.  I'm not really concerned about those cases but was asking since
you mentioned memmap as an example.

In any case, how does someone, like a system administrator, confirm that
a /dev/pmem device is a device that claims to be persistent?  Is there
a specific ndctl command line that would make it obvious what the Linux
device is on a device that claims to be persistent?

>>> so I would not be in favor of changing the device
>>> name if we think the memory might not be persistent. Moreover, I think
>>> it was a mistake that we change the device name for btt or not, and
>>> I'm glad Matthew talked me out of making the same mistake with
>>> memory-mode vs raw-mode pmem namespaces. So, the block device name
>>> just reflects the driver of the block device, not the properties of
>>> the device, just like all other block device instances.
>>
>> I agree that creating a new device name for BTT was perhaps a mistake,
>> although it would be good to know how to query a device property for
>> sector atomicity.  The difference between BTT vs. non-BTT seems less
>> critical to me than knowing in an obvious way whether the device is
>> actually persistent.
>
> We don't have a good way to answer "actually persistent" in the
> general case. I'm thinking of cases where the energy source on the
> DIMM has died, or we trigger one of the conditions that leads to the
> ""unable to guarantee persistence of writes" message.

There are certainly error conditions that can happen and we've talked
about that bit in our health status discussions.  I think the question
of whether the device is healthy enough to be persistent right now
is different from whether the device is never ever going to be persistent.

> The /dev/pmem
> device name just tells you that your block device is hosted by a
> driver that knows how to handle persistent memory constraints, but any
> other details about the nature of the address range need to come from
> other sources of information, and potentially information sources that
> the kernel does not know about.

I'm asking about the other source of information in this specific case
where we're exposing pmem devices that will never ever be persistent.
Before we add these devices, I think we should be able to tell the user
how they can know the properties of the underlying device.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
