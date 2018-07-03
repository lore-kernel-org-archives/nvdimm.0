Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5FCE210F257B
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 20:48:27 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id k12-v6so1028337oiw.8
 for <linux-nvdimm@lists.01.org>; Mon, 02 Jul 2018 20:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 2 Jul 2018 20:48:26 -0700
Message-ID: <CAPcyv4gXt=K7yC3M8gsgK35T1zrWW9kCXjjiyOPBgH8ZDTQxnA@mail.gmail.com>
Subject: Re: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 2, 2018 at 4:39 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding support to allow query the security status of the Intel nvdimms and
> also unlock the dimm via the kernel key management APIs. The passphrase is
> expected to be pulled from userspace through keyutils. Moving the Intel
> related bits to its own source file as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/Makefile |    2 -
>  drivers/acpi/nfit/core.c   |    3 +
>  drivers/acpi/nfit/intel.c  |  142 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/intel.h  |    2 +
>  drivers/nvdimm/dimm.c      |    7 ++
>  drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h   |    3 +
>  drivers/nvdimm/nd.h        |    2 +
>  include/linux/libnvdimm.h  |   22 ++++++-
>  9 files changed, 287 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/acpi/nfit/intel.c
>
> diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
> index a407e769f103..8287005f9226 100644
> --- a/drivers/acpi/nfit/Makefile
> +++ b/drivers/acpi/nfit/Makefile
> @@ -1,3 +1,3 @@
>  obj-$(CONFIG_ACPI_NFIT) := nfit.o
> -nfit-y := core.o
> +nfit-y := core.o intel.o
>  nfit-$(CONFIG_X86_MCE) += mce.o
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index a6fb336da79d..638bb7fbe565 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1907,7 +1907,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                 nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
>                                 acpi_nfit_dimm_attribute_groups,
>                                 flags, cmd_mask, flush ? flush->hint_count : 0,
> -                               nfit_mem->flush_wpq, dimm_id);
> +                               nfit_mem->flush_wpq, dimm_id,
> +                               &intel_security_ops);

I would expect there to be a routine that returns the security ops
based on the 'nvdimm family'. I.e. that this ops structure should be
NULL for everything except NVDIMM_FAMILY_INTEL presently.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
