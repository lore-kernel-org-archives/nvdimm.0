Return-Path: <SRS0=lzik=YM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFE2CA9EAE
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Oct 2019 23:10:16 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 345B221D7C
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Oct 2019 23:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="fvmToX7R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 345B221D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8DCE81007B681;
	Sat, 19 Oct 2019 16:12:12 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::341; helo=mail-ot1-x341.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B55371007B67E
	for <linux-nvdimm@lists.01.org>; Sat, 19 Oct 2019 16:12:10 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id y39so8009893ota.7
        for <linux-nvdimm@lists.01.org>; Sat, 19 Oct 2019 16:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6V+goadp04lgp/6ouBZ08nnuiR9ZWMieowK64fMJJPo=;
        b=fvmToX7RhHX15J5XNflMsTcTNnjDjUc+03b9RJ9IzDfHKW+ha2Pvtrwen5Kj1hOVkI
         7IvzLMfYo5WOsYQPNi1pPjq83hd4BPzrAhD+byEiWhCrqKCHnBfBplkdJANy4Y4xfq9O
         F3MKgd81AdNmz99JPnxqi1dEPJFyfFURzhByULjZd/ddnWi4WsnzwkMfvQAwaCI/KUEQ
         Z/tWnSRMlDqgrueeSLcbfZ5u6IT3Fm3M0RHUENJiofrHx3m6DS6MUS1VXmTvZS+yvbtv
         WMnb9Tp1XzNtcPKkniBWTGF+U3d3aBQm2aSL/r2CtFbkVSW40/sMTmF22l/5SsbiKR38
         7oUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6V+goadp04lgp/6ouBZ08nnuiR9ZWMieowK64fMJJPo=;
        b=oUrpFjXi15rNiKfPKrAkTSG16Xd3yZSicnpu4OFVNDBVi+4GEiEwEi/ebVm51kKQm2
         DFgsjUf3mhOpPME0/vBuod6UakjpNpdEJOYnbvkeMPZxEK+sv7eDLqwRiRtDFbpyLEvU
         G52YWqjaP90YWYvvgHwAmS28r08ESBRZ9a4ky3A9aB2UIlp11zRi9oWjIUKmb7UMkhbc
         gmtrB1gAkLuFZFfNar4m3HK+Y6BWXuT2PJK7b2oAdFOLU0qEIne7twPUusU7AHg4/Q3T
         V/sNvAMsGyP4wihCzeH+awWnF7R/RDhVCF4nDt6GbLH4FAvXfQXrs0VOd9T2BXjyGTfr
         4saw==
X-Gm-Message-State: APjAAAXbTh0Qs9wu25drrXkVscQFV9MeRA2QuuROulIGYsatE/lIKQk2
	CWEj/QWu2LejRRTFAzaqgPmg+i/JuCodYDVs4ZBWdQ==
X-Google-Smtp-Source: APXvYqwVmgrM8/hkJM+rSC4kzo3Uext5IYl8OOxkbKEkTk91yIuX8Rv6+rZQ8op0qxcaadFmv/oFPnRqVJ8/JKRoTzw=
X-Received: by 2002:a9d:7843:: with SMTP id c3mr12157037otm.71.1571526612232;
 Sat, 19 Oct 2019 16:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20191019205003.GN32665@bombadil.infradead.org>
In-Reply-To: <20191019205003.GN32665@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 19 Oct 2019 16:09:59 -0700
Message-ID: <CAPcyv4jj-BqhPj3vB5=G7YfGPvBgugEZ39gf+3Wwn6BC1fAUJw@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: Fix pmd vs pte conflict detection
To: Matthew Wilcox <willy@infradead.org>
Message-ID-Hash: O4M6UQHWSTP3KK5GIFYAK7QDQPYEW2ZE
X-Message-ID-Hash: O4M6UQHWSTP3KK5GIFYAK7QDQPYEW2ZE
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Smits <jeff.smits@intel.com>, Doug Nelson <doug.nelson@intel.com>, stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/O4M6UQHWSTP3KK5GIFYAK7QDQPYEW2ZE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Oct 19, 2019 at 1:50 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Oct 19, 2019 at 09:26:19AM -0700, Dan Williams wrote:
> > Check for NULL entries before checking the entry order, otherwise NULL
> > is misinterpreted as a present pte conflict. The 'order' check needs to
> > happen before the locked check as an unlocked entry at the wrong order
> > must fallback to lookup the correct order.
> >
> > Reported-by: Jeff Smits <jeff.smits@intel.com>
> > Reported-by: Doug Nelson <doug.nelson@intel.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  fs/dax.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index a71881e77204..08160011d94c 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -221,10 +221,11 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
> >
> >       for (;;) {
> >               entry = xas_find_conflict(xas);
> > +             if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
> > +                     return entry;
> >               if (dax_entry_order(entry) < order)
> >                       return XA_RETRY_ENTRY;
> > -             if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> > -                             !dax_is_locked(entry))
> > +             if (!dax_is_locked(entry))
> >                       return entry;
>
> Yes, I think this works.  Should we also add:
>
>  static unsigned int dax_entry_order(void *entry)
>  {
> +       BUG_ON(!xa_is_value(entry));
>         if (xa_to_value(entry) & DAX_PMD)
>                 return PMD_ORDER;
>         return 0;
>  }
>
> which would have caught this logic error before it caused a performance
> regression?

Sounds good will add it to v2.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
