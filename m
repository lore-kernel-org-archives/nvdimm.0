Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11113164A1
	for <nvdimm@lists.linux.dev>; Sun, 26 Apr 2026 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777247828; cv=none; b=vCI7yh3Gin+ZjxASDKOI0Qd4thUzaKMNaxGewcakb1wA3bH67JL2atFfYQujRjxUj+T1LkI5VAoSCGNZUQBuHvDM09rQbHRM4n4/jIusPba7zkBdTIl+7uEG1vO36wHmMsj4by1nXSOJbB8H07QBpbeiMC8sf9ly+mNcpzhJNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777247828; c=relaxed/simple;
	bh=XmNZ25JviKfT2ppQT+dMiP10WaXoGI2IHIweLZdopcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fP5/te8wmDJSctxHBWwfieqGdKqgKkt9/ZpiN9Zgd9CAgpe+VUvNisr+wS0bl/cQtrdgei1sYQFdsEpnyQhawz7kE/wO+AKorSu66g5xAVDSjb0x7NG0crbyuz3hUbD7r1CPbR+sjuKszOe8he6svANVIRXVeK2ib+4HMmIA+C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10AE51B8C10;
	Sun, 26 Apr 2026 23:56:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf11.hostedemail.com (Postfix) with ESMTPA id 5B3072002A;
	Sun, 26 Apr 2026 23:56:47 +0000 (UTC)
Date: Sun, 26 Apr 2026 18:56:46 -0500
From: John Groves <John@groves.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Message-ID: <ae6e9wYqgLkWsS-e@groves.net>
References: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
X-Rspamd-Queue-Id: 5B3072002A
X-Stat-Signature: r49r8re331sizxziokm115mnz3b1s454
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19u7GbFuQadFVki3V8MJh0E+hGt0fj4tgg=
X-HE-Tag: 1777247807-31514
X-HE-Meta: U2FsdGVkX1+ejEaOBEq+s20L42bbwXjGwb5g2mDO8CAE5LR6nn/pI2TTWArk1d1VlMhjsWX04EpdjtoUwD57LgCgKVnHXpsVZKTEgMOSQ/eBI1MFhpuilvIWaBO6Wcnp17MglLqJhjpGeab2cDeD4WFI0iypH2q9cWhVwm/XpBe783Ntivguwd4nXQdm1ocjbmt2f024CBQlGpjf5SMh4KYvEvrXnw2sq2Y75LIJj3S/I88WgwIHBBI9v+WZgrGBZG/3kAAoKqDNPoM7SjQvvTn8uDosAos/qF5dEOH642zm8ZtISN7mJ+MLeJ2yC8VY+TbUbtZ5LgrQhfrQcGlN9irbyW7qj5sYw6zYtiYYRgi+TjUq/7K/DG42fl3PLmlmwbhkOLDRwtLdlQg0lM8NpeDPO0xspyl1X1anyB1MiPD+Vua2TkmPKELhBNHbNr4KlDX9+KS8HWBIuShIbY5ocBewvEvFs3on

Maybe I'm overcomplicating things (it's one of the things I do), 
but I'm still struggling through how to address all these issues. 
Some comments inline.

