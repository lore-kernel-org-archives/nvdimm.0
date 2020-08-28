Return-Path: <SRS0=2D2W=CG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_20,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB96C433E2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 28 Aug 2020 14:27:13 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB41C2078A
	for <linux-nvdimm@archiver.kernel.org>; Fri, 28 Aug 2020 14:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="XQbewNZ6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB41C2078A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=szeredi.hu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 83496126DA0E0;
	Fri, 28 Aug 2020 07:27:12 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::641; helo=mail-ej1-x641.google.com; envelope-from=miklos@szeredi.hu; receiver=<UNKNOWN> 
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D4ED91283DC5E
	for <linux-nvdimm@lists.01.org>; Fri, 28 Aug 2020 07:27:09 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id d11so1727902ejt.13
        for <linux-nvdimm@lists.01.org>; Fri, 28 Aug 2020 07:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gl0n7d6uzVJsvRESdz9U6Q5zoOE/mArKZEtiHXlxl+A=;
        b=XQbewNZ6vbVoEOX8gsi1Rc4oDnVeju8D129HRlTSxUJHzvsLy8S4x4ttUv/Q1UbD7a
         RvH7dXTmrZ/ZsiQSdTzwNPUfqx9vmGPSqZ3jM1W1LFFJhJpo1s7/hzIpe/U20goTwNkm
         M/hx0L+ugVWf90stUZL9nRhUG59hiac/rQbow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gl0n7d6uzVJsvRESdz9U6Q5zoOE/mArKZEtiHXlxl+A=;
        b=NwPXctHpV+QME+/ias1wSGmXprVbS30/L4WiLc+NPuRSuNtWPM410rQA+WejjTgIQe
         HOeCf+WwDeP5SmWXC9+gUWNi9BRsohL55qfutAdIZzpsLsOn1JJfPgQ21vrFVpwg344g
         8xZoBESTVmtH0y7AseqkpkOBYdpbKnupeRfeVc26vPsb87FTPgdZ3W2KQkAb/Vv8tJuq
         /xDPV1qUCy4AGaYcyF4yEWE3WcbTjbm7brVkkSlhLne6OgBICWOtNnD6wemoxJcjZqG7
         OcmBp7CW2Uom7yH1r0roEL2O8XJaz9ygkotW3CwnWBlvkIt7Og3zc/Qlf/Fo4ujQiB7s
         77Jw==
X-Gm-Message-State: AOAM531LJuSdvwBsCUVRYsUs7WXauP0KCCmXKOfVcr3mHtGKHa9b4A6R
	b4Ugj1nZ2IhC9iXWXV2JNlEnprWHDwC4UiMdeuCGmg==
X-Google-Smtp-Source: ABdhPJx/XumYJzNHjGferUrsD62R+WOS937oWA5dXyt/UPWotd7gXol3fLS1WId9GCqY81zy1C7DxVDsLeoyTNi+yYA=
X-Received: by 2002:a17:906:ca55:: with SMTP id jx21mr2095017ejb.110.1598624827171;
 Fri, 28 Aug 2020 07:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200819221956.845195-1-vgoyal@redhat.com>
In-Reply-To: <20200819221956.845195-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Aug 2020 16:26:55 +0200
Message-ID: <CAJfpegv5ro-nJTsbx7DMu6=CDXnQ=dzXBRYEKxKc6Bx+Bxmobw@mail.gmail.com>
Subject: Re: [PATCH v3 00/18] virtiofs: Add DAX support
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: AT66MGXSMYFL6RX67TVNCH24OE3HF5KG
X-Message-ID-Hash: AT66MGXSMYFL6RX67TVNCH24OE3HF5KG
X-MailFrom: miklos@szeredi.hu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, virtio-fs-list <virtio-fs@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AT66MGXSMYFL6RX67TVNCH24OE3HF5KG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 20, 2020 at 12:21 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi All,
>
> This is V3 of patches. I had posted version v2 version here.

Pushed to:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#dax

Fixed a couple of minor issues, and added two patches:

1. move dax specific code from fuse core to a separate source file

2. move dax specific data, as well as allowing dax to be configured out

I think it would be cleaner to fold these back into the original
series, but for now I'm just asking for comments and testing.

Thanks,
Miklos
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
