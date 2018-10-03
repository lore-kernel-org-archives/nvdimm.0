Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E8B521161696
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 18:08:17 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 0/3] Replace udev rule for latch and
 dirty-shutdown-count
Date: Wed, 3 Oct 2018 01:08:16 +0000
Message-ID: <b6e4883ef657d192f91f2801f15eb347d2ef7c00.camel@intel.com>
References: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153809529764.1963951.7530312689559729607.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <6DD45D1C897EF84689317EA307A3E158@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-09-27 at 17:41 -0700, Dan Williams wrote:
> Changes since v2 [1]:
> * Drop the 'dirty-dimm' command
> * Add ndctl_dimm_get_dirty_shutdown() api
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-September/017890.html
> 
> ---
> 
> The latch mechanism is awkward especially when all that it needed is a
> rolling count of dirty-shutdown events. The expectation going forward is
> that the platform firmware will handle the latch, if it is present, and
> the OS need only consume the dirty-shutdown count. The ndctl
> implementation called libndctl apis from the udev queue which we
> discovered injects unnecessary udev queue drains / stalls into the boot
> path. Lastly, the userspace caching scheme for non-root users to consume
> the dirty-shutdown-count just isn't as efficient as teaching the kernel
> to cache this value and export it as a standard sysfs attribute.
> 
> ---
> 
> Dan Williams (3):
>       ndctl, lib: Add dirty-shutdown-count retrieval helper
>       ndctl: Revert "ndctl, intel: Fallback to smart cached shutdown_count"
>       ndctl: Revert "ndctl: Create ndctl udev rules for dirty shutdown"

These look good, applied.

> 
> 
>  .gitignore             |    1 
>  Makefile.am            |    3 -
>  configure.ac           |   10 ---
>  contrib/80-ndctl.rules |    3 -
>  ndctl.spec.in          |    3 -
>  ndctl/Makefile.am      |    5 --
>  ndctl/lib/intel.c      |   41 -------------
>  ndctl/lib/libndctl.c   |   16 ++++-
>  ndctl/lib/libndctl.sym |    5 ++
>  ndctl/lib/private.h    |    4 -
>  ndctl/libndctl.h       |    1 
>  ndctl/ndctl-udev.c     |  150 ------------------------------------------------
>  test/libndctl.c        |   29 +++++++--
>  13 files changed, 40 insertions(+), 231 deletions(-)
>  delete mode 100644 contrib/80-ndctl.rules
>  delete mode 100644 ndctl/ndctl-udev.c

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
