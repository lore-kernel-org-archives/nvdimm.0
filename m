Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4618.austin.hp.com (g2t4618.austin.hp.com [15.73.212.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23A581A1F89
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 16:36:17 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: acpi_nfit_query_poison() broken on non-ARS systems
Message-ID: <5723EFEE.9060200@hpe.com>
Date: Fri, 29 Apr 2016 19:36:14 -0400
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

I tested Vishal's original ARS patches and they worked correctly on my test
system, which doesn't support ARS.  By worked correctly, I mean that they
properly looked at the status of the Query ARS Capabilities function and saw
that it indicated that the function is not supported.  The original code
skipped the rest of the ARS processing.

The code I tested has been re-worked a number of times and now it no longer
looks at the status of the Query function.  It assumes that if the DSM worked
at all, it must be ok and happily uses fields that is shouldn't be looking at.

If you look here:

> static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
>                 struct nfit_spa *nfit_spa)
> {
>         struct acpi_nfit_system_address *spa = nfit_spa->spa;
>         int rc;
> 
>         if (!nfit_spa->max_ars) {

On a platform that doesn't support ARS, max_ars will always be zero
so you'll keep executing this code when it seems like you're trying
to avoid that.

>                 struct nd_cmd_ars_cap ars_cap;
> 
>                 memset(&ars_cap, 0, sizeof(ars_cap));
>                 rc = ars_get_cap(acpi_desc, &ars_cap, nfit_spa);
>                 if (rc < 0)
>                         return rc;

The call succeeds so this return isn't taken, but then the code assumes
everything is good.  It should check ars_cap.status so see if the function
is supported or if there was an error and return something appropriate.
In previous version of the code, that's what acpi_nfit_find_poison() did.
Instead, this function continues, using data that's not right and making
more calls that also aren't supported.

>                 nfit_spa->max_ars = ars_cap.max_ars_out;
>                 nfit_spa->clear_err_unit = ars_cap.clear_err_unit;

Since we don't bail out, the above values are zero but not actually checked
by subsequent users.

>                 /* check that the supported scrub types match the spa type */
>                 if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE &&
>                                 ((ars_cap.status >> 16) & ND_ARS_VOLATILE) == 0)
>                         return -ENOTTY;
>                 else if (nfit_spa_type(spa) == NFIT_SPA_PM &&
>                                 ((ars_cap.status >> 16) & ND_ARS_PERSISTENT) == 0)
>                         return -ENOTTY;
>         }
> 
>         if (ars_status_alloc(acpi_desc, nfit_spa->max_ars))
>                 return -ENOMEM;
> 
>         rc = ars_get_status(acpi_desc);
>         if (rc < 0 && rc != -ENOSPC)
>                 return rc;
> 
>         if (ars_status_process_records(acpi_desc->nvdimm_bus,
>                                 acpi_desc->ars_status))
>                 return -ENOMEM;
> 
>         return 0;
> }

I don't know if you want to change how this function works or change how
ars_get_cap works but something needs to change.  You actually do check the
status in xlat_status() if the call was initiated from user space but you don't
check when it's initiated from within the kernel.

For reference, below is the dmesg output from my system running the latest
upstream kernel.

-- ljk

[   36.807155] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_cap input length: 16
[   36.807159] ars_cap00000000: 80000000 00000004 00000000 00000002
................
[   36.807336] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_cap output length: 16
[   36.807338] ars_cap00000000: 00000001 00000000 00000000 00000000
................
[   36.807427] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start input length: 24
[   36.807430] ars_start00000000: 80000000 00000004 00000000 00000002
................
[   36.807431] ars_start00000010: 00000002 00000000                    ........
[   36.807513] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start output length: 4
[   36.807515] ars_start00000000: 00000001                             ....
[   36.807516] nfit ACPI0012:00: acpi_nfit_ctl:bus output object underflow cmd:
ars_start field: 1
[   36.807518] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start input length: 24
[   36.807520] ars_start00000000: 80000000 00000006 00000000 00000002
................
[   36.807521] ars_start00000010: 00000002 00000000                    ........
[   36.807593] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start output length: 4
[   36.807594] ars_start00000000: 00000001                             ....
[   36.807596] nfit ACPI0012:00: acpi_nfit_ctl:bus output object underflow cmd:
ars_start field: 1
[   36.807597] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start input length: 24
[   36.807599] ars_start00000000: 80000000 0000000c 00000000 00000002
................
[   36.807600] ars_start00000010: 00000002 00000000                    ........
[   36.807670] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start output length: 4
[   36.807671] ars_start00000000: 00000001                             ....
[   36.807673] nfit ACPI0012:00: acpi_nfit_ctl:bus output object underflow cmd:
ars_start field: 1
[   36.807674] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start input length: 24
[   36.807676] ars_start00000000: 80000000 0000000e 00000000 00000002
................
[   36.807677] ars_start00000010: 00000002 00000000                    ........
[   36.807747] nfit ACPI0012:00: acpi_nfit_ctl:bus cmd: ars_start output length: 4
[   36.807748] ars_start00000000: 00000001                             ....
[   36.807749] nfit ACPI0012:00: acpi_nfit_ctl:bus output object underflow cmd:
ars_start field: 1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
