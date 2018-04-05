Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C3F922526495
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 04:26:43 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id v194-v6so3244808itb.0
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 04:26:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405071500.22320-3-bsingharora@gmail.com>
References: <20180405071500.22320-1-bsingharora@gmail.com>
 <20180405071500.22320-3-bsingharora@gmail.com>
From: Oliver <oohall@gmail.com>
Date: Thu, 5 Apr 2018 21:26:42 +1000
Message-ID: <CAOSf1CFy0im+H368Krr2QVteAumq58CRF_Kfatyv7wvj1n4AGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
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
To: Balbir Singh <bsingharora@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Nicholas Piggin <npiggin@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 5:14 PM, Balbir Singh <bsingharora@gmail.com> wrote:
> The pmem infrastructure uses memcpy_mcsafe in the pmem
> layer so as to convert machine check excpetions into
> a return value on failure in case a machine check
> exception is encoutered during the memcpy.
>
> This patch largely borrows from the copyuser_power7
> logic and does not add the VMX optimizations, largely
> to keep the patch simple. If needed those optimizations
> can be folded in.
>
> Signed-off-by: Balbir Singh <bsingharora@gmail.com>
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/string.h   |   2 +
>  arch/powerpc/lib/Makefile           |   2 +-
>  arch/powerpc/lib/memcpy_mcsafe_64.S | 212 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 215 insertions(+), 1 deletion(-)
>  create mode 100644 arch/powerpc/lib/memcpy_mcsafe_64.S
>
> diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
> index 9b8cedf618f4..b7e872a64726 100644
> --- a/arch/powerpc/include/asm/string.h
> +++ b/arch/powerpc/include/asm/string.h
> @@ -30,7 +30,9 @@ extern void * memcpy_flushcache(void *,const void *,__kernel_size_t);
>  #ifdef CONFIG_PPC64
>  #define __HAVE_ARCH_MEMSET32
>  #define __HAVE_ARCH_MEMSET64
> +#define __HAVE_ARCH_MEMCPY_MCSAFE
>
> +extern int memcpy_mcsafe(void *dst, const void *src, __kernel_size_t sz);
>  extern void *__memset16(uint16_t *, uint16_t v, __kernel_size_t);
>  extern void *__memset32(uint32_t *, uint32_t v, __kernel_size_t);
>  extern void *__memset64(uint64_t *, uint64_t v, __kernel_size_t);
> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> index 3c29c9009bbf..048afee9f518 100644
> --- a/arch/powerpc/lib/Makefile
> +++ b/arch/powerpc/lib/Makefile
> @@ -24,7 +24,7 @@ endif
>
>  obj64-y        += copypage_64.o copyuser_64.o mem_64.o hweight_64.o \
>            copyuser_power7.o string_64.o copypage_power7.o memcpy_power7.o \
> -          memcpy_64.o memcmp_64.o pmem.o
> +          memcpy_64.o memcmp_64.o pmem.o memcpy_mcsafe_64.o
>
>  obj64-$(CONFIG_SMP)    += locks.o
>  obj64-$(CONFIG_ALTIVEC)        += vmx-helper.o
> diff --git a/arch/powerpc/lib/memcpy_mcsafe_64.S b/arch/powerpc/lib/memcpy_mcsafe_64.S
> new file mode 100644
> index 000000000000..e7eaa9b6cded
> --- /dev/null
> +++ b/arch/powerpc/lib/memcpy_mcsafe_64.S
> @@ -0,0 +1,212 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) IBM Corporation, 2011
> + * Derived from copyuser_power7.s by Anton Blanchard <anton@au.ibm.com>
> + * Author - Balbir Singh <bsingharora@gmail.com>
> + */
> +#include <asm/ppc_asm.h>
> +#include <asm/errno.h>
> +
> +       .macro err1
> +100:
> +       EX_TABLE(100b,.Ldo_err1)
> +       .endm
> +
> +       .macro err2
> +200:
> +       EX_TABLE(200b,.Ldo_err2)
> +       .endm

