Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4AE3E3DBE
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363175; cv=none; b=EbQGdnTlB4i7IpjIJRPwrYmdiSWljSTNAuYyIrBEOX13x+mWFrAT8KMlMIILUbk5hDc7HqcOmUOlJXf5qZzAM8pLga6tUjAO+IC/fnCEA3/re3MWoNt0e/jNXnD7BkdpqGpaV+khjgZotIdOFAXceZe99xt7LOcjStriC6+LxNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363175; c=relaxed/simple;
	bh=RqDUqW3L3rKetW8HoMI6lvA7Iwm4e4zETz+ERZw6qSg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hE/f4XY3LetjMo3/X6+YAfiqlAeNscJk+vgZx/ANmmpJ59LvZZTRd+2zxtQBdcmXNnPDSr0UyLzIa/f1h4M+JNIEy/5K+leoS5DaaVT8Tr3H71aW9HHaaD4gzHfsc/Ddq5A59WHYRUD6NJqLlzTOMBoANx7hvFG9iv/1pY2Kshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgCN03zDbzHnGdd;
	Tue, 24 Mar 2026 22:38:56 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 11B6E4058C;
	Tue, 24 Mar 2026 22:39:30 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:39:28 +0000
Date: Tue, 24 Mar 2026 14:39:27 +0000
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
Subject: Re: [PATCH V9 3/8] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <20260324143927.000024c3@huawei.com>
In-Reply-To: <0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003818.5009-1-john@jagalactic.com>
	<0100019d1d476420-6b0bf60e-3b3a-4868-8f5f-484cd55d4709-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Mar 2026 00:38:31 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <john@groves.net>
> 
> The new fsdev driver provides pages/folios initialized compatibly with
> fsdax - normal rather than devdax-style refcounting, and starting out
> with order-0 folios.
> 
> When fsdev binds to a daxdev, it is usually (always?) switching from the
> devdax mode (device.c), which pre-initializes compound folios according
> to its alignment. Fsdev uses fsdev_clear_folio_state() to switch the
> folios into a fsdax-compatible state.
> 
> A side effect of this is that raw mmap doesn't (can't?) work on an fsdev
> dax instance. Accordingly, The fsdev driver does not provide raw mmap -
> devices must be put in 'devdax' mode (drivers/dax/device.c) to get raw
> mmap capability.
> 
> In this commit is just the framework, which remaps pages/folios compatibly
> with fsdax.
> 
> Enabling dax changes:
> 
> - bus.h: add DAXDRV_FSDEV_TYPE driver type
> - bus.c: allow DAXDRV_FSDEV_TYPE drivers to bind to daxdevs
> - dax.h: prototype inode_dax(), which fsdev needs
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: John Groves <john@groves.net>

I was kind of thinking you'd go with a hidden KCONFIG option with default
magic to do the same build condition to you had in the Makefil, but one the
user can opt in or out for is also fine.

Comments on that below. Meh, I think this is better anyway :)

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index d656e4c0eb84..7051b70980d5 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -61,6 +61,17 @@ config DEV_DAX_HMEM_DEVICES
>  	depends on DEV_DAX_HMEM && DAX
>  	def_bool y
>  
> +config DEV_DAX_FSDEV
> +	tristate "FSDEV DAX: fs-dax compatible devdax driver"
> +	depends on DEV_DAX && FS_DAX
> +	help
> +	  Support fs-dax access to DAX devices via a character device
> +	  interface. Unlike device_dax (which pre-initializes compound folios
> +	  based on device alignment), this driver leaves folios at order-0 so
> +	  that fs-dax filesystems can manage folio order dynamically.
> +
> +	  Say M if unsure.
Fine like this, but if you wanted to hide it in interests of not
confusing users...

config DEV_DAX_FSDEV
	tristate
	depends on DEV_DAX && FS_DAX
	default DEV_DAX

> +
>  config DEV_DAX_KMEM
>  	tristate "KMEM DAX: map dax-devices as System-RAM"
>  	default DEV_DAX

> +}

