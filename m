Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA6B19F135
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767992424; cv=none; b=S95eo11UA1bCCNszB1833Gecn7T/mdyvyn5sMTlunY6K8k/7PiO4UujMoyJtOUbcSJsl81M99H2CIkspjQEkPnX+4u9OnQYILSMCpvL59Io9hj4ZfZyUr8cIGCnHgg16e1NBF7RfU/5lgvqG8xBnAhaq52q5CnGBKHY75Q94zPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767992424; c=relaxed/simple;
	bh=Lnqx2IsjK6GGMeXoPLfF8Q/0waslPMIHDLq8xmDBOWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=en0u3lqp0dOUlC9TKOCzjprlmFfATn5ANFWqJZEQ7PifTOZBznwDWlJwLdJfWekx9vXbcMH1nCH/jMNgQxd9xeDAcGbXmqwc8XinC7ykC7UTQDJ4rQpf9/XEPEoEZcOxfqrvf9YJZMovGkrInlw0DtdW23FTECokKmFI2WVe4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ope0vwAF; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ope0vwAF"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45a81568eafso700816b6e.0
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 13:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767992422; x=1768597222; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4M8PfdySXBuLCXo+RLzMIyIY7QrHbUdCMkagyIMvnE=;
        b=Ope0vwAFcXBDK30TKyZTjJWY3oODKp6buJOIo/N8chBo2GVdW/ptEAJymMJTLoljKX
         6w+3twFMeZybqm96H7UCp8W117BGc1r/TjGghS/2xjAbg89cbGm/60X/0Enl5NhEhS9B
         sajSKapI25FM0EhHK99yINGpaXQ9lwE4+jgIS2UxausnSOUIpeSf5bpnKh5UKrATkVCu
         n8T+Mz+uIiklLxvUrQDxUUnx2SJFML8rM9OFcpWp78zgpG0sq+yXYvZdrtdvJ37O+JqU
         kPapREU6fCn9XYYYHsdJw1DZ9r1SELSPTRZZNO4dWYTuWPZVZAJ3AN4695OHH53v4BlB
         Ne0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767992422; x=1768597222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v4M8PfdySXBuLCXo+RLzMIyIY7QrHbUdCMkagyIMvnE=;
        b=V9EyU56Xg/02QehmoHUzPx7WDKzBzTzLNFv7f5MZkY3TxNEEbv8B0yx76h2yAsElKG
         qo3ew5CR0ioKY0SChIKLbZoi286CCmn8is73RTYXr07C7MbEhJbnVD5BuYMw9mitDwfm
         1WQIV1RE8ODs+yTqaqXp81qOR/TvZgkhssZr/6z8jc2VE8N9nxARg79860uw7cQKvER/
         SXXOhyMziFY8CkCq86UE64nSStcI0kZHVCFqTHIrgQmUjwou92reciPg49my3xsu1SLu
         Lpdw25v3EcAvTVTYHMNBd4lglD4zfTZwF50If6polKs/iJic9WRUQ89pR8rwb76xzbJ+
         Mr8g==
X-Forwarded-Encrypted: i=1; AJvYcCW7CUFeTQTUGIOyJUNjAb0JN4vHaUeAkvKuEAwLMT4c6o+diWwsKj6DjGIMKr/DK3P69XWP650=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMoPennhXEl3hG/zupBt5fovuyca6/Mk/SYbFAP5mMASuCFJFO
	NhBu381WlykfwqLSq3+FElbs6NorX1Rqj88cI+jpn2fnOm7ybtCIULfi
X-Gm-Gg: AY/fxX6/uQhn/xMFTsM1dvsU1x75r+zpaA9UubmMTFu+hl6MgtJ0DGkP56FUaMOg7Xu
	H8po191A8n53W20rpqHS7tSr6IOb6L6vWlSyllzVsHew+/nzOC2vYNasT9sX5ID+CyBDgFRphH7
	zyK5ayWGjj7E8CI8nvQJl5sj88YUSNeNTll6ZDCTNsS29vvnM3h8QydhthkeJjWot2oLlNL+GDE
	wh8ditxW2zof8iw9SEOg6AD+jnyKjTa7sDvIMwSLLUPD381J089ZUqiOLyRIsXeJlYktqLzxDZY
	qmaeRuYWFuMpuwUt57+vweGHZI3Ydg6QzT+ZrGIB1T6LhtKiEZApsii7MOnQY5t1l40fit/vBYe
	8JxpgaMMU5e68uBz1flHyH23MOdiiU69VnMrEH+N9RsVvxeqkK0IE2rrJagZ1COFapqzNidUln3
	eN5hugya7yLrWGwh9R6Pcya9aWA+vOyg==
