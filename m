Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 17 Aug 2015 17:01:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 5/7] libnvdimm, e820: make CONFIG_X86_PMEM_LEGACY a
	tristate option
Message-ID: <20150817150158.GB2625@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com> <20150813035028.36913.25267.stgit@otcpl-skl-sds-2.jf.intel.com> <20150815090635.GF21033@lst.de> <CAPcyv4hMaRDOttcnvjq-aBXqgaPuB1d1XVi-dJFryC9pJ8PhMw@mail.gmail.com> <20150815155846.GA26248@lst.de> <CAPcyv4iN0BmipDfrsoCg2N2KnhX0+Hz2-ghr1i0H4US+bFe+Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iN0BmipDfrsoCg2N2KnhX0+Hz2-ghr1i0H4US+bFe+Dw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 15, 2015 at 09:04:02AM -0700, Dan Williams wrote:
> What other layer? /sys/devices/platform/e820_pmem is that exact same
> device we had before this patch.  We just have a proper driver for it
> now.

We're adding another layer of indirection between the old e820 file
and the new module.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
