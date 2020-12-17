Return-Path: <SRS0=M8eZ=FV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4BFC4361B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 17 Dec 2020 13:07:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 146BA2389F
	for <linux-nvdimm@archiver.kernel.org>; Thu, 17 Dec 2020 13:07:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 146BA2389F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 82319100EBB8F;
	Thu, 17 Dec 2020 05:07:08 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a0a:51c0:0:12e:550::1; helo=galois.linutronix.de; envelope-from=tglx@linutronix.de; receiver=<UNKNOWN> 
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3B91A100EBBAC
	for <linux-nvdimm@lists.01.org>; Thu, 17 Dec 2020 05:07:05 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1608210421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CyOHKGrGF5FgJ/jrTCkQanXT7eBDkCqK5reXHcNL6hU=;
	b=eovS1hyj5PJ9FjFq7ljImsiygsavh4+hyAufANIEN4qOrIiRDJvnEz+nMcNLlzLjQ0nmpQ
	qpnwUz3EbXYBc8fFktrxzlnN4DQmYjZ5fJG/MnTix8uxeXRp5AG95AtjsfGKOw0krQrQxv
	1vu89vPNDAI5DTALWz8VCvROwjE0G5obplIWO86tQCTJsL8Ksrn/sX1nm9dy12fVzaf4Jy
	eLWmf4CzfHO5nriFc0GYwEHcejk6r4D1+RzHUBqtvKcEI2Cbx+JIjoJYs4kN/Xi6fu2LQC
	vavhLTIKjSMksx9LjtZAGZdRTRAJXK54Rhp3ahyHcTjHuE4EKFiMiOaYQs+8/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1608210421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CyOHKGrGF5FgJ/jrTCkQanXT7eBDkCqK5reXHcNL6hU=;
	b=trlnJKPooUM3Q07R6gTR3/B9v5VRgpJBlPadulHLT7hRSrDAzhWFliWBHTApTwcTBZrwKG
	VIZ25dC5Vt0t6hDA==
To: Andy Lutomirski <luto@kernel.org>, Weiny Ira <ira.weiny@intel.com>
Subject: Re: [PATCH V3.1] entry: Pass irqentry_state_t by reference
In-Reply-To: <CALCETrUHwZPic89oExMMe-WyDY8-O3W68NcZvse3=PGW+iW5=w@mail.gmail.com>
References: <20201106232908.364581-6-ira.weiny@intel.com> <20201124060956.1405768-1-ira.weiny@intel.com> <CALCETrUHwZPic89oExMMe-WyDY8-O3W68NcZvse3=PGW+iW5=w@mail.gmail.com>
Date: Thu, 17 Dec 2020 14:07:01 +0100
Message-ID: <878s9wshsa.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID-Hash: YMZT2LODGJXNX3YT3DWFB5GP7SGMLCPI
X-Message-ID-Hash: YMZT2LODGJXNX3YT3DWFB5GP7SGMLCPI
X-MailFrom: tglx@linutronix.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Fenghua Yu <fenghua.yu@intel.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux-MM <linux-mm@kvack.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YMZT2LODGJXNX3YT3DWFB5GP7SGMLCPI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 11 2020 at 14:14, Andy Lutomirski wrote:
> On Mon, Nov 23, 2020 at 10:10 PM <ira.weiny@intel.com> wrote:
> After contemplating this for a bit, I think this isn't really the
> right approach.  It *works*, but we've mostly just created a bit of an
> unfortunate situation.  Our stack, on a (possibly nested) entry looks
> like:
>
> previous frame (or empty if we came from usermode)
> ---
> SS
> RSP
> FLAGS
> CS
> RIP
> rest of pt_regs
>
> C frame
>
> irqentry_state_t (maybe -- the compiler is within its rights to play
> almost arbitrary games here)
>
> more C stuff
>
> So what we've accomplished is having two distinct arch register
> regions, one called pt_regs and the other stuck in irqentry_state_t.
> This is annoying because it means that, if we want to access this
> thing without passing a pointer around or access it at all from outer
> frames, we need to do something terrible with the unwinder, and we
> don't want to go there.
>
> So I propose a somewhat different solution: lay out the stack like this.
>
> SS
> RSP
> FLAGS
> CS
> RIP
> rest of pt_regs
> PKS
> ^^^^^^^^ extended_pt_regs points here
>
> C frame
> more C stuff
> ...
>
> IOW we have:
>
> struct extended_pt_regs {
>   bool rcu_whatever;
>   other generic fields here;
>   struct arch_extended_pt_regs arch_regs;
>   struct pt_regs regs;
> };
>
> and arch_extended_pt_regs has unsigned long pks;
>
> and instead of passing a pointer to irqentry_state_t to the generic
> entry/exit code, we just pass a pt_regs pointer.

While I agree vs. PKS which is architecture specific state and needed in
other places e.g. #PF, I'm not convinced that sticking the existing
state into the same area buys us anything more than an indirect access.

Peter?

Thanks,

        tglx
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
