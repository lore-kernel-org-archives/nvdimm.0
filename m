Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A1874BF1
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 22:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244999; cv=none; b=JGI6XCKUGyhRF8cdZfXJIzeYRIcSJUTG3R5oVaHsxnyh44N9aUj6ihIbEe84J0O9600P1z5fShIeYPOPq9hEljdjSiJIsdhQdv/FMRKtO9UQzg6jD9sq2AHHJVybtOH7BKAI/Pss32HV9+uKqaaEsJtePAG+eFzHbQRXZVcFtiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244999; c=relaxed/simple;
	bh=ACzWMSBVSbROvAz/KF0+OOhAKUBYt21796gDCX9IvxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjX7TVFaKJiINyFQa4E1Arn2BSeGh3wgDrmg3xy/lfFnlPM72RKyuArZmJ/+BJVd9PNKO7BP2Qllihm7dLwP9SZGWti3YlqETJqgPLGsOlXpCoNyJxN2WMFk+jY58Q2xwqkIzIWj7SFrIPtBcgqeW1qhiUuElJifXc/eZOOMBqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcemUpiT; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcemUpiT"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-21f3a4ba205so530923fac.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 14:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709244996; x=1709849796; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jX/0FGNYJgzcsBn/SznB4/DvBP9JHSAGQHtl/qEj9o=;
        b=jcemUpiTJRtsKfpM8aGKDn4JgK68kklSWKvKsJJyzDqE5fteqHQ7+UQboA8Bc0nN0y
         Zb3XjedvC1k3lSq9IJVut9AUnLa4j/mK/6hBDERFPxI5fCIX8PEREZ8lx8JXsIFyuD3+
         2lrpPHtVSTW623c/eIVPegDkoLwZCKyPzjIbmnKUERedpFlw0oRp5QPTyMggCBVOpGta
         vAlGjXGyfXnFozk7OCKjSSZovmCHowvc1jRaz7YAhPjHK/bT99OKhWjDOQ8qkt3G+Grk
         f7sAG2fFlMyR33IAlE2OuubcxYQD9dwUbwAX2NcPNNemEvS/Iz3MQPMzSByJ+EGJKPUE
         VU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709244996; x=1709849796;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jX/0FGNYJgzcsBn/SznB4/DvBP9JHSAGQHtl/qEj9o=;
        b=P9BfHS3URwX6VTlxwibxA/FquCBQ9iWUDAhBJSNdOjqh6CjecWue3ni8c7UqdymAWa
         E9YgIIX5iuhzlUb833xVR49Padz/GVQFK6w8dhA4Xp4FInyrRhirHtZs6asA6gTDs66l
         /KzkYoRVjgn+pZqIxV4B7lPaTflGWtXXUN0AgKsZWMuqP3xnHtduFYko8xSeMHnHytoI
         bdLr6gQ0k3wHfLocdC2fhuaaZ41jHxVRlC2P9rfgtXBfaXvaMRqAvi0rNaDDioV5AUuh
         TP/p1bbSndBkp9Q1e2krs7xjfdiUQ9fN6Rtqdiyt0n9akCzCoQ0EyvnF5XixV9+LQ5AH
         dUzA==
X-Forwarded-Encrypted: i=1; AJvYcCXUrpw3Vz7Q15fkDCOqNFW9svKcBnGLgl/+NFK3Q0bnugG2vBIfS+KASDAQJS1f23pmjAB5WRvVtugU/4RiZppWTPbD3nrh
X-Gm-Message-State: AOJu0Yw2H8/+LPXinOD71+GotrnmRvDq2KpHSG2x/aYgA13wajd+z0MX
	pQVhXukR1hD1vMMcxqZdMuqqmL+wlccwhd1orpNUuuCzRS3Wk+iq
X-Google-Smtp-Source: AGHT+IFyGPwgD+94e5jiTNKG6OD6umzOYBwkvbAB5UKUevYwym/Dgn02nynUh8GFXuJUSfHgSNy1AA==
X-Received: by 2002:a05:6870:6112:b0:220:88b7:5145 with SMTP id s18-20020a056870611200b0022088b75145mr3500762oae.41.1709244996533;
        Thu, 29 Feb 2024 14:16:36 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id s20-20020a0568302a9400b006e4ad2edb1bsm446693otu.8.2024.02.29.14.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 14:16:36 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 29 Feb 2024 16:16:33 -0600
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com, Miklos Szeredi <miklos@szeredi.hu>, 
	Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <3jwluwrqj6rwsxdsksfvdeo5uccgmnkh7rgefaeyxf2gu75344@ybhwncywkftx>
