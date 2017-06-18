Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D147A21A07A94
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 01:27:22 -0700 (PDT)
Date: Sun, 18 Jun 2017 10:28:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 01/14] x86, uaccess: introduce
 copy_from_iter_flushcache for pmem / cache-bypass operations
Message-ID: <20170618082841.GA26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983098.20620.14791162611225792317.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703983098.20620.14791162611225792317.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 09, 2017 at 01:23:51PM -0700, Dan Williams wrote:
> Implement a __copy_from_user_inatomic_flushcache, memcpy_page_flushcache, and
> memcpy_flushcache, that guarantee that the destination buffer is not dirty in
> the cpu cache on completion. The new copy_from_iter_flushcache and sub-routines

Wouldn't writethrough be a better name?

> will be used to replace the "pmem api" (include/linux/pmem.h +
> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_flushcache()
> and memcpy_flushcache() are gated by the CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
> config symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
> otherwise.

What is UACCESS about memcpy_flushcache?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
