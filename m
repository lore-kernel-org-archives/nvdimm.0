Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4814D6C29
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 09:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970004; cv=none; b=tgANgmC5etXC8DxZYc5XvSxujZwnBLIAH1HQAYIzDRjh6VPYle5efK3APNNgQ7r7B2SMzteeMBe9V8H8ROUnT3HtptdOupzgckoD4DrAoOJ+aJAjgOXAAPzlmzuX0+Mz2U60qylXnHzEiKqqjKdptERBRzaEKwFS/qd0qjoYGyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970004; c=relaxed/simple;
	bh=42HZk7Eqx7sOIWk8sWRefK14hjH25QPd21VNFE4YkZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DggsWO4LnIUwhSmglA6qd4tiHDmSBxRtbW0SIMv2VvxCRjeW30tLTvk3jjJYlzbPDKDwHvRR8iHMP4iXeO4Vl54Jzp+1eU6wFcInLqw5kMQnYXlSt70x+UgqhLOcUlGjP6XLw6xBiAqGeUM4lPLgLtCNpFbtIvYBhl75VxcwyBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G1bwBU7k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G1bwBU7k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791969999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRwUw3pnIFIx4Z4YHezup2l4Uf0vq02fpJ9Jm9KmqLw=;
	b=G1bwBU7kBR1icyV6CIZ1ZEycVgAAHQwQv1T2DO8+7gUJgK0UgtqBTgl799qla9gakxFe6x
	15RotWObwDO9VZUhqyjgyaaYfmbQK+VHB/NXxYWTcstGk1oDJmIAIVjZnY+hm2jsGHXe2V
	31Ef868PNr81HJmvzUzpnCrwnbNSNIw=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-MdM3UgXhOvmvQkAzmqmbKA-1; Wed, 14 Oct 2026 09:26:38 +0000
X-MC-Unique: MdM3UgXhOvmvQkAzmqmbKA-1
X-Mimecast-MFC-AGG-ID: MdM3UgXhOvmvQkAzmqmbKA_1791969998
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66cdb701595so5272093d50.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 02:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791969998; x=1792574798;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jRwUw3pnIFIx4Z4YHezup2l4Uf0vq02fpJ9Jm9KmqLw=;
        b=Pk8Atl4nVy3QRrk5cp/eyzDq/9yWoGZd7mHNI5fcQH5XYmUZ9PfwOkUW2baal8g8yr
         F8rgPnJShoYS9n+t1qRFQDdImr2kbO1PbiMDOU01lSr6DLvM31fsYFVC1Zck+9CzCtzy
         yygRG5EmsgCaDcmPnQAIQ75T9d3IQo8mQ4mil1uABgywQvvR/bWhUXa556DnSntwAFB0
         492KBIrMt07e+IJAmGeIHsuaAeq3YbmEe0k2V8DnRcu+3d6cTata0DgMNqX0kKwhYamM
         Uzpy0TdmKyoP0rdhA5y0PmK7BH5xL8gDLKymfITUqKXUZvG1SctFyG+5pK1YhJA6Fx3Y
         S4Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzrXSC8onqbTrr3vudN0u+8qCBjfZ957hCjiIyOXzdM8Xfqu2lXnwqyOHedpkbHT/Tcn2zfxPY=@lists.linux.dev
X-Gm-Message-State: AFq9FYIP8I4VnBtWW+wlDIHnc4UO0IAqvjB585iUShyxcuLVnl41FYcb
	ufAD3Uvp4rkPvj/iXv3baQZ2hybLY73qacKd82H199ILk5uH0PZ0vIuHzElYbOGKTMPY143SFMv
	Iy4ZF7Yzo7kqZM7ziMXCA84zt4UqW6S8cr/DWKziEUUXRdz1n7DRxvE4mIgvvWVm1GKDZqH9cYE
	eTjfM2tfKT68q6Wxq82x7MjKs42a7UmRsX
