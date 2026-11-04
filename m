Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834324;
	b=BuNlvzn3wfMafc0i3vg3mS3GXth+NrT0J9GcN7oAK9T1dmMrYcLt3qGWpgbAkr0ggUMT
	 1tzsnbnHgvZ/fjhFoVpFbh9+C+ON4YguSiRBXDcXBuQph8gaA+ESgoC4POp2JmhYr9I9J
	 n/5asxacUpaNl4K3IT+ri1DFzVKkEoT3h4iW/0/OGsXjLJGZAfO/DGVeysc/GEVFTdLuO
	 A/Pg5DHGbO+sFTQpe4xsj1jgiTGlYKaFNXKEipzxQ7aUPhHZP3qSW4Y+FeeP62rCRJFng
	 PxWNKG2RUhAiQyPLh+Px2L5fiNI/zVvysUX+OnzOUyESs+gl5Xn0vNunoUimUNAQQlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834324;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Spnf9WW7gFI6g07rWBEFRvUbqYpQ+l6ZF40itB3lXKg=;
	b=weu4Mk4wmwA6rt91teyDXed3IngIxkXCuCoL25AjbdyMDCgOYtzmDy8ownlXgNVI7Qvb
	 e7ODseAshgNcb50ZqAgxvnE5NJbtwgg/71CQ3Ii4slxYybwK/E2EjDnNeiKIni/V99WLj
	 7GDy+nmg39EhvZeKw/lDY5xGolSDsQDP4fqzm2/Ur+IvLf1AwG0+iDMx33g5XY7rexJtF
	 4PPoJx27YA2J0mDUbBBEpPsJST/QiUwreN+CC90W4u8uP5W9Z0UeM2sg/BPcwT0bgLGPf
	 kQKOEUfmdl5wouJmeATbLMTHO1JSYKuat5H2Npo9/kg+BkLJS6IVkicgOzvSVjunCfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBZyW676;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27405606A31B;
	Wed,  4 Nov 2026 23:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBZyW676
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2631F00919;
	Wed,  4 Nov 2026 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834323;
	bh=Spnf9WW7gFI6g07rWBEFRvUbqYpQ+l6ZF40itB3lXKg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QBZyW676IF//hgPjmbdUzDQ0v8iXVXKJzxUxPKLgGs+D6MTgW2q/t54+8U2/7lJf5
	 F2O9I5p6T1CTICmJk/DG6rKr5EdwpGsKUlrcVjG3Weeir3vFo13GtCTav8XcDYMccY
	 pqKGrC7qp1LUBr+kDKPHdWLNi20dGo1kIEvXAlCISORBsJEM3A15+VQRpsZin66rHk
	 MXEku32tymD+uABG7W+eq37Ypy0GGEkAlB6gwK+Fwr3Y4Y+N3tEGJn37fOE/xujWCz
	 YfQQ4nGXjl5LkkUajyN1mCpSLI4bKrrHB8grJKyr0CtGFpPxxn81B0ewzUU8urcYwx
	 4LJ/fijPkBlcQ==
Message-ID: <sashiko-outbox-198289@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 04/14] cxl/mem: Introduce DC event handlers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-5-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-5-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:18:43 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] cxl/mem: incomplete chain abort on staging failure in handle_dcd=
_chain_event()
- [Medium] cxl/mem: missing chain abort in cxl_handle_dcd_event_records()
--

commit 5ef1f10166c3a30ee58534de97a6b9ec5412cf04
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Introduce DC event handlers

