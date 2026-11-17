Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794884078;
	b=f4e11GgTT7GiW8EP4yTCZ3cUQWKSBp5HP60SaPfjS8TBbuS90xbEua6DWCAmChilb6sd
	 kul5yXMA6e6VIpnI0W65KAxcuFbE9/pJuT1HQBhPC6+Z1pW0J72gFZ5TB8s1WtK6BHP3C
	 q5zX+VA2OxXzGn7yBrZf7bSFMFr5ZWmE5yEmUTcbQ3MtEV+n+SvkeuBvBszvPNr2zXEe6
	 hw1Apwen5iAmxE08io4vi1HaNDGpCPXX3p1TaZOFQISQ19KGKMAQQ867Pj4cKW2vxSfHM
	 WqlGGmbpU1XZlYC8anetL17LnizY22Nvfo/fW2hpo/0ou4Gtv7/G8Hg+wmriVJnatQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794884078;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=REPG2PTjjlLBXySmbr3czUPyqylqIzZwgGf/Je96Dk0=;
	b=draQSwPmAcf5M4LG4YV39CFlsZ8BgNyC+4NdJd90XK6vgRE/5KUNT9PP/ib/VsQau7+j
	 IZOWWWXeH6seVjly9qWSvbfDWOSEDScvDs/vZHMAL6bwVeIyWk6mHHHcRgz1U4CzsBvXd
	 gfCZvVew9unCYHBmtkYQC4pC9cDdpWaa0UvEz3rD2WdA+nkM5tKvDr6bAwtExzNuRXJrF
	 aQJE4aFwCNmwiC0rkn6aW78E4v93suFLzDVWXfonPFz2NKedSRPLeOULmCS2RpI2Jj+XO
	 GFt2jjJtReAAt7mJdrzF47uYz5J40qc2BNZ9PqSBDYswL363VmsNEM5ZyrWFr4CdD/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTRaI7mJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE1F606A32A;
	Tue, 17 Nov 2026 02:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTRaI7mJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0FC1F000C4;
	Tue, 17 Nov 2026 02:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794884078;
	bh=REPG2PTjjlLBXySmbr3czUPyqylqIzZwgGf/Je96Dk0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NTRaI7mJ5qh98ipqHqdO/ndG3EnSNDGY9CdRgJVYrwS9wfCs9E04qU/3WAlxO4yEr
	 IqIawjyCv5B//hBTpV3FWR5y0QrXgRWBPUsS9UeMmY1r5dIXNXVzn22+BuMM7KsQ90
	 5dVBRNakOQQfveonn5zaTOjJ47bCfdnFkEy5npjzlTBD78AxAyTaRI1n11ubYyYl8b
	 sXquIKEpqVkbwekmmyQsojMvLcieOySDPU74MHmUQi3n2E4znCfm9jxnfFzGMUZKR1
	 IuECUSCls4vmgDrubz92N3UyJ6+H2W1gwD8CKA4KfhoFRPavHQwnR6PVHPLtzEz8vh
	 C81xfO/3kq78A==
Date: Tue, 17 Nov 2026 02:54:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 04/14] cxl/mem: Introduce DC event handlers
Message-ID: <20261117025427.48bb687d@jic23-hlaptop>
In-Reply-To: <20261104230445.66625-5-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
	<20261104230445.66625-5-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Nov 2026 08:02:28 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Add the handling skeleton for DC Add and DC Release events. Per CXL
