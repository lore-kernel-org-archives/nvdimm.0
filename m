Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B27B21D1E2C5
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 05:57:43 -0700 (PDT)
Date: Fri, 25 Aug 2017 06:00:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
Message-ID: <20170825130011.GA30072@infradead.org>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org>
 <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
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
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 10:36:02AM -0700, Dan Williams wrote:
> I'll let Andy and Kirill restate their concerns, but one of the
> arguments that swayed me is that any new mmap flag with this hack must
> be documented to only work with MAP_SHARED and that MAP_PRIVATE is
> silently ignored. I agree with the mess and delays it causes for other
> archs and libc, but at the same time this is for new applications and
> libraries that know to look for the new flag, so they need to do the
> extra work to check for the new syscall.

True.  That is for the original hack, but I spent some more time
looking at the mmap code, and there is one thing I noticed:

include/uapi/asm-generic/mman-common.h:

#define MAP_SHARED      0x01            /* Share changes */
#define MAP_PRIVATE     0x02            /* Changes are private */
#define MAP_TYPE        0x0f            /* Mask for type of mapping */

mm/mmap.c:

	if (file) {
		struct inode *inode = file_inode(file);

		switch (flags & MAP_TYPE) {
                case MAP_SHARED:
			...
		case MAP_PRIVATE:
			...
		default:
			return -EINVAL;
		}

and very similar for the anonymous and nommu cases.

So if we pick e.g. 0x4 as the valid bit we don't even need to overload
the MAP_SHARED and MAP_PRIVATE meaning.

> 
> However, if the fcntl lease approach works for the DMA cases then we
> only have the one mmap flag to add for now, so maybe the weird
> MAP_{SHARED|PRIVATE} semantics are tolerable.
---end quoted text---
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
