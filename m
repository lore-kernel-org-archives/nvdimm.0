Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35090492E3C
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817319; cv=pass; b=cWg5y+udGUfupYZ1dnNOizLXwob+BtxaGq/BazI7jKDW1twRrwHoKy6mBY1wXOroAsDBPWeDhGYAg2MPcScvYok7QSKBxV3X4hWewI2kok7yVh3MnP+RJDN+7yuxTy771aijUuAYS/sqK6+XaTM1hkc1cGjMwlKjGX4VQDwPaVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817319; c=relaxed/simple;
	bh=cOwreW6S5TABEHJlwZlMIIHSrtzIZn+nQff2XWEoojc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRevYt1SWNf1IoSUbxa7sGHO7sSIGASuNhRx/ZerkKFRs+CAjJSbKnLuRhgit0KbkCSAKM0obab5ioWbPbuhpyzpLtBzPMFKzDVHgfFdE0xqGC4juvYAnqrngdHif9Mq3EDI+Lm5bTQXib1esolUrLTd0XNrb5qW9aBcB6c9V6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQ8FkErL; arc=pass smtp.client-ip=74.125.224.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQ8FkErL"
Received: by mail-yx2-f1.google.com with SMTP id 956f58d0204a3-6792fa2ca24so793970d50.0
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 08:01:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791817317; cv=none;
        d=google.com; s=arc-20260327;
        b=Wbv7fyXOBJT42UwYEdeYPuhcQGSwzZ0GaG+vdvMxtyv1MCQrnXD1UH+6SF5jKI0z2r
         v0qQ0EvuiwXVPdYyFxWd2OUmfQFnPyvaljuDQSImjJXsjTiafuv9Dn33nwcyicbbeRzR
         ariVmn6iYxOxKIfpAFNav38m4GpmiHhdR0gwnHoy9FS35R5LBcVeznbSyw2S0qZa9Dpq
         J1L+WZFT7J6QoGQJxnMs44UZ2L9jlnnes47j6oxNlkiza1Wk3UFKn7ougQN2Fg9qGNxr
         zodWGgxZihdRLST2W8ApuXVhfNkvMjAp+aSiQtM1dg63YGmLSb4POttt5bgn4QFjmEuu
         utYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KIAMYnoVUBdUzXVqQqDP3VFDzLpC4xBDzQAPsFXbvk4=;
        fh=lV8dqM6JHbl16lUCunTcKcKrJyK3Ykau8KBiV1eXMr8=;
        b=jSfWwz4Wgh9yit8zwp90HMnc2i4OBDdYK2R5NG9745KsThyLoijlGd8st2ynBKgnf5
         QI+0cQUmaewzdMoLrOdRUAezYjnJbAW1eD3UA4YxXHq05GMfrzW51Jo/K51wjUZiNAQ1
         5HpuQPXRRQUD8fzPLORwBb1dOCOxZfvsbTb0u0EZTnGNFhXst2pEgU+rh80ZMDgIRd5g
         OWQWWqNRgDDOdkpLsgjUT+88XmR4O4S9TloQNaX7dNIgtdaQxp0XpofDHGeIlFf2XVW+
         1YzKe2Bek9CYDh8AawAx4rI7JXX0ILXYkS1ueq+OJlwZQgGmU/uTWxJGsjSw/OTaSMXy
         GjDA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791817317; x=1792422117; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KIAMYnoVUBdUzXVqQqDP3VFDzLpC4xBDzQAPsFXbvk4=;
        b=TQ8FkErLP9JbLQQkcxxbYJitQf73lL0Hht9NecZUxz99ZqgAYRwtyg291WQf9dag/z
         jbo6w+HcEGz0xOQ7kAplPruzeZ1lZHCVAuoEZ7eiVgDVY5AI2HS2DqWO2VvAkLOUNftK
         NrOdvLuZYSU/VX3O7VtmMcWCj9djT/9jCDVFTY7QusUogpI84Vgf9JgIUIQyfp4sIYGI
         wdNHNOBUgnBhUYFAKhl5Nu5b64X+CG4xYQwKWp93UiPDlwCIXmp4LSWMGHhrg7+pMzAs
         Zb5pQV5njLHjdAhMzXvqbkClTX4bAHAkkJ0+JszaB0jFtTR+YVmFERRvK+7Pc0nNcKSz
         VyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817317; x=1792422117;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KIAMYnoVUBdUzXVqQqDP3VFDzLpC4xBDzQAPsFXbvk4=;
        b=O0SxKh9nL3eC8Zp1HkfSggvGZRpkvngFNtkxccn0rYzCMkXUuSYo3yGvdmB1YH+6+A
         hYpzR3zzAyLpZwTrewaoSjF+JFNkReMrza3lqsD6VE/jXmvQsjP2NuP6Dpnh7h/RKxgO
         RfQVS8uGEFq6poGNyrRdJaFQmW9BUAjOPzgZNQKOZa1127NUpx+0P5exV4zAihaYecM8
         o26Qxshy0NN3hIaIOaRo9VrFsZI70iI/y+ZH8zZW78GEIP77SucgDwsWDoRGSxzOlkof
         aA2HNwE5eKe7thpOcnr4QdCXtOHFhW1KjwHY4xFX4yEiVPWJ1jT6CfTGxUxKTww8qXLQ
         rAZg==