> r4.0 Section 8.2.10.9.9.3, the host is expected to respond to one or
> more Add Capacity Event Record(s) with an Add Dynamic Capacity Response
> (Opcode 4802h) to acknowledge which extents the host accepts for use.
> Similarly, per CXL r4.0 Section 8.2.10.9.9.4, the host is expected to
> respond to Release Capacity Event Record(s) with a Release Dynamic
> Capacity command (Opcode 4803h), or to issue one that is not
> associated with any event to release capacity on its own.
> 
> The records of one operation can be chained by the More flag. Chained
> records are contiguous in the event log and share one event type (CXL
> r4.0 Table 8-229), so a single staging context, mds->dc_chain, holds
> the records of the open chain until the closing record (More=0)
> arrives and the chain is processed and responded to as a whole. A
> record that fails to stage, or one of the other type arriving inside an
> open chain, drops the chain: an add is refused with an empty response,
> a release is left for the device to retry.
> 
> This commit refuses all extents from Add Capacity chains and acks all
> Release Capacity chains. Subsequent commits implement accepting and
> releasing extents.
> 
> Forced Capacity Release and Region Configuration Updated events are
> logged and ignored.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
Sashiko does raise an interesting question about trailing events
in a chain after an error.  If it's shared capacity we aren't allowed
a partial accept. Otherwise it is fine (I think) but perhaps not complexity we
want.  So probably need some flag to say problem occured on a record
with more flag set. Keep dropping until we have had a closing record.

For force release, I'm not sure if we should just panic() (maybe
with a sanity check that the range was mapped) or ignore it and
die in a storm of poison (hopefully rather than zeros).

> ---
>  drivers/cxl/core/mbox.c  | 246 ++++++++++++++++++++++++++++++++++++++-
>  drivers/cxl/core/trace.h |   3 +-
>  drivers/cxl/cxl.h        |   9 ++
>  drivers/cxl/cxlmem.h     |  46 ++++++++
>  drivers/cxl/pci.c        |  20 +++-
>  include/cxl/event.h      |  37 ++++++
>  6 files changed, 353 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 13a68f5cef69..3acf5ace48db 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

> +static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
> +				struct list_head *extent_list, int cnt)
> +{
> +	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	struct cxl_mbox_dc_response *p;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	struct cxl_extent *extent;
> +	u32 pl_index;
> +
> +	size_t pl_size = struct_size(p, extent_list, cnt);
> +	u32 max_extents = cnt;
> +
> +	/* May have to use more bit on response. */
> +	if (pl_size > cxl_mbox->payload_size) {
> +		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
> +			      sizeof(struct updated_extent_list);
> +		pl_size = struct_size(p, extent_list, max_extents);
> +	}
> +
> +	struct cxl_mbox_dc_response *response __free(kfree) =
> +						kzalloc(pl_size, GFP_KERNEL);
> +	if (!response) {
> +		struct cxl_mbox_dc_response empty = { };
> +
> +		/* An empty Release DC is invalid (CXL r4.0 Table 8-352) */
> +		if (opcode == CXL_MBOX_OP_RELEASE_DC)
> +			return -ENOMEM;
> +		/* Refuse all extents rather than stall the device. */
> +		return send_one_response(cxl_mbox, &empty, opcode, 0, 0);
> +	}
> +
> +	/* Set __counted_by to capacity before populating; reset per response. */
> +	response->extent_list_size = cpu_to_le32(max_extents);
> +
> +	if (cnt == 0)
> +		return send_one_response(cxl_mbox, response, opcode, 0, 0);
> +
> +	pl_index = 0;
> +	list_for_each_entry_safe(pos, tmp, extent_list, list) {
> +		extent = pos->extent;
> +		response->extent_list[pl_index].dpa_start = extent->start_dpa;
> +		response->extent_list[pl_index].length = extent->length;
> +		pl_index++;
> +
> +		if (pl_index == max_extents) {
Maybe flip?
		if (pl_index != max_extents)
			continue;

		flags = 0;

		...

> +			u8 flags = 0;
> +			int rc;
> +
> +			if (pl_index < cnt)
> +				flags |= CXL_DCD_EVENT_MORE;
> +			rc = send_one_response(cxl_mbox, response, opcode,
> +					       pl_index, flags);
> +			if (rc)
> +				return rc;
> +			cnt -= pl_index;
> +			if (cnt < max_extents)
> +				max_extents = cnt;
> +			pl_index = 0;
> +		}
> +	}
> +
> +	if (!pl_index) /* nothing more to do */
> +		return 0;
> +	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
> +}

