Received: from sienna.cherry.relay.mailchannels.net (sienna.cherry.relay.mailchannels.net [23.83.223.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674612FE578
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 19:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770061376; cv=pass; b=UjA0AIdsdcGBx1Pfk9sdvTE52EiEbyA9ZugfEXX73Xha/QznsPpR7YzxCql+Lcs1EgsE29fkuAUkzt1kkoUfBhyv+3hcqVfI8hISRnvpnODgMUrKMJTOk0S3EK/iLToNbwKt2UmLF1nuNVF57cZiZoWAQRkAXvbSS0R66DNwFr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770061376; c=relaxed/simple;
	bh=tkv+TSxtw3V3RnH03tIV1G8/siCL5dmJerasomPzC0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLqnHL1+YQlJWDO/AdeutL9KM0h53gAXlRKDfRhgPOivWjpTGyhB8TBFFxcqOZ3CoW9sZHNbKdbDdCqD/fZH0rqgeR8jfF+hR8ydEgeBvx/jY0UFVNIlShhZ7w0aEda0khI6MRmVGGMUID5qSBJUZ6zXEQ2ySpCkMKpsmST6YOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=GlzuQ1c4; arc=pass smtp.client-ip=23.83.223.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="GlzuQ1c4"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BD794461C5E;
	Mon, 02 Feb 2026 19:42:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (trex-green-1.trex.outbound.svc.cluster.local [100.96.255.91])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3A555461896;
	Mon, 02 Feb 2026 19:42:49 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770061369;
	b=WyuFiSSmHt/XpOj2SEFlUeAmeR/4WPuz49XIdZRz0nlN76cC6rNsGBFihBrljR0J1cGzfs
	OeLwIFar1FZOz0lYwsYFkNVVST6nMWIYvtCkEmfE6IVJJiudkRq4xnD3zzGRut0doNTT4h
	fr2nXSkBvAPzNb4SDuPvK9clrUhfdkPC3uozAweFPpO400mkMEQ6x1FZxL1f3GMZThQnQ4
	E30k3lr65ObbuKB7ZTkRkh3h6ghaAsDKL7xtlpM35nsxwjQs5+GAUM8FjjC8NIYurpKRhS
	H1MPKXayFdkrivQ+6aC9PpI7aC5SoNCeTea4g2J7GAGHTRhfCb7cEnfwX12q6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770061369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCFzkOutSNXY9dKZ7WhTdiEKcb0HoBLR+6Jq3naTmZg=;
	b=lECwkE8irxF0JLh4KpcNt4yRpTm8EQHIcNrTwza/B1vlkXZisVKcuohA2HY/r/Nt0Ay4lv
	R/80LAM6qVccEj8bAQvLO9lCcbyq2SDLWbSd9UFAEUzVhwu4ptcEPnGI0lmhOZIvl3OAox
	Dwpb6xaVaRt17IgtnTQV+AYiwgygwMt/nHfxgdn7P0CEGu4F5BlNB0QGkVaOVRIoIx0dUC
	0qbLnNfJhGrBWLWcF/079P5RF3+Yi7S34sRkZufLpwKgNw83WVf9jdrmK7/X8tJxyQxfI+
	00YT9PtKR9XvWgLC4L1QcnSjfyE/gq7t8kTw6u9yhVbVo8PRCvy/VMNuVIIw8A==
ARC-Authentication-Results: i=1;
	rspamd-c758cdf4d-snh2h;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Towering-Name: 54c5c7cd5464e1e0_1770061369514_705110241
X-MC-Loop-Signature: 1770061369514:616656904
X-MC-Ingress-Time: 1770061369514
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.255.91 (trex/7.1.3);
	Mon, 02 Feb 2026 19:42:49 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4f4cTh3gHMz105C;
	Mon,  2 Feb 2026 11:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770061369;
	bh=vCFzkOutSNXY9dKZ7WhTdiEKcb0HoBLR+6Jq3naTmZg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=GlzuQ1c43JcO9dAIywLppS/EiOLlPcMVBgFifkc2NkWPO8Zx3jb9CXywiMAMoqpGx
	 LOi0lYT8sta9m8/hSBOp7QnGMrVzdVojjQ8YcwLlbJKlXQAzMjBQ9DV05NvGEuSPs0
	 cK6dowNzZ4jQz2nNdvq7RK0meK8t/ApcSrStBPGmTuWsH19a5QnqLVYwCH+JeKJAal
	 QTY7he1LsJwYJtfy/dEqOODoSn5GmuUksaPhMdmrzc/lE4WsPRtu9KqKV61faeZ33Z
	 uy0UT8tQcMi6pvdT9nLkbVU2nVGQs/IXX2ZNDzSbiP9VskuElFQJoZ6uPV1ii4aser
	 CqoYi5mmRUNqg==
Date: Mon, 2 Feb 2026 11:42:45 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 16/19] cxl/region: Read existing extents on region
 creation
Message-ID: <20260202194245.7wmk64v4l4pdf2hc@offworld>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-16-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-16-1d4911a0b365@intel.com>
User-Agent: NeoMutt/20220429

On Sun, 13 Apr 2025, Ira Weiny wrote:

>Dynamic capacity device extents may be left in an accepted state on a
>device due to an unexpected host crash.  In this case it is expected
>that the creation of a new region on top of a DC partition can read
>those extents and surface them for continued use.
>
>Once all endpoint decoders are part of a region and the region is being
>realized, a read of the 'devices extent list' can reveal these
>previously accepted extents.
>
>CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
>this purpose.  The call returns all the extents for all dynamic capacity
>partitions.  If the fabric manager is adding extents to any DCD
>partition, the extent list for the recovered region may change.  In this
>case the query must retry.  Upon retry the query could encounter extents
>which were accepted on a previous list query.  Adding such extents is
>ignored without error because they are entirely within a previous
>accepted extent.  Instead warn on this case to allow for differentiating
>bad devices from this normal condition.
>
>Latch any errors to be bubbled up to ensure notification to the user
>even if individual errors are rate limited or otherwise ignored.
>
>The scan for existing extents races with the dax_cxl driver.  This is
>synchronized through the region device lock.  Extents which are found
>after the driver has loaded will surface through the normal notification
>path while extents seen prior to the driver are read during driver load.
>
>Based on an original patch by Navneet Singh.
>
>Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>Reviewed-by: Fan Ni <fan.ni@samsung.com>
>Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>
>---
>Changes:
>[0day: fix extent count in GetExtent input payload]
>[iweiny: minor clean ups]
>[iweiny: Adjust for partition arch]
>---
> drivers/cxl/core/core.h   |   1 +
> drivers/cxl/core/mbox.c   | 109 ++++++++++++++++++++++++++++++++++++++++++++++
> drivers/cxl/core/region.c |  25 +++++++++++
> drivers/cxl/cxlmem.h      |  21 +++++++++
> 4 files changed, 156 insertions(+)
>
>diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
>index 027dd1504d77..e06a46fec217 100644
>--- a/drivers/cxl/core/core.h
>+++ b/drivers/cxl/core/core.h
>@@ -22,6 +22,7 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
>	return container_of(cxlds, struct cxl_memdev_state, cxlds);
> }
>
>+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
> int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
>
> #ifdef CONFIG_CXL_REGION
>diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
>index de01c6684530..8af3a4173b99 100644
>--- a/drivers/cxl/core/mbox.c
>+++ b/drivers/cxl/core/mbox.c
>@@ -1737,6 +1737,115 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> }
> EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
>
>+/* Return -EAGAIN if the extent list changes while reading */
>+static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
>+{
>+	u32 current_index, total_read, total_expected, initial_gen_num;
>+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
>+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>+	struct device *dev = mds->cxlds.dev;
>+	struct cxl_mbox_cmd mbox_cmd;
>+	u32 max_extent_count;
>+	int latched_rc = 0;
>+	bool first = true;
>+
>+	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
>+				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
>+	if (!extents)
>+		return -ENOMEM;
>+
>+	total_read = 0;
>+	current_index = 0;
>+	total_expected = 0;
>+	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
>+				sizeof(struct cxl_extent);
>+	do {
>+		u32 nr_returned, current_total, current_gen_num;
>+		struct cxl_mbox_get_extent_in get_extent;
>+		int rc;
>+
>+		get_extent = (struct cxl_mbox_get_extent_in) {
>+			.extent_cnt = cpu_to_le32(max(max_extent_count,
>+						  total_expected - current_index)),

s/max/min().

>+			.start_extent_index = cpu_to_le32(current_index),
