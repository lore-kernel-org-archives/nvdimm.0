Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BDD121FC7498
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 10:04:14 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id f3so33990288oia.2
 for <linux-nvdimm@lists.01.org>; Sat, 07 Oct 2017 10:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015340.29722-3-vishal.l.verma@intel.com>
References: <20171006015340.29722-1-vishal.l.verma@intel.com>
 <20171006015340.29722-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 10:07:38 -0700
Message-ID: <CAPcyv4hLcpngRij-Kr+OZkK=CbHVNc_A+9qP=cgPpOxUKH3SzQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] nfit_test: add error injection DSMs
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 5, 2017 at 6:53 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> From: Dave Jiang <dave.jiang@intel.com>
>
> From: Dave Jiang <dave.jiang@intel.com>
>
> Add nfit_test emulation for the new ACPI 6.2 error injectino DSMs.
> This will allow unit tests to selectively inject the errors they wish to
> test for.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> [vishal: Add badrange.o to nfit_test's Kbuild]
> [vishal: Move injection functions to ND_CMD_CALL]
> [vishal: Add support for the notification option]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit/nfit.h              |   1 +
>  tools/testing/nvdimm/Kbuild           |   1 +
>  tools/testing/nvdimm/test/nfit.c      | 187 +++++++++++++++++++++++++++++-----
>  tools/testing/nvdimm/test/nfit_test.h |   4 +
>  4 files changed, 169 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index 7093bd5..7ddf48f 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -75,6 +75,7 @@ enum {
>         NFIT_ARS_CAP_NONE = 1,
>         NFIT_ARS_F_OVERFLOW = 1,
>         NFIT_ARS_TIMEOUT = 90,
> +       NFIT_ARS_INJECT_INVALID = 2,

If there is no usage of this define outside of nfit_test then it
should be defined in tools/testing/nvdimm/test/nfit.h.

>  };
>
>  enum nfit_root_notifiers {
> diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
> index d870520..3272ab5 100644
> --- a/tools/testing/nvdimm/Kbuild
> +++ b/tools/testing/nvdimm/Kbuild
> @@ -69,6 +69,7 @@ libnvdimm-y += $(NVDIMM_SRC)/region_devs.o
>  libnvdimm-y += $(NVDIMM_SRC)/region.o
>  libnvdimm-y += $(NVDIMM_SRC)/namespace_devs.o
>  libnvdimm-y += $(NVDIMM_SRC)/label.o
> +libnvdimm-y += $(NVDIMM_SRC)/badrange.o

This hunk should go in the same patch that changes
drivers/nvdimm/Makefile to add badrange.o so we don't have an
nfit_test compile breakage gap between commits.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
