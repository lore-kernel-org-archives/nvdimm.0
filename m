Return-Path: <SRS0=H1bD=DY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3B5C433E7
	for <linux-nvdimm@archiver.kernel.org>; Sat, 17 Oct 2020 18:39:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A5F0B2073A
	for <linux-nvdimm@archiver.kernel.org>; Sat, 17 Oct 2020 18:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9jMllkW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5F0B2073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E8AEE15903432;
	Sat, 17 Oct 2020 11:39:02 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::243; helo=mail-lj1-x243.google.com; envelope-from=torvalds@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D3E88158AB6C9
	for <linux-nvdimm@lists.01.org>; Sat, 17 Oct 2020 11:38:59 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m16so6306523ljo.6
        for <linux-nvdimm@lists.01.org>; Sat, 17 Oct 2020 11:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shOVwNs6Avo5GF4u4YTYujjSqI3DtlABC6Tzp53jjj0=;
        b=M9jMllkWWKQilAaKisCs+VZtmXW9uYzRlU8piWtKlW909l5UmNMqGRTXwiRA3/fLWS
         jAcDoHachncFBJ8Xpv8Laz6ex2VwchQZCdh3E1uxbRSLOAQ76gOFwYhk7YNyDesFDcVm
         RXH9sE7syNrGMj1aPTKs3a3cwWU0G9x8oExEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shOVwNs6Avo5GF4u4YTYujjSqI3DtlABC6Tzp53jjj0=;
        b=at1SfoDAlS300ciTv6tPHs7Oav7PGyfObKwihqgliJPtn2Rn4oZEVymGZ35pjzXEfr
         17L4XoHZi+taVkQ6tDyGWdLOX7f87HsBRCb2KjgyujEUJfHrSVc9UzS2QkHvef4WrlEQ
         KU+bAVQJ8R5PSDFfRpPp8iP12IjhfynFJeKJsYGPmMB1CkvR4OxrNjNrt2kRBQr2sgJP
         0UPJE9/+8TzQnfYV8SWrtDFXIEkcaMhykoiggy1PViLhflQJg9LtGY9TMor7HyQOk79T
         Hx4ZoMBVrpmpfDw7AcoOyP1gtrwHpdrykexsDM+mIMVuy8Fl95RzfWYLJrBuK0RZomLJ
         10AQ==
X-Gm-Message-State: AOAM5323n6y5g6V22wJmVvoxb1hu9U7SW2/tlNujzgOmEgoJLxCr5cZf
	d3GPKPl7lW/sa5xJvwDYMHVHCs1mBdwDJA==
X-Google-Smtp-Source: ABdhPJwuAZZ4FjtPZLBDdBo+ag7uA33mwHDHfBycVd7rVIUaOlmnLnsE0Bz+G7BHa79gqrjEJUX+Sg==
X-Received: by 2002:a2e:99c2:: with SMTP id l2mr3471545ljj.38.1602959933895;
        Sat, 17 Oct 2020 11:38:53 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id t19sm2173528lfg.161.2020.10.17.11.38.48
        for <linux-nvdimm@lists.01.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 11:38:48 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 184so7602777lfd.6
        for <linux-nvdimm@lists.01.org>; Sat, 17 Oct 2020 11:38:48 -0700 (PDT)
X-Received: by 2002:a19:c703:: with SMTP id x3mr3090794lff.105.1602959928107;
 Sat, 17 Oct 2020 11:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <160288261564.3242821.6055291930923876456.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160288261564.3242821.6055291930923876456.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Oct 2020 11:38:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_HafvgLvyHcYk=K-gJFdj9aqap4At7DCFyroLVC04LQ@mail.gmail.com>
Message-ID: <CAHk-=wg_HafvgLvyHcYk=K-gJFdj9aqap4At7DCFyroLVC04LQ@mail.gmail.com>
Subject: Re: [PATCH] device-dax/kmem: Use struct_size()
To: Dan Williams <dan.j.williams@intel.com>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Message-ID-Hash: 2OV7SO63THHCURDYYRONXNSQITPVMXFQ
X-Message-ID-Hash: 2OV7SO63THHCURDYYRONXNSQITPVMXFQ
X-MailFrom: torvalds@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2OV7SO63THHCURDYYRONXNSQITPVMXFQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 2:10 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Link: http://lore.kernel.org/r/CAHk-=wgNTLbvAD8mNTvh+GQyapNWeX20PXhU_+frqEvVq4298w@mail.gmail.com

Does that link work for you?

Because I can't see it.

In fact, I don't see my email at all on lore, even if I see Andrew's
email that I answered to:

    https://lore.kernel.org/mm-commits/20201016024059.Ycwm4GmQ8%25akpm@linux-foundation.org/

but your link gives me "Not Found", and when I search for emails from
me on mm-commits I don't see them either.

Adding Konstantin just to solve the mystery. Some odd mirroring
problem, perhaps?

                    Linus
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
