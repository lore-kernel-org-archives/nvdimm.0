Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D429AAF8
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768157606; cv=none; b=GWTIF8q5Ov380ABEMKeSPOTnHs7ZRYn/ePkir9Hgvp41IggaImU2Ce5WqSx/2havEwwCnJTVtVWBmTt8aqbd7V0dyENsmcCUzh61wtnudSxImivcdWIagYKKBokCrVywUDNRDJVV4L3cO3mDYy0c8Y2pd9by3PDHKvbq5h2IyBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768157606; c=relaxed/simple;
	bh=bjkXAEN8Y+D7IMRxZaq/hvH2dXf/omJq+KCOtFcy/ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpUDQ17rQqEMjrN+QbzZduIg39yiGZP7nXVhNB9q8U2RcAaa+4M9KtTYNrL2qiar8urhrcNPBMI2scYKBvUloDJfZRMyGPIaDnR1kMYrj/U2RYkUD1iK0TwosWIle6xcfFPDk7dDH/IrDjAHzr2ZOfsY7N8Dv8HZaRfBhzqgy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3LlAqrs; arc=none smtp.client-ip=209.85.160.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3LlAqrs"
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso3603667fac.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 10:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768157604; x=1768762404; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vTBNax6FoYZ8tcOGsMgyI0isYvrnMxJ74iIpUsR2X1Q=;
        b=J3LlAqrsr1QxgUQXyXqo04VTsoXCxXmE6oZXf5TM5Cp1JNrT1GGJwCsIZ+uTzPktSv
         5jeGVDCVFrT3ZZSljqrl280Pd/E+e2cthgJSjUQdmIVpz++I5mAwu+5m8vVZlhKgkqFk
         /V9qxU0gMQ/D3pzV36ZM4WeiJ3FzIOlCFqMVO9Vox1dFJ5mTxi3J4v7FtlT4FCHUa5Ws
         UPpMaNa1GoHkLlbVilMXTPjuDG5OwP9GnGmdEVHjaOfjEixoha2YtQezZzE7c6/5XsZz
         MHvyxmLCciUrzBrvU52Pr/2u7tAC60J0rG4J+0iyJ4U7Rp8+RTcuCng1q0PvQoQV1J94
         KSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768157604; x=1768762404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vTBNax6FoYZ8tcOGsMgyI0isYvrnMxJ74iIpUsR2X1Q=;
        b=xMegaTTsWIBmJfRMmOyYayyVMDTUdbhWr8MTep40y/qf/ITM1lSRy38QRmWeBZMgM2
         Qznhu4gcJdWmKS4m+CWbvLfttcH3pIKdSkmAUUqUSyU+NQOLncfME1D+BBKAUCJ94xW6
         JM+M/X9ZC7qhfdclaI9jTgVeUlvORtI7XBSY4Z9KmrATGLaoMe6mKY5PU+lONK+MAWYs
         aOaKE/25omKLYuofgL4shdW+PwRITvD6s7CyBW8eG08+tXP+9VNH3ws3Qjiax9GAOX8W
         HEH3gv5Sjd/3dkGHIkeVWrcwkk5a82VIgB2QKKjwpQR/KoPu9NiY4C0IfUhMmEiglnEX
         QA2A==
X-Forwarded-Encrypted: i=1; AJvYcCV5jmLikdnbZv/DdqtLpBe0EVn1aEWbD3VTLxaa+fcG5mEuUQB2eGU9O8JG/yKSPusPsQXttiY=@lists.linux.dev
X-Gm-Message-State: AOJu0YycQ2IqcRlxNI2joXLUr+r0BRsz0Am8DiONPy+HNIu9Sq8fnzSF
	j+acFV4FcqoJ/1nAGFlA4bplPcHlndSb9uCFaSE3uZdihGY01Ui8oQPZ
X-Gm-Gg: AY/fxX6HVTFCLD3OsthTH6r5hVVAiTY1dz5IflvYfNQMyr2BeFICRBZ9ls0Oy3NfZcV
	cZpKGzSbwLOdPbbtEEK+l94rY0oqvrs1iZt9rgXsZIKQTkE7uE6B7hJqme8Kk2PotUF5Zfo2efK
	u4gl1mCws3blnB7O74vmGcZN3k9zTraWYCa3eIjCeHnSoz6Tkg3uh+0kqQn6aPk3UsWsaw6HQ1+
	05Z/W0+ejNasxmBvq8tTCXxOEz1ANPEE7nPhTh4udI2MncKGQFwJPe00MJubX50vOdM8bN3ob49
	+zxoFwWESktoekK2AA/l5Tt4iX0MMJkRHJsvfVMqTfhmFXgyRH1kDsKD2boYKxvNByBC9pzauEJ
	gSwJfLFvK+CV7sVHP2c/yNHflNqGDjzkz48cJYkofZfW7V3FNWixAilCT6PNQhZVuSb4dBOR5dG
	XtFaxOf+2qzPPLcO9qrqWVzTyAT089npWYiPx6W0WV
X-Google-Smtp-Source: AGHT+IFCDAYjOU7Tv/QzCofEX4QjQQf7VTkE0/1bWiSzEnwsQJCLaG0COOECS73BVhT6La3jE2HlAQ==
X-Received: by 2002:a05:6870:b525:b0:3d3:5ea0:5dd3 with SMTP id 586e51a60fabf-3ffc08f67c1mr8587303fac.10.1768157603977;
        Sun, 11 Jan 2026 10:53:23 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:cc0c:a1b0:fd82:1d57])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa516150fsm10835406fac.20.2026.01.11.10.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 10:53:23 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 11 Jan 2026 12:53:20 -0600
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
Subject: Re: [PATCH V3 21/21] famfs_fuse: Add documentation
Message-ID: <2v2f3kfrbjolx3gaeo3273beah4msor6vpojusrf5ekd4rg7rf@tgnvcuxh3sgo>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-22-john@groves.net>
 <20260108152713.00001b42@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108152713.00001b42@huawei.com>

On 26/01/08 03:27PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:30 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Add Documentation/filesystems/famfs.rst and update MAINTAINERS
> > 
> > Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> > Tested-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
> >  Documentation/filesystems/index.rst |   1 +
> >  MAINTAINERS                         |   1 +
> >  3 files changed, 144 insertions(+)
> >  create mode 100644 Documentation/filesystems/famfs.rst
> > 
> > diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst
> > new file mode 100644
> > index 000000000000..0d3c9ba9b7a8
> > --- /dev/null
> > +++ b/Documentation/filesystems/famfs.rst
> 
> > +Principles of Operation
> > +=======================
> ....
> > +When an app accesses a data object in a famfs file, there is no page cache
> > +involvement. The CPU cache is loaded directly from the shared memory. In
> > +some use cases, this is an enormous reduction read amplification compared
> > +to loading an entire page into the page cache.
> > +
> Trivial but this double blank line seems inconsistent.
> I don't mind if it's one or two, but do the same everywhere.

This doc is identical to the the previous series, becuase I kept the Reviewed-by
and Tested-by tags from Randy. I'm happy to remove the extra blank line if he
or somebody from the doc team thinks I should.

> 
> > +
> > +Famfs is Not a Conventional File System
> > +---------------------------------------
> 
> Nice doc.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan!

John

