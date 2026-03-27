Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E07D1946BC
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774572985; cv=none; b=qL9hVAtxHN3fpCT9bmGwclUg1bwH8G9VMYVXw9Nwrb2VvI/OkwmPDwR1066XTMajpkpp9FNY+gZmGWAKBQSdr1XIA2nqztxEB+o+I+9/hICUIcd31TKYYh0spNPN2msCbyF1Re5E6Aa14C3sA0Piu5zZKshMqKaYtwfDUtyKZos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774572985; c=relaxed/simple;
	bh=sxgyfDFfcLW8f4y/ctcfNum+GjGlSyLZJz2FFhSHzC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfrnEoXlTWWLSS+akLTPs5axe/j9gX7yG9O7s7yeDhN31yh8QojXy4HE2Ipsk2TFnVymNcLvCja+9L3dO4vnIBMMAfEMwXSvpxZskoLlco76f6XS2M5vax+r6X9cleJ4AqHEJ1khSvLrtoRKyB6TnF8KCB5mSqYRUWz6sGxH7g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9BC1A0F7B;
	Fri, 27 Mar 2026 00:56:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id F1EE220015;
	Fri, 27 Mar 2026 00:56:06 +0000 (UTC)
Date: Thu, 26 Mar 2026 19:56:03 -0500
From: John Groves <John@groves.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, 
	John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <acXMdEKG7kO11OtH@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
 <acPX9T2ZF7xTCHtZ@groves.net>
 <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
 <acVDCKeolpJM9qg6@groves.net>
 <69c5b7411999c_14003310089@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c5b7411999c_14003310089@iweiny-mobl.notmuch>
X-Stat-Signature: ko8szx11u5k77n6nqk59j99a5xxt8mr3
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: F1EE220015
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18Sp1J2sqvErs6fiLaDm7ZjUhkuV6qZy9g=
X-HE-Tag: 1774572966-297846
X-HE-Meta: U2FsdGVkX1/YcZ68/41dDl0EhYoRucZLNm72ZdcH/o76nnU4LKsAsP6rnnq3oWLui378Cpf6Mn+OjxXNQtRaXTfUV1XEi6hJR2XTq9t12sgqXswFKL8H+K61LQVQG9YMdVmVgFHfAev3Hm40IqW3Vlk01SzBI3koppUwIogFjwMWmFDkegfVfrFCA8uvIMqkZSEgnkBRroKwN+vmaKEw//FTkBRUmgwjbt8hXal5pGR/WGIbCwbqsQaSvuHT14o+Pn+bPSEtwJY7XofGBPXedTBHZOhYS4y+RvMB5CLtv/DptLxokykL4JrLNiQtNVPmKvS37uuxTi6LFGOtrlJFqJGsQtGenB7w36A1ecyUTRgRYItUSO/P6aF0aP+r79mcp9xFabObC94pfl4MCWMaMpJhqjpr/VO0Si4q1FSGeppNYB7J3NcH1eaunxXQX01MWwzwgRxOgA02IEdZhrT711tyl7kHYkVkwvOEOyJUSdUuxkBvlWqJZuELzlHP4d8lGuTcmDDsxBJ5xcPs2J8shlPF0aREvtearjkrV6VDUbwNohxR+6AeN0UYYLsiAIH4

