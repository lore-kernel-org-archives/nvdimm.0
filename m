Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <554143E0.7010305@hp.com>
Date: Wed, 29 Apr 2015 16:49:36 -0400
From: Linda Knippers <linda.knippers@hp.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH v2 10/20] pmem: use ida
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <20150428182506.35812.4007.stgit@dwillia2-desk3.amr.corp.intel.com> <1430331934.23761.100.camel@misato.fc.hp.com> <CAPcyv4jBjmvuO7EY9S13M8CUxHUUSpHR+Cy-8+F4d-+m5ZVhkg@mail.gmail.com> <1430333633.23761.109.camel@misato.fc.hp.com>
In-Reply-To: <1430333633.23761.109.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 4/29/2015 2:53 PM, Toshi Kani wrote:
> On Wed, 2015-04-29 at 11:59 -0700, Dan Williams wrote:
>> On Wed, Apr 29, 2015 at 11:25 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>>> Hi Dan,
>>>
>>> Thanks for the update.  This version of the patchset enumerates our NFIT
>>> table properly. :-)
>>>
>>> On Tue, 2015-04-28 at 14:25 -0400, Dan Williams wrote:
>>>> In preparation for the pmem driver attaching to pmem-namespaces emitted
>>>> by libnd, convert it to use an ida instead of an always increasing
>>>> atomic index.  This provides a bit of stability to pmem device names in
>>>> the presence of driver re-bind events.
>>>   :
>>>> @@ -122,20 +123,26 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
>>>>  {
>>>>       struct pmem_device *pmem;
>>>>       struct gendisk *disk;
>>>> -     int idx, err;
>>>> +     int err;
>>>>
>>>>       err = -ENOMEM;
>>>>       pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
>>>>       if (!pmem)
>>>>               goto out;
>>>>
>>>> +     pmem->id = ida_simple_get(&pmem_ida, 0, 0, GFP_KERNEL);
>>>
>>> nd_pmem_probe() is called asynchronously via async_schedule_domain
>>> ().  We have seen a case that the region#->pmem# binding becomes
>>> inconsistent across a reboot when there are 8 NVDIMM cards (reported by
>>> Robert Elliott).  This leads user to access a wrong device.
>>>
>>> I think pmem id needs to be assigned before async_schedule_domain(), and
>>> cascaded to nd_pmem_probe().
>>>
>>
>> I'll take a look at making this better, but it will never be
>> bulletproof.  For the same reason that root=UUID=<uuid> is preferred
>> over root=/dev/sda userspace should never rely on consistent pmem
>> device names from boot to boot.
> 
> I agree that constant unique IDs, such as UUIDs, are necessary to
> guarantee their consistent numbering regardless of configuration
> changes.  For now, /dev/pmem%d should have consistent numbering while
> NFIT table entries are consistent.

What's the right answer for this in the long run?

The NFIT has information like "Memory Device Physical ID" that is an SMBIOS
type 17 handle.  SMBIOS could have some naming information, like it does for
NICs.  There is also a "Memory Device Region ID".  Is that combination
enough to give us a unique identifier?

Of course, I'm assuming that information is consistent across reboots
and ideally across configuration changes, like adding more NVDIMMs.
For NICs, that's where the SMBIOS consistent naming information is helpful.
Is that what we need for devices that don't have namespaces and labels?

-- ljk

> 
> Thanks,
> -Toshi
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

