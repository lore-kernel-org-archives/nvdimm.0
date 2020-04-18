Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260A4C3A5A0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 19:16:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E7709221E9
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 19:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VUI+VnT1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7709221E9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7709C10FC62E8;
	Sat, 18 Apr 2020 12:16:30 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::642; helo=mail-ej1-x642.google.com; envelope-from=torvalds@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 722A410FC62E6
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 12:16:27 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id pg17so4297094ejb.9
        for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 12:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5L2K70fxOQxP+uWdRM/yMA+3xinlowUvRSVTNSTLNw=;
        b=VUI+VnT1NDQO7RfejypC/A0x1WOF6JlDgQOx4uVj0o8myo36afYqYoAB1bDh9hMclE
         y2579x/RBIr7L8eyYz+tWMdcXNGl1k4dVtK8zltRzr1OvNlhqXGfw7OPYoGf+9sgrfJ0
         nPVwr3eWFbVskZYoGSYtK1N/R40NufLSxc2Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5L2K70fxOQxP+uWdRM/yMA+3xinlowUvRSVTNSTLNw=;
        b=iSV8hEobuUTdci3kIIphPdmc8grMMHHQbI1p9rdWl1Y3GnK/wx2SE1XrEiBBGHc3uN
         aUvCldLD5ZBhWXP8ablclIjtzPYQ0lgW2poKO/Jhwpj+LyZ/3Na+zEfX1EKoqzie40X+
         93vLHDc9hOpM45KrxZtuY78LtfXtTJ6K5SPT8x+D763zf3KMg3zDH51wt2iSpVRhtTOT
         L9rp2vLzua3qCnhzOyTmRnWT04j7x8H1zm1Dl2wVVvR2LoITASOfl4AYaR4ZHfU3KKiQ
         8ihukbQMbROO72GXfiwvTwO5W1ZWomhcYWi3ybPb+tKCp+MYAagDx4PVQyzo7SbXIDxv
         H8Fg==
X-Gm-Message-State: AGi0PuYdYN5reZ6Ll/V41+la+gC6j2Lti/PTaLvkpHdJ6adOYbTkdHHE
	pOj1kNwvKP8VOy+c+UwAKgHFOCqOY/0=
X-Google-Smtp-Source: APiQypJvoXWSE+CXcUgP0nLIS1JH73YcLynabEvJyBKScFlSq/2tY1ZXuGdWeYT5F7W+fCotmz2RWQ==
X-Received: by 2002:a17:906:27d1:: with SMTP id k17mr8702859ejc.134.1587237377142;
        Sat, 18 Apr 2020 12:16:17 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 13sm3493247ejw.88.2020.04.18.12.16.14
        for <linux-nvdimm@lists.01.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 12:16:14 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id e5so4076546edq.5
        for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 12:16:14 -0700 (PDT)
X-Received: by 2002:a2e:1418:: with SMTP id u24mr5613429ljd.265.1587237373258;
 Sat, 18 Apr 2020 12:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200418184111.13401-1-rdunlap@infradead.org> <20200418184111.13401-8-rdunlap@infradead.org>
 <20200418185033.GQ5820@bombadil.infradead.org> <b88d6f8b-e6af-7071-cefa-dc12e79116b6@infradead.org>
 <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
In-Reply-To: <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Apr 2020 12:15:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
Message-ID: <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in devcoredump.c
To: Joe Perches <joe@perches.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rafael Wysocki <rafael@kernel.org>
Message-ID-Hash: 53DSH3LGZH6RBDQKHQZ3HPZ3RA2L24B4
X-Message-ID-Hash: 53DSH3LGZH6RBDQKHQZ3HPZ3RA2L24B4
X-MailFrom: torvalds@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Randy Dunlap <rdunlap@infradead.org>, Matthew Wilcox <willy@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org, linux-usb@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/53DSH3LGZH6RBDQKHQZ3HPZ3RA2L24B4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 18, 2020 at 11:57 AM Joe Perches <joe@perches.com> wrote:
>
> sysfs_create_link is __must_check

The way to handle __must_check if you really really don't want to test
and have good reasons is

 (a) add a big comment about why this case ostensibly doesn't need the check

 (b) cast a test of it to '(void)' or something (I guess we could add
a helper for this). So something like

        /* We will always clean up, we don't care whether this fails
or succeeds */
        (void)!!sysfs_create_link(...)

There are other alternatives (like using WARN_ON_ONCE() instead, for
example). So it depends on the code. Which is why that comment is
important to show why the code chose that option.

However, I wonder if in this case we should just remove the
__must_check. Greg? It goes back a long long time.

Particularly for the "nowarn" version of that function. I'm not seeing
why you'd have to care, particularly if you don't even care about the
link already existing..

            Linus
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
