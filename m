Return-Path: <SRS0=ufxj=YL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAF0CA9EA0
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 21:25:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0DF720700
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 21:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="GqAhHxgx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0DF720700
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B05A11007B986;
	Fri, 18 Oct 2019 14:27:48 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::242; helo=mail-oi1-x242.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A44831007B984
	for <linux-nvdimm@lists.01.org>; Fri, 18 Oct 2019 14:27:46 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i185so6397489oif.9
        for <linux-nvdimm@lists.01.org>; Fri, 18 Oct 2019 14:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwIHNgX/2ReCzBnXecUyKisKy+6r38CsMatM1qjPGBg=;
        b=GqAhHxgxH7wfmM/XTsFjzAteyRDmsjzt4rIPS27elKBV/3H4ntPZfplWRTcTWN/B9L
         9c4RAco/ETnZBmckN+7a5ziBNvnps5KjYCAUGE4erCjuTPSm7Fc0y0GR13BrHKhkFtLw
         umM6GVZw5Rtl0nTZ41QshqVk4XiripbJTm3peDLT+HLcjnTzSHiy3GvBQiPPq67qrtsj
         OmERCD8TfSV6b/pzONHEaD8D7mSh7gEukiuqvGNCjX5zFlbbfijw1LSVJwLiHLTNvK6X
         o4iItcl+ro5qcLIPl4tKgBNAbgYUladVhXFqJgN/CEe8uxjv8HiGdBAiEMPewp36s4W9
         qCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwIHNgX/2ReCzBnXecUyKisKy+6r38CsMatM1qjPGBg=;
        b=qMltlNiOs1IVLEtgDYw5nChXXp0F4aZYonEbQniJFC8KXXYAWfNsUQ5CBfMLRsAZPq
         FDJFgKtoIVyb0N3aJMGIYGCZrVYrnVrAnkMTwIKP+FBdtAx/nfMW7SQ7VzxOsKGaHqmw
         12ETeN6B2mbXlk0hNFE7xVOjNPBXDPwI/UiCNzdGm8/cefPyuxpQFdg4ZMc+XKt8MzdQ
         T12dfC2phPzNXjcqPKkD7U3uS6F0Pe454FSbCd6BYypP2fMiE8rbzs5J9PTQVLnY2Zem
         +lh3NZhqyQzZZ1z04ivDyHsXlZtjtXoj7svuEZXS6P5aeSEoQPRh/O/vZgV0X4S1ZEL5
         cv6g==
X-Gm-Message-State: APjAAAU3Fd2VhN//WVdOZDB4WhRcfiT3v7Ip+jDug7HRq607BCN/si04
	QyWyZW7nsdnszyTHYmebM2cJE1zW/qQvsTKIkDjvgw==
X-Google-Smtp-Source: APXvYqz5t7anP0uAMllZmKIQRqeV64ZG2Xryw4xVwtfrRDN6WxkJyDrH9QGh1oHOX5RWxTQT44mFwkz48SNTPdBmzdo=
X-Received: by 2002:a05:6808:7cd:: with SMTP id f13mr9156408oij.70.1571433940333;
 Fri, 18 Oct 2019 14:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191002234925.9190-1-vishal.l.verma@intel.com>
 <20191002234925.9190-11-vishal.l.verma@intel.com> <CAPcyv4hrxMFFK1wvCPkE1hMC8dyVFj3WUAzS4wgCBiuh0noa8w@mail.gmail.com>
 <8b50ca67ffcd36bbc7fd0b23ad4f2e4607e56cbb.camel@intel.com>
In-Reply-To: <8b50ca67ffcd36bbc7fd0b23ad4f2e4607e56cbb.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Oct 2019 14:25:28 -0700
Message-ID: <CAPcyv4idM2A3dj0dz4G9bh=Q8C8OX+vTy2qZxkQzH2sW1i7RSA@mail.gmail.com>
Subject: Re: [ndctl PATCH 10/10] daxctl: add --no-movable option for onlining memory
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Message-ID-Hash: CDY3STYDSCJVZPZ6WMK3H3TA3TK6VIWP
X-Message-ID-Hash: CDY3STYDSCJVZPZ6WMK3H3TA3TK6VIWP
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Olson, Ben" <ben.olson@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Biesek, Michal" <michal.biesek@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CDY3STYDSCJVZPZ6WMK3H3TA3TK6VIWP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 18, 2019 at 2:04 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Fri, 2019-10-18 at 13:58 -0700, Dan Williams wrote:
> >
> > > +++ b/Documentation/daxctl/movable-options.txt
> > > @@ -0,0 +1,10 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +-M::
> > > +--no-movable::
> >
> > If --movable is the default I would expect -M to be associated with
> > --movable. Don't we otherwise get the --no-<option> handling for free
> > with boolean options? I otherwise don't think we need a short option
> > for the "no" case.
>
> Yep we get the inverse options for booleans for free, but we can define
> them either way - i.e. define it as --no-movable, and --movable is
> implied, or the other way round.

Ah, I missed that we get the inverse flag option either way its defined, cool!
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
