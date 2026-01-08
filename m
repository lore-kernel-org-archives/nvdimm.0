Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12754187FE4
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895705; cv=none; b=CsT6dmTnxbfHMd+bC8iVI8jj5m/wsay5EJGGv/zVfmNFqKaey5W6JtBntSUh0S2fiNDj8AY00dh4OWGQrVzJtlRZTVj0vn5P8FIS+Joj1NOKVZFZO3iV+gja8Asj2eq+SOrNknzCX5fKqCuBt32TDNWhNBwXUNTo0ZZCHVtKPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895705; c=relaxed/simple;
	bh=MmK1SujRNf2S2W33zhGcNZEf7Eh4KS8jaIg2kKAyUI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwgJX0r0t6W2HvZK03rYCInNMaSQsCJS6onXWHWjxUH7PojQt9wZuq8QL0rVuiBdOThKtMLeanbaQfJMH95ab51WOPUHFqJ89zqVqVtHc49hiVkL1vopGit0NCO9vdep90dO4LVVkBNH0XYbcfM+IuqU5uK+BB595Zdpx/rVeN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSsMaPao; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSsMaPao"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cac8243bcdso2270042a34.3
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 10:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767895700; x=1768500500; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XI9IhUnsXzT6Xe36mfNiAku0AsRQgr8M/6vd/MAZgJw=;
        b=kSsMaPaozhCjEdtGzkMvYqQY8mq4+/m2yS2v+rYjSkeBQIklZpLQ5s3leLnWDap1lK
         ZyZpRAWLoF2qYNr3mYWDlSumO9RCFSE0qqCUItLzgquUd6uZi+IbuHWpx2IvuwTpd4+j
         Gb7eRUQVeFx3ftxniFkjjCvX2n2Gn4zskBMyr9Et+2p9tCHwOyoRZDoDUQspgE5hCnUp
         JIbG8tVglwYE4jrnTyYYonZppbyxwM3YzZodQC7KQ+RccrxtSY67Eih8/v9fBwgFP55n
         yvFRTRkVP719miQaUgvUNFRYqV69WNU/c8cQV5nSCUJFAr90tStA3Bg+cm5tUD1JkhS9
         OMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767895700; x=1768500500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XI9IhUnsXzT6Xe36mfNiAku0AsRQgr8M/6vd/MAZgJw=;
        b=bqNrkzTmA9baTuZOjW31f8lJQyJ1waoITkKH6Xrc17FQF/huSoR7F8xtfj0CcwQ47f
         wAyo4Tbjz3s++1QHmvlp85AAOd5CRq7QlWo3f70FnknnykHmRK2N4RCdJ6wyXksaIBU4
         dzDqnaKLP65Ac9xBX2yD2dvT3Q5YWUKyVU/ixgSzVUZi951uEW0QwkYTr6qyq8kgRVoW
         V7SjSFCZGQfbBF36OdUGGpa20v7YixIM5rFbk94MK7c7hI5ztyvrRwfLrJcwwLkCwlrL
         v+Dn8F3VDpFW8sF8aRLoa2R33cWPyxuP37mJuCSLA3R2vYV+dxTuAb7I+w9Ta4obrn+x
         VdSA==
X-Forwarded-Encrypted: i=1; AJvYcCWmPH8LWSfWY6GLpnTViwV7I0bn/9ss6vId06gQSrLMvXL7KXxe3k1M3nRB4Md2eJ49Vk+tJt0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKtdGna1DtXEKmxteXsLj9fo6WXMBC04V3/+4F82SKIhLKc6af
	kF4JY7AOuSdMBAXuLW7pl6LrfFR2hX5LEn3Uhw6fqOMpwb5vlqtXztkp
X-Gm-Gg: AY/fxX7Df+WBTA6DpXNI4pq/MzplzkcS8iwPfAR6WrZTglFfNIip9LAfFmro4M38UvA
	O5iuXZdMNSjNDEkgJSqyMDGGCLkdzfu7fzs6R9+Pk362ocfpG+i7Ay3Qv9PMBuTl1V5CS9N/wnx
	V6TbJ/duLQab7vFiv+e7xQNosJ93MHlhMy49kFvJzkb7/JVspQGN5zAKSy+NU3r6UNgvWTRmPLn
	amtiVHsfXCkV5qdZ/Q6j0MOKoEJwbRFsCtw4o2u/5+4IaYiRmiHiHRjndYb1u0kl4sZ3ub3L8a/
	cbLzX7vIp/dx0DYZ6I+SXEMuHV+lBhZPDawi23WWoXFpaG82qyOnlatHvw6qNl9qKF5Q4xUxfQr
	abVqVpeVyqtm+87twtvy7e923K+6wjQ9LH+QRZb0MLrKtcGk9VKTzdhM4AvfsXAjwxG79iS6pCL
	BxF65fUXP4AqpAaPTdVRKnUiV3BXgMdg==
