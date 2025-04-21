Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8AF12F399
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 20:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745269083; cv=none; b=VCArDnc4j9A8saexL5pAZcpsfcZv2KOqGXmEaiiymnJJRlQRfTJ3Jciy9czrvPmrGL73ra0Dy1xkCferLxUZyL6JTT0TVPSfuPfEGivZJGWScC1pyRG1E30KDgCZfCj9rO/1/+cNpALHrAiypr/7vC7vnPmE2qvX+TvJiiazdFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745269083; c=relaxed/simple;
	bh=7pdH9UOfVfuFbbn9mahzEXs7vahfUfV9abHAxtaRBDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPLN0OsLz66rgG6kCqiWASXJ5ey4FqzKba8EzzL6a6NsKpEoART4zJLEJOeIaiGgtmbWNddyCszm+tWkzzYG4uzcBqziLO3xs0EIY0jAS3sgDvWkqHg10qouqg4j6Nhk+iSc1Fkw2MQi3eZ8fZuuwgDnXmax8sxqV7n7M/upt9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TENWvGd8; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TENWvGd8"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-72fffa03ac6so2571416a34.3
        for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 13:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745269080; x=1745873880; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T1OdjLW6crwFiXOwMGrZBFM5IVgmkv8//EKkYeYlw9o=;
        b=TENWvGd8OzHJAIJWFMnUecIo+iqqSngZIoVPtsC+hd+rS9hq5o+WBmmTci0KVdCzdD
         g+UFHIWuHSvXhy7PbnQ0dkOnMNxP2AfDldJFmgy0rfhwBjaNm4RCP2IxL7PEvaHlsdfT
         o3+alL2ADtiYVtjCGRPsGc5zAxbbB/VVa261/XT2PFpzgO8Fr67L5pqn1CRsHVSmipdl
         mMBm5QSvs7ACmRjY9vcC2YwbIhsprta9IETva7rn+CWJz7XE0xqEvXRiHUEdKSekHylG
         IGBMW3hTgASMyB2SDBFRQ79kpxNyqRmFUNkvmjxw4N2+1Qk21hgiMLKivPfvTsL8Y01X
         6OIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745269080; x=1745873880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1OdjLW6crwFiXOwMGrZBFM5IVgmkv8//EKkYeYlw9o=;
        b=tK8MbdWqtdgLIOMQMtki8t8fBGBvbVldhHnL+iGa9HqmNtN6pfYBisKfVM6R8nhOAE
         mAKtZ2yOW4mwyjfKlchARczD9+SdqIaXV9BptxPSuTRH4qdR76bFAc4xuq+FtZd+OHGz
         MveXJQWXLee5h+H4hNbsTIc6vACvh9F+TvEs0QqKvjT7MwVObo0VDeSePC8zJyvLLepm
         slRwW5ohV42iB/iXmCJGvXZrkxkM+zbReA+58gUA4/6vd8PSLrBL/ac7U/lAc790QS9I
         vvCIu5bA+xJOqylydFTnbFK7icl6dJVmsBtvX0cW8GpGgWFWDHdXqsuU3pCus0NB3QUE
         JgTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5ysMNnlz+7Q1OBdPt6uKjZ5Ir4CxWPP0X0BiXz2K6E+GoNoyJHuavF8jBVZXUhQQ45w1FYfE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWqYWJ1wBKUNfqEBUvLWcPbo2NhqE4JpETHBYMx3SgW1vBLoYd
	ma8UWoblf2zoB2+E5V/EY3u0Om43uFVnFApChtS1PqgRjNYBl5Wp
X-Gm-Gg: ASbGnctFuuN7m9s23ZzmishnymK9F44R6LmUoL5OeDgaZaVr01pKc19xhiVrZGZPx5W
	8drBLQ540KxzA8KsYVaxQ1fp2dsna6l86QkJdla6x5aWpkrP4pKVf82/n4SfhAC6vM3KYIpSIl3
	TnldMobsQb/j3R07US1gXigo2vgzI4sCzab0trY/BuvTBdHD0RmAsbDtDpXif8aTECCLyydze9H
	0VH+M7QrXi/EVJmAWPUJbuAM6rWOco9FA4xdLZyF7/OIj9qaXdLy/0poeOeZJOEDmWl7OvX4yja
	sOwKpIAAXkJcqFgEeWnfizG+s36gFFjqZU//VI9v9Lb+IXyAEwikp/P/ax536wEsum893DA=
