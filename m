Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0700.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::700])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B01711A1E28
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 18:54:25 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH v2 1/3] introduce memcpy_nocache()
Date: Fri, 28 Oct 2016 01:54:24 +0000
Message-ID: <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
In-Reply-To: <58110959.90901@plexistor.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Boaz Harrosh <boaz@plexistor.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Moreno, Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

Boaz Harrosh wrote on 2016-10-26:
> On 10/26/2016 06:50 PM, Brian Boylston wrote:
>> Introduce memcpy_nocache() as a memcpy() that avoids the processor cache
>> if possible.  Without arch-specific support, this defaults to just
>> memcpy().  For now, include arch-specific support for x86.
>> 
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: <x86@kernel.org>
>> Cc: Al Viro <viro@ZenIV.linux.org.uk>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
>> Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
>> Reported-by: Oliver Moreno <oliver.moreno@hpe.com>
>> ---
>>  arch/x86/include/asm/string_32.h |  3 +++
>>  arch/x86/include/asm/string_64.h |  3 +++
>>  arch/x86/lib/misc.c              | 12 ++++++++++++
>>  include/linux/string.h           | 15 +++++++++++++++
>>  4 files changed, 33 insertions(+)
>> diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
>> index 3d3e835..64f80c0 100644
>> --- a/arch/x86/include/asm/string_32.h
>> +++ b/arch/x86/include/asm/string_32.h
>> @@ -196,6 +196,9 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
>> 
>>  #endif
>> +#define __HAVE_ARCH_MEMCPY_NOCACHE
>> +extern void *memcpy_nocache(void *dest, const void *src, size_t count);
>> +
>>  #define __HAVE_ARCH_MEMMOVE
>>  void *memmove(void *dest, const void *src, size_t n);
>> diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
>> index 90dbbd9..a8fdd55 100644
>> --- a/arch/x86/include/asm/string_64.h
>> +++ b/arch/x86/include/asm/string_64.h
>> @@ -51,6 +51,9 @@ extern void *__memcpy(void *to, const void *from, size_t len);
>>  #define memcpy(dst, src, len) __inline_memcpy((dst), (src), (len))
>>  #endif
>> +#define __HAVE_ARCH_MEMCPY_NOCACHE
>> +extern void *memcpy_nocache(void *dest, const void *src, size_t count);
>> +
>>  #define __HAVE_ARCH_MEMSET
>>  void *memset(void *s, int c, size_t n);
>>  void *__memset(void *s, int c, size_t n);
>> diff --git a/arch/x86/lib/misc.c b/arch/x86/lib/misc.c
>> index 76b373a..c993ab3 100644
>> --- a/arch/x86/lib/misc.c
>> +++ b/arch/x86/lib/misc.c
>> @@ -1,3 +1,6 @@
>> +#include <linux/export.h>
>> +#include <linux/uaccess.h>
>> +
>>  /*
>>   * Count the digits of @val including a possible sign.
>>   *
>> @@ -19,3 +22,12 @@ int num_digits(int val)
>>  	}
>>  	return d;
>>  }
>> +
>> +#ifdef __HAVE_ARCH_MEMCPY_NOCACHE
>> +void *memcpy_nocache(void *dest, const void *src, size_t count)
>> +{
>> +	__copy_from_user_inatomic_nocache(dest, src, count);
>> +	return dest;
>> +}
>> +EXPORT_SYMBOL(memcpy_nocache);
>> +#endif
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index 26b6f6a..7f40c41 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -102,6 +102,21 @@ extern void * memset(void *,int,__kernel_size_t);
>>  #ifndef __HAVE_ARCH_MEMCPY
>>  extern void * memcpy(void *,const void *,__kernel_size_t);
>>  #endif
>> +
>> +#ifndef __HAVE_ARCH_MEMCPY_NOCACHE
>> +/**
>> + * memcpy_nocache - Copy one area of memory to another, avoiding the
>> + * processor cache if possible
>> + * @dest: Where to copy to
>> + * @src: Where to copy from
>> + * @count: The size of the area.
>> + */
>> +static inline void *memcpy_nocache(void *dest, const void *src, size_t count)
>> +{
>> +	return memcpy(dest, src, count);
>> +}
> 
> What about memcpy_to_pmem() in linux/pmem.h it already has all the arch switches.
> 
> Feels bad to add yet just another arch switch over __copy_user_nocache
> 
> Just feels like too many things that do the same thing. Sigh

I agree that this looks like a nicer path.

I had considered adjusting copy_from_iter_nocache() to use memcpy_to_pmem(),
but lib/iov_iter.c doesn't currently #include linux/pmem.h.  Would it be
acceptable to add it?  Also, I wasn't sure if memcpy_to_pmem() would always
mean exactly "memcpy nocache".

I had also considered adjusting copy_from_iter_pmem() (also in linux/pmem.h)
to just use memcpy_to_pmem() directly, but then it can't use the goodness
that is the iterate_and_advance() macro in iov_iter.c.

So, I took a shot with a possibly ill-fated memcpy_nocache().  Thoughts on
either of the above two?  Are these even in line with what you were thinking?

Thanks!
Brian

> 
> Boaz
> 
>> +#endif
>> +
>>  #ifndef __HAVE_ARCH_MEMMOVE
>>  extern void * memmove(void *,const void *,__kernel_size_t);
>>  #endif
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
