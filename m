Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598636B17
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjbYrqDn"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-507b96095abso5593985e87.3
        for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 10:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697738361; x=1698343161; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPpqFnRlR4uSK16DavFgn7RP6vUonhIX0hmH74GxJEI=;
        b=mjbYrqDnkj18LAWb1Cr/b3/gqgPfdUc5kny1mVNacHJBwAn0nzEctsrm1XuY6DwkdZ
         1+rfbL7qpyPDM6vMof/3yieuM28Fy+5p0zcNWeophWDa2efW01iR6+GSQpWnf+B9Lhzf
         ckhC5w16BpbaJaQN+PiyP1d7cncVk+XZTaZimH3AFRBM+Gs5Gkt479WxkNKnjF6Nraar
         WTeyusXoNTb9skpwm6s7E77xQOdsHZUTotuPu60OGHa9uOmHbjunND+JytTel9CiIik5
         QPzrMaT8hWar30TLl2v21iifsg3pg7aVFGcMOpV4MuHs97fe2/sJAkHlobdOAepeA97i
         E5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738361; x=1698343161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPpqFnRlR4uSK16DavFgn7RP6vUonhIX0hmH74GxJEI=;
        b=s3dUZ5eODF44NgfbM156/Eolp8wzqpI/v0T/LSu5TCX/GbuCTl8AOaguXExp0iiuOH
         8kOyYyejaIS0K5h3AFMo4u7Kbv74SjpBeEmrRFMQ8DbMIdmlGsA7Wy3O6mnKCx7yvNIY
         4lvUJmlIADZlBq5coQikU+rgsUbQVuKVQLbw/sVNMrMuco+tN+3u19TY9AsXp+tRjp3U
         rGMaVrktoLR4Ok2UrxWNYv3Z59Uou0kvlR9OGsUm+SufnpfVXXuovAZSEQlj9FZ9C6Eq
         vZyNPP9k5b85nT8M583BhK+PPSVgff5YR7CCXB4TZk2p8pYlXVErvpkIw/TS1Tv1dv9h
         viKA==
X-Gm-Message-State: AOJu0Yz5q8hXECoBHrjFgeG4Ec4UDb/JKFyMJkcCnEkhyrrTm2L3yPi4
	1KNfHTkQVI5kmKPQs9MHRYofricYfdYpDZKuA3okHg==
X-Google-Smtp-Source: AGHT+IGZf3CoKIiKhyBtdv8sWG6RzJ6x50GjhcgoVZKdnvbl0TdRVmE4DPWaxT7rZJE37reFkRerDzjsiL6e4QWS7oY=
X-Received: by 2002:ac2:5052:0:b0:4fb:94c6:fd63 with SMTP id
 a18-20020ac25052000000b004fb94c6fd63mr1983277lfm.17.1697738361215; Thu, 19
 Oct 2023 10:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com>
 <CAFhGd8o-ftoGQ4qvrdGM2tSYWBqvYbF7Qb7O+UfsbzYxVmU6sA@mail.gmail.com> <ZTBrSb/h13YzE3Ws@aschofie-mobl2>
In-Reply-To: <ZTBrSb/h13YzE3Ws@aschofie-mobl2>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 19 Oct 2023 10:59:09 -0700
Message-ID: <CAFhGd8pC+uhovQPezcWoddFgPaJjB3Hpf1sTOhiKgMfRLsAFrg@mail.gmail.com>
Subject: Re: [PATCH] block: replace deprecated strncpy with strscpy
To: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 4:33=E2=80=AFPM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Wed, Oct 18, 2023 at 03:39:59PM -0700, Justin Stitt wrote:
> > I have a feeling I may have botched the subject line for this patch.
> > Can anyone confirm if it's good or not?
> >
> > Automated tooling told me that this was the most common patch
> > prefix but it may be caused by large patch series that just
> > happened to touch this file once.
> >
> > Should the subject be: nvdimm/btt: ... ?
> >
> > Judging from [1] I see a few "block" and a few of nvdimm/btt.
>
> Hi Justin,
>
> It should be nvdimm/btt because it only touches btt.c.

Got it. I just sent a [v2].

>
> Here's the old school way that I use to find prefixes. Maybe you can
> train your automated tooling to do this, and then share it with me ;)

I use a gently modified version of [1] which I've hardwired into my b4
installation to automatically set the prefix when creating a patch.

