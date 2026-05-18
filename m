Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC29448AE17;
	Mon, 18 May 2026 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779120109; cv=none; b=J/S/NCK21FZsh0mq8RIsZWR4eHIP+2shmwidw3b4LQpkUh8HVbaokCOffQdCItEPN0OHWb6FdwCytHTWbNWpRjG7uXBlLUwgNr7jAN/dSfK1K+PIWToAqicaeSxWisQhC88vL3WCsTQlfB4A6K/t7YRxPn4pH1w5Zj8IBe95Jus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779120109; c=relaxed/simple;
	bh=FCGWUGMNjJV87dNcPdgRZIs+BRGoP/SlXkuHlY98T30=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UR37kub0wtnjrFGYG1OP7Nhmu/CIApDYsYFHn8CJRxMV1sQR7zExI8WW5GI+WcP1TOYnXIgiiaVsFx/WH1fFUNAUu93Nl2pxLnoPUMY4Q8DNgCUIX8gg6RAaxBqRG5a0yurdVbOcuePet0EC79ULDRdNauY8rH8mShAgNYe4mXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mooAlLJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mooAlLJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EB4C2BCB7;
	Mon, 18 May 2026 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779120109;
	bh=FCGWUGMNjJV87dNcPdgRZIs+BRGoP/SlXkuHlY98T30=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mooAlLJ8eGyEh5XBPlgxqvsOXURyISyRpD+m1sQYECwNeyFbeEHQd93ygi+yV+zz+
	 /D7lxzPpUKC88m5HLKZaMcoq1VhExtoQfxk0jJmZmPSNIjwBYs0zz4QczjWLZRx2b3
	 9k+xlTk2idgJUG0EPnDtufZe0lfnxNVgo+csGqw2kLeSvhOhgnDvi7Pu2Z0Sx+g3hS
	 stHOOgdePpxzdd6RHCt7KUO+ghfFIs4jhQHEcmbirbMW0sJHe1Drpwu6LV1/VUAnbQ
	 LQRDhfONGIyGQF5PoGV0zxcPgWoNtm1X6E6f36wG4XcTgDIQSRg955GqS0/34bZIBS
	 8jmUXACbLmvqA==
Date: Mon, 18 May 2026 17:01:41 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Chen Pei <cp0613@linux.alibaba.com>, <nvdimm@lists.linux.dev>,
 <linux-cxl@vger.kernel.org>, <guoren@kernel.org>
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
Message-ID: <20260518170141.215d1755@jic23-huawei>
In-Reply-To: <agZJACMViARKTp8W@aschofie-mobl2.lan>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
	<20260514063234.86439-3-cp0613@linux.alibaba.com>
	<20260514193749.0f0750e2@jic23-huawei>
	<agZJACMViARKTp8W@aschofie-mobl2.lan>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 May 2026 15:13:20 -0700
Alison Schofield <alison.schofield@intel.com> wrote:

> On Thu, May 14, 2026 at 07:37:49PM +0100, Jonathan Cameron wrote:
> > On Thu, 14 May 2026 14:32:34 +0800
> > Chen Pei <cp0613@linux.alibaba.com> wrote:
> >   
> > > kmod_module_probe_insert_module() is supposed to return 0 for builtin
> > > modules, but only when libkmod can locate the modules.builtin index. If
> > > the index is missing or out of sync, libkmod falls through to the real
> > > init_module() syscall and returns an error such as -ENOENT, producing a
> > > spurious "insert failure" even though the driver is already part of the
> > > running kernel.
> > > 
> > > Pre-check kmod_module_get_initstate() and short-circuit when the module
> > > is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE, matching the pattern used by
> > > ndctl's own test/core.c.  
> > 
> > So I happened to run into exactly this print earlier today and was
> > very happy to see this resolving it! I'm lazy so when developing in
> > a VM tend to do everything I care about built in and not bother with
> > installing the modules.
> > 
> > However - despite having CONFIG_DEV_DAX = y in the kernel, I'm getting
> > a state of KMOD_MODULE_COMING which is curious as there is no
> > initstate file to read that from.  
> 
> I think this patch is worth you trying. In libmkmod code I'm looking at:

It doesn't work - hence the reply!

> 
> https://github.com/lucasdemarchi/kmod/blob/master/libkmod/libkmod-module.c
> 
> the "module directory exists but initstate cannot be opened" case returns
> KMOD_MODULE_BUILTIN, not KMOD_MODULE_COMING.

