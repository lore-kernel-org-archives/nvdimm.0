Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2AD2E8DEF
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 21:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767821453; cv=none; b=Vc8/OuU5AHgiNz4VlX2AeK2Ec1w4ouk+avYuzqRfMiURrnfZq5vOKr7qdlGKoxLHNShfeGf9xqcBW64grRaZWhJZ20G2zgXz1hUgGye4JzPgdJbURg2MXg26KcheYkAek7fG4nVZWjedM937VoVVfI+rbSG+7pWKSid8gK3hgpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767821453; c=relaxed/simple;
	bh=hJBhEZEn2IW0Qs8Ce9poSTsX2HFP1recNbm+Qx+TfOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJoxeixpOFAmEZilgLaUtKbyDewg5UjVuzbUQvKyqfSTz+FtY+7/uZg595sU7MfpuOflhJRA5O3+vgnsPcZATDfxI1I6cS/M4Ein3J2XcJ5UYB/J9GLLsXSgqRxZjMe3ijjL6Y7mB5iE8WIGhJSkHbLxZVgPQoKrSHJbwgpfEJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbASGB9s; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbASGB9s"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-3ec41466a30so1122413fac.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 13:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767821449; x=1768426249; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PgyJxKcUhgy66+q0k0EwvKHt6dTWi7O1SwlvNA4nT9c=;
        b=HbASGB9sQAgNTzqkNAr8z0QRAhd06beEirZug4t3oGfbX984Wjl9hEcWC70ZfxO1M2
         5PNFb8BZsFpkkLNK6R3ZDYmIznVhxUmroGdeMuh8n57T4a7TBcuz3lDFX/GD+zuN9b6Q
         k0FlAj6PSaW5hI0tv4gN5JPk9PgJUlXLCsd4q0mYoplqBihUzDm/tevfFVn8f1FJJrjx
         0m8Hp2XqQRuLH7dhGWgfF3oe8Jg8zGLxlUNToGovSa5hrV2cFhnshNJJOVvgYWR1xwOS
         Eum7eKFy3pEglQNe3+eAucyi8cxFMPZz7KCkl5noo2CM784vfczRmS6fTUG2H4lXl/kT
         Y4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767821449; x=1768426249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PgyJxKcUhgy66+q0k0EwvKHt6dTWi7O1SwlvNA4nT9c=;
        b=E/jI/j/JvVaTP3jma2MQ8Z7v4wZcR8fpiIzHYAmh39JIx6Ire6F1qP6VWPrEvLJE+N
         Oru1+nvCe0AJ3sdqdtMB1aQ49PYfQ3E0KBia8iLfP3Wz6kN7IduJyzLCXWqddfMEHP0I
         jwwg0qvIdYj96phxIW7IyjuL/pLpwy835pi4SeXfGcexX4+JFFN0Ccpjq7SpEcnrEjUA
         AWLebBNcOtLmOMc66/12YDQ0Qv4BKXQ7/KypRPLyHRu5kZ93ENbqyTxcrlR/gBHkYl5M
         NXDv89JOwUjUGNsk1wNfp36Rg9PnXC9xUXbjwMmB274C/nl7Tn2qtFy/Z3JL0anlXZNV
         Hj2w==
X-Forwarded-Encrypted: i=1; AJvYcCVR4lJaLy0fC5AMW1kShQoDfZzjYrznx2NMuun5obR/xYV/LqQxeRhQ5jsdFfcyPl9/bd+112Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSJxiqoYmDQA9Mp6yeq//oPIG5c+YCoJ/A2C6xQOjA0cUZv3Kh
	B/G0Ppb1mqcTiZZ70zrv7aAAgvy8jFpzOd/zepcPTPGCnpDkEp/Zg9Uh
