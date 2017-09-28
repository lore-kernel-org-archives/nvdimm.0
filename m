Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAD0F21F2AF8C
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 09:29:31 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] dax: stop using VM_MIXEDMAP for dax
References: <150655617774.700.5326522538400299973.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150655619012.700.15161500295945223238.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 28 Sep 2017 12:32:44 -0400
In-Reply-To: <150655619012.700.15161500295945223238.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Wed, 27 Sep 2017 16:49:50 -0700")
Message-ID: <x49poaaaimr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Now that we always have pages for DAX we can stop setting VM_MIXEDMAP.
> This does require some small fixups for the pte insert routines that dax
> utilizes.

It used to be that userspace would look to see if it had a 'mm' entry in
/proc/pid/smaps to determine whether or not it got a direct mapping.
Later, that same userspace (nvml) just uniformly declared dax not
available from any Linux file system, since msync was required.  And, I
guess DAX has always been marked experimental, so the interface can be
changed.

All this is to say I guess it's fine to change this.

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 680506faceae..d682f60670ff 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1111,7 +1111,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>  	 * We later require that vma->vm_flags == vm_flags,
>  	 * so this tests vma->vm_flags & VM_SPECIAL, too.
>  	 */
> -	if (vm_flags & VM_SPECIAL)
> +	if ((vm_flags & VM_SPECIAL))
>  		return NULL;

That looks superfluous.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