> +
> +static int stage_pending_extent(struct list_head *pending,
> +				struct cxl_extent *to_add)
> +{
> +	struct cxl_extent_list_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
> +	struct cxl_extent *extent;
> +
> +	if (!node)
> +		return -ENOMEM;
> +	extent = kmemdup(to_add, sizeof(*extent), GFP_KERNEL);

Maybe scatter some __free() magic in here and no_free_ptr() where
they get handed off..

> +	if (!extent) {
> +		kfree(node);
> +		return -ENOMEM;
> +	}
> +
> +	node->extent = extent;
e.g.
	node->extent = no_free_ptr(extent);

> +	list_add_tail(&node->list, pending);

	list_add_tail(&no_free_ptr(node)->list, pending);

> +	return 0;
> +}

> +
> +static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
> +					 struct cxl_event_record_raw *raw_rec)
> +{
> +	struct cxl_event_dcd *event = &raw_rec->event.dcd;
> +	struct cxl_extent *extent = &event->extent;
> +	struct device *dev = mds->cxlds.dev;
> +	uuid_t *id = &raw_rec->id;
> +	int rc;
> +
> +	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
> +		return;
> +
> +	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
> +		cxl_dcd_evt_type_str(event->event_type),
> +		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
> +
> +	switch (event->event_type) {
> +	case DCD_ADD_CAPACITY:
> +	case DCD_RELEASE_CAPACITY:
> +		rc = handle_dcd_chain_event(mds, event);
> +		break;
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +		dev_err_ratelimited(dev, "Forced release event ignored.\n");

If that actually happens to us, maybe we should panic?  All bets are off
if we get one of these for capacity that was actually in use.

> +		rc = 0;
> +		break;
> +	case DCD_REGION_CONFIGURATION_UPDATED:
> +		dev_dbg(dev, "Region configuration updated event ignored.\n");
> +		rc = 0;
> +		break;
> +	default:
> +		rc = -EINVAL;
> +		break;
> +	}
> +
> +	if (rc)
> +		dev_err_ratelimited(dev, "dcd event failed: %d\n", rc);
> +}
> +
>  static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>  				    enum cxl_event_log_type type)
>  {
> @@ -1136,9 +1368,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>  		if (!nr_rec)
>  			break;
>  
> -		for (i = 0; i < nr_rec; i++)
> +		for (i = 0; i < nr_rec; i++) {
>  			__cxl_event_trace_record(cxlmd, type,
>  						 &payload->records[i]);
> +			if (type == CXL_EVENT_TYPE_DCD)
> +				cxl_handle_dcd_event_records(mds,
> +							     &payload->records[i]);

Just go long on that one. I wouldn't do the normal thing of flipping the condition
because this being out of line makes sense as its an oddity in this function.

> +		}
>  
>  		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
>  			trace_cxl_overflow(cxlmd, type, payload);

> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index d098f7f50bef..64138e1768a1 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -12,6 +12,7 @@
>  #include <linux/node.h>
>  #include <linux/io.h>
>  #include <linux/range.h>
> +#include <linux/xarray.h>

This looks misplaces as nothing in the header changed
that has anything to do with xarrays.

>  #include <cxl/cxl.h>
>  
>  extern const struct nvdimm_security_ops *cxl_security_ops;
> @@ -557,6 +558,14 @@ struct cxl_pmem_region {
>  	struct cxl_pmem_region_mapping mapping[];
>  };
>  
> +/* See CXL r4.0 8.2.10.2.1.6 */
> +enum dc_event {
> +	DCD_ADD_CAPACITY,
> +	DCD_RELEASE_CAPACITY,
> +	DCD_FORCED_CAPACITY_RELEASE,
> +	DCD_REGION_CONFIGURATION_UPDATED,
> +};
> +
>  struct cxl_dax_region {
>  	struct device dev;
>  	struct cxl_region *cxlr;