>
> I do:
>
> ~/git/linux/drivers/nvdimm$ git log --pretty=3Doneline --abbrev-commit bt=
t.c
>
> 3222d8c2a7f8 block: remove ->rw_page
> ba229aa8f249 nvdimm-btt: Use the enum req_op type
> 86947df3a923 block: Change the type of the last .rw_page() argument
> 8b9ab6266204 block: remove blk_cleanup_disk
> 3205190655ea nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
> 322cbb50de71 block: remove genhd.h
>
> And I see a few choices, with 'block' being pretty common.
> I peek in those patches and see that block was used when the patch
> included files in drivers/block AND also in nvdimm/btt.
>
> Use nvdimm/btt for your patch.
>
> A bit more below -
>
> >
> > On Wed, Oct 18, 2023 at 3:35=E2=80=AFPM Justin Stitt <justinstitt@googl=
e.com> wrote:
> > >
> > > strncpy() is deprecated for use on NUL-terminated destination strings
> > > [1] and as such we should prefer more robust and less ambiguous strin=
g
> > > interfaces.
> > >
> > > We expect super->signature to be NUL-terminated based on its usage wi=
th
> > > memcpy against a NUL-term'd buffer:
> > > btt_devs.c:
> > > 253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) !=3D 0)
> > > btt.h:
> > > 13  | #define BTT_SIG "BTT_ARENA_INFO\0"
> > >
> > > NUL-padding is not required as `super` is already zero-allocated:
> > > btt.c:
> > > 985 | super =3D kzalloc(sizeof(struct btt_sb), GFP_NOIO);
> > > ... rendering any additional NUL-padding superfluous.
> > >
> > > Considering the above, a suitable replacement is `strscpy` [2] due to
> > > the fact that it guarantees NUL-termination on the destination buffer
> > > without unnecessarily NUL-padding.
> > >
> > > Let's also use the more idiomatic strscpy usage of (dest, src,
> > > sizeof(dest)) instead of (dest, src, XYZ_LEN) for buffers that the
> > > compiler can determine the size of. This more tightly correlates the
> > > destination buffer to the amount of bytes copied.
> > >
> > > Side note, this pattern of memcmp() on two NUL-terminated strings sho=
uld
> > > really be changed to just a strncmp(), if i'm not mistaken? I see
> > > multiple instances of this pattern in this system.
>
> I'm not following this note about memcmp() usage. Where is that?

Sorry, I wasn't very clear. I've added more info in [v2] but tl;dr is that
it seems weird to me to use memcmp() on two NUL-terminated strings
when we have something like strncmp() or strcmp() for that purpose.
See [2].

>
> > >
> > > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#=
strncpy-on-nul-terminated-strings [1]
> > > Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.=
en.html [2]
> > > Link: https://github.com/KSPP/linux/issues/90
> > > Cc: linux-hardening@vger.kernel.org
> > > Signed-off-by: Justin Stitt <justinstitt@google.com>
> > > ---
> > > Note: build-tested only.
> > >
> > > Found with: $ rg "strncpy\("
>
> How you found it goes in the commit log, not below the line.

Whoops, fixed in [v2].

>
> > > ---
> > >  drivers/nvdimm/btt.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > index d5593b0dc700..9372c36e8f76 100644
> > > --- a/drivers/nvdimm/btt.c
> > > +++ b/drivers/nvdimm/btt.c
> > > @@ -986,7 +986,7 @@ static int btt_arena_write_layout(struct arena_in=
fo *arena)
> > >         if (!super)
> > >                 return -ENOMEM;
> > >
> > > -       strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
> > > +       strscpy(super->signature, BTT_SIG, sizeof(super->signature));
> > >         export_uuid(super->uuid, nd_btt->uuid);
> > >         export_uuid(super->parent_uuid, parent_uuid);
> > >         super->flags =3D cpu_to_le32(arena->flags);
> > >
> > > ---
> > > base-commit: 58720809f52779dc0f08e53e54b014209d13eebb
> > > change-id: 20231018-strncpy-drivers-nvdimm-btt-c-15f93879989e
> > >
> > > Best regards,
> > > --
> > > Justin Stitt <justinstitt@google.com>
> > >
> >
> > [1]: https://lore.kernel.org/all/?q=3Ddfn%3Adrivers%2Fnvdimm%2Fbtt.c
> >
> > Thanks
> > Justin
> >

[v2]: https://lore.kernel.org/r/20231019-strncpy-drivers-nvdimm-btt-c-v2-1-=
366993878cf0@google.com
[1] https://github.com/kees/kernel-tools/blob/trunk/helpers/get-prefix
[2]: https://elixir.bootlin.com/linux/v6.6-rc6/source/drivers/nvdimm/btt_de=
vs.c#L253

Thanks
Justin
