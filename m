Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F36214223
	for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 09:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747127709; cv=none; b=AnYF8SLlxysTne3Rh+d/L7NiNYUHL+jAjTTLhg9aPGJACNN2tpsz3K+i8offaFHvOvRly05vx1p7Oo5EHuGY3xPBM7K9aUu8o6MGICmCOaW0ZU0TE963yoTUPJHfWK5dv9SN8+ex980K8Si60gN35oo7IfHnbI7SJP0UYBiPET8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747127709; c=relaxed/simple;
	bh=dCEwNwEt7AuPcFjOYYqXUKN9++me11ouKXeEDU4JZv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f6wvF2pMe0M5zBViT8ttRLjv1JJsSnsG3JTWaMVG2H9LamnX7W0wUDluTKWVBgXAoA4tXIlPnFzUMc3EZP8DxFt2jW7QQcZK832U3E8wp0r+t36xgSHCMCZLIHwAsGJYOGDw+QyvBVCOkO+Dlefl0YSjXLRsm3pJhInqxrntNIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=SpJoz5BP; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SpJoz5BP"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4772f48f516so70138031cf.1
        for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 02:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1747127707; x=1747732507; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ihrFZxGWgoMburH5YAF+Sr/kylX3rOORHrh4dczbaY=;
        b=SpJoz5BP/pmtcq6DoWOn/z/L7AxUPTjSaxuCVbTywb56hZQLGBIf2yNktYaAZPsEf4
         +lxW8BUsGx3OvbMQQ/qal+e2YGdWnb3CXtROMny8DFu9kIGE2XJqU8IZkkWlqFsm9sQp
         gkp8VVem51mDsbgZZH46kc/opjlk+5yemXCY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747127707; x=1747732507;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ihrFZxGWgoMburH5YAF+Sr/kylX3rOORHrh4dczbaY=;
        b=JaUJA6Nlggh713mepSsYxSR9psZqBRfdo+m+ethYO6iOyDjG/K41/NvW4UEAtRxAEq
         ADF83wRmVuNBj1Zdvh7f+aarelDMd4bEavfJ1TBh0f4Sda5+YW3vE6MhzjypnZrFho12
         MStQ/RLWJ828SFkWrqiL/2PvVzIkB2rCTPXOGFPjnq7AEC3heldgHOQRr3E1RCNIAHkH
         ko71SJyg/IIckLXNOw/for0D0srzoNStzT/VHqpehRcMrZ5rypnGFIHLjzdRXwl6Grlq
         MFgtATBklmkj3PyvSxKRb+KaqBPDmlzuRtHlXXftTLkpxvS7bbXV7V8Lxwh7qLH8wwrT
         ckPg==
X-Forwarded-Encrypted: i=1; AJvYcCX0KyLrR4z+d4tELbWH/wo432UCx76g1I3l2BeF0AQOU+wIfy+LTwB/LRH62toj4uoEvu/TbaA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSJBrJwNJsihQP8CJ0KmwalGuY7K6dYfcPFjczjq0RBrOj5gdV
	qMJhWrQTo0APnkBGsw/JTzGo2ofWxy717Urjpcqu59xibY6nCCmeGra3ZwbcjpfU8nsBoo3wlSG
	SGEMikioSjdUYtqfEGF4Mk3sW9nleQpx4IV+PZA==
X-Gm-Gg: ASbGnctuybkLnB/4rMAVLAOsQCF8X1RO91SLRd9lOh9zsUeyiFNoSB7LaEUltP7F73p
	kiE1oD3Ym3bxKDs/5Bu83XcjAPh219pNwtH8LDk6kcLbB3mVVXP9T1Y9AoGHGvzH4zxlWONJTmR
	UeQtYI/vJdEXEzrS5S2j7yngqmFLqU+YI=
X-Google-Smtp-Source: AGHT+IE6dZiqGjVqQyApS4pbcBalFyHHbwwvSoEvnbF7u5bEK2A/GpSwhcwNVYs+CDOmzCE0rRDdqSfuQIhXOHmw+f0=
X-Received: by 2002:a05:622a:1a93:b0:494:6eed:37b1 with SMTP id
 d75a77b69052e-4948732d7bdmr32223981cf.7.1747127706802; Tue, 13 May 2025
 02:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-14-john@groves.net>
 <nedxmpb7fnovsgbp2nu6y3cpvduop775jw6leywmmervdrenbn@kp6xy2sm4gxr>
 <20250424143848.GN25700@frogsfrogsfrogs> <5rwwzsya6f7dkf4de2uje2b3f6fxewrcl4nv5ba6jh6chk36f3@ushxiwxojisf>
 <20250428190010.GB1035866@frogsfrogsfrogs> <CAJfpegtR28rH1VA-442kS_ZCjbHf-WDD+w_FgrAkWDBxvzmN_g@mail.gmail.com>
 <20250508155644.GM1035866@frogsfrogsfrogs>
In-Reply-To: <20250508155644.GM1035866@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 May 2025 11:14:55 +0200
X-Gm-Features: AX0GCFsg_IXaIo9w2jh-HmI1-M2cVqc9zT7I6qGhspawMoCH4j3pG6URFnq5ts0
Message-ID: <CAJfpegt4drCVNomOLqcU8JHM+qLrO1JwaQbp69xnGdjLn5O6wA@mail.gmail.com>
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
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 May 2025 at 17:56, Darrick J. Wong <djwong@kernel.org> wrote:

> Well right now my barely functional prototype exposes this interface
> for communicating mappings to the kernel.  I've only gotten as far as
> exposing the ->iomap_{begin,end} and ->iomap_ioend calls to the fuse
> server with no caching, because the only functions I've implemented so
> far are FIEMAP, SEEK_{DATA,HOLE}, and directio.
>
> So basically the kernel sends a FUSE_IOMAP_BEGIN command with the
> desired (pos, count) file range to the fuse server, which responds with
> a struct fuse_iomap_begin_out object that is translated into a struct
> iomap.
>
> The fuse server then responds with a read mapping and a write mapping,
> which tell the kernel from where to read data, and where to write data.

So far so good.

The iomap layer is non-caching, right?   This means that e.g. a
direct_io request spanning two extents will result in two separate
requests, since one FUSE_IOMAP_BEGIN can only return one extent.

And the next direct_io request may need to repeat the query for the
same extent as the previous one if the I/O boundary wasn't on the
extent boundary (which is likely).

So some sort of caching would make sense, but seeing the multitude of
FUSE_IOMAP_OP_ types I'm not clearly seeing how that would look.

> I'm a little confused, are you talking about FUSE_NOTIFY_INVAL_INODE?
> If so, then I think that's the wrong layer -- INVAL_INODE invalidates
> the page cache, whereas I'm talking about caching the file space
> mappings that iomap uses to construct bios for disk IO, and possibly
> wanting to invalidate parts of that cache to force the kernel to upcall
> the fuse server for a new mapping.

Maybe I'm confused, as the layering is not very clear in my head yet.

But in your example you did say that invalidation of data as well as
mapping needs to be invalidated, so I thought that the simplest thing
to do is to just invalidate the cached mapping from
FUSE_NOTIFY_INVAL_INODE as well.

Thanks,
Miklos
