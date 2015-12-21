Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <567869D5.30801@hpe.com>
Date: Mon, 21 Dec 2015 16:06:29 -0500
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] Expose known poison in SPA ranges to the block layer
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
In-Reply-To: <1450603122-7205-1-git-send-email-vishal@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: vishal@kernel.org, linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 12/20/2015 04:18 AM, vishal@kernel.org wrote:
> From: Vishal Verma <vishal.l.verma@intel.com>
> 
> This series does a few things:
> - Retrieve all known poison in the system physical address (SPA) space
>   using ARS (Address Range Scrub) commands to firmware
> - Store this poison in a new 'nd_poison' structure
> - In pmem, consume the poison list and expose the ranges as bad sectors
> 
> This depends on the badblocks series sent out previously[1]
> 
> This was tested using nfit_test to add poison at specific address ranges.
> More testing, specially on NVDIMM-N hardware is much appreciated!

All I can report on my NVDIMM-N hardware is that these patches work
properly when the firmware reports that ARS is not supported.  I
can see the capability query and status for each device. Since
there's no ARS support, the rest of the code gets skipped, at it should.

I'll take a look at the test code too but as for testing on my real
NVDIMM-N hardware, this is probably as far as I can go for a while.

-- ljk
> 
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-December/003239.html
> 
> Vishal Verma (3):
>   nfit_test: Enable DSMs for all test NFITs
>   libnvdimm: Add a poison list
>   pmem: Use the poison list to expose badblocks
> 
>  drivers/acpi/nfit.c              | 193 +++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/core.c            |  63 +++++++++++++
>  drivers/nvdimm/nd-core.h         |   1 +
>  drivers/nvdimm/nd.h              |   6 ++
>  drivers/nvdimm/pmem.c            | 124 +++++++++++++++++++++++++
>  include/linux/libnvdimm.h        |   2 +
>  tools/testing/nvdimm/test/nfit.c |   9 ++
>  7 files changed, 398 insertions(+)
> 

