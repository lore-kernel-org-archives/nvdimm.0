Return-Path: <SRS0=+IV0=3E=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80491C33CB2
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Jan 2020 20:17:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AD4D2081E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Jan 2020 20:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="fpojuKnu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AD4D2081E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 87BCE10097DD8;
	Wed, 15 Jan 2020 12:21:14 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::344; helo=mail-ot1-x344.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 49B0510097DD4
	for <linux-nvdimm@lists.01.org>; Wed, 15 Jan 2020 12:21:10 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 66so17251172otd.9
        for <linux-nvdimm@lists.01.org>; Wed, 15 Jan 2020 12:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPd0oj72IQTr7Ho1Km4ZWXqORK+AR/nQgrcplLwpJyE=;
        b=fpojuKnu+Wi5p9+eOGcUnK1tXz/ym+tDyQJR7fiN07JPdlNydPbQ1RuKfL9nYOO/vp
         ktdoj1LGNeeH0tLetzt6le5Wb0WjNM3TI4p2CjOGGX+EuSOWw0DzUACfhhv8vVjFUZDe
         W6M8jugyiYMYQ6KmvTTdLB9sA/e2SPnlatCfzz0H0tbTOuYqDFrMchmtCY6PyFUez9hR
         OJoFqGd7eJNY1E5+nY46wPN/+WfX65rZrOFaITHNzfaWg74cclGgIH9l50y+jzJWSEL7
         OLoPXxM4Hj1zKIsYyFEQOBs4ip5mmicI0GLmGXVjvoFJoRTGMOaPmOsh7mhiRTDNLsCU
         UcPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPd0oj72IQTr7Ho1Km4ZWXqORK+AR/nQgrcplLwpJyE=;
        b=ue4RvXumqCcf4Q4CVYZIuxGg8Vzn4kCE3QB8FOvvZ7QyPdOVHZx3de/sdLN2NhLxsL
         v7nScyIQVD5V8XSAEglxLBeBClTYPPjgLMpvpTEbw27BrkKE8WVQfRvXpPqQ0Dd/WW7E
         DNlHzWPt8mRvjOqu6+Kxn4vISVGzuI1zN0Q7BqABY2dqjuRK0ZTrsoaF6ZO1gR8pPkVF
         X34D1/03SOaC3AoBJdYr/Wh4KkHITHs2Q9O/rI1UZ6WT/Cjei6dVMdO8oGP98d9IbEqS
         honNQleSMvpEA0kTqJRAomLMkqZntAm5lGKu3t5qQ2bNf2SGvWS8WnE1mlQw42hmZgtA
         vG6g==
X-Gm-Message-State: APjAAAV3gnPN5O6d0w79saUxZYmpreMEViZDElV+KpAvoToKnvbWUKGG
	GkmKoHZSLgEUyjA1/QwCgnvI+bdHZ38h364Wk144Rw==
X-Google-Smtp-Source: APXvYqxa2PtNKtiTJcIUathhM+5vp8w9k5zscIWT4wSuOwLkVVcCWydFq1TB1qX0u3WdgAKuekec5Tb3+clHuOZsZ0c=
X-Received: by 2002:a9d:68d3:: with SMTP id i19mr3785693oto.71.1579119471207;
 Wed, 15 Jan 2020 12:17:51 -0800 (PST)
MIME-Version: 1.0
References: <20200107180101.GC15920@redhat.com> <CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
 <20200107183307.GD15920@redhat.com> <CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
 <20200109112447.GG27035@quack2.suse.cz> <CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
 <20200114203138.GA3145@redhat.com> <CAPcyv4iXKFt207Pen+E1CnqCFtC1G85fxw5EXFVx+jtykGWMXA@mail.gmail.com>
 <20200114212805.GB3145@redhat.com> <CAPcyv4igrs40uWuCB163PPBLqyGVaVbaNfE=kCfHRPRuvZdxQA@mail.gmail.com>
 <20200115195617.GA4133@redhat.com>
In-Reply-To: <20200115195617.GA4133@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Jan 2020 12:17:40 -0800
Message-ID: <CAPcyv4iEoN9SnBveG7-Mhvd+wQApi1XKVnuYpyYxDybrFv_YYw@mail.gmail.com>
Subject: Re: [PATCH 01/19] dax: remove block device dependencies
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: VQUKL5QAZTGEUHAFALBOTWNPBLL3REDK
X-Message-ID-Hash: VQUKL5QAZTGEUHAFALBOTWNPBLL3REDK
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VQUKL5QAZTGEUHAFALBOTWNPBLL3REDK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 15, 2020 at 11:56 AM Vivek Goyal <vgoyal@redhat.com> wrote:
[..]
> > Even the Red Hat
> > installation guide example shows mounting on pmem0 directly. [1]
>
> Below that example it also says.
>
> "When creating partitions on a pmem device to be used for direct access,
> partitions must be aligned on page boundaries. On the Intel 64 and AMD64
> architecture, at least 4KiB alignment for the start and end of the
> partition, but 2MiB is the preferred alignment. By default, the parted
> tool aligns partitions on 1MiB boundaries. For the first partition,
> specify 2MiB as the start of the partition. If the size of the partition
> is a multiple of 2MiB, all other partitions are also aligned."
>
> So documentation is clearly saying dax will work with partitions as well.
> And some user might decide to just do that.

Yes, of course but my point is that it was ambiguous.

I'm going to take a look at how hard it would be to develop a kpartx
fallback in udev. If that can live across the driver transition then
maybe this can be a non-event for end users that already have that
udev update deployed.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
