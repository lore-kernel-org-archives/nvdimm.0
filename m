Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2342212108E4
 for <linux-nvdimm@lists.01.org>; Tue, 23 Apr 2019 07:27:27 -0700 (PDT)
Date: Tue, 23 Apr 2019 16:27:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 4/6]  dax: check synchronous mapping is supported
Message-ID: <20190423142723.GD9910@quack2.suse.cz>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-5-pagupta@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190423080612.15361-5-pagupta@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pankaj Gupta <pagupta@redhat.com>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval.shaia@oracle.com, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong.eric@gmail.com, darrick.wong@oracle.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue 23-04-19 13:36:10, Pankaj Gupta wrote:
> This patch introduces 'daxdev_mapping_supported' helper
> which checks if 'MAP_SYNC' is supported with filesystem
> mapping. It also checks if corresponding dax_device is
> synchronous. Virtio pmem device is asynchronous and
> does not not support VM_SYNC. 
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  include/linux/dax.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index c97fc0cc7167..41b4a5db6305 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -41,6 +41,18 @@ void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> +/*
> + * Check if given mapping is supported by the file / underlying device.
> + */
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{
> +	if (!(vma->vm_flags & VM_SYNC))
> +		return true;
> +	if (!IS_DAX(file_inode(vma->vm_file)))
> +		return false;
> +	return dax_synchronous(dax_dev);
> +}
>  #else
>  static inline struct dax_device *dax_get_by_host(const char *host)
>  {
> @@ -68,6 +80,11 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
>  {
>  	return false;
>  }
> +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> +				struct dax_device *dax_dev)
> +{
> +	return !(vma->flags & VM_SYNC);
> +}
>  #endif
>  
>  struct writeback_control;
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
