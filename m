From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation
 2
Date: Fri, 19 Aug 2016 16:46:36 +0000
Message-ID: <DM2PR21MB0089C6E00631E41BE4221612CB160@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
 <20160819160651.GA7478@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160819160651.GA7478-he5eyhs8q0BAdwtm4QZOy9BPR1lH4CV8@public.gmane.org>
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
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

I don't think we need to gate this based on the platform.  If you look at the differences between what is done:

 - The printk is no longer called.  That's fine; we already did the printk modified in patch 2/2.  The user is aware there machine doesn't have PCI :-)

 - We set the cacheline size.  That's copying a value from the cpuinfo to a global __read_mostly variable and emitting a printk.  No big deal.

 - In pcibios_resource_survey, we iterate over three empty lists, call e820_reserve_resources_late() (which is what we want!) and call ioapic_insert_resources() (which I rather think we want too)

In short, not calling these functions is a bug.  We just haven't noticed before now because PCI is so omnipresent.

-----Original Message-----
From: Konrad Rzeszutek Wilk [mailto:konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org] 
Sent: Friday, August 19, 2016 12:07 PM
To: Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2

On Thu, Aug 18, 2016 at 12:12:54PM -0700, Matthew Wilcox wrote:
> @@ -516,11 +516,6 @@ void __init pcibios_set_cache_line_size(void)
>  
>  int __init pcibios_init(void)
>  {
> -	if (!raw_pci_ops && !raw_pci_ext_ops) {
> -		printk(KERN_WARNING "PCI: System does not support PCI\n");
> -		return 0;
> -	}

So shouldn't this be gated on whether the platform is HyperV?

> -
>  	pcibios_set_cache_line_size();
>  	pcibios_resource_survey();
>  
> --
> 2.8.1
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
