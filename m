Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x234.google.com (mail-yw0-x234.google.com
 [IPv6:2607:f8b0:4002:c05::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 777C881E45
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 13:23:58 -0800 (PST)
Received: by mail-yw0-x234.google.com with SMTP id a10so32227687ywa.3
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 13:24:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161110191711.GB26806@omniknight.lm.intel.com>
References: <147879993593.130465.16954973899565924428.stgit@djiang5-desk3.ch.intel.com>
 <20161110191711.GB26806@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Nov 2016 13:24:00 -0800
Message-ID: <CAPcyv4j9-PsJ4T8EdiiLnq1-hOLvasV7FymuLbYpsDfu3G7=EA@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm: check and clear poison before writing to
 pmem
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 10, 2016 at 11:17 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 11/10, Dave Jiang wrote:
>> We need to clear any poison when we are writing to pmem. The granularity
>> will be sector size. If it's less then we can't do anything about it
>> barring corruption.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/nvdimm/claim.c |   24 +++++++++++++++++++++---
>>  1 file changed, 21 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
>> index d5dc80c..306d8fd 100644
>> --- a/drivers/nvdimm/claim.c
>> +++ b/drivers/nvdimm/claim.c
>> @@ -226,6 +226,11 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>               resource_size_t offset, void *buf, size_t size, int rw)
>>  {
>>       struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
>> +     unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>> +     sector_t sector = offset >> 9;
>> +
>> +     if (unlikely(!size))
>> +             return -EINVAL;
>>
>>       if (unlikely(offset + size > nsio->size)) {
>>               dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
>> @@ -233,12 +238,25 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>       }
>>
>>       if (rw == READ) {
>> -             unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>> -
>> -             if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
>> +             if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
>>                       return -EIO;
>>               return memcpy_from_pmem(buf, nsio->addr + offset, size);
>>       } else {
>> +
>> +             if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
>> +                     if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
>> +                             long cleared;
>> +
>> +                             cleared = nvdimm_clear_poison(&ndns->dev,
>> +                                                           offset, size);
>
> Everything above looks good..
>
>> +                             if (cleared != size)
>> +                                     return -EIO;
>
> But I think we don't want to return -EIO here. Instead, ...
>> +
>> +                             badblocks_clear(&nsio->bb, sector,
>> +                                             cleared >> 9);
>> +                     }
>> +             }
>> +
>>               memcpy_to_pmem(nsio->addr + offset, buf, size);
>>               nvdimm_flush(to_nd_region(ndns->dev.parent));
>
> Do _some_ writes. We have two options:
> 1. Try to write the whole thing (size), and return success. If the write
> touches any remaining poison, it will not complain, but the poison will
> be retained, so subsequent reads will hit it and fail.
>
> 2. Only write what we were able to clear, i.e. 'cleared' bytes. And
> since we didn't complete the write, error out.
>
> I think 1 makes more sense, but I could be convinced otherwise..
>
> One wild idea might be:
> rw_bytes can write arbitrary lengths, and commonly does up to 4K at a
> time (BTT data writes). This gives us a rather large window where we
> could be clearing 4K worth of badblocks all together, and then writing
> 4K of data. If we crash anywhere in the middle, we're almost guaranteed
> silent data corruption.
>
> Instead, what if, for the known-errors case for writes, we break it down
> into smaller chunks:
> Go cache line by cache line - if it may have poison (based on
> badblocks), clear poison, followed by a cache line worth of data write.
> When we cross a sector boundary (512), do a badblocks_clear.
>
> I think this gives us the best chance against silent corruption in the
> absence of an atomic clear-error-and-write command.
>
> Thoughts?

This feels like over-engineering a still not perfect solution to a
rare problem.  Outside of atomic-write-and-clear we should just keep
the code best effort and simple.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