X-Google-Smtp-Source: AGHT+IEjWT5M9/INgbL6wkWLwsvPXOhe1gZQdudmQFnLtNyCh1dUGd0KiFZ98Jj/kb2bsPwekn22xQ==
X-Received: by 2002:a05:6820:7511:b0:65f:5418:5844 with SMTP id 006d021491bc7-65f54eda3d7mr2172010eaf.20.1767895700283;
        Thu, 08 Jan 2026 10:08:20 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48cb03d4sm3649518eaf.12.2026.01.08.10.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 10:08:19 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 12:08:16 -0600
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
Subject: Re: [PATCH V3 07/21] dax: prevent driver unbind while filesystem
 holds device
Message-ID: <q5ucezwbtvslsbbudo4sfwsnrh2b7jdul56wwg5vubbq7ekwzs@iqdm3ovre5bf>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-8-john@groves.net>
 <20260108123450.00004eac@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108123450.00004eac@huawei.com>

On 26/01/08 12:34PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:16 -0600
> John Groves <John@Groves.net> wrote:
> 
> > From: John Groves <John@Groves.net>
> > 
> > Add custom bind/unbind sysfs attributes for the dax bus that check
> > whether a filesystem has registered as a holder (via fs_dax_get())
> > before allowing driver unbind.
> > 
> > When a filesystem like famfs mounts on a dax device, it registers
> > itself as the holder via dax_holder_ops. Previously, there was no
> > mechanism to prevent driver unbind while the filesystem was mounted,
> > which could cause some havoc.
> > 
> > The new unbind_store() checks dax_holder() and returns -EBUSY if
> > a holder is registered, giving userspace proper feedback that the
> > device is in use.
> > 
> > To use our custom bind/unbind handlers instead of the default ones,
> > set suppress_bind_attrs=true on all dax drivers during registration.
> 
> Whilst I appreciate that it is painful, so are many other driver unbinds
> where services are provided to another driver.  Is there any precedence
> for doing something like this? If not, I'd like to see a review on this
> from one of the driver core folk. Maybe Greg KH.
> 
> Might just be a case of calling it something else to avoid userspace
> tooling getting a surprise.

I'll do more digging to see if there are other patterns; feedback/ideas
requested...

> 
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  drivers/dax/bus.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index 6e0e28116edc..ed453442739d 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -151,9 +151,61 @@ static ssize_t remove_id_store(struct device_driver *drv, const char *buf,
> >  }
> >  static DRIVER_ATTR_WO(remove_id);
> >  
> > +static const struct bus_type dax_bus_type;
> > +
> > +/*
> > + * Custom bind/unbind handlers for dax bus.
> > + * The unbind handler checks if a filesystem holds the dax device and
> > + * returns -EBUSY if so, preventing driver unbind while in use.
> > + */
> > +static ssize_t unbind_store(struct device_driver *drv, const char *buf,
> > +		size_t count)
> > +{
> > +	struct device *dev;
> > +	int rc = -ENODEV;
> > +
> > +	dev = bus_find_device_by_name(&dax_bus_type, NULL, buf);
> 
> 	struct device *dev __free(put_device) = bus_find_device_by_name()...
> 
> and you can just return on error.
> 
> > +	if (dev && dev->driver == drv) {
> With the __free I'd flip this
> 	if (!dev || !dev->driver == drv)
> 		return -ENODEV;
> 
> 	...
> 

I like it; done.

> > +		struct dev_dax *dev_dax = to_dev_dax(dev);
> > +
> > +		if (dax_holder(dev_dax->dax_dev)) {
> > +			dev_dbg(dev,
> > +				"%s: blocking unbind due to active holder\n",
> > +				__func__);
> > +			rc = -EBUSY;
> > +			goto out;
> > +		}
> > +		device_release_driver(dev);
> > +		rc = count;
> > +	}
> > +out:
> > +	put_device(dev);
> > +	return rc;
> > +}
> > +static DRIVER_ATTR_WO(unbind);
> > +
> > +static ssize_t bind_store(struct device_driver *drv, const char *buf,
> > +		size_t count)
> > +{
> > +	struct device *dev;
> > +	int rc = -ENODEV;
> > +
> > +	dev = bus_find_device_by_name(&dax_bus_type, NULL, buf);
> Use __free magic here as well..
> > +	if (dev) {
> > +		rc = device_driver_attach(drv, dev);
> > +		if (!rc)
> > +			rc = count;
> then this can be
> 		if (rc)
> 			return rc;
> 		return count;
> 

Done

Thanks!
John

