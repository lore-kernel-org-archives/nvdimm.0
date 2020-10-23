Return-Path: <SRS0=UOT5=D6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC94C5517A
	for <linux-nvdimm@archiver.kernel.org>; Fri, 23 Oct 2020 21:50:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B023223EA
	for <linux-nvdimm@archiver.kernel.org>; Fri, 23 Oct 2020 21:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0yAkbZnT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1RyBpBn3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B023223EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DCFEB163660A5;
	Fri, 23 Oct 2020 14:50:16 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a0a:51c0:0:12e:550::1; helo=galois.linutronix.de; envelope-from=tglx@linutronix.de; receiver=<UNKNOWN> 
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 428CA163660A2
	for <linux-nvdimm@lists.01.org>; Fri, 23 Oct 2020 14:50:15 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1603489811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cHZqtXRz0EpqKwmVvrfGdZyZvC7siQQGSvicS0vKKBg=;
	b=0yAkbZnTwDY2ALAbXdGN6vr3ehp2VwpXNIcf51OXNu5rvFRvmCFOCTkkOciH3bsMMB1GTJ
	M49Ooo+35dE2U2EdR4GV6DqIHTyROF7HKJgwhEe+YkykUW9BNC5m+IszzFX1oA8ZEa0XuD
	1d/dCepUNoGiDlYmKWo738FoXRvvngEHtiadyKHOVShEMn5o8bVNUoOmknFSNyw0C29P1y
	lG0GxNgCHxB0lekDN0U72B9z95n6HUAC3ZK2mGWWUMRbEJvRSTaJxxe2QqwdMQCr0LGqOO
	auNEwTjIY0XSihJxFVb3YEpC1IQVLCt4JgLsfilbBuSQ9ygKHpb0dXjIER+lPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1603489811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cHZqtXRz0EpqKwmVvrfGdZyZvC7siQQGSvicS0vKKBg=;
	b=1RyBpBn3mRKQKuLJjCvQxmBBrnxabQDijrSaiAdGjc2n/P1b8Vr9dL2Zi4iX0nPaJ9AC7Q
	vT1Rr3Z8/S0zuhCQ==
To: ira.weiny@intel.com, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/10] x86/entry: Move nmi entry/exit into common code
In-Reply-To: <20201022222701.887660-7-ira.weiny@intel.com>
References: <20201022222701.887660-1-ira.weiny@intel.com> <20201022222701.887660-7-ira.weiny@intel.com>
Date: Fri, 23 Oct 2020 23:50:11 +0200
Message-ID: <874kmk6298.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID-Hash: ETNKLF4M5SJB3XE7VR4HHQTQGLWL6LTU
X-Message-ID-Hash: ETNKLF4M5SJB3XE7VR4HHQTQGLWL6LTU
X-MailFrom: tglx@linutronix.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ETNKLF4M5SJB3XE7VR4HHQTQGLWL6LTU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 22 2020 at 15:26, ira weiny wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
>
> Lockdep state handling on NMI enter and exit is nothing specific to X86. It's
> not any different on other architectures. Also the extra state type is not
> necessary, irqentry_state_t can carry the necessary information as well.
>
> Move it to common code and extend irqentry_state_t to carry lockdep
> state.

This lacks something like:

 [ Ira: Made the states a union as they are mutually exclusive and added
        the missing kernel doc ]

Hrm.
 
>  #ifndef irqentry_state
>  typedef struct irqentry_state {
> -	bool	exit_rcu;
> +	union {
> +		bool	exit_rcu;
> +		bool	lockdep;
> +	};
>  } irqentry_state_t;
>  #endif

  -E_NO_KERNELDOC

Thanks,

        tglx
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
