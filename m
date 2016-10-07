Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6220.austin.hp.com (g1t6220.austin.hp.com [15.73.96.84])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B92071A1E08
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 11:19:48 -0700 (PDT)
Subject: Re: [PATCH 00/14] libnvdimm: support sub-divisions of pmem for 4.9
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <1338e517-99a4-43c3-b3c4-4ca2f27a290c@hpe.com>
Date: Fri, 7 Oct 2016 14:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

A couple of general questions...

On 10/7/2016 12:38 PM, Dan Williams wrote:
> With the arrival of the device-dax facility in 4.7 a pmem namespace can
> now be configured into a total of four distinct modes: 'raw', 'sector',
> 'memory', and 'dax'. Where raw, sector, and memory are block device
> modes and dax supports the device-dax character device. With that degree
> of freedom in the use cases it is overly restrictive to continue the
> current limit of only one pmem namespace per-region, or "interleave-set"
> in ACPI 6+ terminology.

If I understand correctly, at least some of the restrictions were
part of the Intel NVDIMM Namespace spec rather than ACPI/NFIT restrictions.
The most recent namespace spec on pmem.io hasn't been updated to remove
those restrictions.  Is there a different public spec?

> This series adds support for reading and writing configurations that
> describe multiple pmem allocations within a region.  The new rules for
> allocating / validating the available capacity when blk and pmem regions
> alias are (quoting space_valid()):
> 
>    BLK-space is valid as long as it does not precede a PMEM
>    allocation in a given region. PMEM-space must be contiguous
>    and adjacent to an existing existing allocation (if one
>    exists).

Why is this new rule necessary?  Is this a HW-specific rule or something
related to how Linux could possibly support something?  Why do we care
whether blk-space is before or after pmem-space? If it's a HW-specific
rule, then shouldn't the enforcement be in the management tool that
configures the namespaces?

> Where "adjacent" allocations grow an existing namespace.  Note that
> growing a namespace is potentially destructive if free space is consumed
> from a location preceding the current allocation.  There is no support
> for dis-continuity within a given namespace allocation.

Are you talking about DPAs here?

> Previously, since there was only one namespace per-region, the resulting
> pmem device would be named after the region.  Now, subsequent namespaces
> after the first are named with the region index and a
> ".<namespace-index>" suffix. For example:
> 
> 	/dev/pmem0.1

According to the existing namespace spec, you can already have multiple
block namespaces on a device. I've not see a system with block namespaces
so what do those /dev entries look like?  (The dots are somewhat unattractive.)

-- ljk
> 
> ---
> 
> Dan Williams (14):
>       libnvdimm, region: move region-mapping input-paramters to nd_mapping_desc
>       libnvdimm, label: convert label tracking to a linked list
>       libnvdimm, namespace: refactor uuid_show() into a namespace_to_uuid() helper
>       libnvdimm, namespace: unify blk and pmem label scanning
>       tools/testing/nvdimm: support for sub-dividing a pmem region
>       libnvdimm, namespace: allow multiple pmem-namespaces per region at scan time
>       libnvdimm, namespace: sort namespaces by dpa at init
>       libnvdimm, region: update nd_region_available_dpa() for multi-pmem support
>       libnvdimm, namespace: expand pmem device naming scheme for multi-pmem
>       libnvdimm, namespace: update label implementation for multi-pmem
>       libnvdimm, namespace: enable allocation of multiple pmem namespaces
>       libnvdimm, namespace: filter out of range labels in scan_labels()
>       libnvdimm, namespace: lift single pmem limit in scan_labels()
>       libnvdimm, namespace: allow creation of multiple pmem-namespaces per region
> 
> 
>  drivers/acpi/nfit/core.c              |   30 +
>  drivers/nvdimm/dimm_devs.c            |  192 ++++++--
>  drivers/nvdimm/label.c                |  192 +++++---
>  drivers/nvdimm/namespace_devs.c       |  786 +++++++++++++++++++++++----------
>  drivers/nvdimm/nd-core.h              |   23 +
>  drivers/nvdimm/nd.h                   |   28 +
>  drivers/nvdimm/region_devs.c          |   58 ++
>  include/linux/libnvdimm.h             |   25 -
>  include/linux/nd.h                    |    8 
>  tools/testing/nvdimm/test/iomap.c     |  134 ++++--
>  tools/testing/nvdimm/test/nfit.c      |   21 -
>  tools/testing/nvdimm/test/nfit_test.h |   12 -
>  12 files changed, 1055 insertions(+), 454 deletions(-)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
