From: "Boylston, Brian" <brian.boylston-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH v2 1/3] introduce memcpy_nocache()
Date: Fri, 28 Oct 2016 01:52:47 +0000
Message-ID: <CS1PR84MB01198F4F6DCE8D35E85394208EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com>
 <alpine.DEB.2.20.1610262110220.5013@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1610262110220.5013@nanos>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Moreno,
 Oliver" <oliver.moreno-ZPxbGqLxI0U@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "boylston-393akWIupGAXhy9q4Lf3Ug@public.gmane.org" <boylston-393akWIupGAXhy9q4Lf3Ug@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Thomas Gleixner wrote on 2016-10-26:
> On Wed, 26 Oct 2016, Brian Boylston wrote:
>> --- a/arch/x86/include/asm/string_32.h
>> +++ b/arch/x86/include/asm/string_32.h
>> @@ -196,6 +196,9 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
> 
>> +#define __HAVE_ARCH_MEMCPY_NOCACHE
>> +extern void *memcpy_nocache(void *dest, const void *src, size_t count);
> 
> Can we please move that prototype to linux/string.h instead of having it in
> both files and just define __HAVE_ARCH_MEMCPY_NOCACHE? And that define can
> move into x86/include/asm/string.h. There is no point in duplicating all
> that stuff.

Yes, sounds good.

> 
>> --- a/arch/x86/include/asm/string_64.h
>> +++ b/arch/x86/include/asm/string_64.h
>> @@ -51,6 +51,9 @@ extern void *__memcpy(void *to, const void *from, size_t len);
> 
>> +#define __HAVE_ARCH_MEMCPY_NOCACHE
>> +extern void *memcpy_nocache(void *dest, const void *src, size_t count)
> 
>> +#ifdef __HAVE_ARCH_MEMCPY_NOCACHE
> 
> You define __HAVE_ARCH_MEMCPY_NOCACHE for both 32 and 64 bit. What is
> this #ifdef for ?

Now that you raise the question, I'm not sure, and I see that the
x86 memcpy() definition isn't similarly wrapped.  I can adjust it.

> 
>> +void *memcpy_nocache(void *dest, const void *src, size_t count)
>> +{
>> +	__copy_from_user_inatomic_nocache(dest, src, count);
> 
> You want to replace a memcpy with this and then use copy from user. Why?
> That does not make any sense to me and even if it makes sense for whatever
> reason then this wants to be documented and the src argument needs a type
> cast to (void __user *)..

I agree that the documentation needs improvement.  The goal is to memcpy
while avoiding the processor cache.  Following x86's arch_memcpy_to_pmem(),
I was thinking that the user nocache implementation on x86 would work,
but I have none of the comments that arch_memcpy_to_pmem() has...

> 
> Further this uses the inatomic variant. Why? Does a memcpy replacement
> suddenly require to be called in atomic context? Again, this makes no sense
> and lacks any form of comment. The kernel doc below does not say anything
> about that.

I borrowed the use of the inatomic variant from arch_memcpy_to_pmem().

Perhaps I need to look at memcpy_to_pmem() as suggested by Boaz.

> 
> Neither provides the changelog any useful information which is
> complementary to what the patch actually does.
> 
>> +#ifndef __HAVE_ARCH_MEMCPY_NOCACHE
>> +/**
>> + * memcpy_nocache - Copy one area of memory to another, avoiding the
>> + * processor cache if possible
> 
> I'm not sure whether kerneldoc is happy about that line break. Did you
> build the docs?
> 
> Make the initial line shorter and explain the functionality in detail
> below the arguments
> 
>> + * @dest: Where to copy to
>> + * @src: Where to copy from
>> + * @count: The size of the area.
> 
> Nit. Can you please make this in tabular form for readability sake?

No, I did not try to build the docs.  I'll revisit this and your other
doc-related feedback.

Thanks!
Brian

> 
>  * @dest:	Where to copy to
>  * @src:	Where to copy from
>  * @count:	The size of the area.
>> + */
>> +static inline void *memcpy_nocache(void *dest, const void *src, size_t count)
>> +{
>> +	return memcpy(dest, src, count);
>> +}
>> +#endif
> 
> Thanks,
> 
> 	tglx
