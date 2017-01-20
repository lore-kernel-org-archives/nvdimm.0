Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x243.google.com (mail-ua0-x243.google.com
 [IPv6:2607:f8b0:400c:c08::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69FD581EA9
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 07:33:04 -0800 (PST)
Received: by mail-ua0-x243.google.com with SMTP id i68so7660442uad.1
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 07:33:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170120102717.GI14115@quack2.suse.cz>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488423988.37913.16814081637297710444.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170120102717.GI14115@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Jan 2017 07:33:02 -0800
Message-ID: <CAA9_cmdY=Wg7xduOSUeLhnsxHDgQTCz-389hyr8XH6q-NrSp+Q@mail.gmail.com>
Subject: Re: [PATCH 05/13] x86, dax: replace clear_pmem() with open coded
 memset + dax_ops->flush
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
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 20, 2017 at 2:27 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 19-01-17 19:50:39, Dan Williams wrote:
>> The clear_pmem() helper simply combines a memset() plus a cache flush.
>> Now that the flush routine is optionally provided by the dax device
>> driver we can avoid unnecessary cache management on dax devices fronting
>> volatile memory.
>>
>> With clear_pmem() gone we can follow on with a patch to make pmem cache
>> management completely defined within the pmem driver.
> ...
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 160024e403f6..8883ce4d391e 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -986,6 +986,7 @@ static bool dax_range_is_aligned(struct block_device *bdev,
>>  int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
>>               unsigned int offset, unsigned int length)
>>  {
>> +     const struct dax_operations *dax_ops = to_dax_ops(bdev);
>>       struct blk_dax_ctl dax = {
>>               .sector         = sector,
>>               .size           = PAGE_SIZE,
>> @@ -999,7 +1000,9 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
>>       } else {
>>               if (dax_map_atomic(bdev, &dax) < 0)
>>                       return PTR_ERR(dax.addr);
>> -             clear_pmem(dax.addr + offset, length);
>> +             memset(dax.addr + offset, 0, length);
>> +             if (dax_ops->flush)
>> +                     dax_ops->flush(dax.addr + offset, length);
>>               dax_unmap_atomic(bdev, &dax);
>>       }
>>       return 0;
>
> Shouldn't we rather have some callback in dax_ops for clearing memory?
> If we had all accesses to persistent memory inside DAX code wrapped inside
> appropriate device wrappers that can report errors, we can have proper
> error handling for the case we hit MCE, can't we?

That's true. I was thinking along those lines in the badblocks thread
and then missed that I did not give clearing pmem the same treatment.
No objections from me, I'll add ->clear() to dax_ops.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
