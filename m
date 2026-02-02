Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879D7261C
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770062428; cv=pass; b=k+/yth83yojyLcf/J23xs3opw5IJ7ok4H5rHxP9j+b6wG+kf6IiOyQYsVekA/gO/nxEr22ayFDeuZj9NxxmYvq/Qbc1+LTLP9+Q2FX3+nOcJ9h44iPqLdba7JBB2q7h3fyNiLRigvjmeRwg7Czt1r4GRUbP1ulObKFOVnqpKTdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770062428; c=relaxed/simple;
	bh=zNnjzhBFi1tGHAZPFKr3IpG4jkjHIuxvSu01c9+xkAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWQv0J8sZXmMfC94bLRTFyrNPDebZ6Vsc6bWxBQcmejVgz8a+ZN8Df7Qv2hLXLM5m1FvHIiw1gjDCTcpoJvJCIK+sJ0Dw+cdyCSy0aAVeHv0TXGU4GZVxc3ltf76tzZ8WdVeVmj+S8hzg1/qZfU/7v/Cie+QN2IWptAiYNsnb04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Rv2iz45I; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Rv2iz45I"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 58D287628A3;
	Mon, 02 Feb 2026 20:00:26 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (100-123-122-168.trex-nlb.outbound.svc.cluster.local [100.123.122.168])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id A2994762A89;
	Mon, 02 Feb 2026 20:00:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770062425;
	b=buBFaY0Iic7xkUVBdrTwcM6WDn0lzO1c3Tjiy4aYQ3KdfS8bmJ0Qk01Yif6x5xIMMi8Peu
	pvdJh1N3TmctJFaQabb6K5iAoq1lX7ABc0qkB/cdktWYgKZ4nqK+GbLeKBWFVO5PLT+8pB
	732mzKaKiguTh5HNrLcl7NAClL2NN1hRNpzO6m53NJk4+0KDklmvKjQjW+rq7MNL2yYj62
	ck0Q6XOlcmqidUx8KMFRyhPZ2kchE1OGktAVilsbEaK9ayRusBxhW+y9XqpmSwFjtQJrdk
	ajQ2wMS0ABhhjRVj/H/5SseZUks+ff2B24o1/AhMrewLJe/u1NeeRnabP2Caeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770062425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TGN7ccQVSBL3zXRq2zaj0oD2hNGEzmLxxzO6Rb+LSs=;
	b=XORwvSiJxxIdS40yshMiqivS+Jn5v5VdVj3g2Rq4I/6TKhG9ehj19Ze0kiW6vXU8McnyLk
	vxpcVJaaerE+dCf4naqqhsRUICwXL0TEc/5jfD0CVOU0T7x6tCrt+8AXGkxp0wZ1nslZLA
	BNiD3fJr/kiUlapoXq+V7m6iWI+4ogZIJ6ohbB+X8whvbTpMpDS0LK2ofS6ekEyMHZGVXz
	An3O2IzZ0rVDeROy1l3TzuC8FUtpznzE5ZrnI1Z7QavSgEjmaDf7wBCZvv7ubvQghhDSbl
	mGLUPKwg9wSok70jJQMweXVBmrt3Xvu19LKCpewQbkEXbQdhxlXm1jDZ+kajLQ==
ARC-Authentication-Results: i=1;
	rspamd-5b979ccf89-rd6mt;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Supply-Abiding: 242d3e9e5583ac84_1770062426113_2035063146
X-MC-Loop-Signature: 1770062426113:356498927
X-MC-Ingress-Time: 1770062426113
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.122.168 (trex/7.1.3);
	Mon, 02 Feb 2026 20:00:26 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4f4ct06PzxzyrC;
	Mon,  2 Feb 2026 12:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770062425;
	bh=2TGN7ccQVSBL3zXRq2zaj0oD2hNGEzmLxxzO6Rb+LSs=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Rv2iz45Idk+B96pM881dT/5x9esMS+FNhGHCokgJouotgjehS8mbVAdVKa95LP+c/
	 CbuxuH69qP57Fay88O6YnVZbUTDm29zmTvXEV5Bkgw0RtSwyquW0mquXxSEcgCBgeI
	 SPvv94t1au5YlwPJYbshgLMQmEBPbxxufleDu6s0x906q9e/rlvDx9lAQAeWDxPVat
	 9gRwiZ8hHbSj53jHxDSgI+Oma/x5axymGVfsOXJ4+Llx5lb3WeWF+1cScgAnTjTCRJ
	 3tZ42acKG14rS5f8Bbk6HhLo3flI3AyjMjGsLQLW0vBw+R/dMrxDzcSNxUTvAdNOSq
	 qG1aXEQlNpmjg==
Date: Mon, 2 Feb 2026 12:00:22 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Ming <ming.li@zohomail.com>
Subject: Re: [PATCH v9 12/19] cxl/extent: Process dynamic partition events
 and realize region extents
Message-ID: <20260202200022.zkowzjzrmogwmt4u@offworld>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-12-1d4911a0b365@intel.com>
User-Agent: NeoMutt/20220429

On Sun, 13 Apr 2025, Ira Weiny wrote:

>+static int cxlr_add_extent(struct cxl_dax_region *cxlr_dax,
>+			   struct cxl_endpoint_decoder *cxled,
>+			   struct cxled_extent *ed_extent)
>+{
>+	struct region_extent *region_extent;
>+	struct range hpa_range;
>+	int rc;
>+
>+	calc_hpa_range(cxled, cxlr_dax, &ed_extent->dpa_range, &hpa_range);
>+
>+	region_extent = alloc_region_extent(cxlr_dax, &hpa_range, &ed_extent->uuid);
>+	if (IS_ERR(region_extent))
>+		return PTR_ERR(region_extent);
>+

afaict the ed_extent can leak in this error path

>+	rc = xa_insert(&region_extent->decoder_extents, (unsigned long)ed_extent,
>+		       ed_extent, GFP_KERNEL);
>+	if (rc) {
>+		free_region_extent(region_extent);
>+		return rc;
>+	}

.. and this one (not in the xarray).

>+
>+	/* device model handles freeing region_extent */
>+	return online_region_extent(region_extent);
>+}

...

> static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>				    enum cxl_event_log_type type)
> {
>@@ -1100,9 +1369,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
>		if (!nr_rec)
>			break;
>
>-		for (i = 0; i < nr_rec; i++)
>+		for (i = 0; i < nr_rec; i++) {
>			__cxl_event_trace_record(cxlmd, type,
>						 &payload->records[i]);
>+			if (type == CXL_EVENT_TYPE_DCD)
>+				cxl_handle_dcd_event_records(mds,
>+							&payload->records[i]);
>+		}
>
>		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
>			trace_cxl_overflow(cxlmd, type, payload);

With DCD the extent list needs resync'd in the overflow case; cxl_process_extent_list() needs
called.
