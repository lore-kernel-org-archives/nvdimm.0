Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D00EA4
	for <nvdimm@lists.linux.dev>; Wed, 28 Feb 2024 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709081982; cv=none; b=NQSzo0Q5sLWoQw5YmxpwQIe0MAp+a7VCLHYVCe7DSr4KigD7uCq28vCBsKU7CwfL00eI0xV7UirMzuS/ft1Qd2+lGP1LeSpdISz7DnBw8xHiTd/YSRdArNLqYWtKZV0WjahXHBVf1HM+3wGRXjvRONzfzvUOx2kA2A0Y4RKLCwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709081982; c=relaxed/simple;
	bh=6mAwiUtOknSSutvq0YNFLvWJ9KCKfA9wjlmgNIu1avE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kv8hg/6jHrmlRGISfWrAJfhZE5TmkfIH7g7CFGS88T6Iy4dZQ5L1sssoXfwU0M9P4FMoDmtC8wPpUDHtRJhMgKTsCShZ/KFBZBrxK1xkhG1P9O0LEhC4ME5IX1C/OXQqbBNdoPAuLkNRvIGWqwDb75SgKN0liTaAhM0HXfPDPpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bD1idP59; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bD1idP59"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-21ea1aae402so2610920fac.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 16:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709081979; x=1709686779; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/VJ4ezn4JfkgFtFkFYYYQTXIflXruAY0C3laMtvGzA=;
        b=bD1idP59BlddTL8pU79s3TGl/n9huLGrxcD/zkYJIErap2GLX9HMtgKcK1cBEgLSZO
         7QALUX0su/Dos9m9M3Ey2rKd8ZxnNN2NSo/03a9JnnE0gPQoM6LPCs8bhicokBEH/1JW
         gHPjfiyUaYpk9hqDERJhCHxoJMisYQc4Pmp3Nr2UmeuhsU4covv96JWlk8XidqaybYCP
         o23lxf0Ai2Jf3ES+gORB74lkdfEFrRTnJ5/JsVJzuYhf73QGVmP1Yom6gv9YwQiUrfr/
         Jije8svR02qaafmODTA4wdkm7qmWngA5DE2A/I77Brahe7HKXcHPMMbSyIdpEF3iHrBW
         u21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709081979; x=1709686779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/VJ4ezn4JfkgFtFkFYYYQTXIflXruAY0C3laMtvGzA=;
        b=Q6W1W+NZuCWAcSnVAxG+/xAEgAl/QRtL9FslS7ooU7AwSqH2QDJ91xBmgVztqKiFtB
         38Y8075A/jR03xSUTw4L+5Vyv1CzpGXg2fopE9hrXrgO7Bxz2eig57/m6uSG41Z5U3Wx
         8Q7phYEHJMQenTxIQl2F2ge9WDAYn7SwPfVjQQ6wXlQyvJgzi+NvT4zSRffenmSDmTpW
         6yFDPsCP+5Rsjx+NDfenPptBSPJndm5dZWGfN1OF+iHc31RFQVXHUZNu1LnYGU7jz+uQ
         pegXED/X7ZqIBMraPcmCGOgowJ7V6Mf2H9Y0zLN4lMg//RHSJ2Dx+XhV83VWx2K8SSfN
         k0WQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0EMUqa1b6UDqneoV6e0InsbH5LClZpfMyDABxPOtVevn0zBwmLB/P0sSqIxuNh2uc5pXSZkAxC9iSpxp/q8k0j8I4n13J
X-Gm-Message-State: AOJu0YwvfDq21Xi/+I+gW65ucp89wEnusjd5JAh29oFtulHpMGMhu+37
	6IAXWgf1+Xa+Okwkz12H8hF0+N1u91P37LCFEM6xyHdoROt16MA6
X-Google-Smtp-Source: AGHT+IE/bq+pbCEPKnDfm3BhnEgfwUEKQIWim6ODi2jvIyHs822SfRjbFVspFukSBnfjmr30t4HikQ==
X-Received: by 2002:a05:6870:55d2:b0:21e:5827:9483 with SMTP id qk18-20020a05687055d200b0021e58279483mr13395251oac.29.1709081978556;
        Tue, 27 Feb 2024 16:59:38 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id xm12-20020a0568709f8c00b0021fb37e33e5sm2322033oab.19.2024.02.27.16.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 16:59:38 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 18:59:36 -0600
