Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DFD9321959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 10:12:42 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4] nvdimm, btt: fix LBA masking during 'free list'
 population
Date: Wed, 27 Feb 2019 18:12:31 +0000
Message-ID: <34fc552cb992d62e14b4edda8edc1534b32277b4.camel@intel.com>
References: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
 <20190226231331.8730-1-vishal.l.verma@intel.com>
 <PU1P153MB01693156DE97BEA6BF300ACBBF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01693156DE97BEA6BF300ACBBF740@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <EDE207AB9B882C47961840E90CF02708@intel.com>
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
To: "decui@microsoft.com" <decui@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "pbarbuda@microsoft.com" <pbarbuda@microsoft.com>, "mikelley@microsoft.com" <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-02-27 at 05:55 +0000, Dexuan Cui wrote:
> > From: Vishal Verma <vishal.l.verma@intel.com>
> > Sent: Tuesday, February 26, 2019 3:14 PM
> > ...
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > @@ -555,16 +555,21 @@ static int btt_freelist_init(struct arena_info
*arena)
> >  		if (new < 0)
> >  			return new;
> > 
> > +		/* old and new map entries with any flags stripped out
*/
> > +		log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
> > +		log_newmap = ent_lba(le32_to_cpu(log_new.new_map));
> > +
> >  		/* sub points to the next one to be overwritten */
> >  		arena->freelist[i].sub = 1 - new;
> >  		arena->freelist[i].seq =
nd_inc_seq(le32_to_cpu(log_new.seq));
> > -		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
> > +		arena->freelist[i].block = log_oldmap;
> > 
> >  		/*
> >  		 * FIXME: if error clearing fails during init, we want
to make
> >  		 * the BTT read-only
> >  		 */
> >  		if (ent_e_flag(log_new.old_map)) {
> > +			set_e_flag(arena->freelist[i].block);
> Hi Vishal,
> The logic doesn't look quite right to me: as I understand, if both the
zero flag and
> the error flag are set, it means a normal map entry rather than an
error.
> 
> Windows can indeed set both flags: 
> [    3.756239] freelist_init: i=0, log_old: lba=bcc01,
old_map=c00bcc30, new_map=c00bcc02, seq=2
> [    3.765583] freelist_init: i=0, log_new: lba=bcc00,
old_map=c0001b7b, new_map=c00bcc30, seq=3
> (For the full log, see 
https://github.com/dcui/linux/commit/b472968e01d72be3bd42e4568befc4602f9ac396
)
> 
> Due to this new line, the 'block' can exceed the normal internal_nlba,
and cause I/O failure:
> 
> [  103.589766] btt_write_pg failed: lane=0x0, new_postmap=0x40001b7b,
internal_nlba=0x1ff8018
> [  103.602387] nd_pmem btt1.1: io error in WRITE sector 33056, len
4096,
> [  103.611662] Buffer I/O error on dev pmem1s2, logical block 36, lost
async page write 
> 
> I suppose the new line should not be added, and the line 
>   		if (ent_e_flag(log_new.old_map)) {
> should be changed to
>   		if (ent_e_flag(log_new.old_map) && !
ent_z_flag(log_new.old_map)) {
> ?
> 
Ah yes good catch, I broke my own rule, in that freelist[i].block should
not have flag bits since it is used as is. The freelist has a separate
has_err field to allow for error clearing, and we should be setting
that.

Does the following incremental patch fix it? Let me know and I can send
a new version including it.

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 294c48e45e74..1e7c1a66cef8 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -569,7 +569,7 @@ static int btt_freelist_init(struct arena_info
*arena)
 		 * the BTT read-only
 		 */
 		if (ent_e_flag(log_new.old_map)) {
-			set_e_flag(arena->freelist[i].block);
+			arena->freelist[i].has_err = 1;
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
 				dev_err_ratelimited(to_dev(arena),

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
