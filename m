Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA305208AE352
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 08:44:04 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 32so17471101ota.12
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 08:44:04 -0800 (PST)
MIME-Version: 1.0
References: <155017502147.944049.2893295352368862579.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155017550946.954637.8586902409974005660.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155017550946.954637.8586902409974005660.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 08:43:52 -0800
Message-ID: <CAPcyv4jVK-0F4BrSEb5VBn+Bq_qa4Ex5a=O=FGYdVYccf4hhzg@mail.gmail.com>
Subject: Re: [PATCH v2] nfit/ars: Allow root to busy-poll the ARS state machine
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
Cc: Erwin Tsaur <erwin.tsaur@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 12:32 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> The ARS implementation implements exponential back-off on the poll
> interval to prevent high-frequency access to the DIMM / platform
> interface. Depending on when the ARS completes the poll interval may
> exceed the completion event by minutes. Allow root to reset the timeout
> each time it probes the status. A one-second timeout is still enforced,
> but root can otherwise can control the poll interval.
>
> Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Change since v1: Use mod_delayed_work() instead of queue_delayed_work()
> to modify the timeout for existing work.
>
>  drivers/acpi/nfit/core.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 934be96dc149..b1ab593a808a 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1328,6 +1328,12 @@ static ssize_t scrub_show(struct device *dev,
>                 rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
>                                 acpi_desc->scrub_busy
>                                 && !acpi_desc->cancel ? "+\n" : "\n");
> +               /* Allow an admin to poll the busy state at a higher rate */
> +               if (acpi_desc->scrub_busy && !acpi_desc->cancel
> +                               && capable(CAP_SYS_RAWIO)) {
> +                       acpi_desc->scrub_tmo = 1;
> +                       mod_delayed_work(nfit_wq, &acpi_desc->dwork, HZ);
> +               }

I added support to ndctl to specify a poll-interval to 'ndctl
wait-scrub'. The support highlighted an infinite loop problem as
mod_delayed_work() called in a loop prevented the workqueue from ever
running. A revised patch-set adds a new ARS_POLL flag to ensure that
the workqueue runs at least once after every mod_delayed_work().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
