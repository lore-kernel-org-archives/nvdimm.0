Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DF8021EB528F
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 02:59:20 -0700 (PDT)
Date: Thu, 31 Aug 2017 12:02:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] vfs: add flags parameter to ->mmap() in 'struct
 file_operations'
Message-ID: <20170831100201.GC21443@lst.de>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450036.5923.13851061508172314879.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150413450036.5923.13851061508172314879.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, jack@suse.cz, linux-nvdimm@lists.01.org, David Airlie <airlied@linux.ie>, linux-api@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, luto@kernel.org, Daniel Vetter <daniel.vetter@intel.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> -static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma)
> +static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma,
> +			 unsigned long map_flags)
>  {
>  	struct file *lower_file = ecryptfs_file_to_lower(file);
>  	/*
> @@ -179,7 +180,7 @@ static int ecryptfs_mmap(struct file *file, struct vm_area_struct *vma)
>  	 */
>  	if (!lower_file->f_op->mmap)
>  		return -ENODEV;
> -	return generic_file_mmap(file, vma);
> +	return generic_file_mmap(file, vma, 0);

Shouldn't ecryptfs pass on the flags?  Same for coda_file_mmap and
shm_mmap.

> -static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
> +static inline int call_mmap(struct file *file, struct vm_area_struct *vma,
> +			    unsigned long flags)
>  {
> -	return file->f_op->mmap(file, vma);
> +	return file->f_op->mmap(file, vma, flags);
>  }

It would be great to kill this pointless wrapper while we're at it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
