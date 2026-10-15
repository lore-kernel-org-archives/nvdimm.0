Received: from mail-yx2-f11.google.com (mail-yx2-f11.google.com [74.125.224.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA42049B5C3
	for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073941; cv=pass; b=JRt0LiO3EySszXxxpD/swqFSyV4X/PvOBMh3fz/u1wBNWx+5//EzhhQI1bEoJRBBE3QrbGSUgMCdojSeKEwp8c+f3LTJS6vZEMS5FTBxCLqlCjCk3EqdiR3fuxYb0stYUjWsTh7DX0osDsveRiHOKaZ/VzIdbjhta5IYEPZb9DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073941; c=relaxed/simple;
	bh=GE0mUrsglv7uryn8BI9Nl070Uq5d0Ou2kQcEz9yCTF4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kBEkgN/RBEpuzX3vKk7JrksQ7U7zyGiUFky6/0s8nrGrxgHAbPgsRMskW5jFe/wCgGfdV+gRYG+r7GA60tMxob7tMsbR60q8VxPWreZ/FVoJtCtTJ6fafQwJ7hCQULh+vrHqKADiTCJqkgJjZ0xt2+C5pNnAhaZUu0hsXjKoyDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7PQTnpj; arc=pass smtp.client-ip=74.125.224.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7PQTnpj"
Received: by mail-yx2-f11.google.com with SMTP id 956f58d0204a3-66c70f9ad8aso1852173d50.1
        for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 07:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792073939; cv=none;
        d=google.com; s=arc-20260327;
        b=V2BlpQb9bwWAAijeEk4Jh6CfQDbxe4wl/zfiZgybYCO+IVO+NeP37Pn3rPJ3wZM3+C
         B9mRvASO2kpl26vRNtVgPkFeG1NBXrpUz1Qv+rn/GFZmRJglLvuyoNFVDbHxnn5cbxnY
         RM8K4GSaEVC8BKP9PI6hcRiAGyoUH1XjQcaVkKJNqbkchMyqoY7/gf/b+6VZ33S+3xk3
         QwbZZVyyy82EQMDW+pSvdl+hw0A6TUjDWexEMuoQpUaR3wnqHLlRxIq2hYvrrfafSre4
         cGmFuiouSxZvSpbb6DrQhbVXuPxLsIF+YZtcFFxPuCghC8vTbzHQr/pFjMei3BtJuqu8
         HXOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xSN1yQdp8zpcfJuoyWCP9n5+uPspbmcoGBxcmTAtR1M=;
        fh=GVC301w3xeN/jMo0bjMJ6+qBUB3V3Ah2j2Kz5SF7v8w=;
        b=GQaqRMpnbxabURwFMJZYUF0NcOOEoRJcE8XXFKsUSSKjJc8LeFb8FlRVVHGjP3Mg0I
         H9uPAgoCUSZBYhX8L5Jr61mKUqPvRSNT2HoaoXZ2qg0Oq57RnpHH4y6SDbUlECgYynEX
         r0nc2DgxjoTfKcTHpmV1l3y2gGaJgQwl6Dxkx7PNFcjiMXbViuYSW2S8HLnEKXLnSXTC
         IQOyhU/RNaf0nrLXeIQo6686xzQqgbiPkCn3aV/7crY8bSr7WSsj4b+8aHxc5BQmEzIi
         qq36GHJ6KEJXbGRQrYn2j4xjOBOLrNBAC5s/GJ/7eNpjkJ71bgPMuFiTNXpJ3oRWPm0q
         sksA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792073939; x=1792678739; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xSN1yQdp8zpcfJuoyWCP9n5+uPspbmcoGBxcmTAtR1M=;
        b=T7PQTnpjjv9QUfVe2zjhBospFQY2FZeNxVc+U6FQfhR2TFEQp4iqolcWnA8DZNMKXh
         1H6NNSI9sIRbJKsb914coWiLr4Y1JXyYDWnysAr7etkvLGsq5kC+N9FHBbjzxk+IFh8L
         h/NZpu54XmXkP3J/wTdpIpIGkvaH6J1NmbydzPFlVVxHVlGd8oRp5oSNfxv40lPPen5q
         rFf2To8e4yVOhenbnEL0PD5Ve1YmKjItCY7ZR3EGLwydli+SNjgb9Rlrxzs8lzW7A5yK
         wwYMmxcReysrENpUFZR1JBXqBWy5Zl2O0MGVdrBl966h8DeYyVg+IiH66plOoD8uSpuO
         6+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792073939; x=1792678739;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xSN1yQdp8zpcfJuoyWCP9n5+uPspbmcoGBxcmTAtR1M=;
        b=tMYhDfjA7/0MsgEvIzStJv9JoKW16urGxZ9Gvi3wbBP4xloMIGTh6r4qBaZVLsPTy1
         OtE1xVURBSWgvAZYo5eANb/iTggLAxJpgzSgs7rVgPebpJPCEJrEuOzFGa4ggsDiAt87
         OsgiV/8wxJZickoZMHEZi+NrUZR5OtGmtBEccSBvWDxxXhhM4rK0p0Ye+G2POGKgTG3o
         EpiZao128aZJjkai6xqzh6qQ8sK6UAAgkhLhs/+BEJNqqW8QW/pHgu9Au/ylxLZAL5Q1
         HYn4BAYS2D+KdU+Yioecrr5tOmWsOkczFMf36KlFCTmz8Xeak7VDeViDbSPQUY5QbSk+
         RxdQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2gXF96yzkQ4JRz0IGb8m9rwRWwtKbfxvetrXQ5S9eGbPJb4RpO2JnLKvdaMwJ8jobkhPbzUs=@lists.linux.dev
X-Gm-Message-State: AFq9FYLjTMDutxHZQw53RFZ9rMnQ1Rj2HTuAbZzMV9aFtX3hh4y/uwrj
	jSPkcPogiUXAZq13LPOJ/IqY2MPzWDpuqshsTm/YcQfzv7ofgMXf44Y+UEhGV/LczOKguBpMOcU
	VaGkBpNNcTlQP4IvIuOFHjALp173JGNI=
X-Gm-Gg: AYBFou0g1zQJLE3li7POb4ortijoWW9Pbj30QZ8HaPh96DZsIFOrF0hSuhqi5m0mOpx
	39nivfvbX3OXI9oNKzu21aY6tDzOaZx+WBttwLgd7ocov0oVjbOFH2QnJrV7t2YLLIJ9mj68O0k
	Xb4xtEQAb80a1h7nqYmKkSxTL7UNgdLTIvRZfPFPW8zYozD2xMVE61Jzh4A+zJLOcD2HX7X5Ls9
	2v4qbVivmVmLb4r9skzIRmjIAyy4g0Pb4zXOmHkS6D6s3BenVf1JWdAk7NrnXj1yU/oOrDbd9z4
	lHH260rmC6JMwCovUpLzrTWhDvexocQ3A2ahlXUZXpHzFylZKaCkaa/LVoeKW7ayCFmD3Gj20we
	6/YALlRieQBgVnPy3OdGWS1PAweT/r/vXVPxYM8zo4BDe9mU=
X-Received: by 2002:a05:690e:1685:b0:672:f58f:b9c9 with SMTP id
 956f58d0204a3-67936a1faf5mr8821758d50.59.1792073937854; Thu, 15 Oct 2026
 07:18:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261012144925.6728-1-jianyungao89@gmail.com> <as95bXy1IfqNUCFo@bfoster>
In-Reply-To: <as95bXy1IfqNUCFo@bfoster>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Thu, 15 Oct 2026 22:18:46 +0800
X-Gm-Features: AclHuK8aytQ7H4Nncmnmre9ei3UMhClX2_Eg7b6Gz9NoVPwY9-qoKaBctsbcYj0
Message-ID: <CAHP3+4Aea8kfmh5SqTp-dvCBrXEpAS-tUMwmm8aNkgiL4oYuWQ@mail.gmail.com>
Subject: Re: [PATCH v2] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
To: Brian Foster <bfoster@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <linux-fsdevel@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Brian,

You're right, the bug was actually introduced in 0e79e3736d54("fsdax:
dedupe: iter two files at the same time"), not the rename commit. I
will fix the Fixes tag in the next version.
Thanks for catching this!

Best regards,
Jianyun

On Wed, Oct 14, 2026 at 8:45=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
>
> On Mon, Oct 12, 2026 at 10:49:24PM +0800, jianyungao89@gmail.com wrote:
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > When dax_range_compare_iter() returns a negative error code (e.g. -EIO)=
,
> > dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds t=
he
> > positive return value from iomap_iter() indicating more iterations rema=
in.
> > This positive value leaks to the caller, where vfs_dedupe_file_range()
> > interprets it as success (bytes_deduped =3D len), causing userspace to
> > incorrectly believe deduplication completed.
> >
> > Return 'status' instead to propagate the actual error code.
> >
> > Fixes: 39eb05112987 ("dax: advance the iomap_iter on dedupe range")
>
> Hmm.. the patch looks fine to me, but the above commit basically just
> renamed compared to status in this function. I.e. before that commit we
> did:
>
>         if (compared < 0)
>                 return ret;
>
> ... which seems to me has the same problem. So I'm a little curious if
> either the Fixes: is wrong, or I'm just missing something..?
>
> Brian
>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
> >
> > Changes in v2:
> > - Add Fixes tag and Cc stable
> > - Add Reviewed-by tag from Jan Kara
> >
> > v1: Link: https://lore.kernel.org/lkml/20261010021010.19575-1-jianyunga=
o89@gmail.com/
> >
> >  fs/dax.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6ba50142eeb2..1f6a4fbb97bd 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *s=
rc, loff_t srcoff,
> >               status =3D dax_range_compare_iter(&src_iter, &dst_iter,
> >                               min(src_iter.len, dst_iter.len), same);
> >               if (status < 0)
> > -                     return ret;
> > +                     return status;
> >               src_iter.status =3D dst_iter.status =3D status;
> >       }
> >       return ret;
> > --
> > 2.34.1
> >
>
