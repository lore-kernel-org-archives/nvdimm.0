Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1430331934.23761.100.camel@misato.fc.hp.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182506.35812.4007.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1430331934.23761.100.camel@misato.fc.hp.com>
Date: Wed, 29 Apr 2015 11:59:35 -0700
Message-ID: <CAPcyv4jBjmvuO7EY9S13M8CUxHUUSpHR+Cy-8+F4d-+m5ZVhkg@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 10/20] pmem: use ida
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 29, 2015 at 11:25 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> Hi Dan,
>
> Thanks for the update.  This version of the patchset enumerates our NFIT
> table properly. :-)
>
> On Tue, 2015-04-28 at 14:25 -0400, Dan Williams wrote:
>> In preparation for the pmem driver attaching to pmem-namespaces emitted
>> by libnd, convert it to use an ida instead of an always increasing
>> atomic index.  This provides a bit of stability to pmem device names in
>> the presence of driver re-bind events.
>   :
>> @@ -122,20 +123,26 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
>>  {
>>       struct pmem_device *pmem;
>>       struct gendisk *disk;
>> -     int idx, err;
>> +     int err;
>>
>>       err = -ENOMEM;
>>       pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
>>       if (!pmem)
>>               goto out;
>>
>> +     pmem->id = ida_simple_get(&pmem_ida, 0, 0, GFP_KERNEL);
>
> nd_pmem_probe() is called asynchronously via async_schedule_domain
> ().  We have seen a case that the region#->pmem# binding becomes
> inconsistent across a reboot when there are 8 NVDIMM cards (reported by
> Robert Elliott).  This leads user to access a wrong device.
>
> I think pmem id needs to be assigned before async_schedule_domain(), and
> cascaded to nd_pmem_probe().
>

I'll take a look at making this better, but it will never be
bulletproof.  For the same reason that root=UUID=<uuid> is preferred
over root=/dev/sda userspace should never rely on consistent pmem
device names from boot to boot.
