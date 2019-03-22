From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 2/4] libndctl: NVDIMM_FAMILY_HYPERV: add
 .smart_get_shutdown_count (Function 2)
Date: Fri, 22 Mar 2019 01:32:47 +0000
Message-ID: <PU1P153MB01695CC17BE4C24CD1227255BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01698DBBE02A896DFB8FB4EBBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <301702909683ab34e65609696e2e60f98eadc15d.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <301702909683ab34e65609696e2e60f98eadc15d.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
> Sent: Wednesday, March 20, 2019 6:34 PM
> > ...
> > My feeling is that it's not very good to directly call ndctl_cmd_submit(),
> > but by doing this we don't need to make any change to the common code,
> and
> > I'm unsure if it's good to change the common code just for Hyper-V.
> 
> I thought about this, and this approach seems reasonable to me. I agree
> that there is not precedent for submitting a command from the various
> family libraries, but I think the way dimm-ops are structured, this
> seems warranted. The way I see it is a dimm op means "get X information
> for this family", and however it needs to be obtained is just a detail
> specific to that DSM family. For intel it happens to be in the smart
> information, but if it happens to be a separate DSM, that is also fine.

Thanks! I'm gald you think this is fine. :-)

> I do think this commentary in the changelog can be reworded. Consider
> changing the first-person narrative to a more 'informational' or
> 'imperative' one. For example: "The 'smart_get_shutdown_count' dimm-op
> is expected to return a shutdown count, but for the HYPERV family, this
> is only available from a separate DSM. Perform a command submission in
> the 'hyperv_cmd_smart_get_shutdown_count' dimm op to retrieve this, so
> that a smart health listing can display this information"

Will fix it.
 
> Apart from the commit message comments in the previous patch, also
> consider wrapping commit messages to a 72 column width [1].

Thanks for another good read! I'll fix it.

> > -static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm
> *dimm)
> > +static struct ndctl_cmd *hyperv_dimm_cmd_new_cmd(struct ndctl_dimm
> *dimm,
> > +						 unsigned int command)
> 
> The 'new' in the function name is a bit confusing, as 'new' functions
> are also used for cmd allocation. I'd suggest following the intel.c
> convention and calling it 'alloc_hyperv_cmd'.

Will fix it.
 
> Maybe consider calling it this right from the start in patch 1, and also
> having the wrapper for the new smart command in patch 1 - this way there
> is less unrelated thrash in this patch, and makes it easier to review.

Ok. Will do.
 
> > -static int hyperv_smart_valid(struct ndctl_cmd *cmd)
> > +static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm
> *dimm)
> Similar comment as above. In general this sort of refactoring can be
> done in two ways:
> 
>    1. If you know the end result at the start, just create the generic
>    helpers then, so future patches don't have the thrash.
> 
>    2. If the changes are in prior code, and if the refactoring is
>    extensive, split it out into its own functionally equivalent patch,
>    so that the meat of *this* change is not cluttered by unrelated
>    refactoring.

Will fix it.
 
> >  static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
> >  {
> >  	return CMD_HYPERV_STATUS(cmd) == 0 ? 0 : -EINVAL;
> >  }
> >
> > +static int hyperv_get_shutdown_count(struct ndctl_cmd *cmd,
> > +				     unsigned int *count)
> 
> No need to split this line, it fits within 80 columns.

Ok. Will fix it.

> > +{
> > +	unsigned int command = ND_HYPERV_CMD_GET_SHUTDOWN_INFO;
> > +	struct ndctl_cmd *cmd_get_shutdown_info;
> > +	int rc;
> > +
> > +	cmd_get_shutdown_info = hyperv_dimm_cmd_new_cmd(cmd->dimm,
> command);
> > +	if (!cmd_get_shutdown_info)
> > +		return -EINVAL;
> > +
> > +	if (ndctl_cmd_submit(cmd_get_shutdown_info) < 0 ||
> 
> The return value from ndctl_cmd_submit() only indicates that the kernel
> was successfully able to send the DSM to the platform firmware. It does
> *not* capture any failures indicated by the platform in the 'status'
> field of the cmd struct. We should be ensuring that was also successful
> by calling the hyperv_cmd_xlat_firmware_status for the cmd.
> Alternatively, instead of the ndctl_cmd_submit() API, you could also use
> the newly added (in ndctl-64) ndctl_cmd_submit_xlat() API, which calls
> the dimm-op for 'xlat_firmware_status' if present to do a status
> translation, and present it in the return value.

Will fix it.

> > +static unsigned int hyperv_cmd_smart_get_shutdown_count(struct
> ndctl_cmd *cmd)
> > +{
> > +	unsigned int count;
> > +
> > +	return hyperv_get_shutdown_count(cmd, &count) == 0 ? count :
> UINT_MAX;
> 
> I'd prefer the long form rc = func(); if (rc) .. here.
> Also, shouldn't we set errno appropriately in the UINT_MAX case?

Will fix it.
 
Thanks,
-- Dexuan