X-Forwarded-Encrypted: i=1; AKwUvByHoludu67+fS/Z4NM45JNyKzAOjpyBmrMXsBFQeU4DycG+/Jfa/RVGZWNWY2aO7OfS+U8qbkA=@lists.linux.dev
X-Gm-Message-State: AFq9FYK4/hXnheKkT1e6urdyW3otag21WkY4Pk55dXmgfPAKPt2Q42uC
	oCaZn+RtRfAorHTCbWUp73fv9z87Qx8Hxz3fR/9nx71ScmFiT0+TyejdxWzP6nqalYI/sQXT9a2
	GjM+CD6F6A/AJFiyBczvjsFolNHT8xCk=
X-Gm-Gg: AYBFou2KTXwuOq54eoumrwhe32T0F2dcxc0Y1XnhoW6Oab4HeJ3vkqTmunQNPQd8U6m
	qHZT6/ZP3B7LfEhXVKWmBu8ufdV3R38S8cukcDD0o1bZZKrIHTCpBSifJVnhW7t5BUpJiRqpS8p
	Y86WE8vpKZQgXA7PvinzsRfPSjREHxuCbOEU8+dkzKMWvnZ5KrsLDk6W4XD7cJ6tsxkllZ5EvSU
	2KfX4wkFS8TzRUhmo0WoWPM8E3odpiXUzR7g3Z/1ob158NQHP3rGxxWYZLI3/A8nWEOV+w9dAWw
	AZNsC2yhneP0JJorILlLZp/Rlcis+PKG/dr4qu+2sc9D/filfNqkVA==
X-Received: by 2002:a05:690e:169f:b0:677:ab1e:92a8 with SMTP id
 956f58d0204a3-679369840e4mr3810866d50.28.1791817317057; Mon, 12 Oct 2026
 08:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261011132017.31131-1-jianyungao89@gmail.com> <20261012152830.5406d532@jic23-hlaptop>
In-Reply-To: <20261012152830.5406d532@jic23-hlaptop>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Mon, 12 Oct 2026 23:01:45 +0800
X-Gm-Features: AclHuK8D_Mlx_jmV0S7_mwmzxgLO6vaiUUSAFEJ32lGeOuz-LFaYscxAPVUV5CY
Message-ID: <CAHP3+4CC1DFcUNrWDG7Xg0yi26zQb5DNEp8BLgVyh-Vo5yUHjg@mail.gmail.com>
Subject: Re: [PATCH] dax: fix dax_core_init error return code
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

Thank you for the review!

For the goto err_fs change, I agree it's unnecessary since there's
nothing to clean up at that point. I will drop it in v2.

For the return 0 -> return rc change, I also can't think of a reason
to deliberately swallow the error. I'll keep this change and cc the
DAX maintainers for their input.

Best regards,
Jianyun

On Mon, Oct 12, 2026 at 10:28=E2=80=AFPM Jonathan Cameron <jic23@kernel.org=
> wrote:
>
> On Sun, 11 Oct 2026 21:20:17 +0800
> jianyungao89@gmail.com wrote:
>
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > dax_core_init() mistakenly returns 0 on error paths. Change the
> > error return to use rc so the actual error code is propagated
> > to the caller.
>
> What is the user visible impact of this failing?
>
> >
> > Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > ---
> >  drivers/dax/super.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 45f84b0eb909..0f35f65363ee 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -723,7 +723,7 @@ static int __init dax_core_init(void)
> >
> >       rc =3D dax_fs_init();
> >       if (rc)
> > -             return rc;
> > +             goto err_fs;
> I don't see an advantage in this bit.  It is a fairly common preference
> to error out directly where there is nothing to do.
>
> >
> >       rc =3D alloc_chrdev_region(&dax_devt, 0, MINORMASK+1, "dax");
> >       if (rc)
> > @@ -738,7 +738,8 @@ static int __init dax_core_init(void)
> >       unregister_chrdev_region(dax_devt, MINORMASK+1);
> >  err_chrdev:
> >       dax_fs_exit();
> > -     return 0;
> > +err_fs:
> > +     return rc;
> I'm not sure about this one.  Will need input from the DAX
> folk on whether they were deliberately eating the error return
> here. Not that I can immediately think of a reason to do so!
>
> Jonathan
>
>
> >  }
> >
> >  static void __exit dax_core_exit(void)
>
