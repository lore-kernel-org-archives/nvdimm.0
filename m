Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17E08226FAA85
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 21:31:19 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id t16-v6so24452913oih.3
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 21:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Apr 2018 21:31:18 -0700
Message-ID: <CAPcyv4gHvaEeLL65WobT7Most_w8htCqjDMcOEbsdQROToddgQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 0/3] nfit, address-range-scrub: rework and fixes
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Whoops, these patches should not be prefixed "ndctl".

On Thu, Apr 5, 2018 at 9:18 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Changes since v1:
> * Merge the cleanups and fixes with Dave's reviewed-by
> * Rework acpi_nfit_query_poison() to be independent of the spa range
> * Rework all acpi_nfit_query_poison() usage to call it once and then
>   iterate the result buffer over all SPA ranges
> * Make sure the implementation never attempts to scrub / register
>   unknown SPA types
> * Change no_init_ars to a bool type so it can be specified without an
>   '=' character.
>
> ---
>
> Given the fact that ARS can take 10s to 100s of seconds it is not
> feasible to wait for ARS completion before publishing persistent memory
> namespaces. Instead convert the ARS implementation to perform a short
> ARS for critical errors, ones that caused a previous system reset,
> before registering namespaces. Finally, arrange for all long ARS
> operations to run in the background and populate the badblock lists at
> run time.
>
> ---
>
> Dan Williams (3):
>       nfit, address-range-scrub: determine one platform max_ars value
>       nfit, address-range-scrub: rework and simplify ARS state machine
>       nfit, address-range-scrub: add module option to skip initial ars
>
>
>  drivers/acpi/nfit/core.c |  542 ++++++++++++++++++++--------------------------
>  drivers/acpi/nfit/nfit.h |    6 -
>  2 files changed, 243 insertions(+), 305 deletions(-)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
