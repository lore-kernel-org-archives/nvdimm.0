Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144BB3FF89B
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363932; cv=none; b=qjo5JGZHb/wUnp+ZUU0ECyb8ohViyclTOHnz2zxONgXF1rpbubFDwbPxoNFb9K7Gm/XeyJLcM3TbML6ee3sq8vFqyngZ6BQU++cEtB6JIcxe0VTAk6XmeZ16+onsiq15NJa5WtUAFe1TceYJUk4uAHucJ98wC6dVjuSWLI5IBOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363932; c=relaxed/simple;
	bh=eb7e5Ix0OyV9hWbj3JMA/NzJW9ZgvAlM/NWr5lwNJSw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkG5O2J7TEGDw1nysuftzFPQkH4TLEH8hpT04rrC5WkFj4ecsbpjCzf/V8y+dWzJGn/Pw1S+I90XSkczk6TwVcafoTX3Tp49oLczFG3Jls+d2+T6vXwWRwTHu9py2mzy3pX2Z9wWUtDalnlqXGQZJuvhV9NYXG4PMK5XGtWO9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgCfT0C2JzHnGkS;
	Tue, 24 Mar 2026 22:51:29 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 879BC40587;
	Tue, 24 Mar 2026 22:52:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:52:00 +0000
Date: Tue, 24 Mar 2026 14:51:59 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: John Groves <John@Groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, "David
 Hildenbrand" <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan
 Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen
 Linxuan <chenlinxuan@uniontech.com>, "James Morse" <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>, "Sean Christopherson" <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on
 fsdev dax
Message-ID: <20260324145159.0000078f@huawei.com>
In-Reply-To: <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003851.5045-1-john@jagalactic.com>
	<0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Mar 2026 00:39:04 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <John@Groves.net>
> 
> fsdev: Add dax_operations for use by famfs.
> 
> This replicates the functionality from drivers/nvdimm/pmem.c that
> conventional fs-dax file systems (e.g. xfs) use to support dax
> read/write/mmap to a daxdev - without which famfs can't sit atop a
> daxdev.
> 
> - These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
> - fsdev_dax_direct_access() returns the hpa, pfn and kva. The kva was
>   newly stored as dev_dax->virt_addr by dev_dax_probe().
> - The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
>   for read/write (dax_iomap_rw())
> - fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not been
>   tested yet. I'm looking for suggestions as to how to test those.
> - dax-private.h: add dev_dax->cached_size, which fsdev needs to
>   remember. The dev_dax size cannot change while a driver is bound
>   (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size
>   at probe time allows fsdev's direct_access path can use it without
>   acquiring dax_dev_rwsem (which isn't exported anyway).
> 
> Signed-off-by: John Groves <john@groves.net>
The indent of trailing parameter lines is very random in here.
Pick a style and stick to it.  Few other trivial things inline.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> ---
>  drivers/dax/dax-private.h |  1 +
>  drivers/dax/fsdev.c       | 84 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+)

> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index c75478d3d548..be3d2b0e8418 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c

> +static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> +			long nr_pages, enum dax_access_mode mode, void **kaddr,
> +			unsigned long *pfn)
> +{
> +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> +	size_t size = nr_pages << PAGE_SHIFT;
> +	size_t offset = pgoff << PAGE_SHIFT;
> +	void *virt_addr = dev_dax->virt_addr + offset;
> +	phys_addr_t phys;
> +	unsigned long local_pfn;
> +
> +	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
> +	if (phys == -1) {
> +		dev_dbg(&dev_dax->dev,
> +			"pgoff (%#lx) out of range\n", pgoff);
> +		return -EFAULT;
> +	}
> +
> +	if (kaddr)
> +		*kaddr = virt_addr;
> +
> +	local_pfn = PHYS_PFN(phys);
Trivial but if !pfn, local_pfn not used so...

	if (pfn)
		*pfn = PHYS_PFN(phys);

Obviously ignore this if it becomes used in some later patch.

> +	if (pfn)
> +		*pfn = local_pfn;
> +
> +	/*
> +	 * Use cached_size which was computed at probe time. The size cannot
> +	 * change while the driver is bound (resize returns -EBUSY).
Might be worth capturing somewhere in code that using the value from
probe means you don't need locking.
> +	 */
> +	return PHYS_PFN(min(size, dev_dax->cached_size - offset));
> +}
> +
> +static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
> +			pgoff_t pgoff, size_t nr_pages)
Three tabs
> +{
> +	void *kaddr;
> +
> +	WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
> +	__fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
> +	fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
> +	return 0;
> +}
> +
> +static long fsdev_dax_direct_access(struct dax_device *dax_dev,
> +		  pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,

Why that indent?  Two tabs and a couple of spaces...
Either two tabs, or align after (

> +		  void **kaddr, unsigned long *pfn)
> +{
> +	return __fsdev_dax_direct_access(dax_dev, pgoff, nr_pages, mode,
> +					 kaddr, pfn);
> +}
> +
> +static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t bytes, struct iov_iter *i)
two tabs....
> +{
> +	return _copy_from_iter_flushcache(addr, bytes, i);
> +}
> +
> +static const struct dax_operations dev_dax_ops = {
> +	.direct_access = fsdev_dax_direct_access,
> +	.zero_page_range = fsdev_dax_zero_page_range,
> +	.recovery_write = fsdev_dax_recovery_write,
> +};


