Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3E3D969E
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 09:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791280117; cv=pass; b=pWO2CgNtwD6FLMcHweq+fK7GTOIQjt8JkDdICkJ10D2zZymHptaBPQYcHEDiAvZuLYgDrIPhBu1bC9gPZO1YJRTv676bVuvvjUxluaX2fsp4nNiou+eDwN32Fysv1TrxfU+YmerDlfrysaGTcNK+heR0qb0529U/p+bTYRUKyJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791280117; c=relaxed/simple;
	bh=z8C5llEeSas+wDevoi5ayKBoOPvXKhtMoOZYxs8J+Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q9j3VtqLoA4MXR8OfSFQLrnybDp+0ukTlb2S1EUIpy251dmWeno4dGielmnLerBRJBDOk1FkCVrWyRXqWzZ5Y4Lw3+XIg+o5CEn5i9Cg9qm1QJbo2+m84fiGC120OznMUyBZVdergCqyP9nF8nnfkmWVJRVd19MKrx6+H/cDDS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=mSYp4mDV; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="mSYp4mDV"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53440816851so30909221cf.0
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 02:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791280112; cv=none;
        d=google.com; s=arc-20260327;
        b=OZfn3EPyPZLUX9vMhlK1hAtaYo7nQBDxp5O4pZIMnDrLt6vgw+FoOiAnTTyQMLSF60
         6gIhVGZs37xWWC8D+fJTYPrbDeR8AgK/biqhhX5+H1dc2lxd944NyCDVA1G9YLt2XaIv
         iWHRg6yDYT1ZENu9tI4bQumCsiK27xnYDblgBNPrVnfQ+I3O9kkRxMUEd/eRQ3MYD/Ci
         49n+DC99Sb+oeDMHopAwmt8aoce9V9ScuF2KMW3Vpmd99EexDv4HLj09Q/FZLGo72u1H
         P54OC7y7WgJC0yY7+owaaidPix+Wn1sYcdMJvl67j8VPCxLebUDVXr3TuJaarLckGkoR
         uqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/5ZFcmaqybTJP5VKzEwaO+zhe9+eXiIc/pJbQP9+B04=;
        fh=tK92IgG4sw7VRhndkthDu9FC21rtzvPczwlYrD9eLfM=;
        b=P2LYA/O164pRYsjUHYgXxTeN6V+30KB36OJf7At69dOU0fEA7WX3NkjGZPFstz8Lcg
         zGMH0J4RVY0j25QLr1qU55Wtt+NKoAouMEw8nxe2mJ4tNdRK3HJxipplbsqJ3OY44PyM
         vY1BP+03YkUdFmUiOloDvO/dwOHTVrwk9eNSPkYUbklfjTJSZc8/+S0NT2xhq8Tcm+mf
         CpoRds82VV8tbaSFPUNpK2kDJPFaKIQmy4aJgurCbBtMSKMvlnh1QGVhe+ILDdlNeeOM
         VrK4QdT1ro+K0GPttjAMpIMRATXgtFzZjNotGqyFfpQ5IdciwXS2uIq7KBfb7Z7LAf5G
         SpQA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791280112; x=1791884912; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/5ZFcmaqybTJP5VKzEwaO+zhe9+eXiIc/pJbQP9+B04=;
        b=mSYp4mDVTrzyFnRgWwxkEzQb+gh8YEVPz1yKaz8mjUtI8OhoHTi8ghbTOuuCWB39M0
         xJO43T0bROvW+PfhvaQwoFlsScGZjlzL7SaGdtTwfZAXWoqzyqz5rh+rigJvG1ZqkcRo
         M3ex6cN4fEK+c8KPNHhTHsvXvDV3QRQyzD3/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791280112; x=1791884912;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/5ZFcmaqybTJP5VKzEwaO+zhe9+eXiIc/pJbQP9+B04=;
        b=PlPVsE/BbwhouZAr537cUWjg2YZ9MmloB5GVln6QduycgL4vCVwfd9EcqDP9H1E4lu
         bTQJNPorAB5J48g9EgB7NdtBbko65X4A2UL0s7KqtjxiHMc3wj0nLz4jV7X8jOczVjbX
         Cb7KbnV0iv0wWGnYCHT4gJrxO5isMRELBgXdu2AojksAJMhNctzLmCRxQ1RmYclCGPhu
         UcseAzTaphgw2H44IcEF6cvVvUOdajAXp9q2fbD/D4ahvrxriItCEHP9i+8zir6Hjnwr
         VVndGMtUIG1/S4qUhSDm010tWSRGTTPripphz/3naKu7xYyoKcxVfj9z0lfJ32nScP2/
         NpAA==
X-Forwarded-Encrypted: i=1; AKwUvBxzZV24F67ca8z9wEBzENB+ROXMaCPYrXJ+4MvRpT32lAZdjSWGpGh95DzaaRTPI+SbtWeMpFI=@lists.linux.dev
X-Gm-Message-State: AFuF++kmwMUpIln2sj1VHEXMDw9q2B/afPDOrLDi/XCmdSKvm7ZcURgV
	BzS8NQrz99eHqk0IuHRiqAZCaU3C6Em6hgNUDexUd789JKqylKXvzugJVDfh0cSubbVkXIUAaFd
	LWRG/7M3kQcQxTKE4xv2skT7mTVkNyN807L3e9+GPfA==
