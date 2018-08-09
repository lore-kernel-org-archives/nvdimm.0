Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 987C7210DF76D
 for <linux-nvdimm@lists.01.org>; Thu,  9 Aug 2018 02:02:10 -0700 (PDT)
Date: Thu, 9 Aug 2018 11:02:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V3 0/4] Fix kvm misconceives NVDIMM pages as reserved mmio
Message-ID: <20180809090208.GD5069@quack2.suse.cz>
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
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
To: Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: jack@suse.cz, yu.c.zhang@intel.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, hch@lst.de, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu 09-08-18 18:52:48, Zhang Yi wrote:
> For device specific memory space, when we move these area of pfn to
> memory zone, we will set the page reserved flag at that time, some of
> these reserved for device mmio, and some of these are not, such as
> NVDIMM pmem.
> 
> Now, we map these dev_dax or fs_dax pages to kvm for DIMM/NVDIMM
> backend, since these pages are reserved. the check of
> kvm_is_reserved_pfn() misconceives those pages as MMIO. Therefor, we
> introduce 2 page map types, MEMORY_DEVICE_FS_DAX/MEMORY_DEVICE_DEV_DAX,
> to indentify these pages are from NVDIMM pmem. and let kvm treat these
> as normal pages.
> 
> Without this patch, Many operations will be missed due to this
> mistreatment to pmem pages. For example, a page may not have chance to
> be unpinned for KVM guest(in kvm_release_pfn_clean); not able to be
> marked as dirty/accessed(in kvm_set_pfn_dirty/accessed) etc.
> 
> V1:
> https://lkml.org/lkml/2018/7/4/91
> 
> V2:
> https://lkml.org/lkml/2018/7/10/135
> 
> V3:
> [PATCH V3 1/4] Needs Comments.
> [PATCH V3 2/4] Update the description of MEMORY_DEVICE_DEV_DAX: Jan
> [PATCH V3 3/4] Acked-by: Jan in V2

Hum, but it is not the the patch...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
