Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x241.google.com (mail-wm0-x241.google.com
 [IPv6:2a00:1450:400c:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70684223CDC16
 for <linux-nvdimm@lists.01.org>; Sun, 11 Mar 2018 04:53:58 -0700 (PDT)
Received: by mail-wm0-x241.google.com with SMTP id s206so9440130wme.0
 for <linux-nvdimm@lists.01.org>; Sun, 11 Mar 2018 05:00:17 -0700 (PDT)
Subject: Re: [RFC v2 05/83] Add NOVA filesystem definitions and useful helper
 routines.
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-6-git-send-email-jix024@eng.ucsd.edu>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0924a2b3-6f21-4aaf-224d-2f5accc21d10@gmail.com>
Date: Sun, 11 Mar 2018 14:00:13 +0200
MIME-Version: 1.0
In-Reply-To: <1520705944-6723-6-git-send-email-jix024@eng.ucsd.edu>
Content-Language: en-US
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
To: Andiry Xu <jix024@eng.ucsd.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, herbert@gondor.apana.org.au, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

[Adding Herbert Xu to CC since he is the maintainer of the crypto subsys
maintainer]

On 10.03.2018 20:17, Andiry Xu wrote:
<snip>

> +static inline u32 nova_crc32c(u32 crc, const u8 *data, size_t len)
> +{
> +	u8 *ptr = (u8 *) data;
> +	u64 acc = crc; /* accumulator, crc32c value in lower 32b */
> +	u32 csum;
> +
> +	/* x86 instruction crc32 is part of SSE-4.2 */
> +	if (static_cpu_has(X86_FEATURE_XMM4_2)) {
> +		/* This inline assembly implementation should be equivalent
> +		 * to the kernel's crc32c_intel_le_hw() function used by
> +		 * crc32c(), but this performs better on test machines.
> +		 */
> +		while (len > 8) {
> +			asm volatile(/* 64b quad words */
> +				"crc32q (%1), %0"
> +				: "=r" (acc)
> +				: "r"  (ptr), "0" (acc)
> +			);
> +			ptr += 8;
> +			len -= 8;
> +		}
> +
> +		while (len > 0) {
> +			asm volatile(/* trailing bytes */
> +				"crc32b (%1), %0"
> +				: "=r" (acc)
> +				: "r"  (ptr), "0" (acc)
> +			);
> +			ptr++;
> +			len--;
> +		}
> +
> +		csum = (u32) acc;
> +	} else {
> +		/* The kernel's crc32c() function should also detect and use the
> +		 * crc32 instruction of SSE-4.2. But calling in to this function
> +		 * is about 3x to 5x slower than the inline assembly version on
> +		 * some test machines.

That is really odd. Did you try to characterize why this is the case? Is
it purely the overhead of dispatching to the correct backend function?
That's a rather big performance hit.

> +		 */
> +		csum = crc32c(crc, data, len);
> +	}
> +
> +	return csum;
> +}
> +

<snip>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