X-Google-Smtp-Source: AGHT+IHMdN7/gFi03PEkZIAWvXK0QyaJl9vfIw0jL8mnQREGY3rrDCX2+lnbLjDamLf02BoGJopV2g==
X-Received: by 2002:a05:6830:390f:b0:727:39d7:b0d5 with SMTP id 46e09a7af769-730062290e2mr8959683a34.15.1745269080087;
        Mon, 21 Apr 2025 13:58:00 -0700 (PDT)
Received: from Borg-550.local ([2603:8080:1500:3d89:c191:629b:fde5:2f06])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1607261a34.66.2025.04.21.13.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 13:57:59 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 21 Apr 2025 15:57:57 -0500
From: John Groves <John@groves.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 14/19] famfs_fuse: GET_DAXDEV message and daxdev_table
Message-ID: <6f22k2r6uu4rimplfdna7farx3o2vfwp3korye54tfezemfl3q@hcngav32igrt>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-15-john@groves.net>
 <bed14737-9432-4871-a86f-09c6ce59206b@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bed14737-9432-4871-a86f-09c6ce59206b@infradead.org>

On 25/04/20 08:43PM, Randy Dunlap wrote:
> Hi,

Hi Randy - thanks for the review!

> 
> On 4/20/25 6:33 PM, John Groves wrote:
> > * The new GET_DAXDEV message/response is enabled
> > * The command it triggered by the update_daxdev_table() call, if there
> >   are any daxdevs in the subject fmap that are not represented in the
> >   daxdev_dable yet.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/famfs.c           | 281 ++++++++++++++++++++++++++++++++++++--
> >  fs/fuse/famfs_kfmap.h     |  23 ++++
> >  fs/fuse/fuse_i.h          |   4 +
> >  fs/fuse/inode.c           |   2 +
> >  fs/namei.c                |   1 +
> >  include/uapi/linux/fuse.h |  15 ++
> >  6 files changed, 316 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> > index e62c047d0950..2e182cb7d7c9 100644
> > --- a/fs/fuse/famfs.c
> > +++ b/fs/fuse/famfs.c
> > @@ -20,6 +20,250 @@
> >  #include "famfs_kfmap.h"
> >  #include "fuse_i.h"
> >  
> > +/*
> > + * famfs_teardown()
> > + *
> > + * Deallocate famfs metadata for a fuse_conn
> > + */
> > +void
> > +famfs_teardown(struct fuse_conn *fc)
> 
> Is this function formatting prevalent in fuse?
> It's a bit different from most Linux.
> (many locations throughout the patch set)

I'll check and clean it up if not; function names beginning in column 1 is a
"thing", but I'll normalize to nearby standards.

> 
> > +{
> > +	struct famfs_dax_devlist *devlist = fc->dax_devlist;
> > +	int i;
> > +
> > +	fc->dax_devlist = NULL;
> > +
> > +	if (!devlist)
> > +		return;
> > +
> > +	if (!devlist->devlist)
> > +		goto out;
> > +
> > +	/* Close & release all the daxdevs in our table */
> > +	for (i = 0; i < devlist->nslots; i++) {
> > +		if (devlist->devlist[i].valid && devlist->devlist[i].devp)
> > +			fs_put_dax(devlist->devlist[i].devp, fc);
> > +	}
> > +	kfree(devlist->devlist);
> > +
> > +out:
> > +	kfree(devlist);
> > +}
> > +
> > +static int
> > +famfs_verify_daxdev(const char *pathname, dev_t *devno)
> > +{
> > +	struct inode *inode;
> > +	struct path path;
> > +	int err;
> > +
> > +	if (!pathname || !*pathname)
> > +		return -EINVAL;
> > +
> > +	err = kern_path(pathname, LOOKUP_FOLLOW, &path);
> > +	if (err)
> > +		return err;
> > +
> > +	inode = d_backing_inode(path.dentry);
> > +	if (!S_ISCHR(inode->i_mode)) {
> > +		err = -EINVAL;
> > +		goto out_path_put;
> > +	}
> > +
> > +	if (!may_open_dev(&path)) { /* had to export this */
> > +		err = -EACCES;
> > +		goto out_path_put;
> > +	}
> > +
> > +	*devno = inode->i_rdev;
> > +
> > +out_path_put:
> > +	path_put(&path);
> > +	return err;
> > +}
> > +
> > +/**
> > + * famfs_fuse_get_daxdev()
> 
> Missing " - <short function description>"
> but then it's a static function, so kernel-doc is not required.
> It's up to you, but please use full kernel-doc notation if using kernel-doc.

Thank you - and sorry for being a bit sloppy on this stuff. I'm caching fixes
for all your comments along these lines into a branch for the next version of
the series.

Snipping the rest, but will address it all.

Thanks,
John

