Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26DE4035DE
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364738; cv=none; b=hSaoVKLaZfFTRcEJReySGZOLBqxv7Tja71qQI5A3Cx3aoODpn97hJ54rUgUPtf9aV1X+FKhvqukVbYj+Hb5tzapsCxx8Q2kW1N2in9axTFk4YAMR+EME2bcLJPTpyFOs1EX/mVRb/4QtFxlC6rG1oESDdj7+00aRsNfTx0/UmIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364738; c=relaxed/simple;
	bh=m8Hx0ozzwk19ZnIruRTH2dbp9moQA8wQsvvEZaTUXFY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jiNaR7a5CltESsGZyo1w0eDWLgNRVm2aNaSIdf2Ek8kH5PcybWg2be6jUmWW52eq3V/QS9SxwI9W8qLSspCexNhDOP2Xn/fN6+iUHOc0TgMJ2JERJuI74lDmiJJpSk+zHdU7JTFWEHLcEmruVkzOZwdSM/eejc5NEcVqS3k0c7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgCyV34T6zJ46Dy;
	Tue, 24 Mar 2026 23:05:22 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 7263940573;
	Tue, 24 Mar 2026 23:05:29 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 15:05:27 +0000
Date: Tue, 24 Mar 2026 15:05:26 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>
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
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 7/8] dax: Add fs_dax_get() func to prepare dax for
 fs-dax usage
Message-ID: <20260324150526.000047b6@huawei.com>
In-Reply-To: <0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003919.5106-1-john@jagalactic.com>
	<0100019d1d484ddc-2487f887-7ecd-49a3-abfe-9dabec28873f-000000@email.amazonses.com>
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

On Tue, 24 Mar 2026 00:39:31 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <john@groves.net>
> 
> The fs_dax_get() function should be called by fs-dax file systems after
> opening a fsdev dax device. This adds holder_operations, which provides
> a memory failure callback path and effects exclusivity between callers
> of fs_dax_get().
> 
> fs_dax_get() is specific to fsdev_dax, so it checks the driver type
> (which required touching bus.[ch]). fs_dax_get() fails if fsdev_dax is
> not bound to the memory.
> 
> This function serves the same role as fs_dax_get_by_bdev(), which dax
> file systems call after opening the pmem block device.
> 
> This can't be located in fsdev.c because struct dax_device is opaque
> there.
> 
> This will be called by fs/fuse/famfs.c in a subsequent commit.
> 
> Signed-off-by: John Groves <john@groves.net>
Hi John,

Looks like a stray header change  - see inline.

With that tidied up.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

>  #define dax_driver_register(driver) \
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index ba0b4cd18a77..d4ab60c406bf 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b19bfe0c2fd1..bf37b9a982f3 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h

>  #if IS_ENABLED(CONFIG_FS_DAX)
> +void fs_put_dax(struct dax_device *dax_dev, void *holder);
> +int fs_dax_get(struct dax_device *dax_dev, void *holder,
> +	       const struct dax_holder_operations *hops);
> +struct dax_device *inode_dax(struct inode *inode);

What's this? Not used in this patch and not stubbed.
It's in drivers/dax/dax-private.h already and given I assume code builds
before this patch (and it's not used in patch 8) then presumably it doesn't
need to be here.

I got suspicious due to the lack of stub rather indicating something differnt
form the other two.

>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct dax_device *dax_dev, struct writeback_control *wbc);
>  int dax_folio_reset_order(struct folio *folio);
> @@ -164,6 +164,15 @@ dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
>  void dax_unlock_mapping_entry(struct address_space *mapping,
>  		unsigned long index, dax_entry_t cookie);
>  #else
> +static inline void fs_put_dax(struct dax_device *dax_dev, void *holder)
> +{
> +}
> +
> +static inline int fs_dax_get(struct dax_device *dax_dev, void *holder,
> +			     const struct dax_holder_operations *hops)
> +{
> +	return -EOPNOTSUPP;
> +}
>  static inline struct page *dax_layout_busy_page(struct address_space *mapping)
>  {
>  	return NULL;

