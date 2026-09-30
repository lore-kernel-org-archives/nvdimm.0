Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ABD37E5DB;
	Wed, 30 Sep 2026 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782515; cv=none; b=Ytve7DpLYNKv6gAJNhURZu8vn8f2g2WNs+auKiuO2F9iKmBmd8jqvOoPGsQIGsm1kCRb05MmNax+L5ehAYTtUr7RsIRL7oJjF2n0go4cXlGjuRPwr3rfbdpzaZBjdzZjQbVLvSxdwCTzmPTQoBMHs1D9kEec0OG/FEUFivS7b58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782515; c=relaxed/simple;
	bh=glDR9rPiqLtJKlnXuD51/1q4bP/bHKkj/e9OpZD7bVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0UHCxFVx4+RfDONQPOPe7SS3An55CrEEE2yCwFwLJiVz+mPuyTkqmnKkSyPd/WP7z76H8W1x0TCn0dNTiJf7IqkwflSkZugFnnUGGeb+Arlwq6mx5pVl6d12TB9ZEZdeiocMtdrmRtEO8JjEpkiZddcS+e4g5L65iLtNV4uN9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdWcc94T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdWcc94T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14C891F00899;
	Wed, 30 Sep 2026 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790782507;
	bh=e8MML2gJrDDcMRCJ5PIStiD2beqwx3+yQN2TtHaQYhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RdWcc94THfMHwFSUABgjmg41Bq1G2/l2cJVK+SE2JZxJ7LVRoTvm70gZfQIgoPqFS
	 fcAFHKxWUE5cOMF7E/+ldTvOV52jVo42dqn0iHEfjkM8v8e6yeih1BIm6cH2A2rC2z
	 aogf5nyS48lpoFvwuMr3c8ivTcLl8ZHPP92kyEcBukiYtjVcj8XyIi2oirit0VF8Ok
	 4p6DcrVx0m3JVyJ/tF9DC8RxykLQWfGAzmcLqGBvnUDpx6zl0NT04c11maqGRz0FsY
	 1sN0qciiRS0nNWbi4ykx849AqCcYN7hX3ozmP5H//jwqm5Y38Zfu1G5qpzTcbRDNW0
	 XBJDiDjzA5obg==
Date: Wed, 30 Sep 2026 08:35:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	fuse-devel <fuse-devel@lists.linux.dev>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org,
	John Groves <John@groves.net>
Subject: Re: fs_put_dax() vs. dax_holder_notify_failure() race
Message-ID: <20260930153506.GR6253@frogsfrogsfrogs>
References: <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguyOXGQO4Q8rSAc8GxExTJU0G2o19fxRnh_93GvAoNcRg@mail.gmail.com>

On Wed, Sep 30, 2026 at 04:29:33PM +0200, Miklos Szeredi wrote:
> During ->notify_failure() callback will dereference holder.  It may be
> NULL at this point, resulting in an Oops, or it may be non-NULL but be
> freed during that call, resulting in UAF.
> 
> This affects xfs at this point, but the fuse extent map patchset[1]
> also adds dax failure handling and is affected by this issue.
> 
> I think this should be fixed in drivers/dax/super.c, since this will
> be a problem in each user.

Yes, I would have thought that the notification code would grab a
refcount on the dax device so that it can't go away.  Though it does
seem a little wild that there's no means to pause fs_dax_put until
all the notifications have cleared....?

--D

> Thanks,
> Miklos
> 
> [1] Report from sashiko (select Patch 8):
> 
> https://sashiko.dev/#/patchset/20260922061019.3320196-1-mszeredi%40redhat.com
> 
> Or here it is inline:
> 
> commit 1580a2f8ad3f103a20b6280aa39a01f8b0be2d3f
> Author: Miklos Szeredi <mszeredi@redhat.com>
> 
> fuse: add support for opening dax device as backing
> 
> Add FUSE_BACKING_IS_DEV flag that allows opening a character device
> (dax device) as a backing, in addition to regular files. Mark the
> inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.
> 
> > diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> > index 58dbdd17c1ef4..aa558a0c2e647 100644
> > --- a/fs/fuse/backing.c
> > +++ b/fs/fuse/backing.c
> [ ... ]
> > @@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
> >  {
> >   pr_debug("%s: fb=0x%p\n", __func__, fb);
> >
> > - if (fb->file)
> > - fput(fb->file);
> > - put_cred(fb->cred);
> > + switch (fb->type) {
> > + case FUSE_BACKING_PATH:
> > + path_put(&fb->path);
> > + put_cred(fb->cred);
> > + break;
> > +
> > + case FUSE_BACKING_DAXDEV:
> > + fs_put_dax(fb->dax_dev, fb);
> > + break;
> > + }
> >   kfree_rcu(fb, rcu);
> 
> Does this code introduce a use-after-free race with a concurrent hardware
> memory failure?
> 
> When a DAX-backed FUSE backing file is closed, fuse_backing_free() drops the
> DAX device holder by calling fs_put_dax() and frees the backing object using
> normal RCU via kfree_rcu().
> 
> Concurrently, a hardware memory failure can trigger dax_holder_notify_failure(),
> which protects its read-side critical section with SRCU using dax_read_lock().
> 
> If dax_holder_notify_failure() reads dax_dev->holder_ops and checks for NULL,
> and is preempted here, fs_put_dax() can run to completion. This would set
> dax_dev->holder_ops and dax_dev->holder_data to NULL, and eventually free fb
> after a normal RCU grace period.
> 
> Because kfree_rcu() does not wait for SRCU readers, the memory could be freed
> while dax_holder_notify_failure() is still running.
> 
> [ ... ]
> > @@ -79,23 +87,88 @@ static struct fuse_backing *fuse_backing_id_remove(struct fuse_conn *fc, u64 id,
> >   return fb;
> >  }
> >
> > +static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset, u64 len, int mf_flags)
> > +{
> > + struct fuse_backing *fb = dax_holder(daxdev);
> > +
> > + fb->dax_error = true;
> 
> Can this code cause a NULL pointer dereference or use-after-free when racing
> with fuse_backing_free()?
> 
> When dax_holder_notify_failure() resumes after the race described in
> fuse_backing_free(), it blindly calls ops->notify_failure() which is this
> function.
> 
> Because fs_put_dax() may have already cleared dax_dev->holder_data,
> dax_holder() might return NULL causing a NULL pointer dereference here.
> Depending on the timing, it could also return a stale pointer to the freed
> fb object, resulting in a use-after-free.
> 
> > +
> > + return 0;
> > +}
> 