References: <cover.1708709155.git.john@groves.net>
 <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>

On 24/02/29 08:52AM, Amir Goldstein wrote:
> On Fri, Feb 23, 2024 at 7:42 PM John Groves <John@groves.net> wrote:
> >
> > This patch set introduces famfs[1] - a special-purpose fs-dax file system
> > for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> > CXL-specific in anyway way.
> >
> > * Famfs creates a simple access method for storing and sharing data in
> >   sharable memory. The memory is exposed and accessed as memory-mappable
> >   dax files.
> > * Famfs supports multiple hosts mounting the same file system from the
> >   same memory (something existing fs-dax file systems don't do).
> > * A famfs file system can be created on either a /dev/pmem device in fs-dax
> >   mode, or a /dev/dax device in devdax mode (the latter depending on
> >   patches 2-6 of this series).
> >
> > The famfs kernel file system is part the famfs framework; additional
> > components in user space[2] handle metadata and direct the famfs kernel
> > module to instantiate files that map to specific memory. The famfs user
> > space has documentation and a reasonably thorough test suite.
> >
> 
> So can we say that Famfs is Fuse specialized for DAX?
> 
> I am asking because you seem to have asked it first:
> https://lore.kernel.org/linux-fsdevel/0100018b2439ebf3-a442db6f-f685-4bc4-b4b0-28dc333f6712-000000@email.amazonses.com/
> I guess that you did not get your answers to your questions before or at LPC?

Thanks for paying attention Amir. I think there is some validity to thinking
of famfs as Fuse for DAX. Administration / metadata originating in user space
is similar (but doing it this way also helps reduce RAS exposure to memory 
that might have a more complex connection path).

One way it differs from fuse is that famfs is very much aimed at use
cases that require performance. *Accessing* files must run at full
memory speeds.

> 
> I did not see your question back in October.
> Let me try to answer your questions and we can discuss later if a new dedicated
> kernel driver + userspace API is really needed, or if FUSE could be used as is
> extended for your needs.
> 
> You wrote:
> "...My naive reading of the existence of some sort of fuse/dax support
> for virtiofs
> suggested that there might be a way of doing this - but I may be wrong
> about that."
> 
> I'm not virtiofs expert, but I don't think that you are wrong about this.
> IIUC, virtiofsd could map arbitrary memory region to any fuse file mmaped
> by virtiofs client.
> 
> So what are the gaps between virtiofs and famfs that justify a new filesystem
> driver and new userspace API?

I have a lot of thoughts here, and an actual conversation might be good
sooner rather than later. I hope to be at LSFMM to discuss this - if you agree,
put in a vote for my topic ;). But if you want to talk sooner than that, I'm
interested.

I think one piece of evidence that this isn't possible with Fuse today is that
I had to plumb the iomap interface for /dev/dax in this patch set. That is the
way that fs-dax file systems communicate with the dax layer for fault 
resolution. If fuse/virtiofs handles dax somehow without the iomap interface,
I suspect it's doing something somehow simpler, /and/ that might need to get 
reconciled with the fs-dax methodology. Or maybe I don't know what I'm talking
about (in which case, please help :D).

I think one thing that might make sense would be to bring up this functionality
as a standalone file system, and then consider merging it into fuse when &
if the time seems right. 

Famfs doesn't currently have any up-calls. User space plays the log and tells
the kmod to instantiate files with extent lists to dax. Access happens with
zero user space involvement.

The important thing, the thing I'm currently paid for, is making it
practical to use disaggregated shared memory - it's ultimately not important 
which mechanism is used to enable a filesystem access method for memory.

But caching metadata in the kernel for efficient fault handling is the
only way to get it to perform at "memory speeds" so that appears critical.

One final observation: famfs has significantly more code in user space than
in kernel space, and it's the user side that is likely to grow over time.
That logic is at least theoretically independent of the kernel ABI.

> 
> Thanks,
> Amir.

Thanks!
John

