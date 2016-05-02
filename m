Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4620.austin.hp.com (g2t4620.austin.hp.com [15.73.212.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 534251A1ECF
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 08:05:09 -0700 (PDT)
Subject: Re: acpi_nfit_query_poison() broken on non-ARS systems
References: <5723EFEE.9060200@hpe.com>
 <CAPcyv4ga02=z-MJDQM2pER=cuwtEk6qaLLG5++p9fs-qQuvr8g@mail.gmail.com>
 <5726400D.10700@hpe.com> <57265CA5.8040503@hpe.com>
 <CAPcyv4g6431bUPLq3RpmoukHDeR3-n93FE=p85yhrC+gskYdjw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <57276CA3.2040204@hpe.com>
Date: Mon, 2 May 2016 11:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g6431bUPLq3RpmoukHDeR3-n93FE=p85yhrC+gskYdjw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 5/1/2016 8:33 PM, Dan Williams wrote:

> Found it.  This is one of those brown-paper-bag bugs that tells me I
> need to figure out a way to unit/regression test the interface between
> acpi_nfit_ctl() and acpi_evalaute_dsm().  In this case I injected a
> __wrap_acpi_evaulate_dsm(), but I can't ship it as a new test in
> nfit_test because it relies on an enabled BIOS for all the other
> cases.

Thanks.  I'll give it a try.

-- ljk
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index d0f35e63640b..24ef312fdba3 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -287,8 +288,11 @@ static int acpi_nfit_ctl(struct
> nvdimm_bus_descriptor *nd_desc,
>                                         offset);
>                         rc = -ENXIO;
>                 }
> -       } else
> +       } else {
>                 rc = 0;
> +               if (cmd_rc)
> +                       *cmd_rc = xlat_status(buf, cmd);
> +       }
> 
>   out:
>         ACPI_FREE(out_obj);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
