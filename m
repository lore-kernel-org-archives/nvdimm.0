Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26DA421C8F61F
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:04:54 -0700 (PDT)
Received: by mail-ot0-x22d.google.com with SMTP id u13so44667547otd.2
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:06:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170618084036.GC26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618084036.GC26456@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 18 Jun 2017 19:06:14 -0700
Message-ID: <CAPcyv4gbzpj3mQeb+Y=QG4dVvau6_1U=aW0e+SjwRkaNn=BmWA@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] x86, dax,
 libnvdimm: move wb_cache_pmem() to libnvdimm
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 18, 2017 at 1:40 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +void clean_cache_range(void *addr, size_t size);
>>
>>  static inline int
>>  __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
>> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
>> index f42d2fd86ca3..baa80ff29da8 100644
>> --- a/arch/x86/lib/usercopy_64.c
>> +++ b/arch/x86/lib/usercopy_64.c
>> @@ -85,7 +85,7 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
>>   * instruction. Note that @size is internally rounded up to be cache
>>   * line size aligned.
>>   */
>> -static void clean_cache_range(void *addr, size_t size)
>> +void clean_cache_range(void *addr, size_t size)
>
> Can you keep clean_cache_range private please?  Just add
> arch_wb_cache_pmem to usercopy_64.c just behind it so that the
> compiler can tail-call and export that instead.
>
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -4,6 +4,13 @@
>>  #include <linux/types.h>
>>  #include <linux/pfn_t.h>
>>  #include <linux/fs.h>
>> +#include <asm/pmem.h>
>> +
>> +#ifndef CONFIG_ARCH_HAS_PMEM_API
>> +static inline void arch_wb_cache_pmem(void *addr, size_t size)
>> +{
>> +}
>> +#endif
>
> And our normal Linux style would be to have this linux linux/pmem.h,
> which should always be included for the asm version.

Ok, will do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
