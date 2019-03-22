From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 1/4] libndctl: add support for
 NVDIMM_FAMILY_HYPERV's _DSM Function 1
Date: Fri, 22 Mar 2019 01:11:19 +0000
Message-ID: <PU1P153MB0169C507CF47A6BFD63F1E0DBF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB016988DC99DD57082BEC6006BF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <b883122b7bbbe46d4895136ebac7305defb03e91.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <b883122b7bbbe46d4895136ebac7305defb03e91.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Wednesday, March 20, 2019 5:23 PM
> ...
> Also on a more general note, the patches in this series don't appear to
> be correctly threaded. Normally, patch emails in a series are replies to
> the first patch (either 1/N or the cover letter), and this allows for
> easier review as all related emails can be found in a single top-level
> thread. It would be nice if you can fix this for the future - git send-
> email should do this correctly automatically, if you use it for sending
> the patches.

OK, I'll use git-send-email. Previously due to some SMTP server issue I 
couldn't use that, but now I can.
 
> 
> On Wed, 2019-02-20 at 05:10 +0000, Dexuan Cui wrote:
> > This patch retrieves the health info by Hyper-V _DSM method Function 1:
> We should never use "This patch.." in a commit message. See 4.c in [1].

Thanks for sharing the good read! I'll update my changelog accordingly.

> > diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
> > new file mode 100644
> For new files, use the SPDX license identifiers, for an example, see:

Ok, will do.

> > +#include <stdlib.h>
> > +#include <limits.h>
> > +#include <util/bitmap.h>
> > +#include <util/log.h>
> > +#include <ndctl/libndctl.h>
> > +#include "private.h"
> > +#include "hyperv.h"
> > +
> > +#define CMD_HYPERV(_c) ((_c)->hyperv)
> 
> I'm not sure this macro improves readability, in fact I think it rather
> detracts from it in many cases - see further below.
> Additionally, no need for the preceeding underscore in the macro
> arguments - the rest of the code base doesn't do this, and I'm not sure
> what value it provides.

I agree. Will change it.
Previously I tried to follow the same style in 
ndctl/lib/hpe1.c and ndctl/lib/msft.c.
 
> > +	size = sizeof(*cmd) + sizeof(struct nd_pkg_hyperv);
> > + ...
> > +	hyperv = CMD_HYPERV(cmd);
> > +	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
> > +	hyperv->gen.nd_command = ND_HYPERV_CMD_GET_HEALTH_INFO;
> > +	hyperv->gen.nd_fw_size = 0;
> > +	hyperv->gen.nd_size_in = offsetof(struct nd_hyperv_smart, status);
> > +	hyperv->gen.nd_size_out = sizeof(hyperv->u.smart);
> > +	hyperv->u.smart.status = 0;
> 
> calloc() zeroes the newly allocated memory - no need to set any of the
> fields in the struct to '0' manually.

Will fix it.

> > +	cmd->firmware_status = &hyperv->u.smart.status;
> > +
> > +	return cmd;
> > +}
> > +
> > +static int hyperv_smart_valid(struct ndctl_cmd *cmd)
> > +{
> > +	if (cmd->type != ND_CMD_CALL ||
> > +	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
> > +	    CMD_HYPERV(cmd)->gen.nd_family != NVDIMM_FAMILY_HYPERV
> ||
> > +	    CMD_HYPERV(cmd)->gen.nd_command !=
> ND_HYPERV_CMD_GET_HEALTH_INFO ||
> 
> I feel in these cases, cmd->hyperv->stuff is /much/ more readable than
> CMD_HYPERV(cmd)->stuff - and shorter as well as easier to type :)

Will fix it. 
 
> > --- /dev/null
> > +++ b/ndctl/lib/hyperv.h
> > @@ -0,0 +1,51 @@
> > +/*
> > + * Copyright (c) 2019, Microsoft Corporation.
> > ...
> 
> Same comment about SPDX License format as above.

Will fix it.

> > +enum {
> > +	ND_HYPERV_CMD_QUERY = 0,
> 
> It sounds like the intention for this function index 0 was to function
> as a supported DSM mask, but the spec says it just returns a static
> value. Nonetheless, should we not include some "_cmd_is_supported"
> helpers, and test them before submitting the smart command in this patch
> for example?

Hyper-V guys told me that 0x1F is always supported, and we do 
check if a cmd is supported or not in the kernel in
acpi_nfit_add_dimm() and acpi_nfit_ctl(). In case a cmd is not supported,
acpi_nfit_ctl() returns -ENOTTY. So IMO we don't bother to check it in ndctl.
 
> Also the name of this enum field can be a bit ambiguous - query /what/?
> (In other DSM families, there are functions to query ARS status,
> firmware update status, etc.). It might be better to name it something
> like "ND_HYPERV_CMD_QUERY_SUPPORTED_FUNCTIONS"

Will fix it.

> > +
> > +	/* non-root commands */
> > +	ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
> > +};
> > +
> > +/*
> > + * This is actually Function 1's data,
> > + * This is the closest I can find to match the "smart".
> > + * Hyper-V _DSM methods don't have a smart function.
> > + */
> > +struct nd_hyperv_smart_data {
> > +	__u32	health;
> > +} __attribute__((packed));
> 
> I'm not sure I fully understand the comment above. Generally speaking,
> we should avoid comments in the first person - i.e. instead of "This is
> the closest thing I found..", it should simply be "X is the closest
> thing to Y".
> 
> But I think you were trying to say:
> 
> /*
>  * This corresponds to 'function 1' (Get Health Information) in the
>  * HYPERV DSM spec referenced above
>  */

I copid the sentences from ndctl/lib/msft.h. :-)
Will fix it. 

Thanks,
-- Dexuan