From: John Groves <John@groves.net>
To: Christian Brauner <brauner@kernel.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 11/20] famfs: Add fs_context_operations
Message-ID: <6jrtl2vc4dmi5b6db6tte2ckiyjmiwezbtlwrtmm464v65wkhj@znzv2mwjfgsk>
References: <a645646f071e7baa30ef37ea46ea1330ac2eb63f.1708709155.git.john@groves.net>
 <20240227-mammut-tastatur-d791ca2f556b@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227-mammut-tastatur-d791ca2f556b@brauner>

On 24/02/27 02:41PM, Christian Brauner wrote:
> On Fri, Feb 23, 2024 at 11:41:55AM -0600, John Groves wrote:
> > This commit introduces the famfs fs_context_operations and
> > famfs_get_inode() which is used by the context operations.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c | 178 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 178 insertions(+)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index 82c861998093..f98f82962d7b 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c

<snip>

> > +enum famfs_param {
> > +	Opt_mode,
> > +	Opt_dax,
> > +};
> > +
> > +const struct fs_parameter_spec famfs_fs_parameters[] = {
> > +	fsparam_u32oct("mode",	  Opt_mode),
> > +	fsparam_string("dax",     Opt_dax),
> > +	{}
> > +};
> > +
> > +static int famfs_parse_param(
> > +	struct fs_context   *fc,
> > +	struct fs_parameter *param)
> > +{
> > +	struct famfs_fs_info *fsi = fc->s_fs_info;
> > +	struct fs_parse_result result;
> > +	int opt;
> > +
> > +	opt = fs_parse(fc, famfs_fs_parameters, param, &result);
> > +	if (opt == -ENOPARAM) {
> > +		opt = vfs_parse_fs_param_source(fc, param);
> > +		if (opt != -ENOPARAM)
> > +			return opt;
> 
> I'm not sure I understand this. But in any case add, you should add
> Opt_source to enum famfs_param and then add
> 
>         fsparam_string("source",        Opt_source),
> 
> to famfs_fs_parameters. Then you can add:
> 
> famfs_parse_source(fc, param);
> 
> You might want to consider validating your devices right away. So think
> about:
> 
> fd_fs = fsopen("famfs", ...);
> ret = fsconfig(fd_fs, FSCONFIG_SET_STRING, "source", "/definitely/not/valid/device", ...) // succeeds
> ret = fsconfig(fd_fs, FSCONFIG_SET_FLAG, "OPTION_1", ...) // succeeds
> ret = fsconfig(fd_fs, FSCONFIG_SET_FLAG, "OPTION_2", ...) // succeeds 
> ret = fsconfig(fd_fs, FSCONFIG_SET_FLAG, "OPTION_3", ...) // succeeds 
> ret = fsconfig(fd_fs, FSCONFIG_SET_FLAG, "OPTION_N", ...) // succeeds 
> ret = fsconfig(fd_fs, FSCONFIG_CMD_CREATE, ...) // superblock creation failed
> 
> So what failed exactly? Yes, you can log into the fscontext and dmesg
> that it's @source that's the issue but it's annoying for userspace to
> setup a whole mount context only to figure out that some option was
> wrong at the end of it.
> 
> So validating
> 
> famfs_parse_source(...)
> {
> 	if (fc->source)
> 		return invalfc(fc, "Uhm, we already have a source....
> 	
>        lookup_bdev(fc->source, &dev)
>        // validate it's a device you're actually happy to use
> 
>        fc->source = param->string;
>        param->string = NULL;
> }
> 
> Your ->get_tree implementation that actually creates/finds the
> superblock will validate fc->source again and yes, there's a race here
> in so far as the path that fc->source points to could change in between
> validating this in famfs_parse_source() and ->get_tree() superblock
> creation. This is fixable even right now but then you couldn't reuse
> common infrastrucute so I would just accept that race for now and we
> should provide a nicer mechanism on the vfs layer.

I wasn't aware of the new fsconfig interface. Is there documentation or a
file sytsem that already uses it that I should refer to? I didn't find an
obvious candidate, but it might be me. If it should be obvious from the
example above, tell me and I'll try harder.

My famfs code above was copied from ramfs. If you point me to 
documentation I might send you a ramfs fsconfig patch too :D.

> 
> > +
> > +		return 0;
> > +	}
> > +	if (opt < 0)
> > +		return opt;
> > +
> > +	switch (opt) {
> > +	case Opt_mode:
> > +		fsi->mount_opts.mode = result.uint_32 & S_IALLUGO;
> > +		break;
> > +	case Opt_dax:
> > +		if (strcmp(param->string, "always"))
> > +			pr_notice("%s: invalid dax mode %s\n",
> > +				  __func__, param->string);
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static DEFINE_MUTEX(famfs_context_mutex);
> > +static LIST_HEAD(famfs_context_list);
> > +
> > +static int famfs_get_tree(struct fs_context *fc)
> > +{
> > +	struct famfs_fs_info *fsi_entry;
> > +	struct famfs_fs_info *fsi = fc->s_fs_info;
> > +
> > +	fsi->rootdev = kstrdup(fc->source, GFP_KERNEL);
> > +	if (!fsi->rootdev)
> > +		return -ENOMEM;
> > +
> > +	/* Fail if famfs is already mounted from the same device */
> > +	mutex_lock(&famfs_context_mutex);
> > +	list_for_each_entry(fsi_entry, &famfs_context_list, fsi_list) {
> > +		if (strcmp(fsi_entry->rootdev, fc->source) == 0) {
> > +			mutex_unlock(&famfs_context_mutex);
> > +			pr_err("%s: already mounted from rootdev %s\n", __func__, fc->source);
> > +			return -EALREADY;
> 
> What errno is EALREADY? Isn't that socket stuff. In any case, it seems
> you want EBUSY?

Thanks... That should probaby be EBUSY. But the whole famfs_context_list
should probably also be removed. More below...

> 
> But bigger picture I'm lost. And why do you keep that list based on
> strings? What if I do:
> 
> mount -t famfs /dev/pmem1234 /mnt # succeeds
> 
> mount -t famfs /dev/pmem1234 /opt # ah, fsck me, this fails.. But wait a minute....
> 
> mount --bind /dev/pmem1234 /evil-masterplan
> 
> mount -t famfs /evil-masterplan /opt # succeeds. YAY
> 
> I believe that would trivially defeat your check.
> 

And I suspect this is related to the get_tree issue you noticed below.

This famfs code was working in 6.5 without keeping the linked list of devices,
but in 6.6/6.7/6.8 it works provided you don't try to repeat a mount command
that has already succeeded. I'm not sure why 6.5 protected me from that,
but the later versions don't. In 6.6+ That hits a BUG_ON (have specifics on 
that but not handy right now).

So for a while we just removed repeated mount requests from the famfs smoke
tests, but eventually I implemented the list above, which - though you're right
it would be easy to circumvent and therefore is not right - it did solve the
problem that we were testing for.

I suspect that correctly handling get_tree might solve this problem.

Please assume that linked list will be removed - it was not the right solution.

More below...

> > +		}
> > +	}
> > +
> > +	list_add(&fsi->fsi_list, &famfs_context_list);
> > +	mutex_unlock(&famfs_context_mutex);
> > +
> > +	return get_tree_nodev(fc, famfs_fill_super);
> 
> So why isn't this using get_tree_bdev()? Note that a while ago I
> added FSCONFIG_CMD_CREAT_EXCL which prevents silent superblock reuse. To
> implement that I added fs_context->exclusive. If you unconditionally set
> fc->exclusive = 1 in your famfs_init_fs_context() and use
> get_tree_bdev() it will give you EBUSY if fc->source is already in use -
> including other famfs instances.
> 
> I also fail to yet understand how that function which actually opens the block
> device and gets the dax device figures into this. It's a bit hard to follow
> what's going on since you add all those unused functions and types so there's
> never a wider context to see that stuff in.

Clearly that's a bug in my code. That get_tree_nodev() is from ramfs, which
was the starting point for famfs.

I'm wondering if doing this correctly (get_tree_bdev() when it's pmem) would
have solved my double mount problem on 6.6 onward.

However, there's another wrinkle: I'm concluding
(see https://lore.kernel.org/linux-fsdevel/ups6cvjw6bx5m3hotn452brbbcgemnarsasre6ep2lbe4tpjsy@ezp6oh5c72ur/)
that famfs should drop block support and just work with /dev/dax. So famfs 
may be the first file system to be hosted on a character device? Certainly 
first on character dax. 

Given that, what variant of get_tree() should it call? Should it add 
get_tree_dax()? I'm not yet familiar enough with that code to have a worthy 
opinion on this.

Please let me know what you think.

Thank you for the serious review!
John


