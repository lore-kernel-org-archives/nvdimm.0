Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60B7E1A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 10:12:46 -0700 (PDT)
Date: Tue, 19 Jul 2016 11:11:53 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi_check_dsm() vs zero functions
 implemented
Message-ID: <20160719171153.GA121461@tevye.fc.hp.com>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-nvdimm@lists.01.org, Marvin Spinhirne <spin@hpe.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 24, 2016 at 10:44:25AM -0700, Dan Williams wrote:
> QEMU 2.6 implements nascent support for nvdimm DSMs. Depending on
> configuration it may only implement the function0 dsm to indicate that
> no other DSMs are available. Commit 31eca76ba2fc "nfit, libnvdimm:
> limited/whitelisted dimm command marshaling mechanism" breaks QEMU, but
> QEMU is spec compliant.  Per the spec the way to indicate that no
> functions are supported is:
> 
>     If Function Index is zero, the return is a buffer containing one bit
>     for each function index, starting with zero. Bit 0 indicates whether
>     there is support for any functions other than function 0 for the
>     specified UUID and Revision ID. If set to zero, no functions are
>     supported (other than function zero) for the specified UUID and
>     Revision ID.


Dan,

This breaks calling DSM on HPE platforms and is a regression.

E-mail context can be found at:

	https://lists.01.org/pipermail/linux-nvdimm/2016-June/006099.html

The problem with this change is that it assumes that ACPI returning an
object means that the UUID is supported on that platform.

However, looking at ACPI v 6.1 section 9.1.1, the example for 
evaluating a _DSM shows that if the UUID is not supported at all,
a zeroed out buffer of length 1 is returned:

	//
	// If not one of the UUIDs we recognize, then return a buffer
	// with bit 0 set to 0 indicating no functions supported.
	//
	return(Buffer(){0})

HPE firmware has been following this practice for a long long time.
I suspect other manufacturer's firmware do so as well.

The problem is that this creates an ambiguity and the linux code
is no longer differentiating the case where the DSM/UUID is
supported but only implements function 0 (the QEMU case you're
trying to accommodate) and the case that the DSM/UUID is not
supported at all.

The result is that the code in acpi_nfit_add_dimm:

      for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
-             if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
+             if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 0))
                      break;


always matches NVDIMM_FAMILY_INTEL.  This is either because its
is an Intel nvdimm, or because the unsupported UUID returns back
a zeroed out buffer of length 1.


As nfit_mem->family always equals NVDIMM_FAMILY_INTEL, no subsequent
DSM call will succeed for NVDIMM_FAMILY_HPE1 or any other
family.

I don't have a fix as of yet, but wanted to make you aware of
the problem.




> 
> Update the nfit driver to determine the family (interface UUID) without
> requiring the implementation to define any other functions, i.e.
> short-circuit acpi_check_dsm() to succeed per the spec.  The nfit driver
> appears to be the only user passing funcs==0 to acpi_check_dsm(), so
> this behavior change of the common routine should be limited to the
> probing done by the nfit driver.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
> Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism")
> Reported-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Tested-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit.c  |    6 +++---
>  drivers/acpi/utils.c |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 2215fc847fa9..32579a7b71d5 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1131,11 +1131,11 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  
>  	/*
>  	 * Until standardization materializes we need to consider up to 3
> -	 * different command sets.  Note, that checking for function0 (bit0)
> -	 * tells us if any commands are reachable through this uuid.
> +	 * different command sets.  Note, that checking for zero functions
> +	 * tells us if any commands might be reachable through this uuid.
>  	 */
>  	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
> -		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
> +		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 0))
>  			break;


At this point i will always == NVDIMM_FAMILY_INTEL.


>  
>  	/* limit the supported commands to those that are publicly documented */
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 22c09952e177..b4de130f2d57 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -680,9 +680,6 @@ bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs)
>  	u64 mask = 0;
>  	union acpi_object *obj;
>  
> -	if (funcs == 0)
> -		return false;
> -
>  	obj = acpi_evaluate_dsm(handle, uuid, rev, 0, NULL);
>  	if (!obj)
>  		return false;
> @@ -695,6 +692,9 @@ bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs)
>  			mask |= (((u64)obj->buffer.pointer[i]) << (i * 8));
>  	ACPI_FREE(obj);


Unsupported UUID will get an object.  A zeroed out buffer of length 1.
So, acpi_check_dsm is saying supported when it is not.


>  
> +	if (funcs == 0)
> +		return true;
> +
>  	/*
>  	 * Bit 0 indicates whether there's support for any functions other than
>  	 * function 0 for the specified UUID and revision.



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
