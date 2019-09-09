From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH v5] mm/nvdimm: Fix endian conversion =?utf-8?Q?issues?=
 =?utf-8?Q?=C2=A0?=
Date: Mon, 09 Sep 2019 20:48:02 +0530
Message-ID: <871rwp1ot1.fsf@linux.ibm.com>
References: <20190809074726.27815-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190809074726.27815-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

"Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> writes:

> nd_label->dpa issue was observed when trying to enable the namespace created
> with little-endian kernel on a big-endian kernel. That made me run
> `sparse` on the rest of the code and other changes are the result of that.
>
> Fixes: d9b83c756953 ("libnvdimm, btt: rework error clearing")
> Fixes: 9dedc73a4658 ("libnvdimm/btt: Fix LBA masking during 'free list' population")
>
> Reviewed-by: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> ---
> Changes from V4:
> * Rebase to latest kernel
>
>  drivers/nvdimm/btt.c            | 8 ++++----
>  drivers/nvdimm/namespace_devs.c | 7 ++++---
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index a8d56887ec88..3e9f45aec8d1 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -392,9 +392,9 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
>  	arena->freelist[lane].sub = 1 - arena->freelist[lane].sub;
>  	if (++(arena->freelist[lane].seq) == 4)
>  		arena->freelist[lane].seq = 1;
> -	if (ent_e_flag(ent->old_map))
> +	if (ent_e_flag(le32_to_cpu(ent->old_map)))
>  		arena->freelist[lane].has_err = 1;
> -	arena->freelist[lane].block = le32_to_cpu(ent_lba(ent->old_map));
> +	arena->freelist[lane].block = ent_lba(le32_to_cpu(ent->old_map));
>  
>  	return ret;
>  }
> @@ -560,8 +560,8 @@ static int btt_freelist_init(struct arena_info *arena)
>  		 * FIXME: if error clearing fails during init, we want to make
>  		 * the BTT read-only
>  		 */
> -		if (ent_e_flag(log_new.old_map) &&
> -				!ent_normal(log_new.old_map)) {
> +		if (ent_e_flag(le32_to_cpu(log_new.old_map)) &&
> +		    !ent_normal(le32_to_cpu(log_new.old_map))) {
>  			arena->freelist[i].has_err = 1;
>  			ret = arena_clear_freelist_error(arena, i);
>  			if (ret)
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index a9c76df12cb9..f779cb2b0c69 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1987,7 +1987,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		nd_mapping = &nd_region->mapping[i];
>  		label_ent = list_first_entry_or_null(&nd_mapping->labels,
>  				typeof(*label_ent), list);
> -		label0 = label_ent ? label_ent->label : 0;
> +		label0 = label_ent ? label_ent->label : NULL;
>  
>  		if (!label0) {
>  			WARN_ON(1);
> @@ -2322,8 +2322,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			continue;
>  
>  		/* skip labels that describe extents outside of the region */
> -		if (nd_label->dpa < nd_mapping->start || nd_label->dpa > map_end)
> -			continue;
> +		if (__le64_to_cpu(nd_label->dpa) < nd_mapping->start ||
> +		    __le64_to_cpu(nd_label->dpa) > map_end)
> +				continue;
>  
>  		i = add_namespace_resource(nd_region, nd_label, devs, count);
>  		if (i < 0)
> -- 
> 2.21.0

Gentle reminder.

Dan - any update on this?

-aneesh
