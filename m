Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CFF3EBF22
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 00:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771375161; cv=none; b=Iz18xoJEX+995/ccj2lDtI//POc25XydIgq0fQPEViWFyn8/MLac/Cm3PycOX0gXqahn56ZeUGMzAnGQHQRBpaFLy/sEE1GdFd+JH2zIVj9jpsV3tswtzjjyvnWH4jUDWDbi0XZlK1Uefl1T8CrHuUEVBmwluM6T+NdSkDckpHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771375161; c=relaxed/simple;
	bh=N7Kt1rlSYfggHAi5kZ/FbucKlFPKkRRUWnHc7hvpR7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eF0uupYbUibMVWhsoAaUWykZ2oXbHnTIPPXALxVUYjsjSYQ688uiVGgJC8R/7uBl37UZ0ks5UpxLldg6H9m+xsFdV//XdXs2gTtkpeqAnHM24jaBBT/DEAjqoPHaH7o+wY1FMynlGHHWGsdOU/liCvMy+FJn3ofkd3iOAzXwsXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A315813AB5F;
	Wed, 18 Feb 2026 00:39:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf16.hostedemail.com (Postfix) with ESMTPA id A77DA2000D;
	Wed, 18 Feb 2026 00:39:00 +0000 (UTC)
Date: Tue, 17 Feb 2026 18:38:59 -0600
From: John Groves <John@groves.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
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
Subject: Re: [PATCH V7 05/19] dax: Add dax_operations for use by fs-dax on
 fsdev dax
Message-ID: <aZUJxi5mzEd1Tojw@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223147.92389-1-john@jagalactic.com>
 <0100019bd33c798b-b40d52e8-b393-4a54-9cc2-f30ee62b566f-000000@email.amazonses.com>
 <698f96436c715_bcb89100ea@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698f96436c715_bcb89100ea@iweiny-mobl.notmuch>
X-Stat-Signature: f4jo787zpakzf3y9zwtrhjdk1ybczeo8
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: A77DA2000D
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/8h3J39DJgkhqm4GBq3iPbDEOPKnf5irY=
X-HE-Tag: 1771375140-854600
X-HE-Meta: U2FsdGVkX19555SNH4TgDw+0D/5WySkCoz344yjmE1drTBd2BDahmB/atoWRuzxIEAC786D/K4NiAhiqTbKLSAqDxQvxqPxT8Od/9C2v//mKOXN/CHgE3gYP2dxH+37rDlBlriOFxFuYWE3Ixmv7MVw+ts4ERsZLsncB/MTDX+6GmAqyW9+I8vwwpCLRAFWZodzJv5dmnhx6GVCeysC4Rx0cTag39mxqDJgl1GAta2IIMiyqx+EkhhMqh6FHkiWZ5hGK7kh6kl3ykgfnBzG0q69IQsVtBVXUbV43PLJ2shR5M8nh1TYjRpc4YsugtX6/3g4uA71iG6zYeYfY7h/XIxfIX8k5d8j2uKXCIwiZ/nuHIqiavmkj+OlsWj4Vxfjb

On 26/02/13 03:23PM, Ira Weiny wrote:
> John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > fsdev: Add dax_operations for use by famfs
> > 
> > - These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
> > - fsdev_dax_direct_access() returns the hpa, pfn and kva. The kva was
> >   newly stored as dev_dax->virt_addr by dev_dax_probe().
> > - The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
> >   for read/write (dax_iomap_rw())
> > - fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not been
> >   tested yet. I'm looking for suggestions as to how to test those.
> > - dax-private.h: add dev_dax->cached_size, which fsdev needs to
> >   remember. The dev_dax size cannot change while a driver is bound
> >   (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size
> >   at probe time allows fsdev's direct_access path can use it without
> >   acquiring dax_dev_rwsem (which isn't exported anyway).
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> [snip]
> 
> > +
> > +static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> > +			long nr_pages, enum dax_access_mode mode, void **kaddr,
> > +			unsigned long *pfn)
> > +{
> > +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> > +	size_t size = nr_pages << PAGE_SHIFT;
> > +	size_t offset = pgoff << PAGE_SHIFT;
> > +	void *virt_addr = dev_dax->virt_addr + offset;
> > +	phys_addr_t phys;
> > +	unsigned long local_pfn;
> > +
> > +	WARN_ON(!dev_dax->virt_addr);
> 
> WARN_ON_ONCE.  But frankly I'm pretty sure this is impossible to hit given
> the probe call, so best remove it.  Also yall already used dev_dax->virt_addr
> above.  And will hand back a bad address to the caller.  So...

Good point - dropped it.

> 
> > +
> > +	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
> > +	if (phys == -1) {
> > +		dev_dbg(&dev_dax->dev,
> > +			"pgoff (%#lx) out of range\n", pgoff);
> > +		return -ERANGE;
> 
> EFAULT?

This feels like a judgment call, but I'm fine with it.
Changed to -EFAULT

> 
> Ira
> 
> [snip]

Thanks Ira!
John

