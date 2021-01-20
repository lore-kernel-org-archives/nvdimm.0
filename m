Return-Path: <SRS0=HRiO=GX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A606FC433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 20:38:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E316235DD
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 20:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E316235DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1FF23100EB826;
	Wed, 20 Jan 2021 12:38:37 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::52a; helo=mail-ed1-x52a.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9398B100EBB71
	for <linux-nvdimm@lists.01.org>; Wed, 20 Jan 2021 12:38:35 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c6so20238290ede.0
        for <linux-nvdimm@lists.01.org>; Wed, 20 Jan 2021 12:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=taqAFeRUQ5Sjt3EdHzAPYZnDjLEK6RrWOo7hBOLa+Sg=;
        b=PxT/MciD/bQOrAoYDG5MJeMscifA2EBpPuvloQWYSjqCrVUuPnBmcDKHzop6AdMa5K
         nlAPDqqhC+S4BW9l7ZucY2SAGu7e8pl9jKiMQwCsS1RVWOuOQ6CSan2sgHp1edWibmqZ
         ciU5hfW2EQWDbCAaRowlAqeuRlEi5NSqhC3fdlD5TdgNmEZZJallLzz78JnldgXc2tuG
         cB6dPye5VJUs6g94AdHr+YaiQDp2ufpn0KeuWNYjxzPCyJygQbmNJe5iDbXOEkTqvyOF
         CPxKm60QcR3iglo//vxuGYP1nStSOk664Jo4ts3xLx8uqbbCNCXlGETXixT0gLv7X6Ig
         gNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=taqAFeRUQ5Sjt3EdHzAPYZnDjLEK6RrWOo7hBOLa+Sg=;
        b=gEDjn3OomEOhmxkE97YiqknYh9QIHe83ZhKN1iqiCIFlHfpc9raAA/qNPrIQ3Cjzwo
         7rpzeMutSZtDuO93Vj3ctXWMOawrVowTniDQuw17j08MPFV0sB2PScFLNglPLKhk2aX9
         MHUZliB+fW3BGXoYyMEmuBNyCH3zMd5nP0sJN7mxijGzWGStjgUgFWTgtDKqWe7i6uZO
         8F44KsE282cAUp7SSShNkW5A9aU9lsR0qKSlmonBfFIxjRyk8KYNcXvrgXfo3Zgk6Ys3
         LCv7GUpSTeH0E7i3gCgGON9fEPvefwBvHk4vh7MUQ4xScPjno/dIXlQeM7lhuvKQl1tR
         IzQQ==
X-Gm-Message-State: AOAM532hCTU9RMRuidv/l0VLPTeufF8Gx59Fz0oZuEhcgrScBH/UJovi
	zw9KCYtKEjl6AnW6WcVpDDMjpSZC4gL84r85zr5MBg==
X-Google-Smtp-Source: ABdhPJyNR+rXufJ4s/zf89FiZMZJimyeH3wrtWsvAnZeKKLnx5i7oNVz0lTe4jR6VcPeG3cgx1wz9KgZyqc+4dSBP98=
X-Received: by 2002:a05:6402:160f:: with SMTP id f15mr8613540edv.348.1611175114060;
 Wed, 20 Jan 2021 12:38:34 -0800 (PST)
MIME-Version: 1.0
References: <161117153248.2853729.2452425259045172318.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161117153776.2853729.6944617921517514510.stgit@dwillia2-desk3.amr.corp.intel.com>
 <809823fb-6eb6-8ce9-c49a-d85b03897fc7@deltatee.com>
In-Reply-To: <809823fb-6eb6-8ce9-c49a-d85b03897fc7@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Jan 2021 12:38:27 -0800
Message-ID: <CAPcyv4j8nfFT5=0T5U7rpNnD29XpTaAmNU5fkaA1--CrmWfRUw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cdev: Finish the cdev api with queued mode support
To: Logan Gunthorpe <logang@deltatee.com>
Message-ID-Hash: AVTRWWB2PX37WH2KCUCUYVT2ENYFLUXZ
X-Message-ID-Hash: AVTRWWB2PX37WH2KCUCUYVT2ENYFLUXZ
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Greg KH <gregkh@linuxfoundation.org>, Hans Verkuil <hans.verkuil@cisco.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AVTRWWB2PX37WH2KCUCUYVT2ENYFLUXZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 20, 2021 at 11:51 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
>
> On 2021-01-20 12:38 p.m., Dan Williams wrote:
> > ...common reference count handling scenarios were addressed, but the
> > shutdown-synchronization problem was only mentioned as something driver
> > developers need to be aware in the following note:
> >
> >     NOTE: This guarantees that associated sysfs callbacks are not running
> >     or runnable, however any cdevs already open will remain and their fops
> >     will still be callable even after this function returns.
> >
> > Remove that responsibility from driver developers with the concept of a
> > 'queued' mode for cdevs.
>
> I find the queued name confusing. What's being queued?

Yeah, as I mentioned to Christoph, a bit too much inspiration from
q_usage_count. Perhaps "managed" makes more sense.

>
> > +static const struct file_operations cdev_queued_fops = {
> > +     .owner = THIS_MODULE,
> > +     .open = cdev_queued_open,
> > +     .unlocked_ioctl = cdev_queued_ioctl,
> > +     .compat_ioctl = compat_ptr_ioctl,
> > +     .llseek = noop_llseek,
> > +};
>
> Why do we only protect these fops? I'd find it a bit confusing to have
> ioctl protected from use after del, but not write/read/etc.

More ops can certainly be added over time, I didn't want to go do the
work to wrap all file_operations before getting consensus on the idea
that the cdev core should provide managed ops at all.

The other question I'm posing with cdev_operations is whether the cdev
core should take away some of the flexibility from end drivers in
favor of adding more type safety. For example, mandate that all ioctls
take a pointer argument not an integer argument? The question of
whether wrapping cdev file_operations around a new cdev_operations is
a good idea can be deferred after finalizing a mechanism for managed
cdev file_operations.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