X-Gm-Gg: AYBFou0oD6APdt57RKoH9MSDjs0cSTwbXDVnmg5qstzZ4cr+6vXWA/b20F2r2hFkIPu
	gMxlEycBvOpogH9mJUJ86pciWAfZgXp3tAgMxaXj2cVnVm1yzi9488Kx4th45rD0LbLMtE+ZzmV
	4DIoHvVlT9SCfkoagQjrE/p4UvyWpi/JPpiPft/VoUnOZ4uM7BeNTq
X-Received: by 2002:a05:690e:bc5:b0:679:8da6:28cf with SMTP id 956f58d0204a3-6798da62973mr409274d50.98.1791969997682;
        Wed, 14 Oct 2026 02:26:37 -0700 (PDT)
X-Received: by 2002:a05:690e:bc5:b0:679:8da6:28cf with SMTP id
 956f58d0204a3-6798da62973mr409254d50.98.1791969997182; Wed, 14 Oct 2026
 02:26:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008112004.1899560-1-mszeredi@redhat.com> <20261008112004.1899560-9-mszeredi@redhat.com>
 <sashiko-outbox-164097@kernel.org>
In-Reply-To: <sashiko-outbox-164097@kernel.org>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 14 Oct 2026 11:26:23 +0200
X-Gm-Features: AclHuK9abSLUZzeKyaaWw37ep03femUMbxNrvpPPWXy4b5nrfVP7AH_KbA-fZNQ
Message-ID: <CAOssrKeEOMUHz_Esfi6L0tu0rbd+aMbb9+fi9fzFYu5NWczOZA@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] fuse: add extent map I/O support
To: Amir Goldstein <amir73il@gmail.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	sashiko-reviews@lists.linux.dev, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xt8xoeKtM-lmaGzUZ4p-TLMa_dGby8Uz7FCe4YJspQA_1791969998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[Restored Cc list]

On Thu, Oct 8, 2026 at 1:36=E2=80=AFPM <sashiko-bot@kernel.org> wrote:

> > diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> > index e9ab1aea34e27..040817ad76e94 100644
> > --- a/fs/fuse/passthrough.c
> > +++ b/fs/fuse/passthrough.c
> [ ... ]
> > @@ -74,10 +73,13 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *i=
ocb,
> >       if (!count)
> >               return 0;
> >
> > -     inode_lock(inode);
> > +     guard(rwsem_write)(&inode->i_rwsem);
> > +
> > +     if (!backing_file)
> > +             return fuse_ext_map_write_iter(iocb, iter);
>
> [Severity: High]
> Does this introduce an ABBA deadlock between pipe_lock and the inode lock=
?
>
> For normal passthrough, fuse_passthrough_splice_write() acquires the inod=
e
> lock first, and then calls backing_file_splice_write(), which ultimately
> acquires pipe_lock() via the backing file's splice_write callback.
>
> However, the EXTMAP DAX path added below for splice_write() directly call=
s
> iter_file_splice_write(), which acquires pipe_lock() first. That function=
 then
> invokes fuse_passthrough_write_iter() where the inode lock is acquired he=
re
> via guard(rwsem_write).

Brute force fix would be to prevent mixing plain and ext-map
passthrough.   Might be a good idea anyway.

However I'm thinking about why fuse_passthrough_splice_write() needs
to lock the fuse inode.

Tracing back through git history that inode lock really originates
from commit 2a92e07edc5e ("ovl: add ovl_write_iter()"), which added
stacked writes.  That was copied into ovl_splice_write() by commit
9b91b6b019fd ("ovl: fix deadlock in splice write").   Which was then
added to fuse_passthrough_splice_write() by commit 5ca73468612d
("fuse: implement splice read/write passthrough").

Even for the original ovl code, I don't see an explanation for the
inode lock, but I'm probably missing something.

Amir, any thoughts about why that inode_lock() could be necessary?

Getting rid of it would restore the pipe lock/inode lock order to
what's normal (pipe lock being the outer one) in fuse and overlayfs.

Thanks,
Miklos

Thanks,
Miklos

