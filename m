Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29DAB1A1E89
 for <linux-nvdimm@lists.01.org>; Sun,  1 May 2016 17:33:33 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id x19so174019118oix.2
 for <linux-nvdimm@lists.01.org>; Sun, 01 May 2016 17:33:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57265CA5.8040503@hpe.com>
References: <5723EFEE.9060200@hpe.com>
 <CAPcyv4ga02=z-MJDQM2pER=cuwtEk6qaLLG5++p9fs-qQuvr8g@mail.gmail.com>
 <5726400D.10700@hpe.com> <57265CA5.8040503@hpe.com>
Date: Sun, 1 May 2016 17:33:32 -0700
Message-ID: <CAPcyv4g6431bUPLq3RpmoukHDeR3-n93FE=p85yhrC+gskYdjw@mail.gmail.com>
Subject: Re: acpi_nfit_query_poison() broken on non-ARS systems
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, May 1, 2016 at 12:44 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 5/1/2016 1:42 PM, Linda Knippers wrote:
> <snip>
>>>
>>> Can you add some debug tracing to xlat_status()?  Something is not lining up.
>
> I put a printk at the top of xlat_status() as well as in each case statement.
>>
>> xlat_status() is not called from acpi_nfit_query_poison(), which is called at
>> boot time.  Not sure if we're getting there from acpi_nfit_scrub() or
>> acpi_nfit_async_scrub().
>
> Ok, it actually is being called, but only for the start command.  See attached.
>
> BTW, this is with your rewrite of Jerry's patches but I saw the same
> behavior before I applied them as that's what the previous dmesg output
> was from.
>
> One thing you'll notice in this new dmesg output is that unlike before,
> the acpi_nfit_ctl() function prints the DSM number, not the DSM name,
> when displaying the input. It prints the DSM name when displaying the
> output.
>

Found it.  This is one of those brown-paper-bag bugs that tells me I
need to figure out a way to unit/regression test the interface between
acpi_nfit_ctl() and acpi_evalaute_dsm().  In this case I injected a
__wrap_acpi_evaulate_dsm(), but I can't ship it as a new test in
nfit_test because it relies on an enabled BIOS for all the other
cases.

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e63640b..24ef312fdba3 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -287,8 +288,11 @@ static int acpi_nfit_ctl(struct
nvdimm_bus_descriptor *nd_desc,
                                        offset);
                        rc = -ENXIO;
                }
-       } else
+       } else {
                rc = 0;
+               if (cmd_rc)
+                       *cmd_rc = xlat_status(buf, cmd);
+       }

  out:
        ACPI_FREE(out_obj);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