This commit adds the event handling skeleton for Dynamic Capacity (DC) Add
and Release event chains in the CXL mailbox driver. Chained records with the
CXL_DCD_EVENT_MORE flag set are staged in mds->dc_chain until the closing
record arrives, at which point Add chains are refused with an empty response
and Release chains are acknowledged.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 13a68f5cef692..3acf5ace48dbc 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
[ ... ]
> +/*
> + * Drop the open chain.  An add chain is refused with an empty response =
so
> + * the device can reclaim the offered capacity; a release chain is simply
> + * dropped, the capacity stays with the host and the device may retry.
> + */
> +static void cxl_dc_chain_abort(struct cxl_memdev_state *mds)
> +{
> +	struct cxl_dc_event_chain *chain =3D &mds->dc_chain;
> +	struct device *dev =3D mds->cxlds.dev;
> +
> +	if (chain->event_type =3D=3D DCD_ADD_CAPACITY &&
> +	    cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				 &chain->pending_extents, 0))
> +		dev_dbg(dev, "Failed to refuse add chain\n");
> +
> +	clear_pending_extents(mds);
> +}
> +
> +static int stage_pending_extent(struct list_head *pending,
> +				struct cxl_extent *to_add)
> +{
> +	struct cxl_extent_list_node *node =3D kzalloc(sizeof(*node), GFP_KERNEL=
);
> +	struct cxl_extent *extent;
> +
> +	if (!node)
> +		return -ENOMEM;
> +	extent =3D kmemdup(to_add, sizeof(*extent), GFP_KERNEL);
> +	if (!extent) {
> +		kfree(node);
> +		return -ENOMEM;
> +	}
> +
> +	node->extent =3D extent;
> +	list_add_tail(&node->list, pending);
> +	return 0;
> +}
> +
> +static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
> +				  struct cxl_event_dcd *event)
> +{
> +	struct cxl_dc_event_chain *chain =3D &mds->dc_chain;
> +	struct device *dev =3D mds->cxlds.dev;
> +	int rc;
> +
> +	/* Chained records share one event type (CXL r4.0 Table 8-229) */
> +	if (list_empty(&chain->pending_extents)) {
> +		chain->event_type =3D event->event_type;
> +	} else if (chain->event_type !=3D event->event_type) {
> +		dev_warn_ratelimited(dev, "DC %s record inside an open %s chain; dropp=
ing the chain\n",
> +				     cxl_dcd_evt_type_str(event->event_type),
> +				     cxl_dcd_evt_type_str(chain->event_type));
> +		cxl_dc_chain_abort(mds);
> +		chain->event_type =3D event->event_type;
> +	}
> +
> +	rc =3D stage_pending_extent(&chain->pending_extents, &event->extent);
> +	if (rc) {
> +		cxl_dc_chain_abort(mds);
> +		return rc;
> +	}

[Severity: Medium]
If stage_pending_extent() fails with -ENOMEM on a non-terminal record in a
chain (where event->flags has CXL_DCD_EVENT_MORE set), what prevents the
remaining records of that aborted chain from being processed as a new chain?

cxl_dc_chain_abort() sends CXL_MBOX_OP_ADD_DC_RESPONSE (for DCD_ADD_CAPACIT=
Y)
and empties chain->pending_extents via clear_pending_extents(). However,
cxl_mem_get_records_log() continues iterating through payload->records[i] a=
nd
passing subsequent records of the same chain into
cxl_handle_dcd_event_records() -> handle_dcd_chain_event().

Because handle_dcd_chain_event() checks list_empty(&chain->pending_extents)=
 to
determine whether a chain is open, the next record in the aborted chain see=
s an
empty list and starts staging the remainder of the chain as a fresh operati=
on.
When the closing record (More=3D0) arrives, a DCD_RELEASE_CAPACITY chain wi=
ll
send CXL_MBOX_OP_RELEASE_DC for only the trailing subset of extents instead=
 of
dropping the chain, and a DCD_ADD_CAPACITY chain will send a duplicate
CXL_MBOX_OP_ADD_DC_RESPONSE.

Should struct cxl_dc_event_chain track an aborted state until the closing
record with CXL_DCD_EVENT_MORE cleared is consumed?

> +
> +	if (event->flags & CXL_DCD_EVENT_MORE) {
> +		dev_dbg(dev, "more bit set; delay processing of extent\n");
> +		return 0;
> +	}
> +
> +	/* Nothing is tracked yet: refuse every add, acknowledge every release =
*/
> +	if (event->event_type =3D=3D DCD_ADD_CAPACITY)
> +		rc =3D cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +					  &chain->pending_extents, 0);
> +	else
> +		rc =3D cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC,
> +					  &chain->pending_extents,
> +					  list_count_nodes(&chain->pending_extents));
> +	clear_pending_extents(mds);
> +	return rc;
> +}
> +
> +static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
> +					 struct cxl_event_record_raw *raw_rec)
> +{
> +	struct cxl_event_dcd *event =3D &raw_rec->event.dcd;
> +	struct cxl_extent *extent =3D &event->extent;
> +	struct device *dev =3D mds->cxlds.dev;
> +	uuid_t *id =3D &raw_rec->id;
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
> +		rc =3D handle_dcd_chain_event(mds, event);
> +		break;
> +	case DCD_FORCED_CAPACITY_RELEASE:
> +		dev_err_ratelimited(dev, "Forced release event ignored.\n");
> +		rc =3D 0;
> +		break;
> +	case DCD_REGION_CONFIGURATION_UPDATED:
> +		dev_dbg(dev, "Region configuration updated event ignored.\n");
> +		rc =3D 0;
> +		break;
> +	default:
> +		rc =3D -EINVAL;
> +		break;
> +	}

[Severity: Medium]
What happens if a DCD_FORCED_CAPACITY_RELEASE,
DCD_REGION_CONFIGURATION_UPDATED, unknown event_type, or non-DC UUID record
arrives in the DCD log while mds->dc_chain.pending_extents is non-empty?

Currently, the check for an open chain is only performed inside
handle_dcd_chain_event(), which is only called for DCD_ADD_CAPACITY and
DCD_RELEASE_CAPACITY. If another event record arrives in the middle of an o=
pen
chain, cxl_handle_dcd_event_records() does not call cxl_dc_chain_abort(mds).

As a result, an interrupted Add chain is not refused when broken by the
intervening record, and if the next chain shares the same event_type as the
interrupted one, handle_dcd_chain_event() sees chain->event_type =3D=3D
event->event_type and merges the stale extents from the broken chain into t=
he
new chain.

Should cxl_handle_dcd_event_records() abort any open chain when receiving
these non-chain records?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D4