On 26/02/26 06:00PM, Alison Schofield wrote:
> On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> > (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> > it is in famfs mode.
> > 
> > The test is added to the destructive test suite since it
> > modifies device modes.
> 
> Make it clear that it is added in a separate patch. (and assume you
> can drop the destructive part too.)
> 
> > 
> > With devdax, famfs, and system-ram modes, the previous logic that assumed
> > 'not in mode X means in mode Y' needed to get slightly more complicated
> > 
> > Add explicit mode detection functions:
> > - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> > - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> 
> 
> The precedence check (ram->famfs->devdax->unknown) now happens in multiple
> places. How about adding a daxctl_dev_get_mode() helper to centralize that.
> It could be private for now, unless you expect external users to need it.
> 
> daxctl_dev_is_famfs_mode() and _is_devdax_mode() are nearly identical aside
> from the module name. Refactoring the shared part into a single helper will
> also make it easier to add a daxctl_dev_get_mode() without duplicating the
> precedence logic.
> 
> > 
> > Fix mode transition logic in device.c:
> > - disable_devdax_device(): verify device is actually in devdax mode
> > - disable_famfs_device(): verify device is actually in famfs mode
> > - All reconfig_mode_*() functions now explicitly check each mode
> > - Handle unknown mode with error instead of wrong assumption
> 
> Wondering about 'Fix' mode transition logic. Was prior logic broken and
> should any of these changes be in a precursor patch that is a 'fix'.
> 
> 
> > 
> > Modify json.c to show 'unknown' if device is not in a recognized mode.
> 
> I think this means disabled devices will always look unknown even when
> the intended mode is devdax or famfs, but disabled. This seems to
> change the meaning of mode from 'configured' to 'active' personality.
> Can you detect the configured mode even when disabled?
> Perhaps a man page change about this new behavior?

Good point; before famfs mode there were just 2 modes, and 
not-system-ram == devdax mode is the current standard, even if no driver 
is bound. At some level that's a conflation, but I'll revise and stick 
with that unless you have a better idea.

Is that how you want it? No driver == devdax mode?

Any thoughts?

> 
> snip
> 
> 
> >  
> > @@ -724,11 +767,21 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
> >  	}
> >  
> >  	if (daxctl_dev_is_enabled(dev)) {
> > -		rc = disable_devdax_device(dev);
> > -		if (rc < 0)
> > -			return rc;
> > -		if (rc > 0)
> 
> Please check the return code semantics.
> This gets rid of the <0 vs >0 distinction. That means a '1' skip
> becomes an error return to the caller. Is that what you want?
> 
> Previously, we had a return 1 from disable_devdax_device for
> “not applicable / already in other mode” and I think that is now
> gone.
> 
> 
> > +		if (mem) {
> > +			/* already in system-ram mode */
> >  			skip_enable = 1;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			rc = disable_famfs_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			rc = disable_devdax_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> >  	}
> >  
> 
> snip
> 
> >  static int reconfig_mode_devdax(struct daxctl_dev *dev)
> >  {
> > +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> > +	const char *devname = daxctl_dev_get_devname(dev);
> >  	int rc;
> >  
> >  	if (daxctl_dev_is_enabled(dev)) {
> > -		rc = disable_system_ram_device(dev);
> > -		if (rc)
> > -			return rc;
> > +		if (mem) {
> > +			rc = disable_system_ram_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			rc = disable_famfs_device(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			/* already in devdax mode, just re-enable */
> > +			rc = daxctl_dev_disable(dev);
> > +			if (rc)
> 
> disable_* helpers print an error message on disable failure.
> Seems this should too.
> 
> 
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> >  	}
> >  
> >  	rc = daxctl_dev_enable_devdax(dev);
> > @@ -801,6 +870,40 @@ static int reconfig_mode_devdax(struct daxctl_dev *dev)
> >  	return 0;
> >  }
> >  
> > +static int reconfig_mode_famfs(struct daxctl_dev *dev)
> > +{
> > +	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> > +	const char *devname = daxctl_dev_get_devname(dev);
> > +	int rc;
> > +
> > +	if (daxctl_dev_is_enabled(dev)) {
> > +		if (mem) {
> > +			fprintf(stderr,
> > +				"%s is in system-ram mode, must be in devdax mode to convert to famfs\n",
> > +				devname);
> > +			return -EINVAL;
> > +		} else if (daxctl_dev_is_famfs_mode(dev)) {
> > +			/* already in famfs mode, just re-enable */
> > +			rc = daxctl_dev_disable(dev);
> > +			if (rc)
> > +				return rc;
> > +		} else if (daxctl_dev_is_devdax_mode(dev)) {
> > +			rc = disable_devdax_device(dev);
> > +			if (rc)
> 
> and here too...the disable error message.
> 
> 
> > +				return rc;
> > +		} else {
> > +			fprintf(stderr, "%s: unknown mode\n", devname);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	rc = daxctl_dev_enable_famfs(dev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	return 0;
> > +}
> 
> snip
> 
> > +DAXCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)
> > +{
> > +	const char *devname = daxctl_dev_get_devname(dev);
> > +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > +	char *mod_path, *mod_base;
> > +	char path[200];
> 
> We have PATH_MAX for the above.

Done, thanks...

> 
> > +	const int len = sizeof(path);
> > +
> > +	if (!device_model_is_dax_bus(dev))
> > +		return false;
> > +
> > +	if (!daxctl_dev_is_enabled(dev))
> > +		return false;
> > +
> > +	if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {
> > +		err(ctx, "%s: buffer too small!\n", devname);
> > +		return false;
> > +	}
> > +
> > +	mod_path = realpath(path, NULL);
> > +	if (!mod_path)
> 
> Maybe a dbg() level err msg here
> 
> > +		return false;
> > +
> > +	mod_base = basename(mod_path);
> 
> Please use path_basename() because of this:
> https://lore.kernel.org/all/20260116043056.542346-1-alison.schofield@intel.com/
> 
> Give me a minute ;) to push that to the pending branch and you can
> work from there: https://github.com/pmem/ndctl/commits/pending/
> 
> snip to end.

Done, thanks

Still chewing on the other stuff

