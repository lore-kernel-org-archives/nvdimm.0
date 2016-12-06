From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] device-dax: fail all private mapping attempts
Date: Mon, 5 Dec 2016 17:01:58 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1612051648270.1536@eggly.anvils>
References: <147931721349.37471.4835899844582504197.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <147931721349.37471.4835899844582504197.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Pawel Lebioda <pawel.lebioda@intel.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, 16 Nov 2016, Dan Williams wrote:

> The device-dax implementation originally tried to be tricky and allow
> private read-only mappings, but in the process allowed writable
> MAP_PRIVATE + MAP_NORESERVE mappings.  For simplicity and predictability
> just fail all private mapping attempts since device-dax memory is
> statically allocated and will never support overcommit.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Reported-by: Pawel Lebioda <pawel.lebioda@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/dax.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index 0e499bfca41c..3d94ff20fdca 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -270,8 +270,8 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
>  	if (!dax_dev->alive)
>  		return -ENXIO;
>  
> -	/* prevent private / writable mappings from being established */
> -	if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) == VM_WRITE) {
> +	/* prevent private mappings from being established */
> +	if ((vma->vm_flags & VM_SHARED) != VM_SHARED) {

I think that is more restrictive than you intended: haven't tried,
but I believe it rejects a PROT_READ, MAP_SHARED, O_RDONLY fd mmap,
leaving no way to mmap /dev/dax without write permission to it.

See line 1393 of mm/mmap.c: the test you want is probably
	if (!(vma->vm_flags & VM_MAYSHARE))

Hugh

>  		dev_info(dev, "%s: %s: fail, attempted private mapping\n",
>  				current->comm, func);
>  		return -EINVAL;
> 
> --

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