X-Gm-Gg: AY/fxX5PbjXbKiFFkcw2pGIhFBWUPUuo9KH4nFPVtEByPfkiwaw/ec+W8qrWLyHFnrd
	NtP/HakmiqbWMsdN0GIJv+0FpXM3UjMiWqvvw/LCmnyGhiGA8egdEj9UJf1RRHn3IIHT6hRLvLo
	WqNh3/frsu+yobpf4h//KmW/coa3eIpObNTJiX0D/mXMl6xlKOfgF3ke8iH4MLFqnvn3Eo0Pu3g
	w73570KA8Na+4ujBa5pCLqDC1CIYai/vBWffGFMhk2nRS1GyBKH+6NQ0nGbd8MwcT0neeTdKJGd
	uBq2RUaCCtHt6qlQ80bJv9DdsgIFCmxhSAncWuV2n3VkiFUG0HaEp9ubXhitV1Fgii7Fw3e+M3T
	r6GSTQBoj0j86LO1DYeFCo6aB/p+k96Lw1jRSGm+aBxnLxEWesMbOeQf24XbcNsgfew30jmUaON
	eaH1Uf/09I2UiJ1KYY8tRHBJX6xTyZfgZ0D4wHms05
X-Google-Smtp-Source: AGHT+IGBpBXjThN1EPukRyzeQDjnIkWKrC19wevk+xy19Ke7HdDQYha50/3EOc1Su9/w3oCaFtcjKw==
X-Received: by 2002:a05:6870:4191:b0:3e8:92f2:caa2 with SMTP id 586e51a60fabf-3ffbed0d56dmr2067280fac.5.1767821449438;
        Wed, 07 Jan 2026 13:30:49 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3e844sm3874317fac.9.2026.01.07.13.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:30:48 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 7 Jan 2026 15:30:46 -0600
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 15/21] famfs_fuse: Create files with famfs fmaps
Message-ID: <smqodjljwvhnssmq4ho3hicnomzyrpsawy65ykxhigrjl7yawu@xwtbxjamivk7>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-16-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107153332.64727-16-john@groves.net>

On 26/01/07 09:33AM, John Groves wrote:
> On completion of GET_FMAP message/response, setup the full famfs
> metadata such that it's possible to handle read/write/mmap directly to
> dax. Note that the devdax_iomap plumbing is not in yet...
> 
> * Add famfs_kfmap.h: in-memory structures for resolving famfs file maps
>   (fmaps) to dax.
> * famfs.c: allocate, initialize and free fmaps
> * inode.c: only allow famfs mode if the fuse server has CAP_SYS_RAWIO
> * Update MAINTAINERS for the new files.
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  MAINTAINERS               |   1 +
>  fs/fuse/famfs.c           | 355 +++++++++++++++++++++++++++++++++++++-
>  fs/fuse/famfs_kfmap.h     |  67 +++++++
>  fs/fuse/fuse_i.h          |  22 ++-
>  fs/fuse/inode.c           |  21 ++-
>  include/uapi/linux/fuse.h |  56 ++++++
>  6 files changed, 510 insertions(+), 12 deletions(-)
>  create mode 100644 fs/fuse/famfs_kfmap.h
> 

[ ... ]

> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 9e121a1d63b7..391ead26bfa2 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -121,7 +121,7 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
>  		fuse_inode_backing_set(fi, NULL);
>  
>  	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> -		famfs_meta_set(fi, NULL);
> +		famfs_meta_init(fi);
>  
>  	return &fi->inode;
>  
> @@ -1485,8 +1485,21 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
>  				timeout = arg->request_timeout;
>  
>  			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> -			    flags & FUSE_DAX_FMAP)
> -				fc->famfs_iomap = 1;
> +			    flags & FUSE_DAX_FMAP) {
> +				/* famfs_iomap is only allowed if the fuse
> +				 * server has CAP_SYS_RAWIO. This was checked
> +				 * in fuse_send_init, and FUSE_DAX_IOMAP was
> +				 * set in in_flags if so. Only allow enablement
> +				 * if we find it there. This function is
> +				 * normally not running in fuse server context,
> +				 * so we can do the capability check here...
                                         ^^^
Oops: this should be "can't" - we can't do the capability check here since we're not in
fuse server context. Will fix before merge...

[ ... ]

John

