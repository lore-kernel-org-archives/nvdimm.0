From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v4] nvdimm, btt: fix LBA masking during 'free list'
 population
Date: Wed, 27 Feb 2019 21:06:15 +0000
Message-ID: <PU1P153MB0169CE8A3E100756A18CBC5ABF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
 <20190226231331.8730-1-vishal.l.verma@intel.com>
 <PU1P153MB01693156DE97BEA6BF300ACBBF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <34fc552cb992d62e14b4edda8edc1534b32277b4.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <34fc552cb992d62e14b4edda8edc1534b32277b4.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
To: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Pedro d'Aquino Filocre F S Barbuda <pbarbuda-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Wednesday, February 27, 2019 10:13 AM
> ...
> > I suppose the new line should not be added, and the line
> >   		if (ent_e_flag(log_new.old_map)) {
> > should be changed to
> >   		if (ent_e_flag(log_new.old_map) && !
> ent_z_flag(log_new.old_map)) {
> > ?
> >
> Ah yes good catch, I broke my own rule, in that freelist[i].block should
> not have flag bits since it is used as is. The freelist has a separate
> has_err field to allow for error clearing, and we should be setting
> that.
> 
> Does the following incremental patch fix it? Let me know and I can send
> a new version including it.

Yes, the patch works for me. Thank you!

But, should we really set the has_err field? Here the enry has both
the zere/error flags set. As I understand, this is not an error, because
the UEFI spec says "... both Error and Zero are set to indicate a map entry
in its normal, non-error state".
 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 294c48e45e74..1e7c1a66cef8 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -569,7 +569,7 @@ static int btt_freelist_init(struct arena_info
> *arena)
>  		 * the BTT read-only
>  		 */
>  		if (ent_e_flag(log_new.old_map)) {
> -			set_e_flag(arena->freelist[i].block);
> +			arena->freelist[i].has_err = 1;
>  			ret = arena_clear_freelist_error(arena, i);
>  			if (ret)
>  				dev_err_ratelimited(to_dev(arena),


Thanks,
-- Dexuan
