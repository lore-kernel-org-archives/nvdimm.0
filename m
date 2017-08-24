Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D25A721E79027
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 09:56:04 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:58:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 1/5] vfs: add flags parameter to ->mmap() in 'struct
 file_operations'
Message-ID: <20170824165838.GB3121@infradead.org>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353211985.5039.4333061601382775843.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150353211985.5039.4333061601382775843.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, David Airlie <airlied@linux.ie>, linux-api@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>, akpm@linux-foundation.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 23, 2017 at 04:48:40PM -0700, Dan Williams wrote:
> We are running running short of vma->vm_flags. We can avoid needing a
> new VM_* flag in some cases if the original @flags submitted to mmap(2)
> is made available to the ->mmap() 'struct file_operations'
> implementation. For example, the proposed addition of MAP_DIRECT can be
> implemented without taking up a new vm_flags bit. Another motivation to
> avoid vm_flags is that they appear in /proc/$pid/smaps, and we have seen
> software that tries to dangerously (TOCTOU) read smaps to infer the
> behavior of a virtual address range.
> 
> This conversion was performed by the following semantic patch. There
> were a few manual edits for oddities like proc_reg_mmap.
> 
> Thanks to Julia for helping me with coccinelle iteration to cover cases
> where the mmap routine is defined in a separate file from the 'struct
> file_operations' instance that consumes it.

How are we going to check that an instance actually supports any
of those flags?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
