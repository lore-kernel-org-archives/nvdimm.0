Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD7406270
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365856; cv=none; b=nz84wlOB5uaM7kATD3Acj6ymYZbui1iqImADeTKUvuLqud7154OcVkVMZSSqBRn54tCvxWDCdHS3TV9NOEXoKKzjoJWxmgqkY3b8kNae5q2mp7SF59Lan6OrX54FFTQ1n5jOZcjp0cmzl3sa/cNuNDerCG6oHFWbWKBsTKlBOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365856; c=relaxed/simple;
	bh=+a67hpaJmi3yqVAqkuADGqiiu50Brow2xVZLB3qMO9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F2lbSgN3rsuFZTK1YJVETjVJerrOkLMmDNdmV4HcsUu4Gr9Tat4eSZTT2JUOQu7vzTBtT4GwAGo8JDYlrWTA/UQrpsFSJWttyxWndpZKFDMiClGKp0LmVfnbyEae8GqN9IlP+fCZHNRrZgBAxSlJx9kYEYxXVzfv0kvB5rlOOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VAyRtivC; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAyRtivC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774365855; x=1805901855;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+a67hpaJmi3yqVAqkuADGqiiu50Brow2xVZLB3qMO9g=;
  b=VAyRtivCli6cmuMZn0+VTmHCa+MBS1zoQFHKJXK4/rBRVZFT5iylFtHX
   9cWmHJopXOA07yAxPJNDzUtysoMmeNHQRM4EWJLkk4q5/crthUrVDDUqN
   FUPmUtbnsmzso7BwL7SitGY5QRokMU7VyZQkdbDOHSv4gMXur0rUenByi
   DzkHU10MB0ahMWZ0GqWMaQBmGXGH49lTWVTc/lR0pCyLxX5Sx9bkfhW+x
   bEVoEdo1/vcM8vNiDqAOMn5ybHEh6xvtIDqi7MRaioBTAl1EglsyRmTaw
   +ui8NysNcHzIq0ooB0IV+vu8Fi0m4v0ksrdDli3YZvaTXkqIFoIBhsEKi
   w==;
X-CSE-ConnectionGUID: w43L8uBoQ6K5/EKYhxTqdA==
X-CSE-MsgGUID: w8xifNA+Q5mPdGm7bGHZXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75577219"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75577219"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:24:03 -0700
X-CSE-ConnectionGUID: 6nYcbJutQMmTFoVyPO5BPg==
X-CSE-MsgGUID: ynwAZT5jQqGDjjw0+6Fayw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="224630548"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.110.6]) ([10.125.110.6])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 08:24:00 -0700
Message-ID: <9f884ec4-af45-44b6-a1c8-85eda4376547@intel.com>
Date: Tue, 24 Mar 2026 08:23:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on fsdev
 dax
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>,
 Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
 <20260324003851.5045-1-john@jagalactic.com>
 <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/23/26 5:39 PM, John Groves wrote:
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/dax-private.h |  1 +
>  drivers/dax/fsdev.c       | 84 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 7a3727d76a68..ee8f3af8387f 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -85,6 +85,7 @@ struct dev_dax {
>  	struct dax_region *region;
>  	struct dax_device *dax_dev;
>  	void *virt_addr;
> +	u64 cached_size;
>  	unsigned int align;
>  	int target_node;
>  	bool dyn_id;
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index c75478d3d548..be3d2b0e8418 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -28,6 +28,85 @@
>   * - No mmap support - all access is through fs-dax/iomap
>   */
>  
> +static void fsdev_write_dax(void *pmem_addr, struct page *page,
> +		unsigned int off, unsigned int len)
> +{
> +	while (len) {
> +		void *mem = kmap_local_page(page);
> +		unsigned int chunk = min_t(unsigned int, len, PAGE_SIZE - off);
> +
> +		memcpy_flushcache(pmem_addr, mem + off, chunk);
> +		kunmap_local(mem);
> +		len -= chunk;
> +		off = 0;
> +		page++;
> +		pmem_addr += chunk;
> +	}
> +}
> +
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
> +	if (pfn)
> +		*pfn = local_pfn;
> +
> +	/*
> +	 * Use cached_size which was computed at probe time. The size cannot
> +	 * change while the driver is bound (resize returns -EBUSY).
> +	 */
> +	return PHYS_PFN(min(size, dev_dax->cached_size - offset));
> +}
> +
> +static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
> +			pgoff_t pgoff, size_t nr_pages)
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
> +		  void **kaddr, unsigned long *pfn)
> +{
> +	return __fsdev_dax_direct_access(dax_dev, pgoff, nr_pages, mode,
> +					 kaddr, pfn);
> +}
> +
> +static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t bytes, struct iov_iter *i)
> +{
> +	return _copy_from_iter_flushcache(addr, bytes, i);
> +}
> +
> +static const struct dax_operations dev_dax_ops = {
> +	.direct_access = fsdev_dax_direct_access,
> +	.zero_page_range = fsdev_dax_zero_page_range,
> +	.recovery_write = fsdev_dax_recovery_write,
> +};
> +
>  static void fsdev_cdev_del(void *cdev)
>  {
>  	cdev_del(cdev);
> @@ -167,6 +246,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		}
>  	}
>  
> +	/* Cache size now; it cannot change while driver is bound */
> +	dev_dax->cached_size = 0;
> +	for (i = 0; i < dev_dax->nr_range; i++)
> +		dev_dax->cached_size += range_len(&dev_dax->ranges[i].range);
> +
>  	/*
>  	 * Use MEMORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving
>  	 * folios at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this

