Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD49334845C
	for <nvdimm@lists.linux.dev>; Thu, 26 Mar 2026 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774535615; cv=none; b=fdhUP9Uu6F54TXrFRmJhMr1hxnnHiHlP5aurtVSYRXHZTsN3ULqpZ9YnQZchgPFAtaYQQUS8D3aebXaAL5IaKyrEeztnhwsR604ExvVNugrdv5WJty+aP1OmAvlFEE7q6u7f8WqcNpDC0fqZO6khJiu8AdOsL7g1MTI2oWSqJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774535615; c=relaxed/simple;
	bh=uitE5N4MSLCwc03nT54vCrcste7AWysJiPN/uu/wMcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atlCZ3Y3bi+2BYvudXDacASaz3rTATJhpTpMlNwHWE3wJRGdTrLX5buk4f5kbLatMmMKXsDR6LafmInv0LqFw9F6lTga0mwfLWZhDihzoVoG8m0rKnz7G8mLP50SByLNQHzeEzGdR1vBuj9/tkpoAkjQtkc6qbuvxyj02dsmfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 614E88D205;
	Thu, 26 Mar 2026 14:33:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 42EDA30;
	Thu, 26 Mar 2026 14:33:15 +0000 (UTC)
Date: Thu, 26 Mar 2026 09:33:13 -0500
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
Message-ID: <acVDCKeolpJM9qg6@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
 <acPX9T2ZF7xTCHtZ@groves.net>
 <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c407903b54c_130d6e1007a@iweiny-mobl.notmuch>
X-Rspamd-Queue-Id: 42EDA30
X-Rspamd-Server: rspamout06
X-Stat-Signature: 5eg85543faus5y8qbax17j5g17jtwxzw
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19vLDgSS82Pku/H0CS1NgXwFtSVcyMwGZI=
X-HE-Tag: 1774535595-812783
X-HE-Meta: U2FsdGVkX1/Ks6E7tKWGMh2aa6R2BohAXkl/97fmQKcl8v/Wik6akqPqBhbNwOUwsQ1hpL8OGYRPf5DozAPXKP1HfCmn2AePBj7XTJcaoE4lwODhimP2J63AMLtaPA6OjGG9opKV+kT9e38423SIFvfJQwUy7ATE//MIDlWaqWn7bn2eThIs14xUlra2v9+d8Uq36M9JrfNlRixl6ULq5pREJFVhuvqyZwoSh3438PJ6pRiHHfTfu8a0mB5n6zzGSmEiKIGulnDSmV3ezak6yohb7oUR+VcLmBrizK4bGV23slgtT9os2G2bmB9j1VJyJS8/+FKjhuELPvargPlDpVjUaC0A0HEPAnFD/9W/NNxLKxnHMPi+eqUdGrQbynXeXg0oNQyADz+S7jsT8w2X1N1y3OQbWD8HJO3BZOu6CR1J9KzEB32I6uImy4tzP7X7yNUOAQZxvh6cff/YTkrphIB7Z7QZChOtxR2A7O0C7v4dq7nnrUrsUCVfk+1VE8Z3NxREyQRo1XWSojPUQ5gusJNdZ9qIf2ZH1PaZ6J/NVCGRBMnGNu70e8q82OJKbs7Q

On 26/03/25 11:04AM, Ira Weiny wrote:
> John Groves wrote:
> > On 26/03/24 02:39PM, Jonathan Cameron wrote:
> > > On Tue, 24 Mar 2026 00:38:31 +0000
> > > John Groves <john@jagalactic.com> wrote:
> > > 
> > > > From: John Groves <john@groves.net>
> > > > 
> > > > The new fsdev driver provides pages/folios initialized compatibly with
> > > > fsdax - normal rather than devdax-style refcounting, and starting out
> > > > with order-0 folios.
> > > > 
> > > > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > > > devdax mode (device.c), which pre-initializes compound folios according
> > > > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > > > folios into a fsdax-compatible state.
> > > > 
> > > > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > > > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > > > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > > > mmap capability.
> > > > 
> > > > In this commit is just the framework, which remaps pages/folios compatibly
> > > > with fsdax.
> > > > 
> > > > Enabling dax changes:
> > > > 
> > > > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > > > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > > > - dax.h: prototype inode_dax(), which fsdev needs
> > > > 
> > > > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > > > Suggested-by: Gregory Price <gourry@gourry.net>
> > > > Signed-off-by: John Groves <john@groves.net>
> > > 
> > > I was kind of thinking you'd go with a hidden KCONFIG option with default
> > > magic to do the same build condition to you had in the Makefil, but one the
> > > user can opt in or out for is also fine.
> > > 
> > > Comments on that below. Meh, I think this is better anyway :)
> > > 
> > > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > 
> > > 
> > > 
> > > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > > index d656e4c0eb84..7051b70980d5 100644
> > > > --- a/drivers/dax/Kconfig
> > > > +++ b/drivers/dax/Kconfig
> > > > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> > > >  	depends on DEV_DAX_HMEM && DAX
> > > >  	def_bool y
> > > >  
> > > > +config DEV_DAX_FSDEV
> > > > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > > > +	depends on DEV_DAX && FS_DAX
> > > > +	help
> > > > +	  Support fs-dax access to DAX devices via a character device
> > > > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > > > +	  based on device alignment), this driver leaves folios at order-0 so
> > > > +	  that fs-dax filesystems can manage folio order dynamically.
> > > > +
> > > > +	  Say M if unsure.
> > > Fine like this, but if you wanted to hide it in interests of not
> > > confusing users...
> > > 
> > > config DEV_DAX_FSDEV
> > > 	tristate
> > > 	depends on DEV_DAX && FS_DAX
> > > 	default DEV_DAX
> > 
> > I like this better. I see no reason not to default to including fsdev.
> > It does nothing other than frustrating famfs users if it's off - since
> > building it still has no effect unless you put a daxdev in famfs mode.
> > 
> > Ira, it's kinda in your hands at the moment. Do you feel like making this
> > change?
> 
> I don't mind making this change.  But we have to deal with the breakage to
> current device dax users.
> 
> https://lore.kernel.org/all/69c36921255b6_e9d8d1009b@iweiny-mobl.notmuch/
> 
> What am I missing?
> 
> Ira

OK, I can reproduce that failure with kernel 7.0.0-rc5 and 
straight ndctl v84. So it's not famfs.

I also studied the verbose logs trying to figure out if famfs
could cause it (while running a famfs kernel and ndctl), but
I don't see it.

Then I tried non-famfs kernel and ndctl and it's the same with
or without famfs kernel and famfs ndctl.

John

