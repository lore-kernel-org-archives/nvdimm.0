Return-Path: <SRS0=JjRb=CN=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1E5C54F50
	for <linux-nvdimm@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA1F025449
	for <linux-nvdimm@archiver.kernel.org>; Fri,  4 Sep 2020 18:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ai5VYeCU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA1F025449
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A7E2513C440F1;
	Fri,  4 Sep 2020 10:11:31 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::144; helo=mail-lf1-x144.google.com; envelope-from=torvalds@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 618F413C440D9
	for <linux-nvdimm@lists.01.org>; Fri,  4 Sep 2020 10:11:29 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id q8so4238124lfb.6
        for <linux-nvdimm@lists.01.org>; Fri, 04 Sep 2020 10:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LwSOZ3VxHk2DxOprDUCFltuLBh+Nnc13XxZ9vhv/VSM=;
        b=Ai5VYeCU8N0HEbW+IM5blqtlPgBAdGE7a3XFUEbRHQk5rk29NE1Y6tMiu2T/EMq17a
         oE42EL494zdqelcOJfkWDvC8gduDspSWRXtrBLodjT6PNtuIMZdw4lEZsKoERdT4+qfQ
         DzOZXMaeU+RmNmSqU9sHI/NrjQBcHXnvyzI6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LwSOZ3VxHk2DxOprDUCFltuLBh+Nnc13XxZ9vhv/VSM=;
        b=F9PeqmIS5P3kduTDuBYkOv/BVgXTJ09kXvzHeecv2YaKFKZZINfqgTRsVRT5tgnuK5
         XI7vQr+9i8pHCxLOJBzwQP67LPgdUvZ4WU6L4vg9BvP0ugMnucz+SqNH9H683NQglncR
         /NKVfEw5G2xpl4o5+9UxfeZUjVe7b34rmCaqf2AXzMGFhXhkf+zhnBVoc7Xijyjj9HUE
         m6/PXn7FdHURuUOwaRFuZoo/h2oToFc+pKaoe8U+hF3o8zhFmfYl8QovaCnXqlxFxF0h
         EcOQzDwGfFJImVRvHS79CQsnA12UJfO6azs3JVhHhs1RfocOZHe8YPYPARNwXX1QNnnw
         EYsw==
X-Gm-Message-State: AOAM532xvozlJbdopGrHY24SH9tNPNfnLaYSa19Hf9NB1sAyGjYTltyK
	UgDiLIuQ2UVohA2W7q0H9bJZEIdJAGE12g==
X-Google-Smtp-Source: ABdhPJwh1lFMPsYAcUQ2m286tviuaCHZW0QzOmKjeByxE+27dVQq8pWzzoDLrR0DF2Sr89RHANx/ww==
X-Received: by 2002:a19:4094:: with SMTP id n142mr4303417lfa.166.1599239486578;
        Fri, 04 Sep 2020 10:11:26 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id o8sm1361416ljg.132.2020.09.04.10.11.22
        for <linux-nvdimm@lists.01.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 10:11:22 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id q8so4237987lfb.6
        for <linux-nvdimm@lists.01.org>; Fri, 04 Sep 2020 10:11:22 -0700 (PDT)
X-Received: by 2002:a05:6512:50c:: with SMTP id o12mr4298936lfb.192.1599239481877;
 Fri, 04 Sep 2020 10:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whpJp9W_eyhqJU3Y2JsnX45xMfQHFNQSsb9dNirdMFnaA@mail.gmail.com> <alpine.LRH.2.02.2009040402560.14993@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009040402560.14993@file01.intranet.prod.int.rdu2.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Sep 2020 10:11:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgmhDNm7+w0atqAj3X=izWxNut_4kQGTG8n=+HhtxEbRw@mail.gmail.com>
Message-ID: <CAHk-=wgmhDNm7+w0atqAj3X=izWxNut_4kQGTG8n=+HhtxEbRw@mail.gmail.com>
Subject: Re: a crash when running strace from persistent memory
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID-Hash: 4UXXYD3AGZUUX2U44LKVXGEN37WTGMKN
X-Message-ID-Hash: 4UXXYD3AGZUUX2U44LKVXGEN37WTGMKN
X-MailFrom: torvalds@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>, Oleg Nesterov <oleg@redhat.com>, Kirill Shutemov <kirill@shutemov.name>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4UXXYD3AGZUUX2U44LKVXGEN37WTGMKN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 4, 2020 at 1:08 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> I applied these four patches and strace works well. There is no longer any
> warning or crash.

Ok. I obviously approve of that series whole-heartedly, but I still
didn't want to apply it this way (and with this kind of "mid-rc"
timing).

I was hoping to just leave it for the next merge window, but there are
now two independent problems that that forced COW patch of mine
caused, and a plain revert isn't acceptable either, so I've just
applied that series to my tree despite the garbage timing.

Maybe I'm just making excuses and rationalizing because I wanted that
series anyway, and patches that remove lines in core code make me
happy, but I don't see other great alternatives.

              Linus
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
