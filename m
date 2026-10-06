Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712A3C9EE8
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 21:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791321877; cv=pass; b=b3WTDJDokdang0LtJ/o+YrYS/WgDQdV+sa2j9wscL0/ELY+02q461lPKDaQ6qj9ymCH3x83QVkFTGMUpjbGjzbbm2XQ6iSBGM9K1oe+HVqQVH2ZNQT/8RfRU4xyeAYYJ1bnN23IS60GYKYqcFgEWy4pP7FVqyw91Qygql8iiqow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791321877; c=relaxed/simple;
	bh=j1Wh4CfTGvYBOyAROOZOXrtCRg+GLe0bKN/CGF567eM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gvYtZnx9VVfc2Y1TjAF7zAiAlSLcQW9Xsxt1l1DOwktbLBj9JbNEtfEwoBPLbs7u/ra8Jl/bTcgxH8ISutc9wWGivWTtTc+vwG8YkNDDWduF29XNC6HnJ1iNSZs4kFzuP2nhwLDFm7iEEVwzFwEivdLW2RIhHTxUcJkcSyavyZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SQ1/i3QG; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQ1/i3QG"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6aa9164072cso1786744a12.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 14:24:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791321874; cv=none;
        d=google.com; s=arc-20260327;
        b=WM1YNlJWW4/dq1oDlzei0DOupNCrdxXLfUsl6hc29+iAyC7ztqyOTt/MzD9wOgnG2d
         ICDXl2oVuZs4jNnAmnW6MO8eszSlA573MyMstKAAaaDEKCJu5gOs0nR/6i/8zBTwCHG0
         Y5VvzJmXcqXA9ZgxICHROw/xunol+3HQS3fQdTnN0NaF+aP5X9TNDHpywHjFbSMROckV
         dRh1qgLPbcgYyLFVWErpx4FIt4vcCIqT0yKdx3McVbVe1RaifdZhdyaw5yBHkuDGjW2x
         Ik2ft5FHoMJxJB9OVm21ct+YrEJxAwMD2kU0SCMNUxwVJb3wKEMBrMX0wBO2AX8ALvsv
         KxqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SYwc8JI6t2v5/H4JTTRJtWLrWEc8ZG38ZE/5tQf+csw=;
        fh=YwYSVojvFic8ZI6cGiuJdLTO+ZAGqAQM++iPUh8/e1A=;
        b=ZCEnc8yVuLrF0eYeBzWukQHgjHvQPEkfR19Z0FyVNyo37sC+nlMGUjkK6hA7qTDSv8
         dPKP1YBSSne11cGhr1LsaSuQWldAy9shS++3JPBrXXBzAHl9x0wEdsgDNgSgVqinpDvR
         0cF2uB4EFZG4INyU+dJ93OtyGerw/YAypStnEMXgt5wKDYdo/qrNkmGcc02pMadb259n
         AaQPMwuBk/fuqJsesCKHFd8JCAHA039S3D/ASeazsv9kTok2MG8Qx63x4NjzWwNlfRUU
         zWqBgTsjitkLPouk8uQn8HiqzGBhL5lbGmdaJ7RaWfukle4yK0xz7MrXgPjAbwxME6YN
         7z+g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791321874; x=1791926674; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SYwc8JI6t2v5/H4JTTRJtWLrWEc8ZG38ZE/5tQf+csw=;
        b=SQ1/i3QGFbsatvE7AfyR3yBWL94OmmtW8i7SlpEWxwwFVD5MILjZaHNIGDPWmAuSTq
         hjaaPdRQomlIYEEgKlo1kB/Ro9DPWyDKH+UHy/9KZ78aUCzjXlwWl7RYyISvw5ICx60o
         OCJKOT3wVgiEtK4VC/gfWEg5XYOwDgSE/4NURCtWQCFch41INa1qwS/0857hkc846DNX
         V4UBIceXHoe7yiFyJI8jnKmUn6oQlv5XoGKRbjlVLoK+HK19V5zI7ymb1wr1Yd2MybRp
         EULYVu8jeu1PlTy/c9VF1kp1BWsseyy/GRyev3N8vsS33M64aAI+90EVsBLAuJ1iXQeb
         OK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791321874; x=1791926674;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SYwc8JI6t2v5/H4JTTRJtWLrWEc8ZG38ZE/5tQf+csw=;
        b=uySeTSfkqEuSCC8V2l7b6vP6U2rFNBLbWfos78Ee01rjYw7WpThBw2xvFUhZd1YiQ7
         SCbfUHqITsTwbfmBUBJFVmvZWmo1THlrve2/FibnYLsj36PWsVT7b0SSmZuBvFPKI/1b
         OmpZ74yttJbY5UNoN1sdBXFtuXEzh1x8zGT6z873s5LyVFv+uhxM/ikQ0kQVvF11payJ
         4lEK8gfd5w5NTO5WO0YCwNh8SX4RY99Sg/QxSI3zoEf9kBejOa299RN0w5S9NfgF4mJ7
         v0i3CeqzOqBNY0T0ql8V5sQ76nTjB/SIzdlT8Wgd7VKpYAesk6spV/gpkrN/KeRlK6AQ
         lxKw==
