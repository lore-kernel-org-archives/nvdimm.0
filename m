Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com
 [IPv6:2a00:1450:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C00AC210C124F
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 00:36:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h14-v6so3034757wrw.13
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 00:36:46 -0700 (PDT)
Date: Tue, 24 Jul 2018 09:36:41 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6 11/13] x86/mm/pat: Prepare {reserve, free}_memtype()
 for "decoy" addresses
Message-ID: <20180724073641.GA15984@gmail.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153154382700.34503.10197588570935341739.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153154382700.34503.10197588570935341739.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for using set_memory_uc() instead set_memory_np() for
> isolating poison from speculation, teach the memtype code to sanitize
> physical addresses vs __PHYSICAL_MASK.
> 
> The motivation for using set_memory_uc() for this case is to allow
> ongoing access to persistent memory pages via the pmem-driver +
> memcpy_mcsafe() until the poison is repaired.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: <linux-edac@vger.kernel.org>
> Cc: <x86@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/mm/pat.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 1555bd7d3449..6788ffa990f8 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -512,6 +512,17 @@ static int free_ram_pages_type(u64 start, u64 end)
>  	return 0;
>  }
>  
> +static u64 sanitize_phys(u64 address)
> +{
> +	/*
> +	 * When changing the memtype for pages containing poison allow
> +	 * for a "decoy" virtual address (bit 63 clear) passed to
> +	 * set_memory_X(). __pa() on a "decoy" address results in a
> +	 * physical address with it 63 set.
> +	 */
> +	return address & __PHYSICAL_MASK;

s/it/bit

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
