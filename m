Return-Path: <SRS0=t/ft=AN=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4852C433DF
	for <linux-nvdimm@archiver.kernel.org>; Thu,  2 Jul 2020 18:22:28 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7A1B12088E
	for <linux-nvdimm@archiver.kernel.org>; Thu,  2 Jul 2020 18:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoegUq2L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A1B12088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5A6101149FF5E;
	Thu,  2 Jul 2020 11:22:28 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=song@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1627F114726CD
	for <linux-nvdimm@lists.01.org>; Thu,  2 Jul 2020 11:22:26 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 52F52214DB
	for <linux-nvdimm@lists.01.org>; Thu,  2 Jul 2020 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593714145;
	bh=2Ob+guxRY0fDcRz+P555VDdl6+UEf5NKd/ZEgEjmyqA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OoegUq2L0uxSt3rrR3lcoqsDAOAxdO0rE6tlewRsGb9eiQzLEa9GcLv3f53+JJtIq
	 Tu4dmdJlB98mXwT/7grCGi1Eg4sXkxKx8O4HxETnxcls0gt5Kok143rso1DF1RnUs7
	 J+0BQhidD4fUWOWUJ491VzOjYlY2TbrXcU05LAhg=
Received: by mail-lj1-f179.google.com with SMTP id t25so28846031lji.12
        for <linux-nvdimm@lists.01.org>; Thu, 02 Jul 2020 11:22:25 -0700 (PDT)
X-Gm-Message-State: AOAM533xtEA1nQSIjqYKYmAen/RyPbmnFD3PCAQ9TDNRiWm3Pvduf5AG
	r+GpGI1S6CtcAEQ52GRgi3La/7JC5W3c6TyBF+M=
X-Google-Smtp-Source: ABdhPJwzHQSAgDG5LZKrrq4sCwOryNIpxeUx+J+pLZvaBWcsyRJefETEyU+mlLl9hUoA9U/QBDPE51PBpf0COAdEZgQ=
X-Received: by 2002:a2e:9901:: with SMTP id v1mr17432874lji.41.1593714143665;
 Thu, 02 Jul 2020 11:22:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200701085947.3354405-1-hch@lst.de> <20200701085947.3354405-18-hch@lst.de>
In-Reply-To: <20200701085947.3354405-18-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Thu, 2 Jul 2020 11:22:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4=eiN2-_cy5vCn_RGwmYRf37jOX4DWTvUCDWAqRzU+pw@mail.gmail.com>
Message-ID: <CAPhsuW4=eiN2-_cy5vCn_RGwmYRf37jOX4DWTvUCDWAqRzU+pw@mail.gmail.com>
Subject: Re: [PATCH 17/20] block: rename generic_make_request to submit_bio_noacct
To: Christoph Hellwig <hch@lst.de>
Message-ID-Hash: ZLGNBE7UZ643BCTMQI76SWZB42XFCNOC
X-Message-ID-Hash: ZLGNBE7UZ643BCTMQI76SWZB42XFCNOC
X-MailFrom: song@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZLGNBE7UZ643BCTMQI76SWZB42XFCNOC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 1, 2020 at 2:01 AM Christoph Hellwig <hch@lst.de> wrote:
>
> generic_make_request has always been very confusingly misnamed, so rename
> it to submit_bio_noacct to make it clear that it is submit_bio minus
> accounting and a few checks.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[...]

>  drivers/md/md-faulty.c                        |  4 +--
>  drivers/md/md-linear.c                        |  4 +--
>  drivers/md/md-multipath.c                     |  4 +--
>  drivers/md/raid0.c                            |  8 ++---
>  drivers/md/raid1.c                            | 14 ++++----
>  drivers/md/raid10.c                           | 28 ++++++++--------
>  drivers/md/raid5.c                            | 10 +++---

For md part:

Acked-by: Song Liu <song@kernel.org>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
