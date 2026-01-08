Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB17357A3F
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767885156; cv=none; b=pqRQe+jLt9sKTZyW+EersP9AkwppqgqIa5usVoHdiAJmCs8qa1XM3vpOp10Rn8cQ2CPjJQ6V9o2YaXxWFmpmo1W68tlk2TMlChSpF/Utto9bOaHfpetcQDJo9dmYfMmFqbxkKnnAXalh1ToDVN7+KkFN15RXNzd4wR2+rjdy/No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767885156; c=relaxed/simple;
	bh=jtYdl2t6rzb7r+mbWvmvVNZ0lh3ErThLQjz03GiTx3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndt0yFVb/rRgO5FALUf9HMCUhYINAhmThHCObb9cXTzgwSURb6+H9sWv4oPE+J4Hjr/qv85WeoMCAUGL7O90Vs1wW2TFI5zr9tgb0WTsdHMeXzJnsjziBR5b3y9qAv8tPk7Yc9o+VCQ59kSgwI9uWeW1trh8hZKhM2vh5eDzY5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXDAEL43; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXDAEL43"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-65cfddebfd0so1710728eaf.0
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 07:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767885154; x=1768489954; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nsGnYTzondw31+n75eOvnobuzn+cZ2qwJK8EEZW82L8=;
        b=JXDAEL43kz2Yug6m1XPh06YNKNhowUNSk5rNWjP9UXzmRoUIiOkkuAg2kp4akou0tb
         KUmKIDJkg2NY6QaoZL4413rwUfslBgZ3dtnnOBFJU8z4Zn+5Y1krLAMOuDVQKUdVzSaP
         0Bnt9LL6tUgTwI4fr+8X7k6IbaBXcEONBXIePRpxaDoyfqX9nQDqjjdKrN0Eu12ccx/t
         Rqu8Wd8vv97wOE7HF4AZ9PX10UbQN+cPg67C+PRsOgQj6yB//+G/TuSKGDUkb4O03ZQx
         yXLmLH4Wdb/r6U6eET7nSmWYTvQz3FJ3MhJI0CIXDvzd/Nf4FjzOEHkjDSN2BrKI+Az4
         rdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767885154; x=1768489954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nsGnYTzondw31+n75eOvnobuzn+cZ2qwJK8EEZW82L8=;
        b=E5d9YiKJJey5j1RlfOFZ7d0pShxjziXdSFOy7PcYZw70fHCW2JEu4Xq+xb95A4F82X
         z/1u0UPRAVHPYq82sDq2fC0zTyojNQ+DtahRIf+XoRcDgWlIiEQKg7BmOK5G0XLU0HhO
         WdTj56oJhukg8ug8D5tjiFbpKMobWRehNaUQQ286nU26AQIBqbls/8IQLfiziCnLT5m7
         qIzU3T+GWv7SBnj6iYK5DevdCYSXD+4gE2CfZVAqH12l5naI4OJ1rj72tvVFdbThvT2l
         yCq/9TIa0Dn9pwDzlWXGlNJkkAczmlNDAeSsjOMW3DfzA2g8BpZEP/ZQ1nnGgQ2qxNI+
         cbHw==
X-Forwarded-Encrypted: i=1; AJvYcCUAdEmrOZMqiyCh9sRsfAhFikcBM0kWyetvFFmOeC/pG127nw8FeIVIm1YRva65Lp11WeCS4CM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAnRYnUjX+YRTJi6k2Ou5b1PCTI//KNXMJ8fuzbqOOvgZjQpho
	xVsQxL7su6NxIfONoiLwV5awcR7SrdL1UUV9dPUCUjzm6TO+IpAWOX33
X-Gm-Gg: AY/fxX4ZackhNpMzdLtCFZtM0z0bvi0LDDALpSVZmV7aaaBBfFKiyQZHAvo44n74Pmv
	o3p6CUyWnSN0+kNeqQfZz/GQWXPMi7zNMxKKK0IIyfmIkl1cma3nY2I3xAeXUIFxZ35z6Nczrtb
	tPUfVMPD0r8BJHMO23A88MBMe/skkTHKEWVqMDI3oQmoTO+PThABLJj4KRNyS79iu9wm28dWYU0
	7ojKkplnIz2jAx7JbpP3CIic6EMIsXGFlnMp1GODAspBVQ3Jm5wDyg8NQC96VxR/ClS+VFncR59
	e2kxROKW3gg59DjsMx1jeavJ3gxXn2KC+1PlCs9Hsx3uPgQpuj5dzcZO1fBju1Bhx7W81IfPPwe
	PeHwt/e0iiXJ972bU47YUeJ9F+bF3pW05rp1Y7Mp47VBR87eX7qI0TgjdK0/8imYGnJpBpPEBdB
	RNGsiqZli3iVCxdrDs+clzJNk0Cmogwa+Hv+jwP91h
X-Google-Smtp-Source: AGHT+IFZyDwPdkeqNSyDSqdmsf84bOQBFu+dUs1b2EahO7yvP66QCwradMj+XO+4P5+KO3vwRZ/fdA==
X-Received: by 2002:a4a:d661:0:b0:65c:fb36:f232 with SMTP id 006d021491bc7-65f55082bd4mr1868554eaf.50.1767885153692;
        Thu, 08 Jan 2026 07:12:33 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50721a6sm5268922fac.10.2026.01.08.07.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 07:12:33 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 09:12:31 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 02/21] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <6ibgx5e2lnzjqln2yrdtdt3vordyoaktn4nhwe3ojxradhattg@eo2pdrlcdrt2>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-3-john@groves.net>
 <20260108113134.000040fd@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108113134.000040fd@huawei.com>

On 26/01/08 11:31AM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:11 -0600
> John Groves <John@Groves.net> wrote:
> 
> > The new fsdev driver provides pages/folios initialized compatibly with
> > fsdax - normal rather than devdax-style refcounting, and starting out
> > with order-0 folios.
> > 
> > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > devdax mode (device.c), which pre-initializes compound folios according
> > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > folios into a fsdax-compatible state.
> > 
> > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > mmap capability.
> > 
> > In this commit is just the framework, which remaps pages/folios compatibly
> > with fsdax.
> > 
> > Enabling dax changes:
> > 
> > * bus.h: add DAXDRV_FSDEV_TYPE driver type
> > * bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > * dax.h: prototype inode_dax(), which fsdev needs
> > 
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Suggested-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: John Groves <john@groves.net>
> 
> > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > index d656e4c0eb84..491325d914a8 100644
> > --- a/drivers/dax/Kconfig
> > +++ b/drivers/dax/Kconfig
> > @@ -78,4 +78,21 @@ config DEV_DAX_KMEM
> >  
> >  	  Say N if unsure.
> >  
> > +config DEV_DAX_FS
> > +	tristate "FSDEV DAX: fs-dax compatible device driver"
> > +	depends on DEV_DAX
> > +	default DEV_DAX
> 
> What's the logic for the default? Generally I'd not expect a
> default for something new like this (so default of default == no)

My thinking is that this is harmless unless you use it, but if you
need it you need it. So defaulting to include the module seems
viable.

[ ... ]

John

