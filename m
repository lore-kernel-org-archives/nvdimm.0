Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA314EFDB
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 22:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709072126; cv=none; b=Fxs1wm9HCZY+26cEARAiyl5zkkixDEyiMQq8CZH1mqf33VIEZSpERtHgnc4bMMSfzcRPEkq3bY4GcCIJaaIeI/q7rIMzjyd/611W1LuAYP7XZ9XlPvwYK6uaWlGvNPWxbbs19MHNhpiKNlq2j80uDBl55tUxUjLIXKD7/Ko9+Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709072126; c=relaxed/simple;
	bh=H0bRBi5Hvxdu8BhZUiSwQ4zqP2aNAbrTGOFlAL9HJGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRJpILg9Q4wNWrAqybdiom4aIepTM505+F7ye0tU9YU7fLv2L3Iu6FrHy3kJneI7Bf9jH/sATwo3GtFSFHAjBlhmlj5Le/GBlggFDDeuvwAEHF4ro9DJ3Zs6UcHaFwgPSJ0JLr0KLYxSqZCL0WAkKgzyH5OiL7F0ug81vJVaTb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1VKDCDe; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1VKDCDe"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2206232d806so290104fac.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709072123; x=1709676923; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QeQuoKsMqjADISGm2Hn4uU+Ji8iXgLUMY646RY4awK4=;
        b=m1VKDCDefKvd0TIx48r77z4M8GhTGKJhIe87bxV+dUyLSRsNjXfpzCxXVnbFqxPUMU
         x6m4aYDGGuBDqH0EywhSCFpg2tD8vUajTrLGB5y/EhY1Qv0cywYLYE6MGaZrgWBq7O3B
         2FHiIGuURuTMAXBeAB3KJq6yhzK5ixxHs04wUy2CiJq2EgSfZVLCuSxoDewT6P1mmBn+
         ENfNjfjR41XAq4bgLJKoLkPIkcZ2uFXA7fzpNdcy0AKrmYQBopquaDCvkDvsqqwAA26j
         T0/bJwP7NjymAkX28POyQ/t+hG3KtSUjV97JbdftheyNzrev2dPNRwooaFVmkaDcvqep
         /BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709072123; x=1709676923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QeQuoKsMqjADISGm2Hn4uU+Ji8iXgLUMY646RY4awK4=;
        b=Pd0S1rZCrs98+BDw3ow66yvuyTnyHP3qF4hAvJpJ+ZH70sqprIA3tTqBmjxE7/EmAG
         LFx5pdQvrlz7QYlZuZZ87Pc2iQ10TWK+U4ZeqzFN0AnhY1JPEBpKCR34Ed3rmZ7dNLGB
         KxgCHk/1mwNN1co3q8g4H8ECrIYnyKpdQ8gWoC6ZDMy1ehnAVGmH5XXJ9v8fAC05JkZ4
         utIeZjND7x5AwnrW445DQAP/KHx+CxzQvpGJnyWujkBrvWXBuU8d9pQHDFkkk5Pqhav6
         w3Zx51aOwRB7u0VYpzsDcDT9jIfXeSt4A9+8ZEIBSvTkUBJLeSLzEgybS5atcM0ic3xO
         DUVA==
X-Forwarded-Encrypted: i=1; AJvYcCX12vi9+3lrGddGSab1DmYSYV6vkn2d2C+LzC/6gwVybVFZ96u5XxSgm0aThpn5rVi5qRUcvyfm1xzSrhxCbrpkqmeeR3PR
X-Gm-Message-State: AOJu0Yzxf4ccpdX+yKYQmkThl4xnsmPwL8wadoKn6SWk3b/fOPSdPK/N
	XRFSZq24bso/xOwihXO0+EkTv3JliNgoUZ8BhEp6/yCXC+VIAFyd
X-Google-Smtp-Source: AGHT+IG+nWjzy1vXAWmi7d4mreq3B1aqw1Sej/iFVDg9WGc8pdhcR0YbATO4JmgBoO6xtBE1Kqr+ZQ==
X-Received: by 2002:a05:6870:c112:b0:21f:ccef:a4d0 with SMTP id f18-20020a056870c11200b0021fccefa4d0mr10576079oad.21.1709072123242;
        Tue, 27 Feb 2024 14:15:23 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id gq27-20020a056870d91b00b0021fb8dc5cabsm2257249oab.47.2024.02.27.14.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 14:15:22 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 16:15:21 -0600
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
Subject: Re: [RFC PATCH 17/20] famfs: Add module stuff
Message-ID: <ydr7ziya3e5evsdbofcqgestidkrjv7opsb6behlcs5oew4kbo@zhyhhzuh26ma>
References: <cover.1708709155.git.john@groves.net>
 <e633fb92d3c20ba446e60c2c161cf07074aef374.1708709155.git.john@groves.net>
 <20240226134748.00003f57@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226134748.00003f57@Huawei.com>

On 24/02/26 01:47PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:42:01 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This commit introduces the module init and exit machinery for famfs.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> I'd prefer to see this from the start with the functionality of the module
> built up as you go + build logic in place.  Makes it easy to spot places
> where the patches aren't appropriately self constrained. 
> > ---
> >  fs/famfs/famfs_inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > index ab46ec50b70d..0d659820e8ff 100644
> > --- a/fs/famfs/famfs_inode.c
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -462,4 +462,48 @@ static struct file_system_type famfs_fs_type = {
> >  	.fs_flags	  = FS_USERNS_MOUNT,
> >  };
> >  
> > +/*****************************************************************************************
> > + * Module stuff
> 
> I'd drop these drivers structure comments. They add little beyond
> a high possibility of being wrong after the code has evolved a bit.

Probably will do with the module-ops-up refactor for v2

> 
> > + */
> > +static struct kobject *famfs_kobj;
> > +
> > +static int __init init_famfs_fs(void)
> > +{
> > +	int rc;
> > +
> > +#if defined(CONFIG_DEV_DAX_IOMAP)
> > +	pr_notice("%s: Your kernel supports famfs on /dev/dax\n", __func__);
> > +#else
> > +	pr_notice("%s: Your kernel does not support famfs on /dev/dax\n", __func__);
> > +#endif
> > +	famfs_kobj = kobject_create_and_add(MODULE_NAME, fs_kobj);
> > +	if (!famfs_kobj) {
> > +		pr_warn("Failed to create kobject\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	rc = sysfs_create_group(famfs_kobj, &famfs_attr_group);
> > +	if (rc) {
> > +		kobject_put(famfs_kobj);
> > +		pr_warn("%s: Failed to create sysfs group\n", __func__);
> > +		return rc;
> > +	}
> > +
> > +	return register_filesystem(&famfs_fs_type);
> 
> If this fails, do we not leak the kobj and sysfs groups?

Good catch, thanks! Fixed for now- but the kobj is also likely to go away. Will
endeavor to get it right...

Thanks,
John

