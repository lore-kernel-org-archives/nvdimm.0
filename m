Return-Path: <SRS0=8S6p=A4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738F2C433E2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 08:55:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61C4A20829
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 08:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XTp6bn8F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61C4A20829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 41B3D11F54B01;
	Fri, 17 Jul 2020 01:54:59 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8141E11EDD974
	for <linux-nvdimm@lists.01.org>; Fri, 17 Jul 2020 01:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aEr7cpiEkCxbEVwXSRfLp3Ytk5hTAgwAHhMYmtgWkp8=; b=XTp6bn8FEKwlnyQgkHyasqtfQs
	fFYXMAUIiMSk8ZvOhG343GjKyPZe9SzrBqo4dgVstwgjT/qqnBnojwBCg02q+0+oaf4CtVI9jrQ03
	ONB24bL/N5z3WjOc/fHRXLiv5pluGJgrS96d7OVkA8awqCpQdsFU7l6f1TDqUW+wjR9oMMFFmdtJn
	VzUhKVeV4zqZEVhYbJxkhKgUC4lOzWSbPL46WpppaNrJaSpNv9qbChKd0nKPB+YDqPSa0c4DPcASR
	deR1T0ijZzeJx31cEvj91bKq7KSnx5u0W411DK6OS3PyVW3svSma5utxYBHXipY7w2w6E5oKjTaT5
	O7+5x+pg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jwM8j-0002lD-9h; Fri, 17 Jul 2020 08:54:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 79D35304D58;
	Fri, 17 Jul 2020 10:54:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5001929CF6F79; Fri, 17 Jul 2020 10:54:42 +0200 (CEST)
Date: Fri, 17 Jul 2020 10:54:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: ira.weiny@intel.com
Subject: Re: [PATCH RFC V2 02/17] x86/fpu: Refactor
 arch_set_user_pkey_access() for PKS support
Message-ID: <20200717085442.GX10769@hirez.programming.kicks-ass.net>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-3-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717072056.73134-3-ira.weiny@intel.com>
Message-ID-Hash: 4LOHEHTWJDA6D27RXWESTVFIT3LJC544
X-Message-ID-Hash: 4LOHEHTWJDA6D27RXWESTVFIT3LJC544
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4LOHEHTWJDA6D27RXWESTVFIT3LJC544/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 17, 2020 at 12:20:41AM -0700, ira.weiny@intel.com wrote:
> +/*
> + * Get a new pkey register value from the user values specified.
> + *
> + * Kernel users use the same flags as user space:
> + *     PKEY_DISABLE_ACCESS
> + *     PKEY_DISABLE_WRITE
> + */
> +u32 get_new_pkr(u32 old_pkr, int pkey, unsigned long init_val)
> +{
> +	int pkey_shift = (pkey * PKR_BITS_PER_PKEY);
> +	u32 new_pkr_bits = 0;
> +
> +	/* Set the bits we need in the register:  */
> +	if (init_val & PKEY_DISABLE_ACCESS)
> +		new_pkr_bits |= PKR_AD_BIT;
> +	if (init_val & PKEY_DISABLE_WRITE)
> +		new_pkr_bits |= PKR_WD_BIT;
> +
> +	/* Shift the bits in to the correct place: */
> +	new_pkr_bits <<= pkey_shift;
> +
> +	/* Mask off any old bits in place: */
> +	old_pkr &= ~((PKR_AD_BIT | PKR_WD_BIT) << pkey_shift);
> +
> +	/* Return the old part along with the new part: */
> +	return old_pkr | new_pkr_bits;
> +}

This is unbelievable junk...

How about something like:

u32 update_pkey_reg(u32 pk_reg, int pkey, unsigned int flags)
{
	int pkey_shift = pkey * PKR_BITS_PER_PKEY;

	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);

	if (flags & PKEY_DISABLE_ACCESS)
		pk_reg |= PKR_AD_BIT << pkey_shift;
	if (flags & PKEY_DISABLE_WRITE)
		pk_reg |= PKR_WD_BIT << pkey_shift;

	return pk_reg;
}

Then we at least have a little clue wtf the thing does.. Yes I started
with a rename and then got annoyed at the implementation too.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
