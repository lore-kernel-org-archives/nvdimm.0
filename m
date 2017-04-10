Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 025202194235A
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 14:35:38 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id f22so33603922oib.2
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 14:35:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CS1PR84MB029468AEA8FE98ED315B51DB82010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
References: <149161025237.38725.13508986873214668503.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CS1PR84MB029453C33D46D4049E1B0F0982010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4hJcj-iJpRd2hvTCmCwyMjWgqpiEjGv1migquZ4PQH_8w@mail.gmail.com>
 <CS1PR84MB029468AEA8FE98ED315B51DB82010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Apr 2017 14:35:36 -0700
Message-ID: <CAPcyv4gO0NWRLs0_A7L+2pX+v0ohoYRSgvtw_VXmBesgOnQyUw@mail.gmail.com>
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

On Mon, Apr 10, 2017 at 2:28 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> > Thanks for the update.  I think the alignment check should be based on
>> > the following note in copy_user_nocache.
>> >
>> >  * Note: Cached memory copy is used when destination or size is not
>> >  * naturally aligned. That is:
>> >  *  - Require 8-byte alignment when size is 8 bytes or larger.
>> >  *  - Require 4-byte alignment when size is 4 bytes.
>> >
>> > So, I think the code may be something like this.  I also made the following
>> changes:
>>
>> Thanks!
>>
>> >  - Mask with 7, not 8.
>>
>> Yes, good catch.
>>
>> >  - ALIGN with cacheline size, instead of 8.
>> >  - Add (bytes > flushed) test since calculation with unsigned long still results
>> in a negative
>> >    value (as a positive value).
>> >
>> >         if (bytes < 8) {
>> >                 if ((dest & 3) || (bytes != 4))
>> >                         arch_wb_cache_pmem(addr, 1);
>> >         } else {
>> >                 if (dest & 7) {
>> >                         dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
>>
>> Why align the destination to the next cacheline? As far as I can see
>> the ALIGN_DESTINATION macro in arch/x86/include/asm/asm.h only aligns
>> to the next 8-byte boundary.
>
> The clflush here flushes for the cacheline size.  So, we do not need to flush
> the same cacheline again when the unaligned tail is in the same line.

Ok, makes sense. Last question, can't we reduce the check to be:

        if ((bytes > flushed) && ((bytes - flushed) & 3))

...since if 'bytes' was 4-byte aligned we would have performed
non-temporal stores.

Can I add your Signed-off-by: on v3?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
