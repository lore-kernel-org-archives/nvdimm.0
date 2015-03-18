Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <55095CC6.4070404@plexistor.com>
Date: Wed, 18 Mar 2015 13:08:54 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH 0/6] Add persistent memory driver
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, hch@infradead.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/16/2015 11:12 PM, Ross Zwisler wrote:
> PMEM is a modified version of the Block RAM Driver, BRD. The major difference
> is that BRD allocates its backing store pages from the page cache, whereas
> PMEM uses reserved memory that has been ioremapped.
> 
> One benefit of this approach is that there is a direct mapping between
> filesystem block numbers and virtual addresses.  In PMEM, filesystem blocks N,
> N+1, N+2, etc. will all be adjacent in the virtual memory space. This property
> allows us to set up PMD mappings (2 MiB) for DAX.
> 
> This patch set is builds upon the work that Matthew Wilcox has been doing for
> DAX, which has been merged into the v4.0 kernel series.
> 
> For more information on PMEM and for some instructions on how to use it, please
> check out PMEM's github tree:
> 
> https://github.com/01org/prd
> 
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: axboe@kernel.dk
> Cc: hch@infradead.org
> Cc: riel@redhat.com
> 
> Boaz Harrosh (1):
>   pmem: Let each device manage private memory region
> 
   Not signed-off-by me.

> Ross Zwisler (5):
>   pmem: Initial version of persistent memory driver

This is the wrong code

>   pmem: Add support for getgeo()

We do not need this patch

>   pmem: Add support for rw_page()
>   pmem: Add support for direct_access()
>   pmem: Clean up includes
> 

NACK!

This is the wrong pmem driver, the wrong API and the wrong bad copy/paste
from brd code.

(And thanks Ross for not CCing me I have lots of mail to read every day,
 Seriously this is rude, what do I need to feel?)

And very Seriously. Ross what is that joke Kconfig and module-param
API, how it is relevant to anything and how it is getting us close
to what pmem really needs to be, with the auto-probe. Is this your
wait wait we done lots of new work on this? It did not change one
bit from the original brd copy/paste.

Boaz

>  MAINTAINERS            |   6 +
>  drivers/block/Kconfig  |  41 +++++
>  drivers/block/Makefile |   1 +
>  drivers/block/pmem.c   | 401 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 449 insertions(+)
>  create mode 100644 drivers/block/pmem.c
> 

