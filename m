Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272874A92F5
	for <nvdimm@lists.linux.dev>; Fri,  9 Oct 2026 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542415; cv=pass; b=lR8Lxf805q68fG0wlLfjRKIRZvf111QlDWQ9pfjpk7YD2O+JrKJbF2/nLAgaUzuoMvZrb7Mb3PN5jA5y6favf2v2rEMXjEENiX2cKJhLBO9tAcO6qTGO0HNEvZj08AHOOSlAfiD3djwB6PkeNuBfyfGXrQBXkV5tEGS90n25hkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542415; c=relaxed/simple;
	bh=TdmxEYfYtkSXgsQopCBGSZ8pT5p6msP1oRfZOE4Yi+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fHV7CxLzqdLnpO4MyCLSwUuM5xCIKdhXnYQK5xm3z67zJ7RYHCgw2wQJwD3mAx1+P6GM1wpQWiMBVHOXKzOQy/NIePfm4586Q3OzB3lnu4/c/0BDGZOdDiBpcIGeov2MouI9S8wQ/IBNvc2Ug82Pr6+AjbQYy66xGh3Py49oD34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=RCUR+Mc0; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="RCUR+Mc0"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5338c1197easo50967901cf.0
        for <nvdimm@lists.linux.dev>; Fri, 09 Oct 2026 03:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791542412; cv=none;
        d=google.com; s=arc-20260327;
        b=WmG/FaJdwLQAEztsXLvcN+P7P3gRMAzeIlrvE+wk3QVVX/uyvtZOWgasC07p34t6So
         vjwfuvMUajcCsG4hmGMjQHP8W9+UfVRwwlHaHsoaOggGuqPbQPSpsdhuNuqN3EKHgh3a
         tKk1FiZT78DatO1juBhzuK8VQZELote2NNtWhIdigS9DkTgQ6M8hqB9Cd8ReA6CWcn4X
         w+SdFLQbibvZENVAmIQyFanQ18XVtA8EsodRw4Sot221Jo3o3Bcvzmp8A1Ks/tcgK53a
         vyDr5UIjmJLHHco0I+bKWXVF8tKiY7DrQKBUNoHF6fgmxE2dwTwtygJPoS6kn/kXjhHW
         g1Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Dj6hvZEw0Eh9ZS8EwZEyRVpYOqz/OSg7EGiwmx0le9o=;
        fh=Ih5LigMjYEj6tq+Lu5077TDL31d+N+hzTXhJ2bodsc0=;
        b=NhooPJhSBnzpVWZPnvIj489xgT2BRWlLBpg79w5Zv0SY1BqDGNnv9kkS9k2JjgW/rb
         LaKkCXEkbPcEhUZ3SMIcAFYm6cprJu4e3lWjc7uRi0RGNekxjgLsDkURL0shZhdTGoIE
         C4y1y+GV2Qd6S/r5MutDrom5i4IpW6d9dCufUNl66skOZfj27Lgcf0OM3qleSKlUEvJu
         XF5EgESWTawIbqYd7k8GDpqyzfoG6Knm5hG7WPfzNk96h4H1UMXAyxbxVwhezb99LGgv
         usPKXE8sIE0jZ9OnEjWs4YWEqsyV3FgNeM3fHD3I8cNkBQfQ7Fzx7dNYZWqAgqsQNt0Y
         XneA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791542412; x=1792147212; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dj6hvZEw0Eh9ZS8EwZEyRVpYOqz/OSg7EGiwmx0le9o=;
        b=RCUR+Mc06oiX9lCu1sHvZ2vZftCHr7fw60m2uDmzLYEe95/EY3lJW0LC6a/+yY7upb
         2zo/UkA1muXGRXJenVZ/Ha5FBcD9migzSzFgTJXrKR/q2asuACr1ULUYa3cKKyDtBpR2
         hfGNmQ4rgRDmwFSL2RbpOb5cNRmx3UrPyckxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791542412; x=1792147212;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Dj6hvZEw0Eh9ZS8EwZEyRVpYOqz/OSg7EGiwmx0le9o=;
        b=0XymjGR6Ku1sQtgZS4WDxLixVp8JEIW7PRA+O47pFo360KeviXfdGBuAR1MaQlxPEu
         qa2ekyLSkHNQ619GyT2SVttt+Ge8ZoWZhvhbWzauhsQL7TnFWtG+x9DR1OxsTD0AywEh
         lTI086U5tiBGMnG0WDNZZngA9tYnE3hDiojrnX9jQXMxfa4edzcoJvyILpM5OZINvMeB
         YLsAMrzvhhZPzEJ28pKCEJZP6wPdlkEmwyTWIXC8RDqT+oA+gl6TPz9f/8jIfHUeJUzh
         UOy4u0mXiqH84F4+SkYoSN9wm/K3bRRQCVUa9U0pQYhFFQ8arQbPKGms9FGcI/pE4HJT
         8hNA==
