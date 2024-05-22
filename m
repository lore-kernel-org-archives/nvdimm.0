Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3AA13F44F
	for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716385318; cv=none; b=uSARQbC/VBr55iGQU6nyg2f0dZaKMBKMI/NexQCHOPy5jiwQ4YDgcfEODXYMuKhzlbone0mp8lO5DLcpK1j3jJg4kEvDjU6wBgO7qdLUBdlb+hZqB+/ykTr9XhKRXvhFZkJI7NrlM/TTQYmkYDc0zJYfDuiaHFXB2fnvbqW84Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716385318; c=relaxed/simple;
	bh=5OlI2c49kc/GH5J/agNRhgbAvOiepAletVFD/jbVaP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rf7PGcqT5XejVkIpLLSg+2umLdznrYHCD3M7XSOhMs77GvooFPO+QfoXW3QwrI7AXUKP4nL9T3QOQ8MKuNhe3hXm5f7RO/54LUpERRXXBiocti9EWqU8sGxhOIymYScKqTw7QFj4+mbuf+sL/JKwMlZNJ7hKgJeuuOFcpbfhytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlT3WQNP; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlT3WQNP"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b27ce83663so2314148eaf.0
        for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 06:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716385316; x=1716990116; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meJM/p/T2OemzzcD44JPElMDWWjCdDm6EvOTQof3oOM=;
        b=VlT3WQNPjcctPG8dnGf52UeITSSAT67WiDiNqjh3Dj+W0T2P8Bj3kSrUMkz78meYHo
         Jgj9c73cvgdn+yVnmBEF940HQe06S4IA6GaQBbeMXMefNQhkrrNzGOF+xVCAeQb40qj4
         zRfVE0/5YmJ08wRoJDLCvd55MqNrKAoBNZ+9oi2ffYxSU0iyI/dzKRoZOYmFYekec5hm
         VQM9j2DmLAK2pWnIyaKy8cT4FiSMGOlMQgDZ/+RSTcQs0/IUa9h51p6vj3GD9wfeTVV+
         ub/nJTN3lRROJbwrIB0njCYk+MoVl0pC9LhFv/IoL3EBLQm5yBIgZSq8uWRSWa2Hmcyb
         o7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716385316; x=1716990116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=meJM/p/T2OemzzcD44JPElMDWWjCdDm6EvOTQof3oOM=;
        b=d1uxTL1TQdcnAVlrDvxHEYkaKQEFPxA2sfbpLJqLZa5IenpCSf+dZ6hqZNSjPLbZRH
         D7lpAK+7Yf4hxrD42dX5E4i2jOKjj+gitcHThSxbltF/g0Pbhmyj14sqm1tkzLZKQt33
         WEOeBeHgBzNXKe3oo9Kwk8HXqJDkayynUT5UCYabniuShKN6lPIupd5ZrB6xVzQFepA2
         taOV4k82YWTup44HcQ2b+ZMyG7um9u/sfXLS7a+OVO7r+3tCKemKNYb2w71JrUgovhGE
         6Gr+OM7y/L7T5s80jwD2tOEJ0UPM+tga0foCKb3cC1fbWVOsSEwHSdpxGg+1QTKyYGNS
         KZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz3w+jzq2y+iA5JfagbPohX516tjoNErdIo+hHIU8PgqO5a1AhOo3knl29pHNwVrmInt8vCaYGesNR/V6tLHzOesEPYjK9
X-Gm-Message-State: AOJu0YzDJ/m7oLIhhZpRgsNj0r+6kTsV/jKKqjehGeYyp671CoiXSQTN
	hDaDBNWTC9LHfMpaDnVoq8Ar4NzCnvhNwlnYYszNd30O8j00NeIBPA2jA1aXpzCVPUmTa4kvZtE
	+FW83LJGGBZ8asyrhvgOxFT74Qtc=
X-Google-Smtp-Source: AGHT+IEJMItiavZC96OOn694KUn/rrJ28jg1RiM7DNQeS56X90KqY7Ko5SU2xqiymo9ES/uF8rC4UK0QhSRV4d/M7TE=
X-Received: by 2002:a05:6358:2826:b0:186:1abe:611e with SMTP id
 e5c5f4694b2df-19791ddd866mr159774755d.30.1716385315608; Wed, 22 May 2024
 06:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net> <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com>
 <CAOQ4uxiY-qHSssaX82_LmFdjp5=mqgAhGgbkjAPSXcZ+yRecKw@mail.gmail.com> <CAJfpegvAuPtKzR1A4GdaZTB_EDqPu53wUf97D1QOUo9VKkTV9Q@mail.gmail.com>
In-Reply-To: <CAJfpegvAuPtKzR1A4GdaZTB_EDqPu53wUf97D1QOUo9VKkTV9Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 22 May 2024 16:41:43 +0300
Message-ID: <CAOQ4uxhNWLQQ+mUED18-4Vi7XJv2hGJJ3_j1Yx+wtLZjZaX5eA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: John Groves <John@groves.net>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, 
	gregory.price@memverge.com, Vivek Goyal <vgoyal@redhat.com>, 
	Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 2:28=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 22 May 2024 at 12:16, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > The first open would cache the extent list in fuse_inode and
> > second open would verify that the extent list matches.
> >
> > Last file close could clean the cache extent list or not - that
> > is an API decision.
>
> Well, current API clears the mapping, and I would treat the fi->fb as
> a just a special case of the extent list.  So by default I'd keep this
> behavior, but perhaps it would make sense to optionally allow the
> mapping to remain after the last close.  For now this is probably not
> relevant...

Already in the works ;)

Not tested - probably not working POC:
https://github.com/amir73il/linux/commits/fuse-backing-inode-wip

I am trying an API to opt into inode operation passthrough, which
has a by-product of keeping fi->fb around after last close.

This is designed to be setup on lookup, but could also be setup on
first open.

I have some ideas for how to return backing id with lookup
(and readdirplus) response, but haven't tried them yet.
But setup backing file from lookup response will surely
stick around until inode evict.

Thanks,
Amir.
