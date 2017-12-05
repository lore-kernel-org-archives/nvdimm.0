Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3C5E2218E927
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 11:59:06 -0800 (PST)
Date: Tue, 5 Dec 2017 12:03:37 -0800
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH 4/4] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20171205200336.tbx7oypjuca3g6vn@agluck-desk>
References: <cover.1512070562.git.tony.luck@intel.com>
 <da4c989314e82ec29195804ba5349ac3136f74c0.1512070562.git.tony.luck@intel.com>
 <20171205105451.ob23asixm726hysb@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171205105451.ob23asixm726hysb@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 11:54:51AM +0100, Borislav Petkov wrote:
> On Thu, Nov 30, 2017 at 12:40:42PM -0800, Tony Luck wrote:
> >  config EDAC_SKX
> >  	tristate "Intel Skylake server Integrated MC"
> >  	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG
> > +	select DMI
> > +	select ACPI_NFIT
> 
> Hmm, that ACPI_NFIT depends on a bunch of stuff and enabling EDAC_SKX
> would pull in all that. Should we make this a user choice instead?
> 
> I mean, there could be boxes which don't have nvdimms so all that code
> would be dead weight there...

I could. But what happens when someone ends up on a system with
an edac driver configured without ACPI_NFIT that does have NVDIMMs?

I can make a stub version of nfit_get_smbios_id() that returns some
error code ... and have the EDAC driver report size==0.

Would that be OK?


> <---- newline here.
> 
> > +	size = dmi_memdev_size(smbios_handle);
> > +	if (size == ~0ul) {
> > +		skx_printk(KERN_ERR, "Can't find size for NVDIMM ADR=%x/SMBIOS=%x\n",
> > +			   dev_handle, smbios_handle);
> > +		return 0;
> > +	}
> 
> Ditto.
> 
> > +	edac_dbg(0, "mc#%d: channel %d, dimm %d, %lld Mb (%lld pages)\n",
> > +		 imc->mc, chan, dimmno, size >> 20, size >> PAGE_SHIFT);
> > +
> > +	dimm->nr_pages = size >> PAGE_SHIFT;
> > +	dimm->grain = 32;
> > +	dimm->dtype = DEV_UNKNOWN;
> > +	dimm->mtype = MEM_NVDIMM;
> > +	dimm->edac_mode = EDAC_SECDED; /* likely better than this */
> 
> Ditto.
> 
> /me hands aegl a bunch of newlines - seems he's all out of \n's

/me finds that the "Enter" key on his keyboard will put in a newline.
Hurrah! now I don't have to copy/paste them from Boris.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
