Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC1A221DA6
	for <nvdimm@lists.linux.dev>; Thu, 29 May 2025 13:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748524640; cv=none; b=bMzjdLYH7lu/PmrxExnTNjZpK0WqYtfm1X/P9lH9jWFJH427uaHmgKYCwsaDu9nGIKU1j0hoj0PU7Rg6XdFWXBiCL2k/FG5HM+TtcyrRxr7Nd4S3Qo74fCa5uSE13r3/k3W9ZRZ1vZwW72BqB0Rf3jE1VOqdgGIiS0kPlA9cS8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748524640; c=relaxed/simple;
	bh=r3zC7VAUD2OAqjuUK18CHUGARurJ5BvZT2B4CR2Dk1Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZEPcYTTVQmNfnasPDGBt5MKIk7b8kqdqp2i4BQjaimKBWmGJV/Q92GCWM+gSvDUmMIK6bODwXKnWw5gf8x+ahFaaAWGXk3goEh12zLePdTY4BDYzhoRuGL/pGmR5K8E44HVaTkvigFRIUIKB432UUcqe1deNChqRSjfqIpod0fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4b7Rjh23kTz6M4sl;
	Thu, 29 May 2025 21:17:12 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 65DF91402EB;
	Thu, 29 May 2025 21:17:16 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 29 May
 2025 15:17:15 +0200
Date: Thu, 29 May 2025 14:17:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>, <Marc.Herbert@linux.intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v9 2/4] cxl: Enumerate major/minor of FWCTL char
 device
Message-ID: <20250529141713.0000530f@huawei.com>
In-Reply-To: <20250523164641.3346251-3-dave.jiang@intel.com>
References: <20250523164641.3346251-1-dave.jiang@intel.com>
	<20250523164641.3346251-3-dave.jiang@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 23 May 2025 09:46:37 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add major/minor discovery for the FWCTL character device that is associated
> with supprting CXL Features under 'struct cxl_fwctl'. A 'struct cxl_fwctl'
> may be installed under cxl_memdev if CXL Features are supported and FWCTL
> is enabled. Add libcxl API functions to retrieve the major and minor of the
> FWCTL character device.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Hi Dave,

I don't normally look at ndctl stuff (not enough time) but I had a few
mins so trivial comments inline.

Jonathan

> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index bab7343e8a4a..af28f976bdc8 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c

> @@ -1253,6 +1254,67 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
>  	return -ENOMEM;
>  }
>  
> +#ifdef ENABLE_FWCTL
> +static const char fwctl_prefix[] = "fwctl";
> +static int get_feature_chardev(struct cxl_memdev *memdev, const char *base,
> +			       char *chardev_path)
> +{
> +	char *path = memdev->dev_buf;
> +	struct dirent *entry;
> +	bool found = false;
> +	int rc = 0;
> +	DIR *dir;
> +
> +	sprintf(path, "%s/fwctl/", base);
> +	dir = opendir(path);
> +	if (!dir)
> +		return -errno;
> +
> +	while ((entry = readdir(dir)) != NULL) {
> +		if (strncmp(entry->d_name, fwctl_prefix, strlen(fwctl_prefix)) == 0) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (!entry || !found) {

If entry != NULL then found is true as no other way to get out
of the loop above.  Which raises obvious question of why we need found?


> +		rc = -ENOENT;
> +		goto read_err;
> +	}
> +
> +	sprintf(chardev_path, "/dev/fwctl/%s", entry->d_name);
> +
> +read_err:
> +	closedir(dir);
> +	return rc;
> +}

> diff --git a/meson_options.txt b/meson_options.txt
> index 5c41b1abe1f1..acc19be4ff0a 100644
> --- a/meson_options.txt
> +++ b/meson_options.txt
> @@ -28,3 +28,5 @@ option('iniparserdir', type : 'string',
>         description : 'Path containing the iniparser header files')
>  option('modprobedatadir', type : 'string',
>         description : '''${sysconfdir}/modprobe.d/''')
> +option('fwctl', type : 'feature', value : 'enabled',
> +  description : 'enable firmware control')

Just looking at what is in the diff, seems that indent isn't
matching local style.

Jonathan

