From: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 8/9] powerpc/mm: Wire up hpte_removebolted for powernv
Date: Wed, 12 Apr 2017 08:50:56 +1000
Message-ID: <20170412085056.4da27f32@kryten>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-9-oohall@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170411174233.21902-9-oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rashmica Gupta <rashmica.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, arbab-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi Oliver,

> From: Rashmica Gupta <rashmica.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Adds support for removing bolted (i.e kernel linear mapping) mappings
> on powernv. This is needed to support memory hot unplug operations
> which are required for the teardown of DAX/PMEM devices.
> 
> Cc: Rashmica Gupta <rashmica.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Could the original author of this add their S-o-b? I pulled it out of
> Rashmica's memtrace patch, but I remember someone saying Anton wrote
> it originally.

I did.

Signed-off-by: Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Anton

> ---
>  arch/powerpc/mm/hash_native_64.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/powerpc/mm/hash_native_64.c
> b/arch/powerpc/mm/hash_native_64.c index 65bb8f33b399..9ba91d4905a4
> 100644 --- a/arch/powerpc/mm/hash_native_64.c
> +++ b/arch/powerpc/mm/hash_native_64.c
> @@ -407,6 +407,36 @@ static void native_hpte_updateboltedpp(unsigned
> long newpp, unsigned long ea, tlbie(vpn, psize, psize, ssize, 0);
>  }
>  
> +/*
> + * Remove a bolted kernel entry. Memory hotplug uses this.
> + *
> + * No need to lock here because we should be the only user.
> + */
> +static int native_hpte_removebolted(unsigned long ea, int psize, int
> ssize) +{
> +	unsigned long vpn;
> +	unsigned long vsid;
> +	long slot;
> +	struct hash_pte *hptep;
> +
> +	vsid = get_kernel_vsid(ea, ssize);
> +	vpn = hpt_vpn(ea, vsid, ssize);
> +
> +	slot = native_hpte_find(vpn, psize, ssize);
> +	if (slot == -1)
> +		return -ENOENT;
> +
> +	hptep = htab_address + slot;
> +
> +	/* Invalidate the hpte */
> +	hptep->v = 0;
> +
> +	/* Invalidate the TLB */
> +	tlbie(vpn, psize, psize, ssize, 0);
> +	return 0;
> +}
> +
> +
>  static void native_hpte_invalidate(unsigned long slot, unsigned long
> vpn, int bpsize, int apsize, int ssize, int local)
>  {
> @@ -725,6 +755,7 @@ void __init hpte_init_native(void)
>  	mmu_hash_ops.hpte_invalidate	= native_hpte_invalidate;
>  	mmu_hash_ops.hpte_updatepp	= native_hpte_updatepp;
>  	mmu_hash_ops.hpte_updateboltedpp =
> native_hpte_updateboltedpp;
> +	mmu_hash_ops.hpte_removebolted = native_hpte_removebolted;
>  	mmu_hash_ops.hpte_insert	= native_hpte_insert;
>  	mmu_hash_ops.hpte_remove	= native_hpte_remove;
>  	mmu_hash_ops.hpte_clear_all	= native_hpte_clear;
