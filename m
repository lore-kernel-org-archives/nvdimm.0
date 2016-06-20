Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22b.google.com (mail-ob0-x22b.google.com
 [IPv6:2607:f8b0:4003:c01::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C5311A1DF8
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 10:21:45 -0700 (PDT)
Received: by mail-ob0-x22b.google.com with SMTP id mu6so602241obc.3
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 10:21:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160619175920.GA12470@xo-6d-61-c0.localdomain>
References: <5cff32b5-7849-4e9d-0ba8-1f12e21814a9@gmail.com>
 <790a33bd-98e9-89c8-6667-e135ada69f80@gmail.com>
 <20160619175920.GA12470@xo-6d-61-c0.localdomain>
Date: Mon, 20 Jun 2016 10:21:15 -0700
Message-ID: <CAPcyv4i3tDov71YbfumBHHjitG7dgcz0+V6rDzGxPfAJX+Sg-w@mail.gmail.com>
Subject: Re: [PATCH] nfit: add Microsoft NVDIMM DSM command set to white list
From: Dan Williams <dan.j.williams@intel.com>
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
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stuart Hayes <stuart.w.hayes@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 19, 2016 at 10:59 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >Add the Microsoft _DSM command set to the white list of NVDIMM command sets.
>> >
>> >This command set is documented at https://msdn.microsoft.com/library/windows/hardware/mt604741.
>> >
>> >Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
>> >---
>> > drivers/acpi/nfit.c        | 9 ++++++---
>> > drivers/acpi/nfit.h        | 4 ++++
>> > include/uapi/linux/ndctl.h | 1 +
>> > 3 files changed, 11 insertions(+), 3 deletions(-)
>> >
>> >diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> >index 2215fc8..48fc575 100644
>> >--- a/drivers/acpi/nfit.c
>> >+++ b/drivers/acpi/nfit.c
>> >@@ -1130,11 +1130,11 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>> >     }
>> >
>> >     /*
>> >-     * Until standardization materializes we need to consider up to 3
>> >+     * Until standardization materializes we need to consider several
>> >      * different command sets.  Note, that checking for function0 (bit0)
>> >      * tells us if any commands are reachable through this uuid.
>> >      */
>> >-    for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
>> >+    for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
>> >         if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
>
> Time to introduce NVDIMM_FAMILY_MAX?

I hope not.  This is the last of what can be considered "first
generation" DSM support, everything else should wait for
standardization.  I.e. no ongoing need to keep changing this line.

>
>> >@@ -1150,7 +1150,9 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>> >         dsm_mask = 0x1fe;
>> >         if (disable_vendor_specific)
>> >             dsm_mask &= ~(1 << 8);
>> >-    } else {
>> >+    } else if (nfit_mem->family == NVDIMM_FAMILY_MSFT)
>> >+        dsm_mask = 0xffffffff;
>> >+    else {
>> >         dev_err(dev, "unknown dimm command family\n");
>> >         nfit_mem->family = -1;
>> >         return force_enable_dimms ? 0 : -ENODEV;
>
> I'd really use {} around the if (), so that it is clear what the else belongs to.

Sure, I can fix this up.  Stuart, no need to re-send.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
