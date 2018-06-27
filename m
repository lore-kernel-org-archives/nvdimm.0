Return-Path: <pmem+bncBDENZKVKQYIBBL7HZXMQKGQE2XM2OJA@googlegroups.com>
Sender: pmem@googlegroups.com
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Wed, 27 Jun 2018 14:23:06 +0300
Message-ID: <CACTTzNbu5FNXiyDeSBgTZCE7x=aNKQWvMLnhy5rkE51JJV9Rzg@mail.gmail.com>
Subject: Re: [PATCH] x86: optimize memcpy_flushcache
Content-Type: text/plain; charset="UTF-8"
List-Post: <https://groups.google.com/group/pmem/post>, <mailto:pmem@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:pmem+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/pmem
List-Subscribe: <https://groups.google.com/group/pmem/subscribe>, <mailto:pmem+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+41775949424+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/pmem/subscribe>
To: Dan Williams <dan.j.williams@intel.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Ingo Molnar <mingo@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, pmem <pmem@googlegroups.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi,
I'm a bit late on this but I have a question about the original patch -
I thought that in order for movnt (movntil, movntiq) to push the data
into the persistency domain (ADR),
one must work with length that is multiple of cacheline size,
otherwise the write-combine buffers remain partially
filled and you need to commit them with a fence (sfence) - which ruins
the whole performance gain you got here.
Am I wrong, are the write-combine buffers are part of the ADR domain
or something?

Thanks,
Yigal

On Mon, Jun 18, 2018 at 7:38 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Jun 18, 2018 at 5:50 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> Hi Mike
>>
>> Could you please push this patch to the kernel 4.18-rc? Dan Williams said
>> that he will submit it, but he forgot about it.
>
> ...to be clear I acked it and asked Ingo to take it. Will need a
> resubmit for 4.19.
>
> Ingo, see below for a patch to pick up into -tip when you have a chance.
>
>>
>> Without this patch, dm-writecache is suffering 2% penalty because of
>> memcpy_flushcache overhead.
>>
>> Mikulas
>>
>>
>>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> I use memcpy_flushcache in my persistent memory driver for metadata
>> updates and it turns out that the overhead of memcpy_flushcache causes 2%
>> performance degradation compared to "movnti" instruction explicitly coded
>> using inline assembler.
>>
>> This patch recognizes memcpy_flushcache calls with constant short length
>> and turns them into inline assembler - so that I don't have to use inline
>> assembler in the driver.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> ---
>>  arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
>>  arch/x86/lib/usercopy_64.c       |    4 ++--
>>  2 files changed, 21 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/string_64.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/string_64.h
>> +++ linux-2.6/arch/x86/include/asm/string_64.h
>> @@ -149,7 +149,25 @@ memcpy_mcsafe(void *dst, const void *src
>>
>>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>>  #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
>> -void memcpy_flushcache(void *dst, const void *src, size_t cnt);
>> +void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
>> +static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
>> +{
>> +       if (__builtin_constant_p(cnt)) {
>> +               switch (cnt) {
>> +                       case 4:
>> +                               asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
>> +                               return;
>> +                       case 8:
>> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
>> +                               return;
>> +                       case 16:
>> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
>> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
>> +                               return;
>> +               }
>> +       }
>> +       __memcpy_flushcache(dst, src, cnt);
>> +}
>>  #endif
>>
>>  #endif /* __KERNEL__ */
>> Index: linux-2.6/arch/x86/lib/usercopy_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c
>> +++ linux-2.6/arch/x86/lib/usercopy_64.c
>> @@ -153,7 +153,7 @@ long __copy_user_flushcache(void *dst, c
>>         return rc;
>>  }
>>
>> -void memcpy_flushcache(void *_dst, const void *_src, size_t size)
>> +void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
>>  {
>>         unsigned long dest = (unsigned long) _dst;
>>         unsigned long source = (unsigned long) _src;
>> @@ -216,7 +216,7 @@ void memcpy_flushcache(void *_dst, const
>>                 clean_cache_range((void *) dest, size);
>>         }
>>  }
>> -EXPORT_SYMBOL_GPL(memcpy_flushcache);
>> +EXPORT_SYMBOL_GPL(__memcpy_flushcache);
>>
>>  void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
>>                 size_t len)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

-- 
You received this message because you are subscribed to the Google Groups "pmem" group.
To unsubscribe from this group and stop receiving emails from it, send an email to pmem+unsubscribe@googlegroups.com.
To post to this group, send email to pmem@googlegroups.com.
To view this discussion on the web visit https://groups.google.com/d/msgid/pmem/CACTTzNbu5FNXiyDeSBgTZCE7x%3DaNKQWvMLnhy5rkE51JJV9Rzg%40mail.gmail.com.
For more options, visit https://groups.google.com/d/optout.
