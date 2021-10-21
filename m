Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7116F2C81
	for <nvdimm@lists.linux.dev>; Thu, 21 Oct 2021 01:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634780331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n49Ebg7hJsbpmo8GxTO0/87u2/R5z7xkI3cR50VOP44=;
	b=apmj2yzm83II6x+jfrd1skbARrWk9O64YLkxsZ865/Cyp1RYYqREF2tkPDdbekeo1oPezZ
	XJHSeLDl03PWZ7pp9achhnR8qb0J3WBLIXgxWO8Nc/mubB4C+hBsdKI8mgG+7HAfNgklW3
	zW7YiE0udNwkBQ3TJQpUCoLmmchVfn8=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-wfJI85qXPHKJuX4LxI5IDQ-1; Wed, 20 Oct 2021 21:38:49 -0400
X-MC-Unique: wfJI85qXPHKJuX4LxI5IDQ-1
Received: by mail-yb1-f197.google.com with SMTP id e189-20020a2569c6000000b005be95530997so2513869ybc.6
        for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 18:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n49Ebg7hJsbpmo8GxTO0/87u2/R5z7xkI3cR50VOP44=;
        b=FpN02e1EwRBEtXNo+obV6c/R5Djf+7hWengpZzhcIILVYpykpZTg5ikvWvyPf0xefk
         vsK4GXyAZNSE7xormM6Haem+qS8xiWYVWzhHZjg+zWKx9WAlGSLMgCJzCKeq+vocstWc
         xjjdl7O3psV/U1z0f21wLGrETYApHfI+POyhbKLXBpUZPhRa7jTFOqJn32wkkUZT8g5N
         n1jwQuV40zfX0erQq52Xx7ZpiLJxvaFa/amtnqEsi2gC09sAtY73Ayek+GzdzvgBj8Ks
         8kX7Dz6XI6e0f7Jy/2Ka7cLGCWst4ekpKLZ/xPFhA1ZH6EcbdXQhj9fyz8UHcmaQKYOZ
         +5Zw==
X-Gm-Message-State: AOAM530AOcFpMnhnsipumvhVQlQuX+nLNysXZI7Q0TDme8INwh3U3Rqk
	yz3X6tKjo+V8U/eVfQGDaA9GTqC0Ek5YiT0fUGWUkoiwfVVvjgFVdmytIe2AmA25u+AfWgGVjLC
	28ZMbrTRBET8xZ8AQV4e6MBW6LgOnP+HF
X-Received: by 2002:a25:ab61:: with SMTP id u88mr2590212ybi.241.1634780329493;
        Wed, 20 Oct 2021 18:38:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVo0pkDLJPjgqzPt2KK+wocH0qv3UHKcXreEhQUbwWEMGJW8p8Piza05CRZ016U0Lmps0ksZu5R9P5V0S+aEc=
X-Received: by 2002:a25:ab61:: with SMTP id u88mr2590197ybi.241.1634780329301;
 Wed, 20 Oct 2021 18:38:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YXAYPK/oZNAXBs0R@angband.pl> <YXAhzF9qQsTPDfWU@angband.pl> <BY5PR11MB3989976BB2AE9F2B31E55B1695BE9@BY5PR11MB3989.namprd11.prod.outlook.com>
In-Reply-To: <BY5PR11MB3989976BB2AE9F2B31E55B1695BE9@BY5PR11MB3989.namprd11.prod.outlook.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 21 Oct 2021 09:38:37 +0800
Message-ID: <CAHj4cs-CHKgcUyB54sBCGdzbTe-QhsGOjXL8TJ67n+L+WzdqTQ@mail.gmail.com>
Subject: Re: ndctl hangs with big memmap=! fakepmem
To: "Scargall, Steve" <steve.scargall@intel.com>
Cc: Adam Borowski <kilobyte@angband.pl>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"Williams, Dan J" <dan.j.williams@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2021 at 11:11 PM Scargall, Steve
<steve.scargall@intel.com> wrote:
>
> Hi Adam,
>
> This is likely related to an issue that was reported to the Linux NVDIMM =
email list (https://lore.kernel.org/linux-block/CAHj4cs87BapQJcV0a=3DM6=3Dd=
c9PrsGH6qzqJEt9fbjLK1aShnMPg@mail.gmail.com/)
>
This issue was fixed by this
patchset:https://lore.kernel.org/nvdimm/20211019073641.2323410-1-hch@lst.de=
/

And they are still in the review process.

> So the bisecting shows it was introduced with below commit:
>
> commit 8e141f9eb803e209714a80aa6ec073893f94c526
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Sep 29 09:12:40 2021 +0200
>
>     block: drain file system I/O on del_gendisk
>
> /Steve
>
> -----Original Message-----
> From: Adam Borowski <kilobyte@angband.pl>
> Sent: Wednesday, October 20, 2021 8:04 AM
> To: nvdimm@lists.linux.dev; Williams, Dan J <dan.j.williams@intel.com>; V=
erma, Vishal L <vishal.l.verma@intel.com>
> Subject: Re: ndctl hangs with big memmap=3D! fakepmem
>
> On Wed, Oct 20, 2021 at 03:23:08PM +0200, Adam Borowski wrote:
> > Hi!
> > After bumping fakepmem sizes from 4G!20G 4G!36G to 32G!20G 32G!192G,
> > ndctl hangs.  Eg, at boot:
> >
> > [  725.642546] INFO: task ndctl:2486 blocked for more than 604 seconds.
> > [  725.649586]       Not tainted 5.15.0-rc6-vanilla-00020-gd9abdee5fd5a=
 #1
>
> > [  725.677539]  ? __schedule+0x30b/0x14e0 [  725.681975]  ?
> > kernfs_put.part.0+0xd4/0x1a0 [  725.686841]  ?
> > kmem_cache_free+0x28b/0x2b0 [  725.691622]  ? schedule+0x44/0xb0 [
> > 725.695622]  ? blk_mq_freeze_queue_wait+0x62/0x90
> > [  725.701009]  ? do_wait_intr_irq+0xc0/0xc0 [  725.705703]  ?
> > del_gendisk+0xcf/0x220 [  725.710050]  ? release_nodes+0x38/0xa0
>
> On 5.14.14 all is fine.  Should I bisect?
>
>
> Meow!
> --
> =E2=A2=80=E2=A3=B4=E2=A0=BE=E2=A0=BB=E2=A2=B6=E2=A3=A6=E2=A0=80
> =E2=A3=BE=E2=A0=81=E2=A2=A0=E2=A0=92=E2=A0=80=E2=A3=BF=E2=A1=81 Remember,=
 the S in "IoT" stands for Security, while P stands =E2=A2=BF=E2=A1=84=E2=
=A0=98=E2=A0=B7=E2=A0=9A=E2=A0=8B=E2=A0=80 for Privacy.
> =E2=A0=88=E2=A0=B3=E2=A3=84=E2=A0=80=E2=A0=80=E2=A0=80=E2=A0=80
>


--=20
Best Regards,
  Yi Zhang

