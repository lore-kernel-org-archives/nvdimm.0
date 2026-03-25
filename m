Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCED3CFF5F
	for <nvdimm@lists.linux.dev>; Wed, 25 Mar 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774442653; cv=none; b=l/iSpyKxcOzQ6Ym+OfT6+tcPfleq+kzgLWG/2oahiWFtvD5Q10clUPbzWemMNq6/XNpbJLcq421R5ZRG8GQuVllW78UfsGcikef6Q+gYF9/8SwOZ7Wh+mjz3OlAgku2Dpq+zp1UUAmZDgtKsAHbn+ic6WUs75nbR7gkI76zac4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774442653; c=relaxed/simple;
	bh=bzYdfF1spGMVjwl4NTjaat4YQrXVriJ+IaIcJqcKJlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYgCNpePfRD7TKbGPP1UjevXBiSKhzM2wYJ27Jm9xyOSWmc6b89F+S3NB1WPFAOquxZf+JRHifA8lsFOUF2jLBq/mEmaGTsyjidOFyiR9QCfZl49o4Becn2zoJDEQHWek9tKXSkUXRrs0pJeg6GOVE/9T4HWF9uya8qI1qqkJ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D0DC1A082D;
	Wed, 25 Mar 2026 12:44:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf12.hostedemail.com (Postfix) with ESMTPA id EC85817;
	Wed, 25 Mar 2026 12:43:54 +0000 (UTC)
Date: Wed, 25 Mar 2026 07:43:53 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
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
Message-ID: <acPX9T2ZF7xTCHtZ@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003818.5009-1-john@jagalactic.com>
 <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
 <20260324143927.000024c3@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324143927.000024c3@huawei.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: EC85817
X-Stat-Signature: 1qn3h5nx7pwds75jfk33psjwun8sh14w
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX180+af1YWzvaZ59D8sxBuIZxxdYmwQ05wU=
X-HE-Tag: 1774442634-3402
X-HE-Meta: U2FsdGVkX1+N9RTW+cU2f//6uhWp/3cA7dyMyvWeDd14EPQJZCrLvO2FgAJa+U+AGXznyUFgoxwG7AiMQ+J/iWcIVhQQqjxL1Z1RBdHi7SMWGXxvholXJsbRJ7vA1tkB3wxhjoXOxImeBTrsGQt9/7Tpp6hu5bpxC8vUZzPCdhLasDGEzMljNdt9S1isvnb85mEOf8EvVD10dWxj0viJRjlot+qh6PxDSWGpwiqSI4Id/V716hBLFkZU2PJKtkMZEvT+NOPFfaUKwAoYWvS8+akdil0Am4UPyiRJV2Beuw1sRneBBtupIg2CLdv3qvibJFNqftrJyNxX2BKVkUCKsJns4hilBfJx4CQoTuzSNGekZWyMLXDjcsyFUruSvcYbRMlzkimElgnyOZSmJF9cIoj/+qluE3dG3Nf34vqLyfe1vFHoQB6CDD7KNpzs5lQuvRnQGs+7W3q8fuDEKMy21SHulDUoAINg0oNWKAEMAr9chD3y6qNx3cS0nujP4+Mm9yiujzZVF/f0QBeo3IX6fKJ3/QdsWCK/Kz56z3DwuO4=

On 26/03/24 02:39PM, Jonathan Cameron wrote:
> On Tue, 24 Mar 2026 00:38:31 +0000
> John Groves <john@jagalactic.com> wrote:
> 
> > From: John Groves <john@groves.net>
> > 
> > The new fsdev driver provides pages/folios initialized compatibly with
> > fsdax - normal rather than devdax-style refcounting, and starting out
> > with order-0 folios.
> > 
> > When fsdev binds to a daxdev, it is usually (always?) switching from the
> > devdax mode (device.c), which pre-initializes compound folios according
> > to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> > folios into a fsdax-compatible state.
> > 
> > A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> > dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> > devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> > mmap capability.
> > 
> > In this commit is just the framework, which remaps pages/folios compatibly
> > with fsdax.
> > 
> > Enabling dax changes:
> > 
> > - bus.h: add DAXDRV_FSDEV_TYPE driver type
> > - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> > - dax.h: prototype inode_dax(), which fsdev needs
> > 
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Suggested-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: John Groves <john@groves.net>
> 
> I was kind of thinking you'd go with a hidden KCONFIG option with default
> magic to do the same build condition to you had in the Makefil, but one the
> user can opt in or out for is also fine.
> 
> Comments on that below. Meh, I think this is better anyway :)
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> 
> 
> > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > index d656e4c0eb84..7051b70980d5 100644
> > --- a/drivers/dax/Kconfig
> > +++ b/drivers/dax/Kconfig
> > @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
> >  	depends on DEV_DAX_HMEM && DAX
> >  	def_bool y
> >  
> > +config DEV_DAX_FSDEV
> > +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> > +	depends on DEV_DAX && FS_DAX
> > +	help
> > +	  Support fs-dax access to DAX devices via a character device
> > +	  interface. Unlike device_dax (which pre-initializes compound folios
> > +	  based on device alignment), this driver leaves folios at order-0 so
> > +	  that fs-dax filesystems can manage folio order dynamically.
> > +
> > +	  Say M if unsure.
> Fine like this, but if you wanted to hide it in interests of not
> confusing users...
> 
> config DEV_DAX_FSDEV
> 	tristate
> 	depends on DEV_DAX && FS_DAX
> 	default DEV_DAX

I like this better. I see no reason not to default to including fsdev.
It does nothing other than frustrating famfs users if it's off - since
building it still has no effect unless you put a daxdev in famfs mode.

Ira, it's kinda in your hands at the moment. Do you feel like making this
change?

> 
> > +
> >  config DEV_DAX_KMEM
> >  	tristate "KMEM DAX: map dax-devices as System-RAM"
> >  	default DEV_DAX
> 
> > +}
> 
