Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9250C212963EF
 for <linux-nvdimm@lists.01.org>; Tue, 18 Jun 2019 15:10:53 -0700 (PDT)
Subject: Re: [PATCH 0/6] libnvdimm: Fix async operations and locking
References: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <53fa618d-376f-2200-c8ba-e22ba004cdc0@oracle.com>
Date: Tue, 18 Jun 2019 15:10:33 -0700
MIME-Version: 1.0
In-Reply-To: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Erwin Tsaur <erwin.tsaur@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On 6/11/2019 4:25 PM, Dan Williams wrote:
> The libnvdimm subsystem uses async operations to parallelize device
> probing operations and to allow sysfs to trigger device_unregister() on
> deleted namepsaces. A multithreaded stress test of the libnvdimm sysfs
> interface uncovered a case where device_unregister() is triggered
> multiple times, and the subsequent investigation uncovered a broken
> locking scenario.
> 
> The lack of lockdep coverage for device_lock() stymied the debug. That
> is, until patch6 "driver-core, libnvdimm: Let device subsystems add
> local lockdep coverage" solved that with a shadow lock, with lockdep
> coverage, to mirror device_lock() operations. Given the time saved with
> shadow-lock debug-hack, patch6 attempts to generalize device_lock()
> debug facility that might be able to be carried upstream. Patch6 is
> staged at the end of this fix series in case it is contentious and needs
> to be dropped.
> 
> Patch1 "drivers/base: Introduce kill_device()" could be achieved with
> local libnvdimm infrastructure. However, the existing 'dead' flag in
> 'struct device_private' aims to solve similar async register/unregister
> races so the fix in patch2 "libnvdimm/bus: Prevent duplicate
> device_unregister() calls" can be implemented with existing driver-core
> infrastructure.
> 
> Patch3 is a rare lockdep warning that is intermittent based on
> namespaces racing ahead of the completion of probe of their parent
> region. It is not related to the other fixes, it just happened to
> trigger as a result of the async stress test.
> 
> Patch4 and patch5 address an ABBA deadlock tripped by the stress test.
> 
> These patches pass the failing stress test and the existing libnvdimm
> unit tests with CONFIG_PROVE_LOCKING=y and the new "dev->lockdep_mutex"
> shadow lock with no lockdep warnings.
> 
> ---
> 
> Dan Williams (6):
>        drivers/base: Introduce kill_device()
>        libnvdimm/bus: Prevent duplicate device_unregister() calls
>        libnvdimm/region: Register badblocks before namespaces
>        libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
>        libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock
>        driver-core, libnvdimm: Let device subsystems add local lockdep coverage
> 
> 
>   drivers/acpi/nfit/core.c        |   28 ++++---
>   drivers/acpi/nfit/nfit.h        |   24 ++++++
>   drivers/base/core.c             |   30 ++++++--
>   drivers/nvdimm/btt_devs.c       |   16 ++--
>   drivers/nvdimm/bus.c            |  154 +++++++++++++++++++++++++++------------
>   drivers/nvdimm/core.c           |   10 +--
>   drivers/nvdimm/dimm_devs.c      |    4 +
>   drivers/nvdimm/namespace_devs.c |   36 +++++----
>   drivers/nvdimm/nd-core.h        |   71 ++++++++++++++++++
>   drivers/nvdimm/pfn_devs.c       |   24 +++---
>   drivers/nvdimm/pmem.c           |    4 +
>   drivers/nvdimm/region.c         |   24 +++---
>   drivers/nvdimm/region_devs.c    |   12 ++-
>   include/linux/device.h          |    6 ++
>   14 files changed, 308 insertions(+), 135 deletions(-)
> 

Tested-by: Jane Chu <jane.chu@oracle.com>

Specifically, running parallel ndctls creating/destroying namespaces in 
multiple processes concurrently led to system panic, that has been 
verified fixed by this patch series.

Thanks!
-jane
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
