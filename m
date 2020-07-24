Return-Path: <SRS0=QIzv=BD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D048CC433E0
	for <linux-nvdimm@archiver.kernel.org>; Fri, 24 Jul 2020 21:31:39 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93805206F6
	for <linux-nvdimm@archiver.kernel.org>; Fri, 24 Jul 2020 21:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="W6Fe6hfg";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="gvXpoJL9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93805206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7B47F1257E564;
	Fri, 24 Jul 2020 14:31:39 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=193.142.43.55; helo=galois.linutronix.de; envelope-from=tglx@linutronix.de; receiver=<UNKNOWN> 
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id F37601257E561
	for <linux-nvdimm@lists.01.org>; Fri, 24 Jul 2020 14:31:36 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1595626293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4aIj5BJFXygT8U4O1CTI3DzA3eMR9QI7whCGEMz/ttI=;
	b=W6Fe6hfg8SE4RiJMMLflHKp+NIWV0wPCb2wlrzrl1CWSYcA1ZeoGi7rq+Rv/c+87J015Ii
	ymqZRbBlkoC7snn6il30NJ9jrjaCZ2P5M9uWUecoBkwg2isk3ACjECD/reQ1fV64r8c6zK
	xXifmMt2Q2pN3iCuMj2WGD03NU0TkqnIl/4taUWW9AGKc9Kh6VVD0kyGKEw4odlDuHki5Q
	+KRrBOygiG05siOdbNw9K7vJEd7aC9LPaw6OfErJFt7c0v8VEO7A7HSr0cWdh4gT0jFy+q
	qIoaWcdYlCOxUrjclZMWRFUgn6vPWyAhHcJ/nA+kp0o5rWTg6Ypjjd3Hok5B8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1595626293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4aIj5BJFXygT8U4O1CTI3DzA3eMR9QI7whCGEMz/ttI=;
	b=gvXpoJL9j0ueMxbRK7LxQkpKPtXsWnCEONeSpDv+LpS7hSA8x+8FAQ2hRnaenRubtW+dhH
	8fovrLUcNueXU0BA==
To: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH RFC V2 17/17] x86/entry: Preserve PKRS MSR across exceptions
In-Reply-To: <874kpwtxlh.fsf@nanos.tec.linutronix.de>
References: <20200717072056.73134-1-ira.weiny@intel.com> <20200717072056.73134-18-ira.weiny@intel.com> <87r1t2vwi7.fsf@nanos.tec.linutronix.de> <20200723220435.GI844235@iweiny-DESK2.sc.intel.com> <87mu3pvly7.fsf@nanos.tec.linutronix.de> <874kpwtxlh.fsf@nanos.tec.linutronix.de>
Date: Fri, 24 Jul 2020 23:31:33 +0200
Message-ID: <871rl0txai.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID-Hash: SJLNXOAKXSLW7IOKWAU3ELYHNDXXIGEM
X-Message-ID-Hash: SJLNXOAKXSLW7IOKWAU3ELYHNDXXIGEM
X-MailFrom: tglx@linutronix.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SJLNXOAKXSLW7IOKWAU3ELYHNDXXIGEM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thomas Gleixner <tglx@linutronix.de> writes:
> static __always_inline idtentry_state_t idtentry_nmi_enter(void)
> {
>      	idtentry_state_t state = {};
>
>         nmi_enter();
>         instrumentation_begin();
>         state.key = save_and_clear_key();
>         instrumentation_end();

Clearly lacks a

        return state;

But I assume you already spotted it. Otherwise the compiler would have :)

Thanks,

        tglx
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
