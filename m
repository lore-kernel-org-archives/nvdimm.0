Return-Path: <SRS0=xhOP=43=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061BBC10DCE
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 19:29:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0B9621D7E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 19:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="aK5PVE29"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0B9621D7E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=szeredi.hu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9379010FC362F;
	Tue, 10 Mar 2020 12:30:49 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::d41; helo=mail-io1-xd41.google.com; envelope-from=miklos@szeredi.hu; receiver=<UNKNOWN> 
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E49BB10FC362D
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 12:30:46 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q128so14001809iof.9
        for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 12:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O+5kKx2vjd+32qtXdrToSkdcaTFfCoL0XwTHvIf1Udg=;
        b=aK5PVE29ZcX0JiUctdQKR6J4V8Ui1eAIPqRanRd0A6P1wY0Olma3AwHhrD2PySTEY1
         kZXXW4WCwVRDmSdrzbH44gRLv2dG0A/Uo2FsE583gbPAcJns18ZxYKCVeIw3hoRvR9nW
         X63aa+sKmNAHbQ4QA3pDh67PTQqXiIq2fbgVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O+5kKx2vjd+32qtXdrToSkdcaTFfCoL0XwTHvIf1Udg=;
        b=AfxRkCPu5oZJtWzN981vYyrlT1aQGe+PTnbi1uOSQiRMawDjvHXMsqVcY02qqxcup1
         Cm9Zo7Qr4FaldLfdDuSHDvt4C3F5WIDlbzp/7G2uxJ5XtsA5wSs+gl1uN1rkQ7zF+ToJ
         4SMfG+mY9gBkYFY78C6E+TiekazE6fLQrPa+KTBNJJPWHRr8M/CKiy9QMVYmVrRyTFnK
         EGufntim7+niQRLYh98UA138vDUW7MQdoo0csuo8NynKkRByAcaT8d1q5u4yJCxZAWr5
         vDDKex65D83mqPhOwOamHBn2TuIrin8nhAbJEq9aiq1UdeGKMTh93IePhXgCtEPoNwGF
         rb1Q==
X-Gm-Message-State: ANhLgQ3GT/YNh303Qf78UUkfMM2XSycmLhHGoSzA9W+NwSR4PHJ+4Nzs
	bEPt6hhMEL6liOq7h88DXoXFXzhko07Q8qbG0aloGw==
X-Google-Smtp-Source: ADFU+vtsHIE3juf6VloEHRQ+IFMzK3xP4NZGmqU4UP+Nis9eHwUR1TaPlSRS7pe1JGlIhD+fR0kBGJFzXYHNxz1Bts4=
X-Received: by 2002:a02:7a07:: with SMTP id a7mr12556058jac.77.1583868594718;
 Tue, 10 Mar 2020 12:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com> <20200304165845.3081-11-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-11-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:29:43 +0100
Message-ID: <CAJfpegshzZB=e3npbY3h9VOLMwAgLtQ3PJSC8AupF_d3FW9few@mail.gmail.com>
Subject: Re: [PATCH 10/20] fuse,virtiofs: Keep a list of free dax memory ranges
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: J5YATSNDKQYBB73CB6PB76MIRLSE2ONQ
X-Message-ID-Hash: J5YATSNDKQYBB73CB6PB76MIRLSE2ONQ
X-MailFrom: miklos@szeredi.hu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Peng Tao <tao.peng@linux.alibaba.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/J5YATSNDKQYBB73CB6PB76MIRLSE2ONQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Divide the dax memory range into fixed size ranges (2MB for now) and put
> them in a list. This will track free ranges. Once an inode requires a
> free range, we will take one from here and put it in interval-tree
> of ranges assigned to inode.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
