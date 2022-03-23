Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08DECD
	for <nvdimm@lists.linux.dev>; Wed, 23 Mar 2022 02:44:40 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id l2so279940ybe.8
        for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 19:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=efPMQeriJeIkgLVViTGao/zapncCWaiAM0zgGbtLSsw=;
        b=dUM+iDw694EijRSlA098+Fx/aB5+wlja0KvLxv5bOItEnfLDndBOKYUYoL13oP9w4g
         z71UCL+N9Bgbkj4OLZG80dLaXLdvQ67057nb7bCNcm5Mdppy7XkSdb3YH8hGh90jW3Li
         mwsCbtDOrrplqS6Lbd0x1vegri0TaSlKVJX7vhWmSc9GAnyTyA/yF4refuvtMjEYJ9pg
         nezWRQYCQWBY9IgSCAcEaxhGbwuhXI9ZMjLsdNorE79icKTYJaSkuxo4scLBWsDpX8aa
         Ex0UTtiZtAf1M8s6SX1nzjxsN3CAU9cdDZ1ZHBYAn2SFsolUjmtoW3zVUpFGUXgBeKqF
         RlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=efPMQeriJeIkgLVViTGao/zapncCWaiAM0zgGbtLSsw=;
        b=i8QELZed7FBhRuGZGBYx0P5tftOmxyo5vfn3VXg/rsDT5JdP7vrU4Uacy8VX6u4vbd
         znHLVCoQZ7SFZ4KzPKpx2RPknJK/+7HjCxAgl2fqi8lllBgndUuM0sL14dzZnrMbY6Gi
         qJASZST5PkM3jpcYxoR0d9IJL3gnhnw322UEFCGIlTszLAuMGIJdyZGHQ17tAd3XkZ3X
         mErRVn87uUJOTtTM4t27gZhFAk0oGUV5C55rZTtfcKkCUeX8dNyOjKUAOs2k+DtriiQl
         gQbTIWMKuEp0zBxPG30MYCh+fZDW7Yfi3efgqenbalQ4vpIopmU2R8h9NqMfkv5pa7DN
         Y0jQ==
X-Gm-Message-State: AOAM531yU8TgbUcqmEu17EzBNJdG+jSxDOAj7O6iZwjAVCT2nu2MEFLt
	3XqY0D31UDwD/QevowLD07MihXUtZh0GFjYnGfI=
X-Google-Smtp-Source: ABdhPJxwzEL+ANDiAAScHbUzhwo9EcOoCzYihDuQY0KTv9hhQV5/TyE+9tWXd4qaAbOMNQ9Xs6c5YTtmK0aUuXcDaDg=
X-Received: by 2002:a25:af41:0:b0:633:905f:9e9b with SMTP id
 c1-20020a25af41000000b00633905f9e9bmr30331661ybj.77.1648003479564; Tue, 22
 Mar 2022 19:44:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220228094938.32153-1-yaozhenguo1@gmail.com> <CAPcyv4i=1BaEMSJsQWrmPx7ycMTVWXB035xmP8Rc2WEr976Y2w@mail.gmail.com>
In-Reply-To: <CAPcyv4i=1BaEMSJsQWrmPx7ycMTVWXB035xmP8Rc2WEr976Y2w@mail.gmail.com>
From: Zhenguo Yao <yaozhenguo1@gmail.com>
Date: Wed, 23 Mar 2022 10:44:28 +0800
Message-ID: <CA+WzARn0St6+oxqnyxBjP0MgzmzBqGX79TvB3A7TAMA5R0Pbbw@mail.gmail.com>
Subject: Re: [PATCH v1] device-dax: Adding match parameter to select which
 driver to match dax devices
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, =?UTF-8?B?5aea5oyv5Zu9?= <yaozhenguo@jd.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I thought about it carefully. Indeed, in my scenario(virtual machine which =
use
optane as DRAM), device assignment can be performed in userspace at very
early time after the system is started. This patch is not needed in my
scenario. Thank you for your reply.

Dan Williams <dan.j.williams@intel.com> =E4=BA=8E2022=E5=B9=B43=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=B8=89 10:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Feb 28, 2022 at 1:50 AM Zhenguo Yao <yaozhenguo1@gmail.com> wrote=
:
> >
> > device_dax driver always match dax devices by default. The other
> > drivers only match devices by dax_id. There are situations which
> > need kmem drvier match all the dax device at boot time. So
> > adding a parameter to support this function.
>
> What are the situations that happen at boot time that can't wait for
> initramfs or userspace to move the device assignment?
