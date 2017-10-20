Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 20 Oct 2017 09:57:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
Message-ID: <20171020075735.GA14378@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com> <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

> --- a/arch/powerpc/sysdev/axonram.c
> +++ b/arch/powerpc/sysdev/axonram.c
> @@ -172,6 +172,7 @@ static size_t axon_ram_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  
>  static const struct dax_operations axon_ram_dax_ops = {
>  	.direct_access = axon_ram_dax_direct_access,
> +
>  	.copy_from_iter = axon_ram_copy_from_iter,

Unrelated whitespace change.  That being said - I don't think axonram has
devmap support in any form, so this basically becomes dead code, doesn't
it?

> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 7abb240847c0..e7e5db07e339 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -52,6 +52,7 @@ static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
>  
>  static const struct dax_operations dcssblk_dax_ops = {
>  	.direct_access = dcssblk_dax_direct_access,
> +
>  	.copy_from_iter = dcssblk_dax_copy_from_iter,

Same comments apply here.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
