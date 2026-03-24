Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E73563DD
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361895; cv=none; b=Rc1D/WSfL2dxJMBEbKcGArwQG0bxv289/+V5dih+4iOsfPRWU+Rpzls3uYIf3oUAIqfH3chAV04yfAp7eVyv1gaxCfDUhUJzRbtf1Fl8z2eAAp/Y94IujagPkhiTAQt2oUyG3l8XOUEBP8KGVSYDS7dfw7/SVixvHuPTEQdXh6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361895; c=relaxed/simple;
	bh=IVVVUYBylP6j/OwUBE4ZhjPwu/hOeew6T5NxSOW15u0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gczk8oodwvK27xHdqmMsUGAmIRydjL9IkuEQDXA7dPLTGBIPG3OegQliBA0ClhN9VNzurPiKoin8h1Ff41zCDXyL/XVN0tvnECwn9TvA27JViwvdC9ooCC39hRZ4jNJsln7fof+9z8Cv6XyZ/9EGAy2A4hZlsX/cAwKnT1rylbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgBvt19QvzJ46bK;
	Tue, 24 Mar 2026 22:18:02 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 2682740086;
	Tue, 24 Mar 2026 22:18:09 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:18:07 +0000
Date: Tue, 24 Mar 2026 14:18:06 +0000
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
	<linux-fsdevel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH V9 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
Message-ID: <20260324141806.000003f7@huawei.com>
In-Reply-To: <0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000@email.amazonses.com>
References: <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
	<20260324003743.4973-1-john@jagalactic.com>
	<0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000@email.amazonses.com>
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

On Tue, 24 Mar 2026 00:37:53 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <john@groves.net>
> 
> This function will be used by both device.c and fsdev.c, but both are
> loadable modules. Moving to bus.c puts it in core and makes it available
> to both.
> 
> No code changes - just relocated.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>
Obviously this is a straight forward code move... But I can't resist
commenting on what is moving  (feel free to ignore! or maybe a follow
up patch if you agree.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  drivers/dax/bus.c    | 24 ++++++++++++++++++++++++
>  drivers/dax/device.c | 23 -----------------------
>  2 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c94c09622516..e4bd5c9f006c 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1417,6 +1417,30 @@ static const struct device_type dev_dax_type = {
>  	.groups = dax_attribute_groups,
>  };
>  
> +/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
> +__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
> +			      unsigned long size)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
Modernize as:

	for (int i = 0; ...

> +		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
> +		struct range *range = &dax_range->range;
> +		unsigned long long pgoff_end;
> +		phys_addr_t phys;
> +
> +		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
> +		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)

We have in_range() (linux/minmax.h) available for these case of a start to start + length - 1
check. I think this is same:

		if (!in_range(pgoff, dax_range->pgoff, PHYS_PFN(range_len(range))) 

> +			continue;
> +		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
> +		if (phys + size - 1 <= range->end)
> +			return phys;
> +		break;
> +	}
> +	return -1;
> +}
> +EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
> +