On 26/03/26 05:46PM, Ira Weiny wrote:
> John Groves wrote:
> > On 26/03/25 11:04AM, Ira Weiny wrote:
> > > John Groves wrote:
> > > > On 26/03/24 02:39PM, Jonathan Cameron wrote:
> > > > > On Tue, 24 Mar 2026 00:38:31 +0000
> > > > > John Groves <john@jagalactic.com> wrote:
> > > > > 
> > > > > > From: John Groves <john@groves.net>
> > > > > > 
> > > > > > The new fsdev driver provides pages/folios initialized compatibly with
> > > > > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > > > > with order-0 folios.
> > > > > > 
> > > > > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > > > > devdax mode (device.c), which pre-initializes compound folios according
> > > > > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > > > > folios into a fsdax-compatible state.
> > > > > > 
> > > > > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > > > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > > > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > > > > mmap capability.
> > > > > > 
> > > > > > In this commit is just the framework, which remaps pages/folios compatibly
> > > > > > with fsdax.
> > > > > > 
> > > > > > Enabling dax changes:
> > > > > > 
> > > > > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > > > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > > > > - dax.h: prototype inode_dax(), which fsdev needs
> > > > > > 
> > > > > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > > > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > 
> > > > > I was kind of thinking you'd go with a hidden KCONFIG option with default
> > > > > magic to do the same build condition to you had in the Makefil, but one the
> > > > > user can opt in or out for is also fine.
> > > > > 
> > > > > Comments on that below. Meh, I think this is better anyway :)
> > > > > 
> > > > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > > > 
> > > > > 
> > > > > 
> > > > > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > > > > index d656e4c0eb84..7051b70980d5 100644
> > > > > > --- a/drivers/dax/Kconfig
> > > > > > +++ b/drivers/dax/Kconfig
> > > > > > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> > > > > >  	depends on DEV_DAX_HMEM && DAX
> > > > > >  	def_bool y
> > > > > >  
> > > > > > +config DEV_DAX_FSDEV
> > > > > > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > > > > > +	depends on DEV_DAX && FS_DAX
> > > > > > +	help
> > > > > > +	  Support fs-dax access to DAX devices via a character device
> > > > > > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > > > > > +	  based on device alignment), this driver leaves folios at order-0 so
> > > > > > +	  that fs-dax filesystems can manage folio order dynamically.
> > > > > > +
> > > > > > +	  Say M if unsure.
> > > > > Fine like this, but if you wanted to hide it in interests of not
> > > > > confusing users...
> > > > > 
> > > > > config DEV_DAX_FSDEV
> > > > > 	tristate
> > > > > 	depends on DEV_DAX && FS_DAX
> > > > > 	default DEV_DAX
> > > > 
> > > > I like this better. I see no reason not to default to including fsdev.
> > > > It does nothing other than frustrating famfs users if it's off - since
> > > > building it still has no effect unless you put a daxdev in famfs mode.
> > > > 
> > > > Ira, it's kinda in your hands at the moment. Do you feel like making this
> > > > change?
> > > 
> > > I don't mind making this change.  But we have to deal with the breakage to
> > > current device dax users.
> > > 
> > > https://lore.kernel.org/all/69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch/
> > > 
> > > What am I missing?
> > > 
> > > Ira
> > 
> > OK, I can reproduce that failure with kernel 7.0.0-rc5 and 
> > straight ndctl v84. So it's not famfs.
> 
> No it is the fsdev_dax driver which causes the issue.
> 
> I can reload the driver and effectively change the order the drivers are
> searched.
> 
> I can prove this with a simple print.  With my test system (where
> fsdev_dax _happens_ to be the first driver searched) the failure happens.
> 
> [  526.564232] IKW searching drv type 0 ; type 1
> [  526.564515] IKW searching drv type 2 ; type 1
> 
> If I remove your driver (modprobe -r fsdev_dax) prior to running the test
> I get.
> 
> [   59.748171] IKW searching drv type 0 ; type 1
> [   59.749127] IKW searching drv type 1 ; type 1
> 
> And it passes.  I can continue by loading fsdev_dax back and it will
> continue to work.  If you are getting this to pass it must be because in
> your system that driver gets loaded first...  not sure how.
> 
> This is with the same exact kernel just with your module removed at run
> time.
> 
> dax_match_type() needs some other way of matching when the fsdev_dax
> driver should be used.

I think the correct answer is that fsdev/famfs should never automatically 
match and bind. Weird that I haven't seen it do that (or maybe it did but
I didn't notice?)

If one does a mkfs.famfs or 'famfs mount', the famfs tools already try to 
bind fsdev/famfs mode if necessary and fail if they can't.

> 
> I'm not seeing a clear path ATM.

I do, but I need to test it out. If it works I'll send a v10 patch set
in a day or two.

Also, I am definitely seeing ndctl/dax test failures from the device-dax 
and dm.sh tests at rc5 with no famfs code (dax or otherwise) at all; I'm 
puzzled that you don't see any ndctl test failures in that situation. If 
I understood Allison correctly, she saw something similar to what I saw). 
But no worries, we'll get it sorted.

If my strategy works, the next version won't ever automatically bind fsdev,
but it will be explicitly bindable via daxctl or famfs tools. Famfs does not 
need fsdev to ever be automatically bound do dax mem...

> 
> > 
> > I also studied the verbose logs trying to figure out if famfs
> > could cause it (while running a famfs kernel and ndctl), but
> > I don't see it.
> > 
> > Then I tried non-famfs kernel and ndctl and it's the same with
> > or without famfs kernel and famfs ndctl.
> 
> :-/  I'm not seeing any failures with rc5.
> 
> Also I'm not running with famfs.  Just the dax changes.

Right - if fsdev ever gets automatically bound instead of 
drivers/dax/device.c, that's my bad. Weird that I haven't seen that happen, 
but that's why we review and test :D

> 
> Ira

Thank you,
John

