Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBCF720985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:04:23 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id s198-v6so65096801oih.11
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142851287.27297.11888372049935247966.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142851287.27297.11888372049935247966.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:04:20 -0700
Message-ID: <CAPcyv4hEOnyV-uJvsffW7k7r2GRm3TTQj6ew_M3L1ycxDAP-qw@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] nfit: add support for Intel DSM 1.7 commands
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

On Thu, Jul 12, 2018 at 1:48 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Add command definition for security commands defined in Intel DSM
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
>  drivers/acpi/nfit/core.c  |   28 ++++++++++++++++++-
>  drivers/acpi/nfit/intel.h |   67 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/nfit.h  |   17 +++++++++++
>  drivers/nvdimm/bus.c      |    2 +
>  include/linux/libnvdimm.h |    2 +
>  5 files changed, 112 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/acpi/nfit/intel.h

Looks good to me,

You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
