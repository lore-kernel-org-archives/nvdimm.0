Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D1B3806D1
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773928774; cv=none; b=nQAGujA/2xEkMMXTvSNzGxi2WwRwYCdI4fJfhVFq2Y+0KgK5zDyIzOP3MAcsS+ETT1PkWVm0STVU+Ha2sgyJa5ckvBbllsm5qDjcGqs426kUlD5OOGUzaPtc8Ath5HuxpXcOYNFjNq6NCm5wHvSFK351riHsNHO/aQntPxzxOdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773928774; c=relaxed/simple;
	bh=TTNzvb3312bF4OJODOgMQqa+yyQSoFloxeONu4CmNao=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZuJ7aq7RSxh/7Q3ovXiSn3Rj1GsCgbPnpanf5PlLP/9F+oTl5lEWd/c04ElO1rpnLvOwPGmzVHCPHiWTftm2TBQp+GNXFVdR8uWJF3fz3M9DjnNL5D3i5tqKrbX7oI5htPOnx735ni99nW/E0wwofS6ik4TdvVBOuLviZ7zr+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc6jb34hCzJ46BP;
	Thu, 19 Mar 2026 21:58:27 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id DD35440572;
	Thu, 19 Mar 2026 21:59:26 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 13:59:25 +0000
Date: Thu, 19 Mar 2026 13:59:24 +0000
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
Subject: Re: [PATCH v7 4/7] dax: Track all dax_region allocations under a
 global resource tree
Message-ID: <20260319135924.000060c2@huawei.com>
In-Reply-To: <20260319011500.241426-5-Smita.KoralahalliChannabasappa@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260319011500.241426-5-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 19 Mar 2026 01:14:57 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> Introduce a global "DAX Regions" resource root and register each
> dax_region->res under it via request_resource(). Release the resource on
> dax_region teardown.
>=20
> By enforcing a single global namespace for dax_region allocations, this
> ensures only one of dax_hmem or dax_cxl can successfully register a
> dax_region for a given range.
>=20
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

The comment below is about the existing code.  If we decide not to tidy that
up for now and you swap the ordering of release_resource() and sysfs_remove=
_groups()
in unregister.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/dax/bus.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c94c09622516..448e2bc285c3 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -10,6 +10,7 @@
>  #include "dax-private.h"
>  #include "bus.h"
> =20
> +static struct resource dax_regions =3D DEFINE_RES_MEM_NAMED(0, -1, "DAX =
Regions");
>  static DEFINE_MUTEX(dax_bus_lock);
> =20
>  /*
> @@ -625,6 +626,7 @@ static void dax_region_unregister(void *region)
>  {
>  	struct dax_region *dax_region =3D region;
> =20
> +	release_resource(&dax_region->res);

Should reverse the line above and the line below so we unwind in reverse of
setup.  I doubt it matters in practice today but keeping ordering like that
makes it much easier to see if a future patch messes things up.

>  	sysfs_remove_groups(&dax_region->dev->kobj,
>  			dax_region_attribute_groups);
>  	dax_region_put(dax_region);
> @@ -635,6 +637,7 @@ struct dax_region *alloc_dax_region(struct device *pa=
rent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> +	int rc;
> =20
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -667,14 +670,25 @@ struct dax_region *alloc_dax_region(struct device *=
parent, int region_id,
>  		.flags =3D IORESOURCE_MEM | flags,
>  	};
> =20
> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		kfree(dax_region);
> -		return NULL;
> +	rc =3D request_resource(&dax_regions, &dax_region->res);
> +	if (rc) {
> +		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +			&dax_region->res);
> +		goto err_res;
>  	}
> =20
> +	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
> +		goto err_sysfs;
> +
>  	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))

This is curious. The code flips over to a kref_put() based release but we d=
idn't
do anything with the kref in the previous call. So whilst not 'buggy' as su=
ch
it's definitely inconsistent and we should clean it up.

This should really have been doing the release via dax_region_put() from the
kref_init().  In practice that means never calling kfree(dax_regions) error=
 paths
because the kref_init() is just after the allocation. Instead call dax_regi=
on_put()
in all those error paths.

=20

>  		return NULL;
>  	return dax_region;
> +
> +err_sysfs:
> +	release_resource(&dax_region->res);
> +err_res:
> +	kfree(dax_region);

=46rom above I think this should be
	dax_region_put(dax_region);

> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax_region);
> =20

