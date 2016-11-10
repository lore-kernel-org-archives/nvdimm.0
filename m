Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x233.google.com (mail-it0-x233.google.com
 [IPv6:2607:f8b0:4001:c0b::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A951081C95
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 16:54:36 -0800 (PST)
Received: by mail-it0-x233.google.com with SMTP id q124so2000843itd.1
 for <linux-nvdimm@lists.01.org>; Wed, 09 Nov 2016 16:54:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161110001405.GA26806@omniknight.lm.intel.com>
References: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
 <20161110001405.GA26806@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Nov 2016 16:54:38 -0800
Message-ID: <CAPcyv4g8jOp4jKH5+Cn2TEhhCZU0Mu7A5PXWAQHmAP7UO4Pk9Q@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: check and clear poison before writing to pmem
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

On Wed, Nov 9, 2016 at 4:14 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 11/09, Dave Jiang wrote:
>> We need to clear any poison when we are writing to pmem. The granularity
>> will be sector size. If it's less then we can't do anything about it
>> barring corruption.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/nvdimm/claim.c |   20 ++++++++++++++++++--
>>  1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
>> index d5dc80c..2078d25 100644
>> --- a/drivers/nvdimm/claim.c
>> +++ b/drivers/nvdimm/claim.c
>> @@ -226,6 +226,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>               resource_size_t offset, void *buf, size_t size, int rw)
>>  {
>>       struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
>> +     unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>>
>>       if (unlikely(offset + size > nsio->size)) {
>>               dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
>> @@ -233,12 +234,27 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>>       }
>>
>>       if (rw == READ) {
>> -             unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>> -
>>               if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
>>                       return -EIO;
>>               return memcpy_from_pmem(buf, nsio->addr + offset, size);
>>       } else {
>> +             sector_t sector = offset / 512;
>
> Small nit, but if you move the above line to the top of the function,
> you can reuse 'sector' int he rw == READ case's is_bad_pmem call too,
> making it read the same as the one below.
>
>> +
>> +             if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
>> +                     if (IS_ALIGNED(offset, 512) &&
>> +                         IS_ALIGNED(size, 512) && (size >= 512)) {
>
> Having the size >= 512 check here feels a bit odd.. If you can refactor
> this to have something near the top to simply exit out for size == 0
> (that should never happen anyway), then you can simply remove this last
> part of the condition. If size > 0, and if it is aligned to 512
> automatically implies it will at least be 512.
>
>> +                             int rc;
>> +
>> +                             rc = nvdimm_clear_poison(&ndns->dev, offset,
>> +                                                      size);
>
> nvdimm_clear_poison returns a long, rc is an int.. While at it, since
> this is the only palce where 'rc' is being used, perhaps rename it to
> something like 'cleared' (like in pmem_clear_poison), so that the usage
> is better described.
>
>> +                             if (rc != size)
>> +                                     return -EIO;
>
> I'm not sure of this myself - perhaps a question to Dan -
> Is it safe to return EIO here? We have potentially cleared some poison,
> and lost some data, but subsequent reads will not indicate any errors,
> returning either 0s or something unpredictable. Would it be better to
> simply go ahead with the write even if we weren't able to clear the
> whole range?

Good point, the interface allows partial completions, so it's
reasonable to go write what we were able to clear.  However that only
shrinks the exposure not eliminate it since we could immediately crash
for some other reason before the write completes.

We would an error clearing interface that had deterministic data after
clearing to do something better, but I can get on board with writing
new data after a partial completion.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
