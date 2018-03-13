Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8859224CCC1D
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 09:09:47 -0700 (PDT)
Date: Tue, 13 Mar 2018 17:16:06 +0100
From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 5/5] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20180313171606.4fef3ab6@endymion>
In-Reply-To: <20180313155956.zapcx3l5bb72w4yz@agluck-desk>
References: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
 <20180312182430.10335-1-tony.luck@intel.com>
 <20180312182430.10335-6-tony.luck@intel.com>
 <20180313105901.0f18d027@endymion>
 <20180313155956.zapcx3l5bb72w4yz@agluck-desk>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 13 Mar 2018 08:59:56 -0700, Luck, Tony wrote:
> On Tue, Mar 13, 2018 at 10:59:01AM +0100, Jean Delvare wrote:
> > > +	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu Mb (%u pages)\n",  
> > 
> > I did not notice on previous review, but I think "b" in general means
> > bit not byte, so "MB" would be better.  
> 
> Heh! We've been cut & pasting that line from EDAC drivers since the i7core_edac.c
> I think the origin is in 2.6.35. So you are far from the only person to not
> notice it in a review :-)

Hehe :-D Then I guess a patch fixing all drivers are once is in order,
after your patch set it accepted.

> > > +		 imc->mc, chan, dimmno, size >> 20, dimm->nr_pages);
> > > +
> > > +	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
> > > +		 imc->src_id, imc->lmc, chan, dimmno);
> > > +
> > > +	return 1;
> > > +}  
> > 
> > Now this function always return 1, that doesn't make a lot of sense?  
> 
> I could fix the return to be:
> 
> 
> diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
> index 84c18bb1e0cd..1a66e145c0bd 100644
> --- a/drivers/edac/skx_edac.c
> +++ b/drivers/edac/skx_edac.c
> @@ -429,7 +429,7 @@ static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
>  	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
>  		 imc->src_id, imc->lmc, chan, dimmno);
>  
> -	return 1;
> +	return (size == 0 || size == ~0ull) ? 0 : 1;
>  }

Yes, I think it makes sense, thanks.

-- 
Jean Delvare
SUSE L3 Support
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
