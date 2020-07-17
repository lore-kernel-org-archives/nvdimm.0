Return-Path: <SRS0=8S6p=A4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42723C433E6
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 09:30:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02B192076A
	for <linux-nvdimm@archiver.kernel.org>; Fri, 17 Jul 2020 09:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hBV4cO6S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02B192076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B5F4C11F7AAE7;
	Fri, 17 Jul 2020 02:30:58 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1231::1; helo=merlin.infradead.org; envelope-from=peterz@infradead.org; receiver=<UNKNOWN> 
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1C3B011F7AAE5
	for <linux-nvdimm@lists.01.org>; Fri, 17 Jul 2020 02:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8JE8Gvv4RB/gs/MAI8dbxdwbA+OZGm7MQq6LvUxR/fo=; b=hBV4cO6S9PgOZBlKCRjzAJL6no
	Rw3QRuDlekzAwQ0JYQs5UINo17RGnHq2jRutA4fH/zxABb1BgsB+fCG80CtP39CHIN8CxAK3aLfje
	Jq2TleBWWjxtrLhGevYeWUNSHyYLsQux8xKQ07MRbf3y0hXK87ujztGJ6Fru6vZHIKqGXKI/GYvQE
	KulTU8LViEwzU7/jwhmNdZ8w+NcNaNvJsPrY9OmksMfz7yVDxHl+GRUoVJNqI6qXeL1QWF4MNCosl
	RF63zB0pzpZ0dBXeCyXrSCuPZYugS/oNE/PbL4hiazMYViBVB5hFMqhlCt45WvfNb/rZX1ToQC1ks
	tEQpBQ5A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jwMhX-0006wo-AQ; Fri, 17 Jul 2020 09:30:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 624C43003D8;
	Fri, 17 Jul 2020 11:30:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4B38729CF6F54; Fri, 17 Jul 2020 11:30:41 +0200 (CEST)
Date: Fri, 17 Jul 2020 11:30:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: ira.weiny@intel.com
Subject: Re: [PATCH RFC V2 17/17] x86/entry: Preserve PKRS MSR across
 exceptions
Message-ID: <20200717093041.GF10769@hirez.programming.kicks-ass.net>
References: <20200717072056.73134-1-ira.weiny@intel.com>
 <20200717072056.73134-18-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717072056.73134-18-ira.weiny@intel.com>
Message-ID-Hash: UY6KSGI46CURWA6GNYMXUZRCZAFON7BH
X-Message-ID-Hash: UY6KSGI46CURWA6GNYMXUZRCZAFON7BH
X-MailFrom: peterz@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UY6KSGI46CURWA6GNYMXUZRCZAFON7BH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 17, 2020 at 12:20:56AM -0700, ira.weiny@intel.com wrote:
> +static void noinstr idt_save_pkrs(idtentry_state_t state)

noinstr goes in the same place you would normally put inline, that's
before the return type, not after it.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
