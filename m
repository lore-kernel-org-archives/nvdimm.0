Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x232.google.com (mail-yw0-x232.google.com
 [IPv6:2607:f8b0:4002:c05::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED98E2095A6CD
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:48:41 -0700 (PDT)
Received: by mail-yw0-x232.google.com with SMTP id j11so42435079ywa.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59556E37.80808@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 14:50:12 -0700
Message-ID: <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] libnvdimm,
 nfit: enable support for volatile ranges
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 2:16 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 06/29/2017 04:42 PM, Dan Williams wrote:
>> On Thu, Jun 29, 2017 at 12:20 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>> On 06/29/2017 01:54 PM, Dan Williams wrote:
>>>> Allow volatile nfit ranges to participate in all the same infrastructure
>>>> provided for persistent memory regions.
>>>
>>> This seems to be a bit more than "other rework".
>>
>> It's part of the rationale for having a "write_cache" control
>> attribute. There's only so much I can squeeze into the subject line,
>> but it is mentioned in the cover letter.
>>
>>>> A resulting resulting namespace
>>>> device will still be called "pmem", but the parent region type will be
>>>> "nd_volatile".
>>>
>>> What does this look like to a user or admin?  How does someone know that
>>> /dev/pmemX is persistent memory and /dev/pmemY isn't?  Someone shouldn't
>>> have to weed through /sys or ndctl some other interface to figure that out
>>> in the future if they don't have to do that today.  We have different
>>> names for BTT namespaces.  Is there a different name for volatile ranges?
>>
>> No, the block device name is still /dev/pmem. It's already the case
>> that you need to check behind just the name of the device to figure
>> out if something is actually volatile or not (see memmap=ss!nn
>> configurations),
>
> I don't have any experience with using memmap but if it's primarily used
> by developers without NVDIMMs, they'd know it's not persistent.  Or is it
> primarily used by administrators using non-NFIT NVDIMMs, in which case it
> is persistent?
>
> In any case, how exactly does one determine whether the device is volatile
> or not?  I'm dumb so tell me the command line or API.

Especially with memmap= or e820-defined memory it's unknowable from
the kernel. We don't know if the user is using it to cover for a
platform where there is no BIOS support for advertising persistent
memory, or if they have a BIOS that does not produce an NFIT as is the
case here [1], or if it is some developer just testing with no
expectation of persistence.

[1]: https://github.com/pmem/ndctl/issues/21

>> so I would not be in favor of changing the device
>> name if we think the memory might not be persistent. Moreover, I think
>> it was a mistake that we change the device name for btt or not, and
>> I'm glad Matthew talked me out of making the same mistake with
>> memory-mode vs raw-mode pmem namespaces. So, the block device name
>> just reflects the driver of the block device, not the properties of
>> the device, just like all other block device instances.
>
> I agree that creating a new device name for BTT was perhaps a mistake,
> although it would be good to know how to query a device property for
> sector atomicity.  The difference between BTT vs. non-BTT seems less
> critical to me than knowing in an obvious way whether the device is
> actually persistent.

We don't have a good way to answer "actually persistent" in the
general case. I'm thinking of cases where the energy source on the
DIMM has died, or we trigger one of the conditions that leads to the
""unable to guarantee persistence of writes" message. The /dev/pmem
device name just tells you that your block device is hosted by a
driver that knows how to handle persistent memory constraints, but any
other details about the nature of the address range need to come from
other sources of information, and potentially information sources that
the kernel does not know about.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
