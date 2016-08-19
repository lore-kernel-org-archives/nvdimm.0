From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Set up resources correctly on Hyper-V
 Generation 2
Date: Fri, 19 Aug 2016 12:06:51 -0400
Message-ID: <20160819160651.GA7478@char.us.oracle.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471547575-14748-1-git-send-email-mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Matthew Wilcox <mawilcox-GeNUCkLqbpfIc/EVeNwBgQC/G2K4zDHf@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Aug 18, 2016 at 12:12:54PM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> The Generation 2 Hyper-V virtual machine does not emulate PCI.
> This check causes the call to pcibios_resource_survey() to be skipped,
> and pcibios_resource_survey() calls e820_reserve_resources_late(), which
> is where PMEM resources are added to the resource tree.  With this patch,
> the PMEM devices now show up.
> 
> Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  arch/x86/pci/common.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 7b6a9d1..d39e799 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
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
