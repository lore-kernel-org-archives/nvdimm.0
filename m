Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 2224A1A21F1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 20:02:00 -0700 (PDT)
Date: Tue, 12 Apr 2016 23:01:56 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Message-ID: <20160413030156.GN2781@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 12, 2016 at 02:39:29PM -0600, Toshi Kani wrote:
> To support DAX pmd mappings with unmodified applications,
> filesystems need to align an mmap address by the pmd size.

> @@ -708,6 +708,9 @@ const struct file_operations ext4_file_operations = {
>  	.open		= ext4_file_open,
>  	.release	= ext4_release_file,
>  	.fsync		= ext4_sync_file,
> +#ifdef CONFIG_FS_DAX
> +	.get_unmapped_area = dax_get_unmapped_area,
> +#endif
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ext4_fallocate,

Could you do something like:

 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
+               unsigned long len, unsigned long pgoff, unsigned long flags);
 #else
 static inline struct page *read_dax_sector(struct block_device *bdev,
                 sector_t n)
 {
         return ERR_PTR(-ENXIO);
 }
+#define dax_get_unmapped_area	NULL
 #endif

in patch 1/5.  Then there's no need for the ifdefs in each filesystem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
