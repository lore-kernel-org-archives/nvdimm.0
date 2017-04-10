Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6588921A04802
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 14:13:56 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id r203so162851085oib.3
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 14:13:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CS1PR84MB029453C33D46D4049E1B0F0982010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
References: <149161025237.38725.13508986873214668503.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CS1PR84MB029453C33D46D4049E1B0F0982010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Apr 2017 14:13:55 -0700
Message-ID: <CAPcyv4hJcj-iJpRd2hvTCmCwyMjWgqpiEjGv1migquZ4PQH_8w@mail.gmail.com>
Subject: Re: [PATCH v2] x86,
 pmem: fix broken __copy_user_nocache cache-bypass assumptions
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 10, 2017 at 11:53 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> Subject: [PATCH v2] x86, pmem: fix broken __copy_user_nocache cache-
>> bypass assumptions
>>
>> Before we rework the "pmem api" to stop abusing __copy_user_nocache()
>> for memcpy_to_pmem() we need to fix cases where we may strand dirty data
>> in the cpu cache. The problem occurs when copy_from_iter_pmem() is used
>> for arbitrary data transfers from userspace. There is no guarantee that
>> these transfers, performed by dax_iomap_actor(), will have aligned
>> destinations or aligned transfer lengths. Backstop the usage
>> __copy_user_nocache() with explicit cache management in these unaligned
>> cases.
>>
>> Yes, copy_from_iter_pmem() is now too big for an inline, but addressing
>> that is saved for a later patch that moves the entirety of the "pmem
>> api" into the pmem driver directly.
>  :
>> ---
>> v2: Change the condition for flushing the last cacheline of the
>>     destination from 8-byte to 4-byte misalignment (Toshi)
>  :
>>  arch/x86/include/asm/pmem.h |   41 ++++++++++++++++++++++++++++++----
>  :
>> @@ -94,7 +86,34 @@ static inline size_t arch_copy_from_iter_pmem(void
>> *addr, size_t bytes,
>>  /* TODO: skip the write-back by always using non-temporal stores */
>>  len = copy_from_iter_nocache(addr, bytes, i);
>>
>> -if (__iter_needs_pmem_wb(i))
>> +/*
>> + * In the iovec case on x86_64 copy_from_iter_nocache() uses
>> + * non-temporal stores for the bulk of the transfer, but we need
>> + * to manually flush if the transfer is unaligned. In the
>> + * non-iovec case the entire destination needs to be flushed.
>> + */
>> +if (iter_is_iovec(i)) {
>> +unsigned long dest = (unsigned long) addr;
>> +
>> +/*
>> + * If the destination is not 8-byte aligned then
>> + * __copy_user_nocache (on x86_64) uses cached copies
>> + */
>> +if (dest & 8) {
>> +arch_wb_cache_pmem(addr, 1);
>> +dest = ALIGN(dest, 8);
>> +}
>> +
>> +/*
>> + * If the remaining transfer length, after accounting
>> + * for destination alignment, is not 4-byte aligned
>> + * then __copy_user_nocache() falls back to cached
>> + * copies for the trailing bytes in the final cacheline
>> + * of the transfer.
>> + */
>> +if ((bytes - (dest - (unsigned long) addr)) & 4)
>> +arch_wb_cache_pmem(addr + bytes - 1, 1);
>> +} else
>>  arch_wb_cache_pmem(addr, bytes);
>>
>>  return len;
>
> Thanks for the update.  I think the alignment check should be based on
> the following note in copy_user_nocache.
>
>  * Note: Cached memory copy is used when destination or size is not
>  * naturally aligned. That is:
>  *  - Require 8-byte alignment when size is 8 bytes or larger.
>  *  - Require 4-byte alignment when size is 4 bytes.
>
> So, I think the code may be something like this.  I also made the following changes:

Thanks!

>  - Mask with 7, not 8.

Yes, good catch.

>  - ALIGN with cacheline size, instead of 8.
>  - Add (bytes > flushed) test since calculation with unsigned long still results in a negative
>    value (as a positive value).
>
>         if (bytes < 8) {
>                 if ((dest & 3) || (bytes != 4))
>                         arch_wb_cache_pmem(addr, 1);
>         } else {
>                 if (dest & 7) {
>                         dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);

Why align the destination to the next cacheline? As far as I can see
the ALIGN_DESTINATION macro in arch/x86/include/asm/asm.h only aligns
to the next 8-byte boundary.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
