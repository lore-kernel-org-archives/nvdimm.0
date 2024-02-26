Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0C128378
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708954362; cv=none; b=M4C9upVZtNtxMnlblI/qEoiQpxQuD7+fIgH+/ti59Woc4oSdm9TV1DiZXvl023RxfprFyoxjqSz23yy036/M2qr1BSpt4gBWRikP8qp1Hd451usak9Iof6fwzpRWEABYEGFau1CED72w3aNCPRTW6PiZlO8WWw1+OlnwGX5cqXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708954362; c=relaxed/simple;
	bh=/neKbunxHrwE+xaiaF0X+DGLLLiJ5WALdtQrSvjEPEc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWrza4S/4wPx8vxCD2kn0/QWp8D7mc00nslcQJnFBj/sogI3xpNaF4Z37IzJao5j+OVkWheTClv6QC1frtk+/po+/ZuvLyjYo9QVQNNCdNDXyCUVS5B70rFVB4ZEpgJzhFm4FLHatal1jnoii3yFBTIi8qKpM6pNTe7qp+LZVuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tk1dc2nRcz6JBTf;
	Mon, 26 Feb 2024 21:28:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FD251400DB;
	Mon, 26 Feb 2024 21:32:38 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 26 Feb
 2024 13:32:37 +0000
Date: Mon, 26 Feb 2024 13:32:37 +0000
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
Subject: Re: [RFC PATCH 14/20] famfs: Add struct file_operations
Message-ID: <20240226133237.0000593c@Huawei.com>
In-Reply-To: <3f19cd8daab0dc3c4d0381019ce61cd106970097.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
	<3f19cd8daab0dc3c4d0381019ce61cd106970097.1708709155.git.john@groves.net>
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
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Feb 2024 11:41:58 -0600
John Groves <John@Groves.net> wrote:

> This commit introduces the famfs file_operations. We call
> thp_get_unmapped_area() to force PMD page alignment. Our read and
> write handlers (famfs_dax_read_iter() and famfs_dax_write_iter())
> call dax_iomap_rw() to do the work.
> 
> famfs_file_invalid() checks for various ways a famfs file can be
> in an invalid state so we can fail I/O or fault resolution in those
> cases. Those cases include the following:
> 
> * No famfs metadata
> * file i_size does not match the originally allocated size
> * file is not flagged as DAX
> * errors were detected previously on the file
> 
> An invalid file can often be fixed by replaying the log, or by
> umount/mount/log replay - all of which are user space operations.
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_file.c | 136 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 136 insertions(+)
> 
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index fc667d5f7be8..5228e9de1e3b 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -19,6 +19,142 @@
>  #include <uapi/linux/famfs_ioctl.h>
>  #include "famfs_internal.h"
>  
> +/*********************************************************************
> + * file_operations
> + */
> +
> +/* Reject I/O to files that aren't in a valid state */
> +static ssize_t
> +famfs_file_invalid(struct inode *inode)
> +{
> +	size_t i_size       = i_size_read(inode);
> +	struct famfs_file_meta *meta = inode->i_private;
> +
> +	if (!meta) {
> +		pr_err("%s: un-initialized famfs file\n", __func__);
> +		return -EIO;
> +	}
> +	if (i_size != meta->file_size) {
> +		pr_err("%s: something changed the size from  %ld to %ld\n",
> +		       __func__, meta->file_size, i_size);
> +		meta->error = 1;
> +		return -ENXIO;
> +	}
> +	if (!IS_DAX(inode)) {
> +		pr_err("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
> +		meta->error = 1;
> +		return -ENXIO;
> +	}
> +	if (meta->error) {
> +		pr_err("%s: previously detected metadata errors\n", __func__);
> +		meta->error = 1;

Already set?  If treating it as only a boolean, maybe make it one?

> +		return -EIO;
> +	}
> +	return 0;
> +}

