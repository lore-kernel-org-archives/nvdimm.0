Return-Path: <SRS0=8S6p=A4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8592EC433E2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 09:17:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AECC2070E
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 09:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1GK9EL0M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AECC2070E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3CEC811F7AAC1;
	Fri, 17 Jul 2020 02:17:33 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7B9D311F54B1B
	for <linux-nvdimm@lists.01.org>; Fri, 17 Jul 2020 02:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pcQ0H1o6p26C2vKLZMF/SJZnMQU+q3kwcSeFrBwvG4U=; b=1GK9EL0Mygx6wkzcHli7MajxZJ
	9bdhJlSKGlg4PMmK23HdyR74DFHwv0hwspiU36sq/NpoEbxvPgpHX+8UyWNxtplg/0VsSXxHCiPB3
	vFRbTtyHpuDavKAh5w7zgL1ghadeqPivAdZCXA0naaJhiCuhyiecFBb+pzLL7zWi9zOvxepXMvaQN
	ntvXivnC5cIE5QyoWA0OpNwPZQrVkbCA07py36E1hxi0uGtUkzP/EmssVu2Q7jz/ZEso4gZGV7W+F
	m5QxMYoo9/iJWWSIgBtc57v9llapUacsJoD8uETqbubjS8m9fifXpugMechsC7FZGC8PNVM2D9NmB
	Pjg04+Jw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jwMUc-0002bP-4T; Fri, 17 Jul 2020 09:17:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 163AB3003D8;
	Fri, 17 Jul 2020 11:17:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0035129CF6F50; Fri, 17 Jul 2020 11:17:18 +0200 (CEST)
Date: Fri, 17 Jul 2020 11:17:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: ira.weiny@intel.com
Subject: Re: [PATCH RFC V2 12/17] memremap: Add zone device access protection
Message-ID: <20200717091718.GA10769@hirez.programming.kicks-ass.net>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-13-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717072056.73134-13-ira.weiny@intel.com>
Message-ID-Hash: CZ27EWO5QT2KNHYMINLIK6DM2IQJQ3KW
X-Message-ID-Hash: CZ27EWO5QT2KNHYMINLIK6DM2IQJQ3KW
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CZ27EWO5QT2KNHYMINLIK6DM2IQJQ3KW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 17, 2020 at 12:20:51AM -0700, ira.weiny@intel.com wrote:
> +void dev_access_disable(void)
> +{
> +	unsigned long flags;
> +
> +	if (!static_branch_unlikely(&dev_protection_static_key))
> +		return;
> +
> +	local_irq_save(flags);
> +	current->dev_page_access_ref--;
> +	if (current->dev_page_access_ref == 0)

	if (!--current->dev_page_access_ref)

> +		pks_update_protection(dev_page_pkey, PKEY_DISABLE_ACCESS);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(dev_access_disable);
> +
> +void dev_access_enable(void)
> +{
> +	unsigned long flags;
> +
> +	if (!static_branch_unlikely(&dev_protection_static_key))
> +		return;
> +
> +	local_irq_save(flags);
> +	/* 0 clears the PKEY_DISABLE_ACCESS bit, allowing access */
> +	if (current->dev_page_access_ref == 0)
> +		pks_update_protection(dev_page_pkey, 0);
> +	current->dev_page_access_ref++;

	if (!current->dev_page_access_ref++)

> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(dev_access_enable);


Also, you probably want something like:

static __always_inline devm_access_disable(void)
{
	if (static_branch_unlikely(&dev_protection_static_key))
		__devm_access_disable();
}

static __always_inline devm_access_enable(void)
{
	if (static_branch_unlikely(&dev_protection_static_key))
		__devm_access_enable();
}
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
