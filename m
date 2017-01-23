Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BC9681EEA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 13:36:24 -0800 (PST)
Date: Mon, 23 Jan 2017 14:36:14 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to
 take only vmf
Message-ID: <20170123213614.GA27007@linux.intel.com>
References: <148495502151.58418.7078842737664999534.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148495502151.58418.7078842737664999534.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: tytso@mit.edu, mawilcox@microsoft.com, darrick.wong@oracle.com, linux-mm@kvack.org, dave.hansen@intel.com, jack@suse.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 20, 2017 at 04:33:08PM -0700, Dave Jiang wrote:
> ->fault(), ->page_mkwrite(), and ->pfn_mkwrite() calls do not need to take
> a vma and vmf parameter when the vma already resides in vmf. Remove the vma
> parameter to simplify things.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> This patch has received a build success notification from the 0day-kbuild
> robot across 124 configs. 
> 
> ---
<>
> diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
> index 10820f6..b6661fd 100644
> --- a/arch/x86/entry/vdso/vma.c
> +++ b/arch/x86/entry/vdso/vma.c
> @@ -38,7 +38,7 @@ void __init init_vdso_image(const struct vdso_image *image)
>  struct linux_binprm;
>  
>  static int vdso_fault(const struct vm_special_mapping *sm,
> -		      struct vm_area_struct *vma, struct vm_fault *vmf)
> +		struct vm_area_struct *vma, struct vm_fault *vmf)

Unneeded spacing change.

Other than that, this looks good to me.  I agree with Jan's observation that
it creates a lot of thrash, but I personally like the change because it
eliminates the question of what to do when the 'vma' you're passed in doesn't
match 'vmf->vma'.  Having one source of truth seems good, and it reduces the
amount of args we are passing around.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
