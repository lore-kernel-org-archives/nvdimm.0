Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 568B5225F31FA
 for <linux-nvdimm@lists.01.org>; Sun,  1 Apr 2018 09:34:15 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id 23-v6so13689393otj.0
 for <linux-nvdimm@lists.01.org>; Sun, 01 Apr 2018 09:34:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152245757217.54599.588915759449280143.stgit@djiang5-desk3.ch.intel.com>
References: <152245757217.54599.588915759449280143.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 1 Apr 2018 09:34:13 -0700
Message-ID: <CAPcyv4igJu4G8+d6e8cPBicQa5GqNW9SodUQQSb2eUhweTNr0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] acpi/libnvdimm: rework ARS query and removing
 blocking on timeout at init
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 30, 2018 at 5:52 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> On initialization we are going to set bit 1 of Start ARS DSM flag. This
> allows us to retrieve the data from the previous scrub without starting a
> scrub. This is to obtain any badblocks on all the DIMMs that does not have
> scrubbing started by the BIOS. Previously we block surfacing the regions
> until ARS is completed on all regions. That has been removed and we will
> now do scrubbing in the background with a delayed workqueue. The delayed
> workqueue will be scheduled starting at 1 second delay and doubled every
> time it has to be rescheduled up to 30 minutes delay. The reschedule will
> no longer be timing out.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/core.c |  263 ++++++++++++++++++++++------------------------
>  drivers/acpi/nfit/nfit.h |   14 ++
>  2 files changed, 135 insertions(+), 142 deletions(-)
>

With the change in policy to never wait for the initial scrub and
perform quick scrubs at initialization time I think this rework needs
to include the removal of acpi_desc->init_complete. Also, to make the
request based scrubbing easier to understand I think
acpi_desc->ars_start_flags needs to be killed in favor of a
per-nfit_spa request flags to trigger "return previous data" scrubs.
Once we have request flags per-nfit_spa I think we can also reduce the
number of scrub states from 6. Given the short time we have to land
this for 4.17 I'll take a stab at this further rework, but this patch
has definitely helped identify the further cleanups that are possible
from where I had things originally.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
