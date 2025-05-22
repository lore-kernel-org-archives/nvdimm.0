Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AEA3D76
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747928769; cv=none; b=pwwJflEFvwWZAXDBHukvCzVqx7TTsc+7zXe5Ns8s4h3T0I8M5d2CEn/9/TZIZRP2nKv8ljLS3ywEpWz5JrSrQ0Um007CbPr8VYl/mWtmrsI6S6SzUu3tUtaT/4ZBZO71dCQLpV/Bafg2bUeghOE0LG4t+c1aLpqWN2swTg94H4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747928769; c=relaxed/simple;
	bh=HHFfb8zt1W7b7687wsmntPJNHJRczR0BfGUhfr1rO0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uquVmIIzUgxK/AETxUwgC+OT/q3VfYLOFQxY4SW7Gx1SQoOEheF3C3ByHDrPUa3plt12WEQguWQTLXJlZDiFbOIp8ngcVd9rEOT/kMBeOr+ETindCwukfX1pCv/SemJmnCrmrvxuQv7BhxQTRW9zYLsZEaslncGTtPlv1X6Pm8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9uBpWsS; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9uBpWsS"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad56cbc7b07so677082966b.0
        for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 08:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747928766; x=1748533566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgiMoj0zBLI77kFJsTbxWoQIzqomQqgDgEkdUW1inN8=;
        b=c9uBpWsS6JfZQDkh2HssmEBlnqtIapQ9dnggA5zmprWx1thcovZuuEKZ4yVxEY3Dp2
         ssxqHU8fQqfwbhNXqhfx/F3RC7SMV06UdgqrQen8fSBdMApra6mEPV+81HoIaU3hSUu0
         iitLEBI8N1IO08vrAQe9gotqkDvSejL7ickjQtlj+PV4YqKTiJjkoUnGrhF2TtEawWIo
         bT9nVovRgCPVhRttagrhXT6A/T9sMbjC621/Z9nB/VmPTR9FqJU26OrrTSrCahXSvpfJ
         8GeYj8J5YP2WZ+t/Fg/jfbgyBTpyS9iQjvlQL34p+BTmrbe4334uLhm7FhcsfIjYpTk/
         bctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747928766; x=1748533566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgiMoj0zBLI77kFJsTbxWoQIzqomQqgDgEkdUW1inN8=;
        b=m3J49XvW+w9slGMkdKZvpiqnBVX52SX2y98JgP4U07twtTd/zQ9W4UNbsylhr+8lnO
         q1Z6RsIZi3TgplEH/P05IjIBAB4Jn9K/Y96Y9ZhfeHDCWi3OuvowU1gRb9CaU+DkO3DS
         VT3Nuz8jznTdpWI6z1a47xodC57SQNuEFV+w8Kinbz7vBymeRa055TNNbD/9pf2ZYsuc
         hGDdEBi+wx49AYPhWwVOhlikOlR3/zy2nvoKx3e2l7LSajolDmjOZVcum5+aHBf51uQ7
         8NfeXJw28O2SpkHhW2wSpDvt3Y4ZV4a/Qej6fp+3HN1b2GWcHrvJZjIN2Oo++wciVQho
         W5ew==
X-Forwarded-Encrypted: i=1; AJvYcCVXhNe/Fg8aFkZ0nCQ5Wrq8ijv0Dmj0yPalVrebiEGVp44jhek+33HDJXwVDagdewJI9pxyWsA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4t4W0NI0sdp7Y/2hGe+LSTOBpEe0QoT+Uc4O8FfkmR8shsN1K
	0IJg23mu2XMW+r4BLI4dPnuWSPcaxCGNKa/d2wTMdZf8eDMZ+jbz/7DbMlkZO3A+Dho4EYagw8H
	K49pmJ0/Zu67yHH3FFra+kJdXKalVelk=
X-Gm-Gg: ASbGncvdg8pZT88ryCkB3OprFJNlApEcbDQW/Nj+Q5Cj1Ly73CTk9JRcJgAc9xb9nM/
	XKDk1njYW6hFmWubYWyepE+Ob5zhdj9nVk6zksKbwDHcggJW0TBVy88h/C4VkMtUWWtQUO9QJE7
	/nGcXhjHBlKZTaHjy7kKysHYGGOO51TUbCfA3QsjOTJec=
X-Google-Smtp-Source: AGHT+IFCqHZ4nii59QrK+Jhw+rDrywqjWTrMjDZMLq2ull6eKrj9OenDertsGsb8tK4eBZqLTUn9pP38DriMvIz7YVc=
X-Received: by 2002:a17:906:6a19:b0:ace:9d35:6987 with SMTP id
 a640c23a62f3a-ad52d441f89mr2374003266b.3.1747928765733; Thu, 22 May 2025
 08:46:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-13-john@groves.net>
 <CAJnrk1ZRSoMN+jan5D9d3UYWnTVxc_5KVaBtP7JV2b+0skrBfg@mail.gmail.com> <xhekfz652u3dla26aj4ge45zr4tk76b2jgkcb22jfo46gvf6ry@zze73cprkx6g>
In-Reply-To: <xhekfz652u3dla26aj4ge45zr4tk76b2jgkcb22jfo46gvf6ry@zze73cprkx6g>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 May 2025 17:45:54 +0200
X-Gm-Features: AX0GCFtyU3N_Zhefral0ZnR18iMPx5aO1xlmLEfo3wUu9EslWmr6-Y8DzN_FaFM
Message-ID: <CAOQ4uxj73Z8Hee1U7LxABYKoHbowA4ARBFDv434yDq+qn5iMZw@mail.gmail.com>
Subject: Re: [RFC PATCH 12/19] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <John@groves.net>
Cc: Joanne Koong <joannelkoong@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, 
	Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 6:28=E2=80=AFPM John Groves <John@groves.net> wrote=
:
>
> On 25/05/01 10:48PM, Joanne Koong wrote:
> > On Sun, Apr 20, 2025 at 6:34=E2=80=AFPM John Groves <John@groves.net> w=
rote:
> > >
> > > Upon completion of a LOOKUP, if we're in famfs-mode we do a GET_FMAP =
to
> > > retrieve and cache up the file-to-dax map in the kernel. If this
> > > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > >
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
...
> > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > index 7f4b73e739cb..848c8818e6f7 100644
> > > --- a/fs/fuse/inode.c
> > > +++ b/fs/fuse/inode.c
> > > @@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct supe=
r_block *sb)
> > >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> > >                 fuse_inode_backing_set(fi, NULL);
> > >
> > > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > > +               famfs_meta_set(fi, NULL);
> >
> > "fi->famfs_meta =3D NULL;" looks simpler here
>
> I toootally agree here, but I was following the passthrough pattern
> just above.  @miklos or @Amir, got a preference here?
>

It's not about preference, this fails build.
Even though compiler (or pre-processor whatever) should be able to skip
"fi->famfs_meta =3D NULL;" if CONFIG_FUSE_FAMFS_DAX is not defined
IIRC it does not. Feel free to try. Maybe I do not remember correctly.

Thanks,
Amir.
