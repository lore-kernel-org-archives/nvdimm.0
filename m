Received: from mail-qk2-f38.google.com (mail-qk2-f38.google.com [74.125.230.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4146AA98
	for <nvdimm@lists.linux.dev>; Mon,  5 Oct 2026 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.230
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193630; cv=pass; b=Rk4fp8RbJsY2UvVWLhecz1+nKiajom7RqeetWPrLGHD5iNMoyTnoUD16nHfCc0jla0A/qmSDTv95Z40YGB9PXl2CBNfRH9jTPvmUJ0ESAgAxJMKntaQI9a+zSppHfU4nUavQEliX8NsFTxChdwxpt9bDRAuF6xjH3xL0J0JrQYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193630; c=relaxed/simple;
	bh=t398vXnJkLdtQG+smof72e6y5/ZQ0xhfNFlipmHb3tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iFm3Fh1A8rnMC97clKX11RYx5mWJcJGgydMlnK5ZQ9M94Q9YyXm1gvSMqScT1T4ohSfhzu9Oba38NEzg02yCCLoHtmZ6BoItd7q2FrsEWC2MyrpzLuTQ2T3DT3PrIxdqWfeBdGTebXsnh+LbsqABkloZLI0gUv1awrBdFWzXNz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=jU0Y23rc; arc=pass smtp.client-ip=74.125.230.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jU0Y23rc"
Received: by mail-qk2-f38.google.com with SMTP id d75a77b69052e-533984bfe2bso13869001cf.3
        for <nvdimm@lists.linux.dev>; Mon, 05 Oct 2026 02:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791193619; cv=none;
        d=google.com; s=arc-20260327;
        b=jhp0njzMXQB6fvsCwTKfLNV0pZjaEN++G8C9mkolL/eN0m7WluNneCSbDUNzDeODMz
         6CFHzvfG0E0Q03tGP624+i89dTR14OABz2q/phOAjfrHwm8+vh1+oYD3ztXsdDlg34vP
         R1x0zGsk9OH4EZoCvj1eeE8bhgaLPrlEhXRY63LxRfPkrUgoJs1s19l0k9/iFbB5h9D2
         vUQtuDSo1v3gjKJdWt4CPVHU8756ZJXBx9zOb60DCv7zF6pja8i5yV3/PyFdYQL2PYJ3
         2bPMVXvXrq69U33qLzQTJAVJFjKT2GUOUW4F8N/VSM47hxZOjSflWgVgXnY6teu86Lsl
         CUUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2x+PPGLVG+ZTg2V6l16xtjRBE7YmaOwtXNyp9L8s3Uo=;
        fh=PggOGhEpU2w8/OuBxeIrAYO7KJNDsMXSVmlkN0hC+Bs=;
        b=jKlYbIVqNyInkkHZdOP5tMVfzJ5ie29zsli7/No/+xWR1rh8CZGBeJ82PE1+Op0ft1
         NwubRx+OAy+PgAvJqFtNP5L/shh20DMcJJuHXA1zQ+gchPg/L414077V27rEv1p9vb0U
         b6mEzP3Nj1Ib3P9o5O2iUggZbydiAo5eqcYKMS9b2uyX65Z6wOeImFXSNlmXvrp5fmat
         VfH9s5yqGwUsmrwOWWzJMwWXn1wg09VjpQKjHQnTKt1Xjow3bA+vjqF+jjQYDXwgwF2w
         wjdMUtC2FJGMBB+XAiOESyiQomUr/57zU0zzdODOJ/2qftEebXGwEr39LE9zGzm0ichU
         SVKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791193619; x=1791798419; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2x+PPGLVG+ZTg2V6l16xtjRBE7YmaOwtXNyp9L8s3Uo=;
        b=jU0Y23rcn6aNhX22+ziMUXTIaLljgzWzP58TX0W3i/V7gohneBQPgXHC8TUK1uaJup
         5bS0fBPDxzJCWFcuD9w6o8N5uWZ5wYp3FnmGEABTFRhDsSJSiwDLozipXnKcJRwxozbY
         jvag+glGgsp78bt5j89laaNWfu1IvMhmmh784=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791193619; x=1791798419;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2x+PPGLVG+ZTg2V6l16xtjRBE7YmaOwtXNyp9L8s3Uo=;
        b=RTX8081pemLV+zjc/g4855tMKw/OKcWSGQMf/3Vct9raSC8Rk0qxD0lACU/TtYbNE+
         nIknu0kXQttNcDylCYf27PLYrdzWUzMzn94a5YwtaC0VxrEdBD7FBH/QRfraSqMlEJQR
         YIp1PONHMaESqYpKWKZA1MXUrHWL601pXFji6wEuWIumKJknzIbNwKGVEJzNfKHD6FGR
         dbL0GHuHCr5dsnar/U9puFDKIUDYC4D0oy8taKIyJ0HbTXQI+33hxu5Mlr7iJ5KuP/iU
         FNmz7+X3zNrRqBcSHC9nVFrWLqKNgZZr+0+9ons4vDV07pGoYePWBjVGGrPf7eguvwOs
         YvbA==
X-Forwarded-Encrypted: i=1; AKwUvBzrtnWYS2vM2bT7grg1dj3Iss4vNWVQixPhRcTTDvDx4lagWAHuNgB0gL5iFIoXQfAF7HL909g=@lists.linux.dev
X-Gm-Message-State: AFuF++m//IvW4I8lE4vVDAGKyp0OSQ9IPTbksT9he5aXdCLgjPfNL/MF
	0Cc3sqyCxbeMVwhUPSquHbBENV4SsC1JMKDck+qmvaTocdaM92CYJgP7cJLcrl39Bh/vUPuI73L
	tRfijIlB2HOEtlGQJmWRf36d9hugxLJkNx8vQK6eZHQ==
X-Gm-Gg: AYBFou27Wy1te/CMohzQBEcj4Z0VJICRTNreFshZeFLvlinBtzIIh+LHwv9/jGeZMpz
	OrWHXlNPeTt2xpiZB/GBoLY6La/dv6iOtnUglXazb6nIG2tDz7iy5wDWK7lpHpX9Xicbtkqv6ep
	0ehLvxj6+1L729hyOil3ppweJFReJgsLk+dsVIjc6D/qlXeziT1ndKQV8UMJZh/rCMmY1XQMHhJ
	eGquYmWFJg63yDBfssG+eu9IcSZ8sXrNx5eFf+MKeSm0FoSnJJx3GmKhhuieHuibD23C8eXca+u
	nvaqW9OEVWt9khm0CQ2eK4dJVfvYJ2fW8PW2yYlghr+zT3JH+ynxVfrgDvOBiDJQ88J2udxDvLy
	oEvrL2170BnVl
X-Received: by 2002:a05:622a:4296:b0:533:3fc2:8b19 with SMTP id
 d75a77b69052e-533cba5b5b6mr179731811cf.20.1791193619134; Mon, 05 Oct 2026
 02:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-3-mszeredi@redhat.com>
 <CAOQ4uxjQYaFUG=VT1LoKbs3QUTbTeEy3tTY=_FMujMiWGRR_=A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjQYaFUG=VT1LoKbs3QUTbTeEy3tTY=_FMujMiWGRR_=A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 Oct 2026 11:46:47 +0200
X-Gm-Features: AclHuK_XtJM6zEUYob9rIZaAPpf4JoILbPUmLW2_NodFgyAwj0rWiXxNnekRhk8
Message-ID: <CAJfpegva+dThGSUf0jEhp_9FTyw6f+ZC-5D0F0R-gPPSxXypYw@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] fuse: add helpers for EIO return value with kernel message
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Oct 2026 at 18:39, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Oct 1, 2026 at 5:09=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.co=
m> wrote:

> > @@ -118,11 +111,9 @@ static int fuse_file_uncached_io_open(struct inode=
 *inode,
> >                                       struct fuse_backing *fb)
> >  {
> >         struct fuse_inode *fi =3D get_fuse_inode(inode);
> > -       int err;
> >
> > -       err =3D fuse_inode_uncached_io_start(fi, fb);
> > -       if (err)
> > -               return err;
> > +       if (!fuse_inode_uncached_io_start(fi, fb))
> > +               return fuse_EIO("failed to start uncached I/O");
>
> Why lose the internal error code?
> If server implementation is wrong that is a good hint of what went wrong.
> ETXTBSY is trying to mix cache mode and passthrough mode.
> EBUSY is trying to passthrough to two different backing inodes.

I'll move the error codes back, and turn them into fuse_EIO with an
appropriate message in the caller.

> > @@ -234,22 +228,10 @@ int fuse_file_io_open(struct file *file, struct i=
node *inode)
> >
> >         if (ff->open_flags & FOPEN_PASSTHROUGH)
> >                 err =3D fuse_file_passthrough_open(inode, file);
> > -       else
> > -               err =3D fuse_file_cached_io_open(inode, ff);
> > -       if (err)
> > -               goto fail;
> > +       else if (!fuse_file_cached_io_open(inode, ff))
> > +               err =3D fuse_EIO("conflicting passthrough open");
>
> Same here.
> If we can keep this bit of information and print it - it is helpful IMO,
> even if we don't go all the way to annotate every error case with
> a pretty log.

There is just one way to fail fuse_file_cached_io_open() so I think
this is okay.

Thanks,
Miklos
