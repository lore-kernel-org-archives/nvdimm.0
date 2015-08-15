Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 15 Aug 2015 11:01:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/7] 'struct page' driver for persistent memory
Message-ID: <20150815090129.GD21033@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, boaz@plexistor.com, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, mingo@kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, mgorman@suse.de, "H. Peter Anvin" <hpa@zytor.com>, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

based on the issues with the physiscal address S/G lists I suspect
we will need this page hotplugging code.  Any chance we could side
step the issue of storing the page structs on the actual pmem for
the first round so that we can an initial version into 4.3?  I'll
help with the max_pfn audit and testing with my WIP block driver
that does I/O from pmem.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
