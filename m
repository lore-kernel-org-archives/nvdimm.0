Return-Path: <SRS0=/Rsh=32=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,URIBL_DBL_ABUSE_MALW autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BBAC352A2
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Feb 2020 04:52:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23A5A214AF
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Feb 2020 04:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="kSuOC11o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23A5A214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4CBD710FC3175;
	Wed,  5 Feb 2020 20:55:41 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::329; helo=mail-ot1-x329.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A84131007A833
	for <linux-nvdimm@lists.01.org>; Wed,  5 Feb 2020 20:55:39 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 77so4300569oty.6
        for <linux-nvdimm@lists.01.org>; Wed, 05 Feb 2020 20:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvgZCiawwyylGoanGUUQMTXz0wj9mfE270X3TaVYmAo=;
        b=kSuOC11oNNeuqyLsoBjCG+I8YMYmD8gAcvMvR1ARIP5Iplb+aMJLpWeOhoBQTodTzA
         RxE86zOEq4rfKI1qxgvPwJf3KNtupoi73qX2rG19/eJjkUdetvpfLP2xJIhuIhfNhIiB
         WPhKPC9tqNnlbjWCE76onXbbDXgSuI0daEADtKM3Cp3JeofsClnwG1nSxiodeg/AuEFx
         0oevXnJ9J0KR+Lj81/qjzRQ08QpBVFAhZkAEHwwom4/HrLrhSl4CnotjBX8ejlOu0Ubx
         6LZue27Kq/6ldbma0F/6IJ0TI4glo1+4PAc6VijYPqfulyPiYhNSgmq1H5l27t5V9w1Z
         1/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvgZCiawwyylGoanGUUQMTXz0wj9mfE270X3TaVYmAo=;
        b=PU6xtSIfms6ycE4fHQl+ZWDJXOTmK7PEGOelvu6TVagiVLqH8p7fnB/ImkwzBYqj4d
         LaK23zu2BfIz8POLY4J/h8Sta3IEdnPTOx+cNOS2dxbqx6jpIki0PdwAy4JWvXJjctRL
         Pg6u4OuDfRJ26J/Rfn62Rv6FWr5SZNNdH/4ieViu6qmq2VIzA6jnDtgpX2azOZZNu6H3
         sdoWUQdwaN4EKQ2JYOOMCxVFbx8ZIU17Q0mXqjCQ0Ofm1aR8xBoiavwcIeJvWreKTHvy
         0PkOCjxhCmWzn/CZVk8//NDdfvzr7kX6GncA7bv9qaSbBtF9B4AvVHHR6Pni5dj6S4eF
         ekLg==
X-Gm-Message-State: APjAAAVF0ruXqkEi3YtGgoa6Tr/2osApnapl9aaclN6rvNUMjUMg/KEr
	bT7p78YdhWuPdDoimDqD0qy0w9E4mFuYaStg1gFKCg==
X-Google-Smtp-Source: APXvYqy9Ub4gRjOSxHxrUHPcq9y8tQmg4kIiwEVMDPsXCYRr96aQCznSQJrSB6Unk7jX1gPaxgTaIF9rKwImnAXHyf8=
X-Received: by 2002:a9d:1284:: with SMTP id g4mr28347378otg.207.1580964741046;
 Wed, 05 Feb 2020 20:52:21 -0800 (PST)
MIME-Version: 1.0
References: <x49r1z86e1d.fsf@segfault.boston.devel.redhat.com> <20200205192802.GA2425@infradead.org>
In-Reply-To: <20200205192802.GA2425@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Feb 2020 20:52:10 -0800
Message-ID: <CAPcyv4i6Btgb2MSLEPY4Fo_gsVd2HX3zeDen51yvXaNn9p28SA@mail.gmail.com>
Subject: Re: [patch] dax: pass NOWAIT flag to iomap_apply
To: Christoph Hellwig <hch@infradead.org>
Message-ID-Hash: L5COXUIZ2LZPKMAFJCX2UEAJYVAH6HTA
X-Message-ID-Hash: L5COXUIZ2LZPKMAFJCX2UEAJYVAH6HTA
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/L5COXUIZ2LZPKMAFJCX2UEAJYVAH6HTA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 5, 2020 at 11:28 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 05, 2020 at 02:15:58PM -0500, Jeff Moyer wrote:
> > fstests generic/471 reports a failure when run with MOUNT_OPTIONS="-o
> > dax".  The reason is that the initial pwrite to an empty file with the
> > RWF_NOWAIT flag set does not return -EAGAIN.  It turns out that
> > dax_iomap_rw doesn't pass that flag through to iomap_apply.
> >
> > With this patch applied, generic/471 passes for me.
> >
> > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
