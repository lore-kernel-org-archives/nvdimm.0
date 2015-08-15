Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 15 Aug 2015 17:58:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 5/7] libnvdimm, e820: make CONFIG_X86_PMEM_LEGACY a
	tristate option
Message-ID: <20150815155846.GA26248@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com> <20150813035028.36913.25267.stgit@otcpl-skl-sds-2.jf.intel.com> <20150815090635.GF21033@lst.de> <CAPcyv4hMaRDOttcnvjq-aBXqgaPuB1d1XVi-dJFryC9pJ8PhMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hMaRDOttcnvjq-aBXqgaPuB1d1XVi-dJFryC9pJ8PhMw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 15, 2015 at 08:28:35AM -0700, Dan Williams wrote:
> I'm not grokking the argument against allowing this functionality to
> be modular.

You're adding a another layer of platform_devices just to make a tivially
small piece of code modular so that you can hook into it.  I don't think
that's a good reason, and neither is the after thought of preventing
potentially future buggy firmware.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
