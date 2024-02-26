Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0FF1E878
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708988407; cv=none; b=aNod2xTUi1ZxxevbN6jhkuvAGl/6Dyb3kBlProNAnundYAn6QScXQY8w7oyvaBL5y5D1XeBTokXqVqe7PA0+MZd/rAuyaERGGGEj5driyfmMY/RE6SgH1IeX+Nzt/Hkqn/hn6Ec/31Vx3RkEGH2toTZty2ZjF5gq4g1NkR3EI/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708988407; c=relaxed/simple;
	bh=eDdDRpRLOs+TLu9DRUmMhRRpoJ/GPPb+1lbirKhJPXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QzDvo2hVkasWAEz3nwvaWu8FC6YSCY6WVAK0ydOxWgEZM5uWXS7EhhrlSWzKmmPcuT+tcxbXf7wf6gg1la2bbjWHQNfphzU1f3Dze5VGTiu8Ft54WW78lLtNP+2lwScpS5zG7z+O6GyUYMh2RrouwupMr+rEiekREsZWzDuBuwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9jYVT/2; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9jYVT/2"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59fd69bab3bso1540808eaf.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 15:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708988403; x=1709593203; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zww+OwBsoYB5pURroMSrOkz/ZQvrjX3VS1JUC45kLpM=;
        b=D9jYVT/2Gx2MJ1lesKAhbLKr4zCMmXP6Y7RmPzJzdNFSztUF9smuC1Z5XbUd9eqGaE
         hwcxCMiJsYeyj9gk+i8y6kmfAJU99zI3JdmTogkv5Y8pZsmCUc5JbC+5TJx2C4+sIhjC
         +Bs4LdNgz16Cv7348nYLXBQSK0YsvcjHaBHvpnGGk3Vlm2M7XMZm0i+iuf1ERdUSsSmW
         0jitQbrx6+h8Wc0OfKdIgMRjBDFfudMU80a5648gm6dJSS+Ck0LPe3tp8ntNPm4T2iCW
         wjgY0fU6el83x8XHOJ54jbdDsHHEZ6N+bE2xwWoB6OAM9CV9ue8uEFUAnUdUSRzG7rUf
         qW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708988403; x=1709593203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zww+OwBsoYB5pURroMSrOkz/ZQvrjX3VS1JUC45kLpM=;
        b=u3xe5oUJoJrBCRcFrEY1oqYxxMz/zc2j75h+NJJaozP02NUHSDvw4fmiKux1kQAwYC
         XPAXVdkt7RGZS8736r37H7I+lHJWpFOfPUD/3OYtWxEk3RGEi7HwndiyAccFX1nloUk8
         Vu2SRXVxR7igFc+1nb/OqhEmawgHpZ5uADfzFwEDcAAcqRoQWIsSmzgi5E3jyZjtLEMQ
         ViO7gNSck8S42rWtVaYOMv7A91mM5GPs6wweZticA1xc3WtVBgg9HVDE99But2SqU/Eh
         MHxLg/L58m9njdvwweV878yJa1kfiPLU/6/L3Vdn5ETSuzk/N1REv8NiULtswqlIOk9W
         7IlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbaJpXp26DXkIgLjdZm53LeWCaGvrgVvb3fyeQPZ6msoToCe8KE40tnMui0QE25Oc2DAUPInfQV6F+k/HBFhJ+tsesOWOe
X-Gm-Message-State: AOJu0Yx2PTATYp24y+bcp7jAtyIyO2f3ypMo7Jx0xYTO6qwDLJbFswD3
	ucxXCadT1EepyUY8no3+9W1vrLeDWQDJOXnjlKBO+YcLSuE6aito
X-Google-Smtp-Source: AGHT+IG3rstfE0sxQj75CLdtkz7tDS/WIIMftEy2NPTiJzeS4j0Vku5utN7c2f5g6t9XbBlzt+Z8DA==
X-Received: by 2002:a05:6820:2c07:b0:5a0:651d:4238 with SMTP id dw7-20020a0568202c0700b005a0651d4238mr5467910oob.2.1708988403399;
        Mon, 26 Feb 2024 15:00:03 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id ej5-20020a0568200d0500b005a06c8ecf54sm1135729oob.25.2024.02.26.15.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 15:00:03 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 17:00:00 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 13/20] famfs: Add iomap_ops
Message-ID: <y4gzithu2qurexucsa5kq542pws3qfxf5rtpza6a7qzsb3r2bv@b434hxvv7hv2>
References: <cover.1708709155.git.john@groves.net>
 <2996a7e757c3762a9a28c789645acd289f5f7bc0.1708709155.git.john@groves.net>
 <20240226133038.00006e23@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226133038.00006e23@Huawei.com>

On 24/02/26 01:30PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:57 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This commit introduces the famfs iomap_ops. When either
> > dax_iomap_fault() or dax_iomap_rw() is called, we get a callback
> > via our iomap_begin() handler. The question being asked is
> > "please resolve (file, offset) to (daxdev, offset)". The function
> > famfs_meta_to_dax_offset() does this.
> > 
> > The per-file metadata is just an extent list to the
> > backing dax dev.  The order of this resolution is O(N) for N
> > extents. Note with the current user space, files usually have
> > only one extent.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> > ---
> >  fs/famfs/famfs_file.c | 245 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 245 insertions(+)
> >  create mode 100644 fs/famfs/famfs_file.c
> > 
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > new file mode 100644
> > index 000000000000..fc667d5f7be8
> > --- /dev/null
> > +++ b/fs/famfs/famfs_file.c
> > @@ -0,0 +1,245 @@
> 
> > +static int
> > +famfs_meta_to_dax_offset(
> > +	struct inode *inode,
> > +	struct iomap *iomap,
> > +	loff_t        offset,
> > +	loff_t        len,
> > +	unsigned int  flags)
> > +{
> > +	struct famfs_file_meta *meta = (struct famfs_file_meta *)inode->i_private;
> 
> i_private is void * so no need for explicit cast (C spec says this is always fine without)

Yessir.

> 
> 
> > +
> > +/**
> > + * famfs_iomap_begin()
> > + *
> > + * This function is pretty simple because files are
> > + * * never partially allocated
> > + * * never have holes (never sparse)
> > + * * never "allocate on write"
> > + */
> > +static int
> > +famfs_iomap_begin(
> > +	struct inode	       *inode,
> > +	loff_t			offset,
> > +	loff_t			length,
> > +	unsigned int		flags,
> > +	struct iomap	       *iomap,
> > +	struct iomap	       *srcmap)
> > +{
> > +	struct famfs_file_meta *meta = inode->i_private;
> > +	size_t size;
> > +	int rc;
> > +
> > +	size = i_size_read(inode);
> > +
> > +	WARN_ON(size != meta->file_size);
> > +
> > +	rc = famfs_meta_to_dax_offset(inode, iomap, offset, length, flags);
> > +
> > +	return rc;
> 	return famfs_meta_...

Done

> 
> > +}
> 
> 
> > +static vm_fault_t
> > +famfs_filemap_map_pages(
> > +	struct vm_fault	       *vmf,
> > +	pgoff_t			start_pgoff,
> > +	pgoff_t			end_pgoff)
> > +{
> > +	vm_fault_t ret;
> > +
> > +	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
> > +	return ret;
> 	return filename_map_pages()....

Done, thanks

John

