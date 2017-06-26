Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9144A21A00AC2
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 10:36:06 -0700 (PDT)
Date: Mon, 26 Jun 2017 11:37:34 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v2 0/7] Enable DSM pass thru for root functions
Message-ID: <20170626173734.GA23637@anatevka.americas.hpqcorp.net>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 20, 2017 at 10:51:19AM -0600, Jerry Hoemann wrote:
> The new ACPI 6.2 spec has added new NVDIMM root DSM functions
> that managibility and test software needs to call.
> 
> This patch set enables the calling root functions DSM via the
> pass thru mechanism.
> 
> Changes v2
> ----------
> 1. Add bus_dsm_mask to filter root pass thru calls.
> 
> 2. Add bus_dsm_mask_show to display bus_dsm_mask in sysfs
> 
> 3. Extend override_dsm_mask to be used for bus_dms_mask also.
> 


  Dan,

  Did you have any feedback?

  Thanks

  Jerry

> 
> 
> 
> Details v1
> ----------
> 
> __nd_ioctl:
> Check pass thru functions against nd_cmd_clear_to_send.
> 
> acpi_nfit_init_dsms:
> Set additional bits in cmd_mask for new functions.
> 
> ndctl.h:
> Define data structure for the new 6.2 functions.
> Add new function names to nvdimm_bus_cmd_name.
> 
> 
> 
> Jerry Hoemann (7):
>   libnvdimm: passthru functions clear to send
>   acpi, nfit: Enable DSM pass thru for root functions.
>   libnvdimm: Add bus level dsm mask.
>   acpi, nfit: Use bus_dsm_mask for passthru
>   acpi, nfit: Show bus_dsm_mask
>   libnvdimm: New ACPI 6.2 DSM functions
>   acpi, nfit: override mask
> 
>  drivers/acpi/nfit/core.c   | 20 ++++++++++++++++++++
>  drivers/nvdimm/bus.c       |  4 +++-
>  include/linux/libnvdimm.h  |  1 +
>  include/uapi/linux/ndctl.h | 41 ++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 64 insertions(+), 2 deletions(-)
> 
> -- 
> 1.8.5.6

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
