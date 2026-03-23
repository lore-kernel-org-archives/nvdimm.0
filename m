Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D526738B
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288667; cv=none; b=DGPeGE2EreubzKX9fjjD1s+h3TVSYeKJ3uiG6i9isCRceUkkqzpJpBxP8YWN770j76m0RYjKTtGfmIH3cvkuwKQxjbLp18emoNp7lckRyN4Be7HHnXgJ8D/L8zsed8yG7HeNsBp0/OTEc21FqNFXvXnZgi1sv66tooSsfjTUJk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288667; c=relaxed/simple;
	bh=llAqm9jUFzuOndiDK/Pj1Otig2XXWSZX0s0xdJgEDBU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwhQ43mS8ltxc3b8Z+0gcXi5a7x7OKGG0jGXZcmySWl55Jrk0ghEoSWpDmK4e5qd4XY/Ty+mQFjS6KXEBxnVDroc2p1t7v1K45q4nV1sMab/YGOBN7UfgrxDFIfFledp8aEf2K6DqXVAKPLc+RDymx6x2Y3eDy8N/376gIKnQ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffgqC4YhQzHnGcW;
	Tue, 24 Mar 2026 01:57:11 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 712B940584;
	Tue, 24 Mar 2026 01:57:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Mar
 2026 17:57:42 +0000
Date: Mon, 23 Mar 2026 17:57:40 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, "Peter Zijlstra"
	<peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Zhijian Li <lizhijian@fujitsu.com>, Borislav
 Petkov <bp@alien8.de>, Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v8 1/9] dax/bus: Use dax_region_put() in
 alloc_dax_region() error path
Message-ID: <20260323175740.000014c1@huawei.com>
In-Reply-To: <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
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

On Sun, 22 Mar 2026 19:53:34 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> alloc_dax_region() calls kref_init() on the dax_region early in the
> function, but the error path for sysfs_create_groups() failure uses
> kfree() directly to free the dax_region. This bypasses the kref lifecycle.
> 
> Use dax_region_put() instead to handle kref lifecycle correctly.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c94c09622516..299134c9b294 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -668,7 +668,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  	};
>  
>  	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		kfree(dax_region);
> +		dax_region_put(dax_region);
>  		return NULL;
>  	}
>  

