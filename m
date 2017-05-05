Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x241.google.com (mail-wr0-x241.google.com
 [IPv6:2a00:1450:400c:c0c::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DBAE21A134AE
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 23:54:09 -0700 (PDT)
Received: by mail-wr0-x241.google.com with SMTP id v42so3416407wrc.3
 for <linux-nvdimm@lists.01.org>; Thu, 04 May 2017 23:54:09 -0700 (PDT)
Date: Fri, 5 May 2017 08:54:04 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86, uaccess: introduce copy_from_iter_wt for pmem /
 writethrough operations
Message-ID: <20170505065404.llj4ym3thrmmlhyo@gmail.com>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
 <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> The pmem driver has a need to transfer data with a persistent memory
> destination and be able to rely on the fact that the destination writes
> are not cached. It is sufficient for the writes to be flushed to a
> cpu-store-buffer (non-temporal / "movnt" in x86 terms), as we expect
> userspace to call fsync() to ensure data-writes have reached a
> power-fail-safe zone in the platform. The fsync() triggers a REQ_FUA or
> REQ_FLUSH to the pmem driver which will turn around and fence previous
> writes with an "sfence".
> 
> Implement a __copy_from_user_inatomic_wt, memcpy_page_wt, and memcpy_wt,
> that guarantee that the destination buffer is not dirty in the cpu cache
> on completion. The new copy_from_iter_wt and sub-routines will be used
> to replace the "pmem api" (include/linux/pmem.h +
> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_wt()
> and memcpy_wt() are gated by the CONFIG_ARCH_HAS_UACCESS_WT config
> symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
> otherwise.
> 
> This is meant to satisfy the concern from Linus that if a driver wants
> to do something beyond the normal nocache semantics it should be
> something private to that driver [1], and Al's concern that anything
> uaccess related belongs with the rest of the uaccess code [2].
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
> [2]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009942.html
> 
> Cc: <x86@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since the initial RFC:
> * s/writethru/wt/ since we already have ioremap_wt(), set_memory_wt(),
>   etc. (Ingo)

Looks good to me. I suspect you'd like to carry this in the nvdimm tree?

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