Would it be possible to move the bulk of the copyuser code into a
seperate file which can be #included once the these err macros are
defined? Anton's memcpy is pretty hairy and I don't think anyone wants
to have multiple copies of it in the tree, even in a cut down form.

> +
> +.Ldo_err2:
> +       ld      r22,STK_REG(R22)(r1)
> +       ld      r21,STK_REG(R21)(r1)
> +       ld      r20,STK_REG(R20)(r1)
> +       ld      r19,STK_REG(R19)(r1)
> +       ld      r18,STK_REG(R18)(r1)
> +       ld      r17,STK_REG(R17)(r1)
> +       ld      r16,STK_REG(R16)(r1)
> +       ld      r15,STK_REG(R15)(r1)
> +       ld      r14,STK_REG(R14)(r1)
> +       addi    r1,r1,STACKFRAMESIZE
> +.Ldo_err1:
> +       li      r3,-EFAULT
> +       blr
> +
> +
> +_GLOBAL(memcpy_mcsafe)
> +       cmpldi  r5,16
> +       blt     .Lshort_copy
> +
> +.Lcopy:
> +       /* Get the source 8B aligned */
> +       neg     r6,r4
> +       mtocrf  0x01,r6
> +       clrldi  r6,r6,(64-3)
> +
> +       bf      cr7*4+3,1f
> +err1;  lbz     r0,0(r4)
> +       addi    r4,r4,1
> +err1;  stb     r0,0(r3)
> +       addi    r3,r3,1
> +
> +1:     bf      cr7*4+2,2f
> +err1;  lhz     r0,0(r4)
> +       addi    r4,r4,2
> +err1;  sth     r0,0(r3)
> +       addi    r3,r3,2
> +
> +2:     bf      cr7*4+1,3f
> +err1;  lwz     r0,0(r4)
> +       addi    r4,r4,4
> +err1;  stw     r0,0(r3)
> +       addi    r3,r3,4
> +
> +3:     sub     r5,r5,r6
> +       cmpldi  r5,128
> +       blt     5f
> +
> +       mflr    r0
> +       stdu    r1,-STACKFRAMESIZE(r1)
> +       std     r14,STK_REG(R14)(r1)
> +       std     r15,STK_REG(R15)(r1)
> +       std     r16,STK_REG(R16)(r1)
> +       std     r17,STK_REG(R17)(r1)
> +       std     r18,STK_REG(R18)(r1)
> +       std     r19,STK_REG(R19)(r1)
> +       std     r20,STK_REG(R20)(r1)
> +       std     r21,STK_REG(R21)(r1)
> +       std     r22,STK_REG(R22)(r1)
> +       std     r0,STACKFRAMESIZE+16(r1)
> +
> +       srdi    r6,r5,7
> +       mtctr   r6
> +
> +       /* Now do cacheline (128B) sized loads and stores. */
> +       .align  5
> +4:
> +err2;  ld      r0,0(r4)
> +err2;  ld      r6,8(r4)
> +err2;  ld      r7,16(r4)
> +err2;  ld      r8,24(r4)
> +err2;  ld      r9,32(r4)
> +err2;  ld      r10,40(r4)
> +err2;  ld      r11,48(r4)
> +err2;  ld      r12,56(r4)
> +err2;  ld      r14,64(r4)
> +err2;  ld      r15,72(r4)
> +err2;  ld      r16,80(r4)
> +err2;  ld      r17,88(r4)
> +err2;  ld      r18,96(r4)
> +err2;  ld      r19,104(r4)
> +err2;  ld      r20,112(r4)
> +err2;  ld      r21,120(r4)
> +       addi    r4,r4,128
> +err2;  std     r0,0(r3)
> +err2;  std     r6,8(r3)
> +err2;  std     r7,16(r3)
> +err2;  std     r8,24(r3)
> +err2;  std     r9,32(r3)
> +err2;  std     r10,40(r3)
> +err2;  std     r11,48(r3)
> +err2;  std     r12,56(r3)
> +err2;  std     r14,64(r3)
> +err2;  std     r15,72(r3)
> +err2;  std     r16,80(r3)
> +err2;  std     r17,88(r3)
> +err2;  std     r18,96(r3)
> +err2;  std     r19,104(r3)
> +err2;  std     r20,112(r3)
> +err2;  std     r21,120(r3)
> +       addi    r3,r3,128
> +       bdnz    4b
> +
> +       clrldi  r5,r5,(64-7)
> +
> +       ld      r14,STK_REG(R14)(r1)
> +       ld      r15,STK_REG(R15)(r1)
> +       ld      r16,STK_REG(R16)(r1)
> +       ld      r17,STK_REG(R17)(r1)
> +       ld      r18,STK_REG(R18)(r1)
> +       ld      r19,STK_REG(R19)(r1)
> +       ld      r20,STK_REG(R20)(r1)
> +       ld      r21,STK_REG(R21)(r1)
> +       ld      r22,STK_REG(R22)(r1)
> +       addi    r1,r1,STACKFRAMESIZE
> +
> +       /* Up to 127B to go */
> +5:     srdi    r6,r5,4
> +       mtocrf  0x01,r6
> +
> +6:     bf      cr7*4+1,7f
> +err1;  ld      r0,0(r4)
> +err1;  ld      r6,8(r4)
> +err1;  ld      r7,16(r4)
> +err1;  ld      r8,24(r4)
> +err1;  ld      r9,32(r4)
> +err1;  ld      r10,40(r4)
> +err1;  ld      r11,48(r4)
> +err1;  ld      r12,56(r4)
> +       addi    r4,r4,64
> +err1;  std     r0,0(r3)
> +err1;  std     r6,8(r3)
> +err1;  std     r7,16(r3)
> +err1;  std     r8,24(r3)
> +err1;  std     r9,32(r3)
> +err1;  std     r10,40(r3)
> +err1;  std     r11,48(r3)
> +err1;  std     r12,56(r3)
> +       addi    r3,r3,64
> +
> +       /* Up to 63B to go */
> +7:     bf      cr7*4+2,8f
> +err1;  ld      r0,0(r4)
> +err1;  ld      r6,8(r4)
> +err1;  ld      r7,16(r4)
> +err1;  ld      r8,24(r4)
> +       addi    r4,r4,32
> +err1;  std     r0,0(r3)
> +err1;  std     r6,8(r3)
> +err1;  std     r7,16(r3)
> +err1;  std     r8,24(r3)
> +       addi    r3,r3,32
> +
> +       /* Up to 31B to go */
> +8:     bf      cr7*4+3,9f
> +err1;  ld      r0,0(r4)
> +err1;  ld      r6,8(r4)
> +       addi    r4,r4,16
> +err1;  std     r0,0(r3)
> +err1;  std     r6,8(r3)
> +       addi    r3,r3,16
> +
> +9:     clrldi  r5,r5,(64-4)
> +
> +       /* Up to 15B to go */
> +.Lshort_copy:
> +       mtocrf  0x01,r5
> +       bf      cr7*4+0,12f
> +err1;  lwz     r0,0(r4)        /* Less chance of a reject with word ops */
> +err1;  lwz     r6,4(r4)
> +       addi    r4,r4,8
> +err1;  stw     r0,0(r3)
> +err1;  stw     r6,4(r3)
> +       addi    r3,r3,8
> +
> +12:    bf      cr7*4+1,13f
> +err1;  lwz     r0,0(r4)
> +       addi    r4,r4,4
> +err1;  stw     r0,0(r3)
> +       addi    r3,r3,4
> +
> +13:    bf      cr7*4+2,14f
> +err1;  lhz     r0,0(r4)
> +       addi    r4,r4,2
> +err1;  sth     r0,0(r3)
> +       addi    r3,r3,2
> +
> +14:    bf      cr7*4+3,15f
> +err1;  lbz     r0,0(r4)
> +err1;  stb     r0,0(r3)
> +
> +15:    li      r3,0
> +       blr
> --
> 2.13.6
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
