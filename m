Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4D1292F6
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708955274; cv=none; b=lm4MdAh3YrlmHJGzs5VdniE7TkuT2oy2MKCnCiuOd/XDEKz4IpdUgUjEpqjIx6UMpaaxfb1p7ARGFb0iuUv6hyEO9zin4YgD3mHBgvpabVEssFjF56lDvI1lhSslZAr6JEkHk6iUY+ANwvWRIeVf+pJG/uUFS/3irPRLaCedBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708955274; c=relaxed/simple;
	bh=E83r2PzgmcARJDM5rhAvuhFm7oVmjpWV1yfSKzHMk8E=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHjCVG2hsVLLeE2MLIAuptknVFTRhY0rya7An94zovWu7WdJTbDJjI3FIJbtbMcr/WjhgGk/9LKvoGTHSogRu3MPeiwXlCw51MzkhKVzLOLuiXhMcgHrrCxw/6Xie/K3n9vcMaAdOr5m+yeTBmyaidWu460D8yPAXIgyqLLnC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk20704Rnz6K9PX;
	Mon, 26 Feb 2024 21:44:07 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 4623F1418DD;
	Mon, 26 Feb 2024 21:47:50 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 13:47:49 +0000
Date: Mon, 26 Feb 2024 13:47:48 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: John Groves <John@Groves.net>
CC: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	<linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <john@jagalactic.com>, Dave Chinner
	<david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	<dave.hansen@linux.intel.com>, <gregory.price@memverge.com>
Subject: Re: [RFC PATCH 17/20] famfs: Add module stuff
Message-ID: <20240226134748.00003f57@Huawei.com>
In-Reply-To: <e633fb92d3c20ba446e60c2c161cf07074aef374.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
	<e633fb92d3c20ba446e60c2c161cf07074aef374.1708709155.git.john@groves.net>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Feb 2024 11:42:01 -0600
John Groves <John@Groves.net> wrote:

> This commit introduces the module init and exit machinery for famfs.
> 
> Signed-off-by: John Groves <john@groves.net>
I'd prefer to see this from the start with the functionality of the module
built up as you go + build logic in place.  Makes it easy to spot places
where the patches aren't appropriately self constrained. 
> ---
>  fs/famfs/famfs_inode.c | 44 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index ab46ec50b70d..0d659820e8ff 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -462,4 +462,48 @@ static struct file_system_type famfs_fs_type = {
>  	.fs_flags	  = FS_USERNS_MOUNT,
>  };
>  
> +/*****************************************************************************************
> + * Module stuff

I'd drop these drivers structure comments. They add little beyond
a high possibility of being wrong after the code has evolved a bit.

> + */
> +static struct kobject *famfs_kobj;
> +
> +static int __init init_famfs_fs(void)
> +{
> +	int rc;
> +
> +#if defined(CONFIG_DEV_DAX_IOMAP)
> +	pr_notice("%s: Your kernel supports famfs on /dev/dax\n", __func__);
> +#else
> +	pr_notice("%s: Your kernel does not support famfs on /dev/dax\n", __func__);
> +#endif
> +	famfs_kobj = kobject_create_and_add(MODULE_NAME, fs_kobj);
> +	if (!famfs_kobj) {
> +		pr_warn("Failed to create kobject\n");
> +		return -ENOMEM;
> +	}
> +
> +	rc = sysfs_create_group(famfs_kobj, &famfs_attr_group);
> +	if (rc) {
> +		kobject_put(famfs_kobj);
> +		pr_warn("%s: Failed to create sysfs group\n", __func__);
> +		return rc;
> +	}
> +
> +	return register_filesystem(&famfs_fs_type);

If this fails, do we not leak the kobj and sysfs groups?

> +}
> +
> +static void
> +__exit famfs_exit(void)
> +{
> +	sysfs_remove_group(famfs_kobj,  &famfs_attr_group);
> +	kobject_put(famfs_kobj);
> +	unregister_filesystem(&famfs_fs_type);
> +	pr_info("%s: unregistered\n", __func__);
> +}
> +
> +
> +fs_initcall(init_famfs_fs);
> +module_exit(famfs_exit);
> +
> +MODULE_AUTHOR("John Groves, Micron Technology");
>  MODULE_LICENSE("GPL");

