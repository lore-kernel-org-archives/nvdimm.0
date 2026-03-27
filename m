Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA73F65E8
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620894; cv=none; b=NUcwuUf6DyNn+lwUGNfgP5bSLtbrakBox+9DCuISXQu/jt4/SkI9/ssk2jeU2nd0qsqCty2cyE7Z+DQrEqh8Gvz40xyWDEIOdTze2xOpq2ViRWEtoxQTzGv0dUL/dUSFsPJd5+nYy5EliYWJVOuPr9Leu5W1OvatCy9gkEU9uzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620894; c=relaxed/simple;
	bh=INKVJIFSQ2mJLOypFSOZweFPtWyfByrCi/uSSs2jZrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9bM2Q/TAJz/z0x8tadTBDCMdtebKx8WQxBzs1FQfUYXiCQ92ujXC8h6CMZQ92ZJQoDtM0aPDtgA2cy+L7uJzWyozJQYjdwVB2zVIebfjVaJSyccSpncwOcOKNXQ9Q8Zbm8cMNVlriZADIMPE/KOUyPu2L+a9UMcHK7XgDsG4ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FA765E9F3;
	Fri, 27 Mar 2026 14:14:40 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf13.hostedemail.com (Postfix) with ESMTPA id 3816C20021;
	Fri, 27 Mar 2026 14:14:28 +0000 (UTC)
Date: Fri, 27 Mar 2026 09:14:26 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on
 fsdev dax
Message-ID: <acaQiBN2vlVwZ5EK@groves.net>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003851.5045-1-john@jagalactic.com>
 <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
 <d4461e56-8a4d-4d2c-8de9-23a265dc617f@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4461e56-8a4d-4d2c-8de9-23a265dc617f@intel.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 3816C20021
X-Stat-Signature: a3gmc9z1zgxc6hf8kzmhk83yunuieo3t
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19D8SBDWcEBvpv9lVq+qSMSLSs9sPxCwdI=
X-HE-Tag: 1774620868-202939
X-HE-Meta: U2FsdGVkX19wBee9icGSPWMdcxMlM6lU3SHQCwJTze+pNrOeNshQ1FEASeTwWC1axg6fNWqOtbYVjY+KeasJtos5ku0EYP1vooqjp/Zzm/XNcN2bIFtSnad98mRfgbILCWhLxD6wS07JykPVMKDeKs2UTVQ9AJtcN78kRDHVGbrcd0Kpq3wnjn8QSAUrUK7k1IL3rzDqJWWUATmhGtQuq0N2VjlGdwtZCFxdsJBzABXCVzbJvarLI4QGZ1LahzV6uHIpqqni6/cHQfhV3ZNH87sGUxaPKI374th7CQkiFqdfeYoiYVMPO0/JCLVa9uRQbgdFLNx8V4B6PUGHOfiUpqKHQeVh8Q7NV/hg82h7jR+cwu6OiNpGMx/9BHW93d1E

On 26/03/25 03:40PM, Dave Jiang wrote:
> 
> 
> On 3/23/26 5:39 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > fsdev: Add dax_operations for use by famfs.
> > 
> > This replicates the functionality from drivers/nvdimm/pmem.c that
> > conventional fs-dax file systems (e.g. xfs) use to support dax
> > read/write/mmap to a daxdev - without which famfs can't sit atop a
> > daxdev.
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
> Couple nits below while I'm stealing code from you.

:D

> 
> > ---
> >  drivers/dax/dax-private.h |  1 +
> >  drivers/dax/fsdev.c       | 84 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 85 insertions(+)
> > 
> > diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> > index 7a3727d76a68..ee8f3af8387f 100644
> > --- a/drivers/dax/dax-private.h
> > +++ b/drivers/dax/dax-private.h
> > @@ -85,6 +85,7 @@ struct dev_dax {
> >  	struct dax_region *region;
> >  	struct dax_device *dax_dev;
> >  	void *virt_addr;
> > +	u64 cached_size;
> >  	unsigned int align;
> >  	int target_node;
> >  	bool dyn_id;
> > diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> > index c75478d3d548..be3d2b0e8418 100644
> > --- a/drivers/dax/fsdev.c
> > +++ b/drivers/dax/fsdev.c
> > @@ -28,6 +28,85 @@
> >   * - No mmap support - all access is through fs-dax/iomap
> >   */
> >  
> > +static void fsdev_write_dax(void *pmem_addr, struct page *page,
> 
> addr instead of pmem_addr? copy pasta error?

Yep, fixed thanks

> 
> > +		unsigned int off, unsigned int len)
> > +{
> > +	while (len) {
> > +		void *mem = kmap_local_page(page);
> > +		unsigned int chunk = min_t(unsigned int, len, PAGE_SIZE - off);
> > +
> > +		memcpy_flushcache(pmem_addr, mem + off, chunk);
> > +		kunmap_local(mem);
> > +		len -= chunk;
> > +		off = 0;
> > +		page++;
> > +		pmem_addr += chunk;
> > +	}
> > +}
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
> > +	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
> 
> you can use 'size' instead here since it's previously computed already.
> 
> DJ

Indeed - thanks!

John

