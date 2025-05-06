Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133B72857EB
	for <nvdimm@lists.linux.dev>; Tue,  6 May 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550615; cv=none; b=Iiy94lugMwrMj3gFJooykXUBH3WDQthgJ52hxKpaTf8aPwXokoQwmPnE8is4vGHH2kwPyVnHg+o2UN/2OGKU0GXrctR4hlxqSX28xzWTCgo5ptNv2uBLUjEA+ZVNQcmc1RDnKn5lMTlDkkWhCxePfXuHQZ2XcOBifqMe3zNwi/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550615; c=relaxed/simple;
	bh=UPskQvYkrxUpUKSU6eggRkM0kZhs49ZXn1vsmfjc6oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gB182gToaAVomh2HXBOiWsxX+eLdNrNSkNY2BI+GL0T7coRwk6hQ5hh8wDQ0X3Cq2/pwZ705hzqy1dP8PeQcTQfOgr8R08rc9e6N3aH9CEMo/QgHdMwoClAVi91Cnj/tcQY87oJkpbPKfPrPVlcLr+bxnhYZ3KgvCj5HpoeybNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=fL80UNRZ; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fL80UNRZ"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-60657f417c4so2793440eaf.0
        for <nvdimm@lists.linux.dev>; Tue, 06 May 2025 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746550612; x=1747155412; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Q5nunoDVPugDexOGX8IwjfNJm1uYPE1x3M/IebA2LI=;
        b=fL80UNRZG3miR5J1ajCl1UdmilYmVz3MT40WyYk5YtajmLS34vBAZ4zQnT++XKq8w1
         Vj4RulHKq2ShORR/FCxOZWoDOqBosR82ppG3Iw/m6aWBRNcRjaoC5e+rmLZygTChwznz
         RLgkLLeK/18Zqx0E4KrtZ3E95ijkZXsFN+27Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550612; x=1747155412;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Q5nunoDVPugDexOGX8IwjfNJm1uYPE1x3M/IebA2LI=;
        b=NJPczTmu9E+8S4qpZ6ufbsqyja4Ne9P1VhSndAzrzuCjyxt2IO6Q7BaYbpCFGSfvX9
         RiKzfcrz2cilp3NAQcKaZJ81qNIz20+J/TAC9r8OjgWli6wxc5Z97CKC1vrDj1VrE4p1
         bCBDmr6y+RpF8mlUqGiLo+ms3nCVCmcP7lshBro6NndbUB7d9a5qjthaQpv158SJDuqm
         f+cqHxX6T+TLvbKf857TzUazNTFe689kzhQlJZgNWJbqBuCvVlz/2fTf1svN4c6V8iQM
         TDgmDXB/9uiig+gluibyuB+dZjaNx+HBgYH0mcpvvihfChj58chzStqXZDw9AcPLdafL
         iT9A==
X-Forwarded-Encrypted: i=1; AJvYcCVuwyvZ5r12xgs24WZzZ51at/5Lo3NvvOd5ErdA96dJJDC2HxumpGBmXz1qy6OJLEWaDFWGZdw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLRaygb/+kNt7mU9LfX6hye5PY7KQCPSgbzLEg61eqWOqOnU0K
	OUG/9Y+uRhlX2D1TWMGBHNfdVKkwWgcqeQVizvflX/CInov7t0cdXpHtgUd1yscngZxvSn/TjqO
	380wBeOFGAy9X/o6WEyClfsaUb1zZ6ZDVskgy9iQUZOaUAunv
X-Gm-Gg: ASbGnctKB0QT8hKrrhzh9RQmf6XdwtlP70Bnd3Yrn4Ooe7Ct+jxZMnbkfjFxbJuBFs0
	VO6YohJjatfX8ce+bfpHLIfFTU6PV2geJTXRAolCSny/h8bz4Q8krLPCNWPYP4BvT+MQJC+7OCb
	QvQIDNOAo7cX+zOqicZcA=
X-Google-Smtp-Source: AGHT+IGJjJepn0gOwuwpfhMDAKJN4TqWIaIZ7UsEzwpTg1tX++SC/L4yjFUv3kDEAUslSG6hvBlXPYOAhZxrMKo+VF4=
X-Received: by 2002:ac8:7e96:0:b0:476:77ba:f7 with SMTP id d75a77b69052e-48e012633afmr162547871cf.34.1746550601068;
 Tue, 06 May 2025 09:56:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-14-john@groves.net>
 <nedxmpb7fnovsgbp2nu6y3cpvduop775jw6leywmmervdrenbn@kp6xy2sm4gxr>
 <20250424143848.GN25700@frogsfrogsfrogs> <5rwwzsya6f7dkf4de2uje2b3f6fxewrcl4nv5ba6jh6chk36f3@ushxiwxojisf>
 <20250428190010.GB1035866@frogsfrogsfrogs>
In-Reply-To: <20250428190010.GB1035866@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 6 May 2025 18:56:29 +0200
X-Gm-Features: ATxdqUFT-fIsXKRHea9-EZCmnVWun07IHA8kCr4QDmzIP2kON1JGlU4dzmYDGDc
Message-ID: <CAJfpegtR28rH1VA-442kS_ZCjbHf-WDD+w_FgrAkWDBxvzmN_g@mail.gmail.com>
Subject: Re: [RFC PATCH 13/19] famfs_fuse: Create files with famfs fmaps
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Luis Henriques <luis@igalia.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, 0@groves.net
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Apr 2025 at 21:00, Darrick J. Wong <djwong@kernel.org> wrote:

> <nod> I don't know what Miklos' opinion is about having multiple
> fusecmds that do similar things -- on the one hand keeping yours and my
> efforts separate explodes the amount of userspace abi that everyone must
> maintain, but on the other hand it then doesn't couple our projects
> together, which might be a good thing if it turns out that our domain
> models are /really/ actually quite different.

Sharing the interface at least would definitely be worthwhile, as
there does not seem to be a great deal of difference between the
generic one and the famfs specific one.  Only implementing part of the
functionality that the generic one provides would be fine.

> (Especially because I suspect that interleaving is the norm for memory,
> whereas we try to avoid that for disk filesystems.)

So interleaved extents are just like normal ones except they repeat,
right?  What about adding a special "repeat last N extent
descriptions" type of extent?

> > But the current implementation does not contemplate partially cached fmaps.
> >
> > Adding notification could address revoking them post-haste (is that why
> > you're thinking about notifications? And if not can you elaborate on what
> > you're after there?).
>
> Yeah, invalidating the mapping cache at random places.  If, say, you
> implement a clustered filesystem with iomap, the metadata server could
> inform the fuse server on the local node that a certain range of inode X
> has been written to, at which point you need to revoke any local leases,
> invalidate the pagecache, and invalidate the iomapping cache to force
> the client to requery the server.
>
> Or if your fuse server wants to implement its own weird operations (e.g.
> XFS EXCHANGE-RANGE) this would make that possible without needing to
> add a bunch of code to fs/fuse/ for the benefit of a single fuse driver.

Wouldn't existing invalidation framework be sufficient?

Thanks,
Miklos
