Return-Path: <SRS0=xhOP=43=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53A9C10F27
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 14:17:07 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61CCB20828
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 14:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DWyZY+fN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61CCB20828
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=szeredi.hu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4348E10FC361D;
	Tue, 10 Mar 2020 07:17:58 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::144; helo=mail-il1-x144.google.com; envelope-from=miklos@szeredi.hu; receiver=<UNKNOWN> 
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4A94D10FC3617
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 07:17:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f5so12117816ilq.5
        for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 07:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHUlshbt0krVyNx6H5AQrYmBp/rsTRhM/TkVqLTK1cA=;
        b=DWyZY+fN2f5GWPycqc6nfqGuuLyjg3vxp56EkljIp4CFmK4rlXVcYb7WGIIrBmtWz9
         NR+EjtBnZDRvDuMV/aRpSTLTMaQIfWG4nIPbzPJwAM0W39llvBvEuEw3xVXPour1P6cG
         OnrgRxf5sAH77uw+c4f2x0E2WfazdfWrmdTjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHUlshbt0krVyNx6H5AQrYmBp/rsTRhM/TkVqLTK1cA=;
        b=EEJU50TiiVMpxPojuVc6bCwjIjI8sK9nRh4SPhQwddfWBSiqh/O3pKh8LVaaLtPrfJ
         B9xO9HPK8gKPpkmezyWEtm44NKjShQOKFCRo/XMW3l3fZtaRQgT61Kx2WxYlYNZAgvVK
         L87gclc8mKtgMarbJVoZPyHR1I3K1QNtGeKoulxaUCt9aEht1gwY6jWuYkXSZVEIhmA0
         Y4QAM8GvHssqGEOshtERHIkzjguNIR4SsdC+nmnUi7oZghaMoOmZMZRxvWyt/Ao0Nhdx
         InAcUZadK1NnmKwyDDeMtSVmYcR3QtrVWDHSDq9Ix986NxPJT+AVStQn3Bu6shXjlbBB
         vrbw==
X-Gm-Message-State: ANhLgQ3lys/ew5KDTzC7Hdyt9KKmlC07PisR1/kEohZAIdK+73pBMjR8
	iXSFzMHkbizBe0SmMykRw/Bb6Npy70mQrm0OMX35CQ==
X-Google-Smtp-Source: ADFU+vtV/3QnmLNUezgyv8VStO5uYY+S+sx5ZNP2mhhnVIGPPCKJl2hcyaOkIWXF/dIC/PIi4nqGuhZAh3mfFWAL+mg=
X-Received: by 2002:a92:d745:: with SMTP id e5mr20045107ilq.285.1583849824037;
 Tue, 10 Mar 2020 07:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com> <20200304165845.3081-9-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-9-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 15:16:53 +0100
Message-ID: <CAJfpegsY1LBe85-Dx49LwM9TOrHE0aQq1CAtZQdYr4pYn5tBbg@mail.gmail.com>
Subject: Re: [PATCH 08/20] fuse,virtiofs: Add a mount option to enable dax
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: P2PJJBBV3AQWZKJ5SYSYQNZ44SQSZEOU
X-Message-ID-Hash: P2PJJBBV3AQWZKJ5SYSYQNZ44SQSZEOU
X-MailFrom: miklos@szeredi.hu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/P2PJJBBV3AQWZKJ5SYSYQNZ44SQSZEOU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Add a mount option to allow using dax with virtio_fs.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
