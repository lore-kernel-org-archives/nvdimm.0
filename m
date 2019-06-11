Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 11 Jun 2019 12:37:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/6] mm/nvdimm: Add page size and struct page size to
 pfn superblock
Message-ID: <20190611103729.GA27635@quack2.suse.cz>
References: <20190604091357.32213-1-aneesh.kumar@linux.ibm.com>
 <20190604091357.32213-3-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604091357.32213-3-aneesh.kumar@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 04-06-19 14:43:54, Aneesh Kumar K.V wrote:
> This is needed so that we don't wrongly initialize a namespace
> which doesn't have enough space reserved for holding struct pages
> with the current kernel.
> 
> We also increment PFN_MIN_VERSION to make sure that older kernel
> won't initialize namespace created with newer kernel.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
...
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 00c57805cad3..e01eee9efafe 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -467,6 +467,15 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  	if (__le16_to_cpu(pfn_sb->version_minor) < 2)
>  		pfn_sb->align = 0;
>  
> +	if (__le16_to_cpu(pfn_sb->version_minor) < 3) {
> +		/*
> +		 * For a large part we use PAGE_SIZE. But we
> +		 * do have some accounting code using SZ_4K.
> +		 */
> +		pfn_sb->page_struct_size = cpu_to_le16(64);
> +		pfn_sb->page_size = cpu_to_le32(SZ_4K);
> +	}
> +
>  	switch (le32_to_cpu(pfn_sb->mode)) {
>  	case PFN_MODE_RAM:
>  	case PFN_MODE_PMEM:

As we discussed with Aneesh privately, this actually means that existing
NVDIMM namespaces on PPC64 will stop working due to these defaults for old
superblocks. I don't think that's a good thing as upgrading kernels is
going to be nightmare due to this on PPC64. So I believe we should make
defaults for old superblocks such that working setups keep working without
sysadmin having to touch anything.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