X-Google-Smtp-Source: AGHT+IGxLlZof8Jy1wQwdG6wIDxdZkGz6jddwYKP+0ZxEiU+0KGp2+NJH27YNyDn7lRSc6+JT5iBCA==
X-Received: by 2002:a05:6808:c1a9:b0:442:522:41a3 with SMTP id 5614622812f47-45a6becae03mr5521861b6e.60.1767992422011;
        Fri, 09 Jan 2026 13:00:22 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:184d:823f:1f40:e229])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e288bc7sm5503964b6e.12.2026.01.09.13.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 13:00:21 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 9 Jan 2026 15:00:19 -0600
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
Subject: Re: [PATCH V3 18/21] famfs_fuse: Add holder_operations for dax
 notify_failure()
Message-ID: <bonriy66ocy6plo66nryagupftobhlnzjr235fukdx7d6vdyku@gzmq25kktdrb>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-19-john@groves.net>
 <20260108151733.00005f6e@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108151733.00005f6e@huawei.com>

On 26/01/08 03:17PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:27 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Memory errors are at least somewhat more likely on disaggregated memory
> > than on-board memory. This commit registers to be notified by fsdev_dax
> > in the event that a memory failure is detected.
> > 
> > When a file access resolves to a daxdev with memory errors, it will fail
> > with an appropriate error.
> > 
> > If a daxdev failed fs_dax_get(), we set dd->dax_err. If a daxdev called
> > our notify_failure(), set dd->error. When any of the above happens, set
> > (file)->error and stop allowing access.
> > 
> > In general, the recovery from memory errors is to unmount the file
> > system and re-initialize the memory, but there may be usable degraded
> > modes of operation - particularly in the future when famfs supports
> > file systems backed by more than one daxdev. In those cases,
> > accessing data that is on a working daxdev can still work.
> > 
> > For now, return errors for any file that has encountered a memory or dax
> > error.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/famfs.c       | 115 +++++++++++++++++++++++++++++++++++++++---
> >  fs/fuse/famfs_kfmap.h |   3 +-
> >  2 files changed, 109 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> > index c02b14789c6e..4eb87c5c628e 100644
> > --- a/fs/fuse/famfs.c
> > +++ b/fs/fuse/famfs.c
> 
> > @@ -254,6 +288,38 @@ famfs_update_daxdev_table(
> >  	return 0;
> >  }
> >  
> > +static void
> > +famfs_set_daxdev_err(
> > +	struct fuse_conn *fc,
> > +	struct dax_device *dax_devp)
> > +{
> > +	int i;
> > +
> > +	/* Gotta search the list by dax_devp;
> > +	 * read lock because we're not adding or removing daxdev entries
> > +	 */
> > +	down_read(&fc->famfs_devlist_sem);
> 
> Use a guard()

Done

> 
> > +	for (i = 0; i < fc->dax_devlist->nslots; i++) {
> > +		if (fc->dax_devlist->devlist[i].valid) {
> > +			struct famfs_daxdev *dd = &fc->dax_devlist->devlist[i];
> > +
> > +			if (dd->devp != dax_devp)
> > +				continue;
> > +
> > +			dd->error = true;
> > +			up_read(&fc->famfs_devlist_sem);
> > +
> > +			pr_err("%s: memory error on daxdev %s (%d)\n",
> > +			       __func__, dd->name, i);
> > +			goto done;
> > +		}
> > +	}
> > +	up_read(&fc->famfs_devlist_sem);
> > +	pr_err("%s: memory err on unrecognized daxdev\n", __func__);
> > +
> > +done:
> 
> If this isn't getting more interesting, just return above.

Right - simplified.

> 
> > +}
> > +
> >  /***************************************************************************/
> >  
> >  void
> > @@ -611,6 +677,26 @@ famfs_file_init_dax(
> >  
> >  static ssize_t famfs_file_bad(struct inode *inode);
> >  
> > +static int famfs_dax_err(struct famfs_daxdev *dd)
> 
> I'd introduce this earlier in the series to reduce need
> to refactor below.

Will mull that over when I further mull the helpers in fuse_i.h that are
hard to rebase...

> 
> > +{
> > +	if (!dd->valid) {
> > +		pr_err("%s: daxdev=%s invalid\n",
> > +		       __func__, dd->name);
> > +		return -EIO;
> > +	}
> > +	if (dd->dax_err) {
> > +		pr_err("%s: daxdev=%s dax_err\n",
> > +		       __func__, dd->name);
> > +		return -EIO;
> > +	}
> > +	if (dd->error) {
> > +		pr_err("%s: daxdev=%s memory error\n",
> > +		       __func__, dd->name);
> > +		return -EHWPOISON;
> > +	}
> > +	return 0;
> > +}
> 
> ...
> 
> > @@ -966,7 +1064,8 @@ famfs_file_bad(struct inode *inode)
> >  		return -EIO;
> >  	}
> >  	if (meta->error) {
> > -		pr_debug("%s: previously detected metadata errors\n", __func__);
> > +		pr_debug("%s: previously detected metadata errors\n",
> > +			 __func__);
> 
> Spurious change.

Derp. Reverted out

Thanks Jonathan