X-Forwarded-Encrypted: i=1; AKwUvBwJs9waMRHG51KeFeDK7/0GQwLW5dTn0J03N+0DauIbSwnGyG86rIjcgoOuqi0wEuFV4dhlGI4=@lists.linux.dev
X-Gm-Message-State: AFuF++l1/aWC6+juTpKfzTx643M6PG40YFdSh4NrS3GUeW+4KdM0LrsC
	J8xqCHWN8/CtHEa6taEGDaHN/mV4BWKpRCo79aDw7hMFDTxbeCp+h0TUP3MX1/Q99zkWluuLqnN
	d8lVZR/5zg0rfIJP9KjHo7hc1wyxDYXUqBeIkY47fwg==
X-Gm-Gg: AYBFou35PvfXICcaJ2keNHh+qu+qTatuf1S4wUM5LmzWGuK0mwafz+9engd8OBXcGhk
	vo0+L2bAFbad9FnL0V1l6AVOf6yC45EiFyonAPSf7ZMtDldZHgVVAC6QJPXJ1LJkEPfwyeZpu2b
	sPhH3mT3ONBPuZpjNvQR0ogZSPj3cTCt1Zdd1MeQfEReMco+ZtUfwOqBIavxRhWo8FyDBISujT1
	L3PECKAsj3bWfbF39aMV0r5UedN4tCyjorMD1ptZ7Kj2mMvMVrTi53PpDjPFtPTN97Vt6zQcHGc
	MPtPGc2yk9qbZDzZakvVVJaehuNYlRa6H5R/OT3vli1Y65ZqLCfoHMsGU1jB7Z/Sc6dXbgaXYEO
	W0xqF3jWf0ns/
X-Received: by 2002:a05:622a:54b:b0:533:6f90:9e7e with SMTP id
 d75a77b69052e-5359fa918b1mr20240541cf.27.1791542411710; Fri, 09 Oct 2026
 03:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <asQcBebepPb9CXzS@groves.net>
 <CAJfpeguEUTYk9m7g2gZTMui0yFDYWSGL1SZ9PvoYiCqjDmHp9A@mail.gmail.com> <asZcsPT-Q8qga0SU@groves.net>
In-Reply-To: <asZcsPT-Q8qga0SU@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 9 Oct 2026 12:39:58 +0200
X-Gm-Features: AclHuK9bZ1vBizXVx85EODvHCHAG09uRctj1VxFiQmSS5BJHJIYfB0DeoAwYH60
Message-ID: <CAJfpegtZvQsu6gD1-zXvmELcu1-93ZKKEdKHMXqHzChgd_TXKg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] fuse: DAX device based extent maps (famfs)
To: John Groves <john@groves.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, david@kernel.org, 
	willy@infradead.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Oct 2026 at 01:00, John Groves <john@groves.net> wrote:

> Fewer fields is nice, but it's on the honor system that the server allocated
> large enough strips - since strips carry the chunk_size rather than their
> actual size when CYCLIC is set. IMO it would be an improvement to add the
> chunk_size to the header; then the strip sizes could be validated.

Cyclic maps could easily be generalized to not require a fixed chunk
size.  Giving a different meaning to extent length (strip length)
would break that, it would no longer be a CYCLIC map.  It's an
un-generalization that has dubious value, since the strip length is
implicit in either the file size or the parent extent length.

In other words: make the server validate the strip size, and all will
be good.  The kernel really doesn't need this information.

> So that's a bug. I've fixed it locally and will share that in the next day
> or two. I also needed to refactor your patch the famfs user space because
> it disabled ABI compatibility with some older versions of the famfs kernel
> that I'm still supporting users with. If you can wait to patch that further
> until I share an update, it will be cleaner on my end.

Yeah, thanks.

> Having said all that, this topic seems to recur and be contentious - we are
> working on tests that can demonstrate bottlenecks - but my current ask is
> that if I can offer an alternative approach to rbtree that is better on
> paper, can we please use it?

If it's not adding complexity, then sure.

Thanks,
Miklos
