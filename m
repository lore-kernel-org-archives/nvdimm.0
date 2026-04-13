Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BFE3BAD9F
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093093; cv=none; b=NgAd5ARUSn5mndDvXMaoQy9ABQXDkJXnnjHrz3MBldtLGiNj439yeu1Pquj1l3pyJzgp8+httv9DJd7vb9MxK6nmDr8sxiBHA+yfhbZZDKwhiIJeV/1y9ge19eVkW80rEkwXzxa2m7EynY0yj19TcgT+KIfnyj1N3qqoyc3b1dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093093; c=relaxed/simple;
	bh=1WjVoliKSKNyCXctiO6G4NwfnbNum0Qi6C/Mc7CbnrQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrLpYrZRQaaq9fnjJHvK4jWkUoMd0iB4vbcz8DLlqX7i9N48CqxnCP90RrvwHMbI8lB94Gl04GaMkLcd0nEs+qvE9Vm1YBx+8S9LQY1PgmnGNxLScR8zLSpDZqLo84RgfDIzQ+VFBBmx7FlT1McLf8oBlfAPPiitIqn/Yi9GjL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fvW8459nqzHnGdQ;
	Mon, 13 Apr 2026 23:11:16 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B4FB40577;
	Mon, 13 Apr 2026 23:11:29 +0800 (CST)
Received: from localhost (10.203.86.132) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 13 Apr
 2026 16:11:28 +0100
Date: Mon, 13 Apr 2026 16:11:26 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Guangshuo Li <lgs201920130244@gmail.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH v3] device-dax: Fix refcount leak in
 __devm_create_dev_dax() error path
Message-ID: <20260413161126.00004d78@huawei.com>
In-Reply-To: <20260413135625.2890908-1-lgs201920130244@gmail.com>
References: <20260413135625.2890908-1-lgs201920130244@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 13 Apr 2026 21:56:25 +0800
Guangshuo Li <lgs201920130244@gmail.com> wrote:

> After device_initialize(), the embedded struct device in dev_dax is
> expected to be released through the device core with put_device().
> 
> In __devm_create_dev_dax(), several failure paths after
> device_initialize() free dev_dax directly instead of dropping the device
> reference, which bypasses the normal device core lifetime handling and
> leaks the reference held on the embedded struct device.
> 
> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.
> 
> Fix this by assigning dev->type before device_initialize(), so the
> release callback is available, use put_device() in the
> post-initialization error paths, and keep dev_dax range cleanup explicit
> since it is not handled by dev_dax_release().
> 
> Fixes: c2f3011ee697f ("device-dax: add an allocation interface for device-dax instances")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Hi

Whilst I think your fix is correct the need to still handle one error path
via a different set of goto labels is not as easy to read as I'd like to see.

There is also some ordering stuff in here that is somewhat messy and
needs some more thought.  alloc_dev_dax_range() is unwound out of order
wrt to data->pgmap.

Thanks,

Jonathan

> ---
> v3:
>   - note that the issue was identified by my static analysis tool
>   - and confirmed by manual review
> 
> v2:
>   - clarify the commit message around the device reference leak
>   - drop the unsupported use-after-free claim
>   - set dev->type before device_initialize() so put_device() can use the
>     release callback on post-init failures
>   - simplify the post-initialization error paths to use explicit range
>     cleanup plus put_device()
> 
>  drivers/dax/bus.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index fde29e0ad68b..2d92674d0d6e 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1453,6 +1453,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	}
>  
>  	dev = &dev_dax->dev;
> +	dev->type = &dev_dax_type;
>  	device_initialize(dev);
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
>  
> @@ -1499,7 +1500,6 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	dev->devt = inode->i_rdev;
>  	dev->bus = &dax_bus_type;
>  	dev->parent = parent;
> -	dev->type = &dev_dax_type;
>  
>  	rc = device_add(dev);
>  	if (rc) {
> @@ -1522,14 +1522,13 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	return dev_dax;
>  
>  err_alloc_dax:
> -	kfree(dev_dax->pgmap);
>  err_pgmap:
>  	free_dev_dax_ranges(dev_dax);
This bothers me somewhat as now the error paths are not unwinding in reverse of the setup.

>  err_range:
> -	free_dev_dax_id(dev_dax);
> +	put_device(dev);
> +	return ERR_PTR(rc);
It would be helpful to have some white space around this to make it easier
to spot given it's in the middle of the list.


>  err_id:
>  	kfree(dev_dax);
Cam we juggle things around a little more so that there is no path that
hits this?  I.e. move device_initialize() (and whatever needs setting for
release to work) to just after allocation?

I think the one complication is we need to ensure correct behavior if the
id has not been successfully allocated.  Perhaps using a flag value of -1 would
make this easy to check for.

Alternative would be to have a helper that does the allocate and ID allocation
parts and handles this kfree() internally.


> -
Unrelated and probably not a desirable change.  It's common to put a blank line
before simple returns like this one.

>  	return ERR_PTR(rc);
>  }
>  

