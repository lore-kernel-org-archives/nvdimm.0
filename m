Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD198194
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 04:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VI9gFdZB"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c9d3a21f7aso61388115ad.2
        for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 21:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697689972; x=1698294772; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RnOzt84oZghevEg+Rzga2baNzgIg+lwRsncAsrhg8lM=;
        b=VI9gFdZBdSw7WuxPAOsbTdhaItIg/Bf/syjXIevB7L4F+UOTT01xQD1Wa6oJGaUFmK
         eaMrfAbAK/nCV/KRJP0fSv+gwEFMrZQxh+d5UYdit91SMVX9XFawJi8pqAP0UDZ+pzZe
         PwejSxpaMmIfg1a5dU3iftm7aBrk4U9h/Tkf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697689972; x=1698294772;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RnOzt84oZghevEg+Rzga2baNzgIg+lwRsncAsrhg8lM=;
        b=r8e+3yYAKMDlrnQI7Ecp5u7HW7d3i8/QFN8mv02AYgJNqXp5flZYJ5q8xqM7Ng03Bl
         U2plyv8zEBIuvbGEy5CRyoVQPZrykgFHKk0nAIZz70Io/hr9LtLc5SrenGXX3PfdXz1/
         rWPXjgmpiX28dyDCKDcdb6Gb4K7OErCk7jNa0l5AJmk19XdoUjY+tYDOesELTaITEFQr
         96kMmZlWR3/GTl0xazJxs5cj3KHMovlysCSWgKWXdrAUZ9276M6i9UXj3FLvHJS3HxuC
         5/dtKtbvvnw2BZl98Gi8WARdRkFo38GJbx58ATZ567WZRuDhBc8+KdbXrqaft7Vm6uTC
         jddA==
X-Gm-Message-State: AOJu0YwxYhacynYvLzJ8HgyCaslNXxvQONkt0NZmn793RPohtON864CF
	/zP3OdW/4v6F2XO66OQixFnlzQ==
X-Google-Smtp-Source: AGHT+IHcZ00Q1gaUgk3wdtXxOzn5zV9aMtkIZ61OLUJA+xezbdzugupNil1ClsZCxpyUazpV5ZbeJg==
X-Received: by 2002:a17:903:24d:b0:1c9:d7f7:47a with SMTP id j13-20020a170903024d00b001c9d7f7047amr1737831plh.38.1697689972006;
        Wed, 18 Oct 2023 21:32:52 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b001b89891bfc4sm751602ply.199.2023.10.18.21.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 21:32:51 -0700 (PDT)
Date: Wed, 18 Oct 2023 21:32:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Justin Stitt <justinstitt@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] block: replace deprecated strncpy with strscpy
Message-ID: <202310182101.8C98652A5C@keescook>
References: <20231018-strncpy-drivers-nvdimm-btt-c-v1-1-58070f7dc5c9@google.com>
 <CAFhGd8o-ftoGQ4qvrdGM2tSYWBqvYbF7Qb7O+UfsbzYxVmU6sA@mail.gmail.com>
 <ZTBrSb/h13YzE3Ws@aschofie-mobl2>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZTBrSb/h13YzE3Ws@aschofie-mobl2>

On Wed, Oct 18, 2023 at 04:33:29PM -0700, Alison Schofield wrote:
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
> 
> Here's the old school way that I use to find prefixes. Maybe you can
> train your automated tooling to do this, and then share it with me ;)
> 
> I do:
> 
> ~/git/linux/drivers/nvdimm$ git log --pretty=oneline --abbrev-commit btt.c
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

Yeah, this "look into the patch" step is what was missing from the
tool[1]. I've just tweaked it to weight based on number of files,
and the results are more in line with what I'd expect now. The "top 5"
best guesses are now:

	libnvdimm, btt:
	nvdimm/btt:
	nvdimm-btt:
	libnvdimm/btt:
	block:

[1] https://github.com/kees/kernel-tools/blob/trunk/helpers/get-prefix

> Use nvdimm/btt for your patch.
> 
> A bit more below -
> 
> > 
> > On Wed, Oct 18, 2023 at 3:35 PM Justin Stitt <justinstitt@google.com> wrote:
> > >
> > > strncpy() is deprecated for use on NUL-terminated destination strings
> > > [1] and as such we should prefer more robust and less ambiguous string
> > > interfaces.
> > >
> > > We expect super->signature to be NUL-terminated based on its usage with
> > > memcpy against a NUL-term'd buffer:

typo memcpy -> memcmp above?

> > > btt_devs.c:
> > > 253 | if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
> > > btt.h:
> > > 13  | #define BTT_SIG "BTT_ARENA_INFO\0"
                             1234567890123456

That's a funny way to define a string. :) Now it has two %NULs at the
end. ;) It doesn't need that trailing '\0'

#define BTT_SIG_LEN 16

And then this could be:

#define BTT_SIG_LEN sizeof(BTT_SIG)

But anyway...

> > >
> > > NUL-padding is not required as `super` is already zero-allocated:
> > > btt.c:
> > > 985 | super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
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
> > > Side note, this pattern of memcmp() on two NUL-terminated strings should
> > > really be changed to just a strncmp(), if i'm not mistaken? I see
> > > multiple instances of this pattern in this system.
> 
> I'm not following this note about memcmp() usage. Where is that?
> 
> > >
> > > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> > > Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> > > Link: https://github.com/KSPP/linux/issues/90
> > > Cc: linux-hardening@vger.kernel.org
> > > Signed-off-by: Justin Stitt <justinstitt@google.com>
> > > ---
> > > Note: build-tested only.
> > >
> > > Found with: $ rg "strncpy\("
> 
> How you found it goes in the commit log, not below the line.
> 
> > > ---
> > >  drivers/nvdimm/btt.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > index d5593b0dc700..9372c36e8f76 100644
> > > --- a/drivers/nvdimm/btt.c
> > > +++ b/drivers/nvdimm/btt.c
> > > @@ -986,7 +986,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
> > >         if (!super)
> > >                 return -ENOMEM;
> > >
> > > -       strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
> > > +       strscpy(super->signature, BTT_SIG, sizeof(super->signature));

Yup, this looks right to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
