Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x244.google.com (mail-it0-x244.google.com
 [IPv6:2607:f8b0:4001:c0b::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1797E20956069
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 12:33:28 -0700 (PDT)
Received: by mail-it0-x244.google.com with SMTP id 19-v6so7498044itw.3
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 12:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180311192256.GA630@zzz.localdomain>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-6-git-send-email-jix024@eng.ucsd.edu>
 <0924a2b3-6f21-4aaf-224d-2f5accc21d10@gmail.com>
 <20180311192256.GA630@zzz.localdomain>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Mon, 19 Mar 2018 12:39:55 -0700
Message-ID: <CAD4Szjsc3kwysGNTEBtOB-F8ZtnmOsmsUm+o6cDZYbvHZkoEsg@mail.gmail.com>
Subject: Re: [RFC v2 05/83] Add NOVA filesystem definitions and useful helper
 routines.
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
To: Eric Biggers <ebiggers3@gmail.com>
Cc: coughlan@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nikolay Borisov <n.borisov.lkml@gmail.com>, Jan Kara <jack@suse.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Steven Swanson <swanson@cs.ucsd.edu>, swhiteho@redhat.com, Jian Xu <andiry.xu@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 11, 2018 at 12:22 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Sun, Mar 11, 2018 at 02:00:13PM +0200, Nikolay Borisov wrote:
>> [Adding Herbert Xu to CC since he is the maintainer of the crypto subsys
>> maintainer]
>>
>> On 10.03.2018 20:17, Andiry Xu wrote:
>> <snip>
>>
>> > +static inline u32 nova_crc32c(u32 crc, const u8 *data, size_t len)
>> > +{
>> > +   u8 *ptr = (u8 *) data;
>> > +   u64 acc = crc; /* accumulator, crc32c value in lower 32b */
>> > +   u32 csum;
>> > +
>> > +   /* x86 instruction crc32 is part of SSE-4.2 */
>> > +   if (static_cpu_has(X86_FEATURE_XMM4_2)) {
>> > +           /* This inline assembly implementation should be equivalent
>> > +            * to the kernel's crc32c_intel_le_hw() function used by
>> > +            * crc32c(), but this performs better on test machines.
>> > +            */
>> > +           while (len > 8) {
>> > +                   asm volatile(/* 64b quad words */
>> > +                           "crc32q (%1), %0"
>> > +                           : "=r" (acc)
>> > +                           : "r"  (ptr), "0" (acc)
>> > +                   );
>> > +                   ptr += 8;
>> > +                   len -= 8;
>> > +           }
>> > +
>> > +           while (len > 0) {
>> > +                   asm volatile(/* trailing bytes */
>> > +                           "crc32b (%1), %0"
>> > +                           : "=r" (acc)
>> > +                           : "r"  (ptr), "0" (acc)
>> > +                   );
>> > +                   ptr++;
>> > +                   len--;
>> > +           }
>> > +
>> > +           csum = (u32) acc;
>> > +   } else {
>> > +           /* The kernel's crc32c() function should also detect and use the
>> > +            * crc32 instruction of SSE-4.2. But calling in to this function
>> > +            * is about 3x to 5x slower than the inline assembly version on
>> > +            * some test machines.
>>
>> That is really odd. Did you try to characterize why this is the case? Is
>> it purely the overhead of dispatching to the correct backend function?
>> That's a rather big performance hit.
>>
>> > +            */
>> > +           csum = crc32c(crc, data, len);
>> > +   }
>> > +
>> > +   return csum;
>> > +}
>> > +
>
> Are you sure that CONFIG_CRYPTO_CRC32C_INTEL was enabled during your tests and
> that the accelerated version was being called?  Or, perhaps CRC32C_PCL_BREAKEVEN
> (defined in arch/x86/crypto/crc32c-intel_glue.c) needs to be adjusted.  Please
> don't hack around performance problems like this; if they exist, they need to be
> fixed for everyone.
>

I have performed the crc32c test on a Xeon X5647 at 2.93GHz, 14G DDR3
memory at 1066MHz platform.
You are right that enabling CONFIG_CRYPTO_CRC32C_INTEL improves the
performance significantly. nova_crc32c() is still slightly faster than
crc32c() with the flag enabled.

Result numbers are follows: data size in bytes, latency in ns, column
3 is crc32c() with  CONFIG_CRYPTO_CRC32C_INTEL enabled and column 4
disabled.

data size (bytes)        nova_crc32c()        crc32c() -enabled
crc32c() -disabled
64                              19                           21
                        56
128                            28                           29
                       99
256                            46                           43
                       182
512                            82                           149
                      354
1024                          157                         232
                    728
2048                          305                         415
                    1440
4096                          603                         725
                    2869

Thanks,
Andiry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
