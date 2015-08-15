Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 15 Aug 2015 11:06:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 5/7] libnvdimm, e820: make CONFIG_X86_PMEM_LEGACY a
	tristate option
Message-ID: <20150815090635.GF21033@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com> <20150813035028.36913.25267.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150813035028.36913.25267.stgit@otcpl-skl-sds-2.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, boaz@plexistor.com, riel@redhat.com, linux-nvdimm@lists.01.org, david@fromorbit.com, mingo@kernel.org, linux-mm@kvack.org, mgorman@suse.de, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 11:50:29PM -0400, Dan Williams wrote:
> Purely for ease of testing, with this in place we can run the unit test
> alongside any tests that depend on the memmap=ss!nn kernel parameter.
> The unit test mocking implementation requires that libnvdimm be a module
> and not built-in.
> 
> A nice side effect is the implementation is a bit more generic as it no
> longer depends on <asm/e820.h>.

I really don't like this artifical split, and I also don't like how
your weird "unit tests" force even more ugliness on the kernel.  Almost
reminds of the python projects spending more effort on getting their
class mockable than actually producing results..

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
