Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECD1B20968907
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:49:37 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id n84-v6so253026oib.9
 for <linux-nvdimm@lists.01.org>; Mon, 02 Jul 2018 16:49:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153057475267.38125.573190510224930543.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057475267.38125.573190510224930543.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 2 Jul 2018 16:49:36 -0700
Message-ID: <CAPcyv4hA39=Ub=01x6engjb8ObzRSxC+rHNMRFjMrLBv8yDFkw@mail.gmail.com>
Subject: Re: [PATCH 01/11] nfit: adding support for Intel DSM 1.7 commands
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
> Adding command definition for security commands defined in Intel DSM
> specification v1.7. This includes "get security state", "set passphrase",
> "unlock unit", "freeze lock", "secure erase", "ovewrite", and
> "overwrite query". Since we are adding a lot of Intel definitions, moving
> the relevant bits to its own header. Also, we don't want those commands
> to be issued from user space through ioctls. Reason being some of the
> security commands require kernel involvement to flush all CPU caches that
> can't be done in userspace and the result can cause system crash. So
> blocking security commands in the ioctl path.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---

Looks good, one nit.

[..]
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index 7d15856a739f..3b3f59828632 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -20,6 +20,7 @@
>  #include <linux/types.h>
>  #include <linux/acpi.h>
>  #include <acpi/acuuid.h>
> +#include "intel.h"

Since nothing in nfit.h requires intel.h this include should move to
core.c directly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
