Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3774F39844
	for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+fOZ14E"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-533d31a8523so12424371a12.1
        for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 15:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697668812; x=1698273612; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z31RrENcT3Hhy0E5og6HBcX5caES7mIPqdSDtyYrG1U=;
        b=B+fOZ14EyiKuyOc2fCsQ2PmXO/H9gpDUwsxsO7DexovnLxQvUXujbpfCsqLp9Tmkl2
         r1pDZnxbgeWFh7gtKXMzFRanJyh5hNDpDg2EsfRgrQhTvuaSD8fC1Pho0kG+A+7s8How
         Lf5NoFkbdnfVgWAZzw5msx/0BRYiWaC/WHbYSWefAf0iGi/FdEghDbWNbnfJ036J/fI4
         cUvdw7/tr9hpLAQfOoUpAXCsLSGyyFiDSMGIqzvhO9EiZF5X478RQJR3lyyOtQHa2f9M
         BuCud+0oxBNO2cjblCAb4hH3vvSrzbhoU8PCUc+HzrfeRCKck75cyCJEAxS6dB0QM+7g
         N0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697668812; x=1698273612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z31RrENcT3Hhy0E5og6HBcX5caES7mIPqdSDtyYrG1U=;
        b=capionAIYeqklBpSxvD3oE2NI/A18p0m6qiDSnMKVPXWjZupyOsZCPDdtpiIAVacya
         DbadlDRBGlqbaSdoUpcWHPZVP0HowDbvVJX5DRFhQkPnavQAQRANIa+GN9Ts1de8RnD/
         +5iLjGqnby4YtzbVhJ15OBKOvRq+rjwU340dgwZ0VexkkmzGtSw/HTXkTpujWr4vKNj9
         rAiED40UZFW8VBfBjNxwDc/Ra7o+uP1mLDlUFBgBQZScRh10r89DS1JrvGkk6J2EW5Ab
         GnzNOw16nKLwJkwsq5hUleb8Bd6afYTgblxDQmDlSmR+aGZOvWKZK28Fuv74S8p9TzZN
         7jpA==
X-Gm-Message-State: AOJu0YwLFiO+PF8HAkaBjSpGVB4ud3VFyUtEVcel6NqURosQklR6Lrhm
	Rx72+OmKDCDWIWid8mRYkWAmyi+OiOE8rFK1YS4neQ==
X-Google-Smtp-Source: AGHT+IH0xBTpkyaIqW41fCuQjgPF5EQ6reBFxe2nMtEt6ALPr4+x7VzbsUCLJ1SIereHNmuCJlIzzV7NizscD3a+p7E=
X-Received: by 2002:a05:6402:524a:b0:53e:2c49:8041 with SMTP id
 t10-20020a056402524a00b0053e2c498041mr298065edd.8.1697668812117; Wed, 18 Oct
 2023 15:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com>
In-Reply-To: <20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com>
From: Justin Stitt <justinstitt@google.com>
Date: Wed, 18 Oct 2023 15:39:59 -0700
Message-ID: <CAFhGd8o-ftoGQ4qvrdGM2tSYWBqvYbF7Qb7O+UfsbzYxVmU6sA@mail.gmail.com>
Subject: Re: [PATCH] block: replace deprecated strncpy with strscpy
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have a feeling I may have botched the subject line for this patch.
Can anyone confirm if it's good or not?

Automated tooling told me that this was the most common patch
prefix but it may be caused by large patch series that just
happened to touch this file once.

Should the subject be: nvdimm/btt: ... ?

Judging from [1] I see a few "block" and a few of nvdimm/btt.

On Wed, Oct 18, 2023 at 3:35=E2=80=AFPM Justin Stitt <justinstitt@google.co=
m> wrote:
>
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
>
> We expect super->signature to be NUL-terminated based on its usage with
> memcpy against a NUL-term'd buffer:
> btt_devs.c:
> 253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) !=3D 0)
> btt.h:
> 13  | #define BTT_SIG "BTT_ARENA_INFO\0"
>
> NUL-padding is not required as `super` is already zero-allocated:
> btt.c:
> 985 | super =3D kzalloc(sizeof(struct btt_sb), GFP_NOIO);
> ... rendering any additional NUL-padding superfluous.
>
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
>
> Let's also use the more idiomatic strscpy usage of (dest, src,
> sizeof(dest)) instead of (dest, src, XYZ_LEN) for buffers that the
> compiler can determine the size of. This more tightly correlates the
> destination buffer to the amount of bytes copied.
>
> Side note, this pattern of memcmp() on two NUL-terminated strings should
> really be changed to just a strncmp(), if i'm not mistaken? I see
> multiple instances of this pattern in this system.
>
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strn=
cpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.h=
tml [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
> Note: build-tested only.
>
> Found with: $ rg "strncpy\("
> ---
>  drivers/nvdimm/btt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index d5593b0dc700..9372c36e8f76 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -986,7 +986,7 @@ static int btt_arena_write_layout(struct arena_info *=
arena)
>         if (!super)
>                 return -ENOMEM;
>
> -       strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
> +       strscpy(super->signature, BTT_SIG, sizeof(super->signature));
>         export_uuid(super->uuid, nd_btt->uuid);
>         export_uuid(super->parent_uuid, parent_uuid);
>         super->flags =3D cpu_to_le32(arena->flags);
>
> ---
> base-commit: 58720809f52779dc0f08e53e54b014209d13eebb
> change-id: 20231018-strncpy-drivers-nvdimm-btt-c-15f93879989e
>
> Best regards,
> --
> Justin Stitt <justinstitt@google.com>
>

[1]: https://lore.kernel.org/all/?q=3Ddfn%3Adrivers%2Fnvdimm%2Fbtt.c

Thanks
Justin