I'm  not following... Also...
https://github.com/kmod-project/kmod/tree/master/libkmod
Is a lot more recent than that tree of Lucas and I'm guessing the current
home given it has 2 week old commits from Lucas.

Can you give me a line number for the path you are talking about because even
in that code of Lucas I'm failing to see it.  Note the kmod_module_is_buitin()
fails for the reason this patch is trying to fix. The file to check that isn't
there - hence we hit the path that tries to figure it out from sysfs.
I can't see any other path to a KMOD_MODULE_BUILTIN.

Jonathan


> 
> So if device_dax is builtin and /sys/module/device_dax exists without
> initstate, this patch should short-circuit before attempting insert. If
> you still see COMING with this patch applied, then we need to figure out
> where that state is coming from (before thinking about special casing
> it in ndctl).
> 
> > 
> > Looking at the code in libkmod it seems to first check if it can open
> > /sys/modules/device_dax/initstate and if it can't checks if
> > the directory /sys/modules/device_dax/ exists. If it finds that it returns
> > KMOD_MODULE_COMING which seems odd given in a fully initialized built in driver
> > that particular set of circumstances is normal.
> > 
> > Any ideas?
> > 
> > To me the description above is misleading if we need to have something else
> > for the builtin case to work.
> > 
> > I'm out of time to today but may get time to look at this tomorrow and chase
> > down if there is a way to get it to work.
> > 
> > Jonathan
> > 
> >   
> > > 
> > > For builtin modules the local kmod reference is dropped because builtin
> > > drivers cannot be unloaded; for live modules the reference is retained
> > > in dev->module, matching the post-probe-success behavior.
> > > 
> > > Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> > > ---
> > >  daxctl/lib/libdaxctl.c | 18 ++++++++++++++++--
> > >  util/sysfs.c           | 17 +++++++++++------
> > >  2 files changed, 27 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > > index ffc81eb..42bfc39 100644
> > > --- a/daxctl/lib/libdaxctl.c
> > > +++ b/daxctl/lib/libdaxctl.c
> > > @@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> > >  	const char *devname = daxctl_dev_get_devname(dev);
> > >  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > >  	struct kmod_module *kmod;
> > > -	int rc;
> > > +	int state, rc;
> > >  
> > >  	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
> > >  	if (rc < 0) {
> > > @@ -919,7 +919,21 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> > >  		return rc;
> > >  	}
> > >  
> > > -	/* if the driver is builtin, this Just Works */
> > > +	/* If the driver is builtin or already live, skip probe-insert. */
> > > +	state = kmod_module_get_initstate(kmod);
> > > +	if (state == KMOD_MODULE_BUILTIN) {
> > > +		dbg(ctx, "%s: module %s is builtin\n", devname,
> > > +			kmod_module_get_name(kmod));
> > > +		kmod_module_unref(kmod);
> > > +		return 0;
> > > +	}
> > > +	if (state == KMOD_MODULE_LIVE) {
> > > +		dbg(ctx, "%s: module %s already loaded\n", devname,
> > > +			kmod_module_get_name(kmod));
> > > +		dev->module = kmod;
> > > +		return 0;
> > > +	}
> > > +
> > >  	dbg(ctx, "%s inserting module: %s\n", devname,
> > >  		kmod_module_get_name(kmod));
> > >  	rc = kmod_module_probe_insert_module(kmod,
> > > diff --git a/util/sysfs.c b/util/sysfs.c
> > > index e027e38..641b86d 100644
> > > --- a/util/sysfs.c
> > > +++ b/util/sysfs.c
> > > @@ -183,12 +183,17 @@ int __util_bind(const char *devname, struct kmod_module *module,
> > >  	}
> > >  
> > >  	if (module) {
> > > -		rc = kmod_module_probe_insert_module(module,
> > > -						     KMOD_PROBE_APPLY_BLACKLIST,
> > > -						     NULL, NULL, NULL, NULL);
> > > -		if (rc < 0) {
> > > -			log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > > -			return rc;
> > > +		/* Skip probe-insert when the module is already builtin or live. */
> > > +		int state = kmod_module_get_initstate(module);
> > > +
> > > +		if (state != KMOD_MODULE_BUILTIN && state != KMOD_MODULE_LIVE) {
> > > +			rc = kmod_module_probe_insert_module(module,
> > > +							     KMOD_PROBE_APPLY_BLACKLIST,
> > > +							     NULL, NULL, NULL, NULL);
> > > +			if (rc < 0) {
> > > +				log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > > +				return rc;
> > > +			}
> > >  		}
> > >  	}
> > >    
> >   

