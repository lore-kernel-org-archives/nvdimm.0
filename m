Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B86299AA9
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747929364; cv=none; b=aV51Nbt8e0vWoPIMJzIaxVmcoUwea41IqCjdry5Hh+dpXli3upC/yZmih/ELrNh9960pl7XRXe9o9PISZJvLUkADZRdCwGvJ+QN5Hwh24XANyWppcGAafHNIRCrQj41zbO9/Zw5+Ehvq0PNMGj5LOuoMIh90lFLEFd3flzBqvn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747929364; c=relaxed/simple;
	bh=A4J+qQeo8FojNZDrm8K6UkrhE2Rb/ECmA/pvJXKHIeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayD5lBDUem++L/42dU//e/z74qc4CANKt1VMo9IjZms4Sc0xS6k0r1puuJzjcX4kJezrNMalW32X6NNYehX6UjwWqHxyHNb4TZFZF+46mbi1AzTQCZOaohAYwgG2GsL4ucsdooyWy8AVLQzkaGeiSc2HZykIbYK3qhGJS+rGSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+aSBjrQ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+aSBjrQ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad545e74f60so1004193966b.2
        for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 08:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747929361; x=1748534161; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4J+qQeo8FojNZDrm8K6UkrhE2Rb/ECmA/pvJXKHIeg=;
        b=J+aSBjrQvaAb2yijbTjUnq6yjgAQx8GjFotcfHhvCJLasyP7x+Kgw+/0nbb9xUbZho
         WKbmfGCfBCVY2Eev6NJzzEPOWitfSMQTyzogul0I0cN/ri1zYAX7ADnq0xYqEewi0tZ1
         lVIWRwrBbgaWsy3HBYOOUXlyeFlUNN99VApV2wGYS5O77lzCui5MHjDl8P2KUjPwE8P4
         pWy3d9CRDLcvYVC9WUpnC3MXhWkCYdrW4UEZoAGxIf+gMw+X8jHeZ2YMR3wJUxqh6AFO
         yGpuc46xlYy+BZZkqLjVQoiDsajUfhFSBOZRXuO3Dq0RB1Kb29Zxd7ImFwOUuphweSF1
         ns1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747929361; x=1748534161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4J+qQeo8FojNZDrm8K6UkrhE2Rb/ECmA/pvJXKHIeg=;
        b=wuPgVzL27sCld+6I91JdDEz2x4ZKp0waSjKbkZj5P4MA2jrFh8UuzmVVU8SUIIO6Bc
         ffs6A6ByHHQDfTCj0rLYVUK2u7HRirSyKqZDqtICV/+oU+/rXp9pC0JHnUiOvD+7OTOU
         2j8AcgxUV29Txwwrv3K3UHwNiqq42zRvUfFqnJ39D8gtaukCapVbuNlkEbsj/xEwoJzG
         pXrjkuEiGsU11c92N6Yivor/xEm7DdIOtHX6zNdjoVk6jZv9+WbcSnXL5UjhANXafBNc
         d3eLPsGwvUk9e4ACvMPLtZW4xkvXb2e4iosXXnXWC7pkTvp61jYCo7Anacuza6Fmz+YO
         jW8A==
X-Forwarded-Encrypted: i=1; AJvYcCWmpYhFKjkh6oL5osYS97Ku/OF20CsWKsW2miM7g5mXB8u4sI3DxBRrYc9fGNFs/tga16RILWU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSN/8URvp+JwQbRq1ivnOMe0yEqIw7WfAs80uo7bYSw3YzfYiA
	geV6cWubkgXccQxl+GjzNM2Ca6JgFZZq6r51UdhitMp3isQj3+Jp7cVxQki/W/l3vImZuE9tZTi
	6qObozGFXWasFxowybBuDSNORidfTFd4=
X-Gm-Gg: ASbGncu/MIg2q7sQ8Io6XBBzSc/Z1gTVtHKVN3u/T5uVxX/Zyi8y6OTg3YdfjUrk1pH
	6y6RP8SU26tJGUuoRJRBzxwToGwk1iCr+lghoiPe/BU2g0DzvZKw4WrulLIkCg+kp0/EL8JWnZd
	Efs972ms3ET3Ux5p9Ctkd7B5dT0u++aIDr
X-Google-Smtp-Source: AGHT+IH6QL3rTW5k/XBVsCAcYeUMdtDIv0Z5CTpmk9yXv5afLUYePNzV48MFbmXlyN3ijm1K7kXjZ0FhjF+aJ1p4y4w=
X-Received: by 2002:a17:907:fdcb:b0:ad5:52a3:e358 with SMTP id
 a640c23a62f3a-ad552a3e5b3mr2046292766b.49.1747929360593; Thu, 22 May 2025
 08:56:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <hobxhwsn5ruaw42z4xuhc2prqnwmfnbouui44lru7lnwimmytj@fwga2crw2ych>
In-Reply-To: <hobxhwsn5ruaw42z4xuhc2prqnwmfnbouui44lru7lnwimmytj@fwga2crw2ych>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 May 2025 17:55:48 +0200
X-Gm-Features: AX0GCFsIIcsMi4HVgfhUZ-aKlbSmC6wfuBA3UyRPVDwUyb5pOFwqCosyJaGAPEw
Message-ID: <CAOQ4uxiNPiT5=OLN_Pp695MPH=p7ffoLm8hEQ4S637RSYZz5gg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/19] famfs: port into fuse
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, 
	Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Alistair Popple <apopple@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 12:30=E2=80=AFAM John Groves <John@groves.net> wrot=
e:
>
> On 25/04/20 08:33PM, John Groves wrote:
> > Subject: famfs: port into fuse
> >
> > <snip>
>
> I'm planning to apply the review comments and send v2 of
> this patch series soon - hopefully next week.
>
> I asked a couple of specific questions for Miklos and
> Amir at [1] that I hope they will answer in the next few
> days.

I missed this question.
Feel free to ping me next time if I am not answering.

> Do you object to zeroing fuse_inodes when they're
> allocated, and do I really need an xchg() to set the
> fi->famfs_meta pointer during fuse_alloc_inode()? cmpxchg
> would be good for avoiding stepping on an "already set"
> pointer, but not useful if fi->famfs_meta has random
> contents (which it does when allocated).
>

I don't have anything against zeroing the fuse inode fields
but be careful not to step over fuse_inode_init_once().

The answer to the xchg() question is quite technically boring.
At least in my case it was done to avoid an #ifdef in c file.

Thanks,
Amir.
