Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD297202C8083
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 13:36:42 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] libnvdimm/security: Introduce a 'frozen' attribute
References: <156583201347.2815870.4687949334637966672.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156583201871.2815870.6795890422719782588.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 16 Aug 2019 16:34:53 -0400
In-Reply-To: <156583201871.2815870.6795890422719782588.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Wed, 14 Aug 2019 18:20:18 -0700")
Message-ID: <x494l2gdf2q.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> In the process of debugging a system with an NVDIMM that was failing to
> unlock it was found that the kernel is reporting 'locked' while the DIMM
> security interface is 'frozen'. Unfortunately the security state is
> tracked internally as an enum which prevents it from communicating the
> difference between 'locked' and 'locked + frozen'. It follows that the
> enum also prevents the kernel from communicating 'unlocked + frozen'
> which would be useful for debugging why security operations like 'change
> passphrase' are disabled.
>
> Ditch the security state enum for a set of flags and introduce a new
> sysfs attribute explicitly for the 'frozen' state. The regression risk
> is low because the 'frozen' state was already blocked behind the
> 'locked' state, but will need to revisit if there were cases where
> applications need 'frozen' to show up in the primary 'security'
> attribute. The expectation is that communicating 'frozen' is mostly a
> helper for debug and status monitoring.
>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/intel.c        |   65 ++++++++++++++-----------
>  drivers/nvdimm/bus.c             |    2 -
>  drivers/nvdimm/dimm_devs.c       |   59 +++++++++++++----------
>  drivers/nvdimm/nd-core.h         |   21 ++++++--
>  drivers/nvdimm/security.c        |   99 ++++++++++++++++++--------------------
>  include/linux/libnvdimm.h        |    9 ++-
>  tools/testing/nvdimm/dimm_devs.c |   19 ++-----
>  7 files changed, 146 insertions(+), 128 deletions(-)
>
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index cddd0fcf622c..2c51ca4155dc 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -7,10 +7,11 @@
>  #include "intel.h"
>  #include "nfit.h"
>  
> -static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm,
> +static unsigned long intel_security_flags(struct nvdimm *nvdimm,
>  		enum nvdimm_passphrase_type ptype)
>  {
>  	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +	unsigned long security_flags = 0;
>  	struct {
>  		struct nd_cmd_pkg pkg;
>  		struct nd_intel_get_security_state cmd;
> @@ -27,46 +28,54 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm,
>  	int rc;
>  
>  	if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask))
> -		return -ENXIO;
> +		return 0;
>  
>  	/*
>  	 * Short circuit the state retrieval while we are doing overwrite.
>  	 * The DSM spec states that the security state is indeterminate
>  	 * until the overwrite DSM completes.
>  	 */
> -	if (nvdimm_in_overwrite(nvdimm) && ptype == NVDIMM_USER)
> -		return NVDIMM_SECURITY_OVERWRITE;
> +	if (nvdimm_in_overwrite(nvdimm) && ptype == NVDIMM_USER) {
> +		set_bit(NVDIMM_SECURITY_OVERWRITE, &security_flags);
> +		return security_flags;
> +	}

Why not just
	return BIT(NVDIMM_SECURITY_OVERWRITE);
?


>  	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> -	if (rc < 0)
> -		return rc;
> -	if (nd_cmd.cmd.status)
> -		return -EIO;
> +	if (rc < 0 || nd_cmd.cmd.status) {
> +		pr_err("%s: security state retrieval failed (%d:%#x)\n",
> +				nvdimm_name(nvdimm), rc, nd_cmd.cmd.status);
> +		return 0;
> +	}
>  
>  	/* check and see if security is enabled and locked */
>  	if (ptype == NVDIMM_MASTER) {
>  		if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_ENABLED)
> -			return NVDIMM_SECURITY_UNLOCKED;
> -		else if (nd_cmd.cmd.extended_state &
> -				ND_INTEL_SEC_ESTATE_PLIMIT)
> -			return NVDIMM_SECURITY_FROZEN;
> -	} else {
> -		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
> -			return -ENXIO;
> -		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
> -			if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
> -				return NVDIMM_SECURITY_LOCKED;
> -			else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN
> -					|| nd_cmd.cmd.state &
> -					ND_INTEL_SEC_STATE_PLIMIT)
> -				return NVDIMM_SECURITY_FROZEN;
> -			else
> -				return NVDIMM_SECURITY_UNLOCKED;
> -		}
> +			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);
> +		else
> +			set_bit(NVDIMM_SECURITY_DISABLED, &security_flags);
> +		if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_PLIMIT)
> +			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
> +		return security_flags;
>  	}
>  
> -	/* this should cover master security disabled as well */
> -	return NVDIMM_SECURITY_DISABLED;
> +

Extra space.

> +	if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
> +		return 0;
> +
> +	if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
> +		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN)
> +			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
> +		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
> +			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);

Change to the following?
+		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN ||
+		    nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
+			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);

[...]
> +
> +		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
> +			set_bit(NVDIMM_SECURITY_LOCKED, &security_flags);
> +		else
> +			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);

I was going to comment on 2 bits being overkill, but you addressed that
in the enum.  :)

The rest looks good.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
