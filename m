Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27AE8209605CA
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:34:15 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id s198-v6so65178760oih.11
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:34:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142854714.27297.10145290341563367334.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142854714.27297.10145290341563367334.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:34:14 -0700
Message-ID: <CAPcyv4iw0mPVvX2ijMGqyfxOqyecpGx7wfzHdaOkG6w5sSvX-g@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] nfit/libnvdimm: add freeze security support to
 Intel nvdimm
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

On Thu, Jul 12, 2018 at 1:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Add support for freeze security on Intel nvdimm. This locks out any
> changes to security for the DIMM unless a reboot is done. This is triggered
> by writing "freeze" to the "security" sysfs attribute. libnvdimm will
> support the generic freeze_lock API call.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/intel.c  |   51 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/dimm_devs.c |   22 +++++++++++++++++++
>  include/linux/libnvdimm.h  |    2 ++
>  3 files changed, 75 insertions(+)

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