X-Forwarded-Encrypted: i=1; AKwUvBzNRBKKIeGVe4kDPVXkyV7O09ZIdUfmm6EO4Et/6nEv/LYd2oW11KPuWVzqbbz+UQWayl63ru4=@lists.linux.dev
X-Gm-Message-State: AFq9FYLgq68RCdiTmQgLh1gZ1LU7N0GqGjzfAnYTvdHx/WkmZ5P6L/n5
	Em+4SzsL6LERWhyXGbnTGGZonaQLcNjSuZFRp5tmACPMr68APrjRrdN92bF0XJP6Xa+82ncsDta
	OVb5B+e1A/EedLmg+zbT3bdBCKQhwynQ=
X-Gm-Gg: AYBFou0gQZsBd6cW8C+ZKiKbzD6F8WIV2naj/tneT0880GdcDTBmKjCsgTIygUjW5Qz
	QTQ6hzgfjoEkA6zcoevI+xNEQ/smzI3gNCIxnPMnJmpDwo2nKtSEEX/XEqRDjfA1+f6aL/56FG2
	35tQ4Ke25v6TyFNBLHFhn3O4oPcBWvLAeqngCyWDqFImJrf7hLk+z9B70cgsinBLhHPeJlatLLj
	fdx2gRJefZ4wsaeST2KkqhRfSvtEPEExayVOpYoOKM/NVVnkyLmDn8nnmJ4EXORJGBlc/H2SiTm
	hoo4P6F45MalXxx9axuv3tKN67v+89oPVPvfY6qAgA5dqO65cKdin54BXrVTNqLw6Qh53/HDmbz
	MDBNeM1oY23g=
X-Received: by 2002:a05:6402:21d7:b0:6ab:7700:9371 with SMTP id
 4fb4d7f45d1cf-6aff47b52d7mr243717a12.25.1791321873525; Tue, 06 Oct 2026
 14:24:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-4-mszeredi@redhat.com>
 <CAOQ4uxjWCRs59Qpc4t+2=i67rdJkHt=+rH07ZXv7ZzAvTjTm-A@mail.gmail.com>
 <CAOQ4uxi1+WgHJdnRKMD3tp24EOyx7iPByzSKLn_siTVY3_sRDQ@mail.gmail.com> <CAJfpegttAHQAGhE61t-VZqfQv9Z==ovbyLY6qp3KOK_CvjBciA@mail.gmail.com>
In-Reply-To: <CAJfpegttAHQAGhE61t-VZqfQv9Z==ovbyLY6qp3KOK_CvjBciA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 6 Oct 2026 23:24:17 +0200
X-Gm-Features: AclHuK_VeO0DSevIgJfwzhinVGoS4FTfS8bmWH03wQQ5EUrXtEm_7IyCpO31gUM
Message-ID: <CAOQ4uxj76PJiumvXLHoJUKx_=FAueg3WQjYd64=B_TXo581POg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] fuse: support 64 bit, server allocated backing ID
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 3:33=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:

> > > It would feel a little less hacky if we do:
> > >     else
> > >           fuse_backing_files_init_32(fc);
> > >
> > > and set
> > >          fc->passthrough =3D 1;
> > >
> > > inside both of them to gate against fuse_backing_files_free()
> > > called without processing init response,
> > > or without either FUSE_PASSTHROUGH in the init response.
>
> Bigger problem is that IOC_BACKING_OPEN can be done before or during
> INIT.  So we need to take care of that case and the race as well.
> Fixed by:
>
>  - leaving the idr initialization fuse_conn_init()
>
>  - adding fc->backing_id_32 flag which is set by fuse_backing_open()
> after chekcking that fc->backing_id_64 is not set.  All under fc->lock
>
>  - in process_init_reply() checking fc->backing_id_32 before setting
> fc->backing_id_64 and failing the connection if so.  Also under
> fc->lock
>
>  - in fuse_dev_ioctl_backing_create() if fch->initialized is not set
> return ENOTCONN
>

I guess that works, but why the asymmetry between the two modes?

We could check fch->initialized in both _open() and _create()
and then no need for the backing_id_32 flag?

Unless we gate _open() with fch->initialized, then it could fail on
either one of these cases:

                if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
                        return -EPERM;

                if (inode->i_sb->s_stack_depth >=3D fc->max_stack_depth)
                        return -ELOOP;

Quite randomly.

Maybe I am missing something.

Thanks,
Amir.
