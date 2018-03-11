Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B327422135D4F
 for <linux-nvdimm@lists.01.org>; Sun, 11 Mar 2018 12:16:40 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id x1so3428252pfh.7
 for <linux-nvdimm@lists.01.org>; Sun, 11 Mar 2018 12:23:00 -0700 (PDT)
Date: Sun, 11 Mar 2018 12:22:56 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC v2 05/83] Add NOVA filesystem definitions and useful helper
 routines.
Message-ID: <20180311192256.GA630@zzz.localdomain>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-6-git-send-email-jix024@eng.ucsd.edu>
 <0924a2b3-6f21-4aaf-224d-2f5accc21d10@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0924a2b3-6f21-4aaf-224d-2f5accc21d10@gmail.com>
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
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: coughlan@redhat.com, Andiry Xu <jix024@eng.ucsd.edu>, linux-nvdimm@lists.01.org, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, david@fromorbit.com, linux-kernel@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com, herbert@gondor.apana.org.au
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 11, 2018 at 02:00:13PM +0200, Nikolay Borisov wrote:
> [Adding Herbert Xu to CC since he is the maintainer of the crypto subsys
> maintainer]
> 
> On 10.03.2018 20:17, Andiry Xu wrote:
> <snip>
> 
> > +static inline u32 nova_crc32c(u32 crc, const u8 *data, size_t len)
> > +{
> > +	u8 *ptr = (u8 *) data;
> > +	u64 acc = crc; /* accumulator, crc32c value in lower 32b */
> > +	u32 csum;
> > +
> > +	/* x86 instruction crc32 is part of SSE-4.2 */
> > +	if (static_cpu_has(X86_FEATURE_XMM4_2)) {
> > +		/* This inline assembly implementation should be equivalent
> > +		 * to the kernel's crc32c_intel_le_hw() function used by
> > +		 * crc32c(), but this performs better on test machines.
> > +		 */
> > +		while (len > 8) {
> > +			asm volatile(/* 64b quad words */
> > +				"crc32q (%1), %0"
> > +				: "=r" (acc)
> > +				: "r"  (ptr), "0" (acc)
> > +			);
> > +			ptr += 8;
> > +			len -= 8;
> > +		}
> > +
> > +		while (len > 0) {
> > +			asm volatile(/* trailing bytes */
> > +				"crc32b (%1), %0"
> > +				: "=r" (acc)
> > +				: "r"  (ptr), "0" (acc)
> > +			);
> > +			ptr++;
> > +			len--;
> > +		}
> > +
> > +		csum = (u32) acc;
> > +	} else {
> > +		/* The kernel's crc32c() function should also detect and use the
> > +		 * crc32 instruction of SSE-4.2. But calling in to this function
> > +		 * is about 3x to 5x slower than the inline assembly version on
> > +		 * some test machines.
> 
> That is really odd. Did you try to characterize why this is the case? Is
> it purely the overhead of dispatching to the correct backend function?
> That's a rather big performance hit.
> 
> > +		 */
> > +		csum = crc32c(crc, data, len);
> > +	}
> > +
> > +	return csum;
> > +}
> > +

Are you sure that CONFIG_CRYPTO_CRC32C_INTEL was enabled during your tests and
that the accelerated version was being called?  Or, perhaps CRC32C_PCL_BREAKEVEN
(defined in arch/x86/crypto/crc32c-intel_glue.c) needs to be adjusted.  Please
don't hack around performance problems like this; if they exist, they need to be
fixed for everyone.

Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