X-Gm-Gg: AYBFou0piOZtM92mkIct7Lsf1god0L9ACXTKZM8C4j9I4hsaWDlZkEnTl2THg/Nhu9/
	iGBBvSYWWgQsWDaF6iAm1khIo1ypdzfcKaYIiXnQJGQL2Fg0YgsJRa8RLLKDGCYptwjO/gTlQYt
	JdQKC4BHoDOg+OdgQiNExPpCdhNt6sHM+s/BOxs9hB5XoA5mSZZc4jCK96Hzvdjxqe4cFfYRknQ
	s6CiMVoCOjwOjNANq3yxkSbsqh6fHs8zG80Tt47jCCbvlaGpaTCfOpy62jmBlMN6Psps57hC0kk
	RMeCDsplSGV3Yw6lmFVQ3XeksE+AIstPRxkYtdKBIH78znqQiSFiLiQkTkxBDI0NNn+P9eKtEG4
	4QVFCtCIp03pn
X-Received: by 2002:a05:622a:1911:b0:530:f77a:b162 with SMTP id
 d75a77b69052e-53511e4f3f3mr177910411cf.27.1791280112604; Tue, 06 Oct 2026
 02:48:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <asQcBebepPb9CXzS@groves.net>
In-Reply-To: <asQcBebepPb9CXzS@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 6 Oct 2026 11:48:20 +0200
X-Gm-Features: AclHuK80ssbUcTC90bN8pi5U0qILib7vm2yX0MtoI7xgqfk-YgE_-OE-vHSlWAI
Message-ID: <CAJfpeguEUTYk9m7g2gZTMui0yFDYWSGL1SZ9PvoYiCqjDmHp9A@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] fuse: DAX device based extent maps (famfs)
To: John Groves <john@groves.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, david@kernel.org, 
	willy@infradead.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Oct 2026 at 01:37, John Groves <john@groves.net> wrote:

> I see the kernel-side rejects these s/size/chunk_size/ strip extents if they
> are not all the same size. Why not put the chunk size in the header and let
> the extents honestly describe the offset and range that they cover?
> The current design can't test for sufficient strip extent sizes, although
> it replaces code that did verify this.

Not adding chunk size to the header is intentional to keep the API as
simple as possible.

> However, the smoke tests passing isn't fully legit, because the patch to the
> famfs fuse server passes the entire strip size on CYCLIC mappings, meaning
> it just produces a concatenation of ranges - which does not achieve the
> interleaving goal at all. That case degenerates to simple extents.

Are you talking about the case where there are multiple simple extents
each with a different striped mapping?

That case is supported by the API, but not the implementation (since
there was not test case).  If you do a test case, I'll add the
implementation.

> To be specific: each chase/dereference that results in an L3 cache miss adds
> a stall of (1 * MEMORY_LATENCY) to the fault time. This is the good reason
> why I didn't do any chasing in the fault path of the famfs code that you're
> replacing.

Please benchmark against the in-kernel implementation.  If there's
significant (meaning it may have a real effect on a real-life
workload) performance hit from using the rb-tree, then we can add an
optimization.  I don't want to add complexity without actually being
able to measure the gain.

> OK, one more. You're using the rbtree for indexing by file offset, which is
> a zero-based non-sparse range in this case. If this could not be avoided
> (which I think it can) you should use an xarray or radix tree for that...
> right?

Unlike xarray, the rb_tree API is one I'm familiar with. But nothing
prevents switching to xarray if that's a better choice.

Thanks,
Miklos


>
> >
> > Thanks,
> > Miklos
> >
> > ---
> > Changes since v1:
> >
> >  - moved 3 prep patches to fuse.git#for-next
> >  - introduce FUSE_PASSTHROUGH_V2 (Amir)
> >  - lots of small fixes and cleanups (Amir, Sashiko)
> >
> > ---
> > John Groves (1):
> >   dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
>
> Golly, it seems like there's more than 1 patch worth of content from me here,
> but the chipper/shredder might meet the letter of copyright law in some
> jurisdictions...
>
> >
> > Miklos Szeredi (7):
> >   fuse: add helpers for EIO return value with kernel message
> >   fuse: support 64 bit, server allocated backing ID
> >   fuse: support opening 64 bit backing ID
> >   fuse: add support for opening dax device as backing
> >   fuse: add extent map data structure
> >   fuse: add extent map I/O support
> >   fuse: add support for striped backing
> >
> >  drivers/dax/super.c       |  38 ++++-
> >  fs/fuse/Makefile          |   2 +-
> >  fs/fuse/backing.c         | 292 ++++++++++++++++++++++++++++++-------
> >  fs/fuse/dev.c             |  21 +++
> >  fs/fuse/dev.h             |   3 +
> >  fs/fuse/dir.c             |   3 +-
> >  fs/fuse/ext_map.c         | 299 ++++++++++++++++++++++++++++++++++++++
> >  fs/fuse/file.c            |  16 +-
> >  fs/fuse/fuse_i.h          |  72 +++++++--
> >  fs/fuse/inode.c           |  17 ++-
> >  fs/fuse/iomode.c          | 108 +++++++-------
> >  fs/fuse/notify.c          |  75 ++++++++++
> >  fs/fuse/passthrough.c     |  63 ++++----
> >  include/linux/dax.h       |   6 +-
> >  include/uapi/linux/fuse.h |  53 ++++++-
> >  15 files changed, 904 insertions(+), 164 deletions(-)
> >  create mode 100644 fs/fuse/ext_map.c
> >
> > --
> > 2.54.0
> >
>
> John
>
>
