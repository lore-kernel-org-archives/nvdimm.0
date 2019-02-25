Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D24F6211CF361
 for <linux-nvdimm@lists.01.org>; Mon, 25 Feb 2019 14:48:42 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/2] nvdimm, btt: fix LBA masking during 'free list'
 population
Date: Mon, 25 Feb 2019 22:48:40 +0000
Message-ID: <70e74e8e47c107d531e45b301ab30c935d89ef5a.camel@intel.com>
References: <20190225224307.6054-1-vishal.l.verma@intel.com>
 <20190225224307.6054-2-vishal.l.verma@intel.com>
In-Reply-To: <20190225224307.6054-2-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <ACB1DFBC0F63BE44B99A8B52D2290110@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "pbarbuda@microsoft.com" <pbarbuda@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-02-25 at 15:43 -0700, Vishal Verma wrote:
> The Linux BTT implementation assumes that log entries will never have
> the 'zero' flag set, and indeed it never sets that flag for log entries
> itself.
> 
> However, the UEFI spec is ambiguous on the exact format of the LBA field
> of a log entry, specifically as to whether it should include the
> additional flag bits or not. While a zero bit doesn't make sense in the
> context of a log entry, other BTT implementations might still have it set.
> 
> If an implementation does happen to have it set, we would happily read
> it in as the next block to write to for writes. Since a high bit is set,
> it pushes the block number out of the range of an 'arena', and we fail
> such a write with an EIO.
> 
> Follow the robustness principle, and tolerate such implementations by
> stripping out the zero flag when populating the free list during
> initialization. Additionally, use the same stripped out entries for
> detection of incomplete writes and map restoration that happens at this
> stage.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
> Tested-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Forgot to include a change description:

v1 -> v2:

- Add a patch to remove unused code getting the old log entry
- Also use the stripped out versions of the log entries when testing for
incomplete writes.

>  drivers/nvdimm/btt.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index cd4fa87ea48c..294c48e45e74 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -542,8 +542,8 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
>  static int btt_freelist_init(struct arena_info *arena)
>  {
>  	int new, ret;
> -	u32 i, map_entry;
>  	struct log_entry log_new;
> +	u32 i, map_entry, log_oldmap, log_newmap;
>  
>  	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
>  					GFP_KERNEL);
> @@ -555,16 +555,21 @@ static int btt_freelist_init(struct arena_info *arena)
>  		if (new < 0)
>  			return new;
>  
> +		/* old and new map entries with any flags stripped out */
> +		log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
> +		log_newmap = ent_lba(le32_to_cpu(log_new.new_map));
> +
>  		/* sub points to the next one to be overwritten */
>  		arena->freelist[i].sub = 1 - new;
>  		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
> -		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
> +		arena->freelist[i].block = log_oldmap;
>  
>  		/*
>  		 * FIXME: if error clearing fails during init, we want to make
>  		 * the BTT read-only
>  		 */
>  		if (ent_e_flag(log_new.old_map)) {
> +			set_e_flag(arena->freelist[i].block);
>  			ret = arena_clear_freelist_error(arena, i);
>  			if (ret)
>  				dev_err_ratelimited(to_dev(arena),
> @@ -572,7 +577,7 @@ static int btt_freelist_init(struct arena_info *arena)
>  		}
>  
>  		/* This implies a newly created or untouched flog entry */
> -		if (log_new.old_map == log_new.new_map)
> +		if (log_oldmap == log_newmap)
>  			continue;
>  
>  		/* Check if map recovery is needed */
> @@ -580,8 +585,15 @@ static int btt_freelist_init(struct arena_info *arena)
>  				NULL, NULL, 0);
>  		if (ret)
>  			return ret;
> -		if ((le32_to_cpu(log_new.new_map) != map_entry) &&
> -				(le32_to_cpu(log_new.old_map) == map_entry)) {
> +
> +		/*
> +		 * The map_entry from btt_read_map is stripped of any flag bits,
> +		 * so use the stripped out versions from the log as well for
> +		 * testing whether recovery is needed. For restoration, use the
> +		 * 'raw' version of the log entries as that captured what we
> +		 * were going to write originally.
> +		 */
> +		if ((log_newmap != map_entry) && (log_oldmap == map_entry)) {
>  			/*
>  			 * Last transaction wrote the flog, but wasn't able
>  			 * to complete the map write. So fix up the map.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
