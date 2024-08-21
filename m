Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A028F1CA81
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 02:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724208412; cv=none; b=dt9voAEMF8JviAx/bdvw0jzz1o981GvLc+PAADDIZFqrtrDoLbm0oY50gkMpzb5bFYuJJPxCR2BU5eCqTzl+UM8Jrm7TAEF9SMUHSqf/Sc0OeuKrBIG8qfA9OLFOg0/h+32lV0E//7EdaCtZUBMt0QQeXjIBfrlPz3g6RaUrH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724208412; c=relaxed/simple;
	bh=5ffCrwx+98BuRFQdrWE2pK2sx399FSfOemoLHXG3ixI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXOMbn1PdasRHiv3K09p5VXmNaRXqekC8GLth97GUE9iMpiNQ0NaRZC15DmQc1QUxEQ26825oj+B96QDGqFqpIES2EcADALVJIJVEJLj/kAO4ueG41yj4YI33ICW2zlTbMNpeGQaVWQdP/JJ1pi94CQq+mray9GKk3dCpsK0CE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ioIQDMkN; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ioIQDMkN"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6bf7ec5c837so25922126d6.1
        for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724208409; x=1724813209; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjQlK/w1X7l7zoTUunhB0pgBWrHMDmZGIJHzaU2XuNI=;
        b=ioIQDMkNoCwUy1CV+7mmr2sGLGwjHBC8kKyODl9tGMiAJ+ocSYvSIMLllt3qh/NLSa
         54g8sJX9nFLIfgpEYjI1lIiDZZG+1id9B3hxm2t4UbA9cZ6TqNP8ivdC0CBUwSA+K5Po
         zukkGIrVj+1H/KsnYK3oHePxrqoOKn7gjP9wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724208409; x=1724813209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KjQlK/w1X7l7zoTUunhB0pgBWrHMDmZGIJHzaU2XuNI=;
        b=iv7yQlsG/CWqh2AB4SlAyyzGDvqLJcHh49USVq3EaHviaTRI2rBt71hRAvbqfjjDW0
         uBEbuS6ydsIE3YKP+R5yhEq2iE+ip+KA7FbS8dCtZzNVJ6QEVxrmbVOIaHQZy4IpX4uV
         3K2HfVlLkOgqXWvQRX+tBcZiPqzPPt7MB5rITAzLTqTBc9LLbWzvUiFSV0/KjkK6fXPB
         +Dj2i5hUJLbmUDSZsxgKBKXtB0i3YRak1mOZGvWELOOjg7wLXGtDdjQurvtt0SY/5MFG
         7cx4x0FFhXzZXhVel9pVEAsAShkc+yVDEuSC6LB03suSLy6eoYN46t24HzSC2pOi639U
         SNAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYl2cLNFG29gmSlXj58l+F0sy0wJFJ1j8kN04/Fc4riDPQm3gBWVR3qclFDls2nxbrxzsJO5I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLD1pVZzd0r9HBYXzk07lCH/d5S97026Tz+2YB7RmYMe3ew3je
	RBN5Jz+HJoEAywa0Ay6cHDkR0cAbiJunOfqv8i9oM52ufld0vcs1UtWJWZayNgF4IGsgELPsDul
	k0EIHP1BdWGULJumLY2DROJE74jV2Xfkys4Vn
X-Google-Smtp-Source: AGHT+IEy16IjVIk++AR2PbHJeMBe06xcx9alXU67L5emPBtwtM9BYEqe4b9oPhs5p/4ItXs4BHcPjzRMMm1C+mtJYmA=
X-Received: by 2002:a05:6214:5d13:b0:6bb:b397:cceb with SMTP id
 6a1803df08f44-6c155de5028mr15373636d6.28.1724208409389; Tue, 20 Aug 2024
 19:46:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815005704.2331005-1-philipchen@chromium.org>
 <66c3bf85b52e3_2ddc242941@iweiny-mobl.notmuch> <CA+cxXhmg6y4xePSHO3+0V-Td4OarCS1e4qyOKUducFoETojqFw@mail.gmail.com>
 <66c4a6d18e811_2f0245294ba@iweiny-mobl.notmuch>
In-Reply-To: <66c4a6d18e811_2f0245294ba@iweiny-mobl.notmuch>
From: Philip Chen <philipchen@chromium.org>
Date: Tue, 20 Aug 2024 19:46:38 -0700
Message-ID: <CA+cxXh=7Vp0LO0jJSwKuX-8W4jAR87N8qagASb=_uqt1=7WN3Q@mail.gmail.com>
Subject: Re: [PATCH] virtio_pmem: Check device status before requesting flush
To: Ira Weiny <ira.weiny@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 20, 2024 at 7:23=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Philip Chen wrote:
> > On Mon, Aug 19, 2024 at 2:56=E2=80=AFPM Ira Weiny <ira.weiny@intel.com>=
 wrote:
> > >
> > > Philip Chen wrote:
> > > > If a pmem device is in a bad status, the driver side could wait for
> > > > host ack forever in virtio_pmem_flush(), causing the system to hang=
.
> > >
> > > I assume this was supposed to be v2 and you resent this as a proper v=
2
> > > with a change list from v1?
> > Ah...yes, I'll fix it and re-send it as a v2 patch.
>
> Wait didn't you already do that?  Wasn't this v2?

Yes, but somehow the patch didn't go to my inbox.
(Maybe it's because there is no code change between v1 and v2?)
So I resent another v2 (with some minor change to the comment):
https://lore.kernel.org/all/20240820172256.903251-1-philipchen@chromium.org=
/
Please take a look.

>
> https://lore.kernel.org/all/20240815010337.2334245-1-philipchen@chromium.=
org/
>
> Ira
