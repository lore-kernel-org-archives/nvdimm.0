Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3AE309F09
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 20:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770065038; cv=pass; b=HSPlGUIHmNvLgXoXQRptU2IXx8h1lGP4DdFDThcos9rCamB8yKbRZbXhapWUvdFJl7Jaf0NR54VonI0adfnHvZfZMm0n6zQxUBX73ZufVr9BT/xhTQUgCbN4GRgocv9GUQcmdb2WDCfoAEETcFrDWi6ky3+cmmbhMNMNgXE4V6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770065038; c=relaxed/simple;
	bh=lwXrTCEx1szCdIt8hXNJEHNBNImULcDwFuLV7vI4p5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ne90D+MxuphyQHdER59RSjGshOCWxdE/BmXfnbwgcmA6CP4fwxfTg81/G5y8ZVyMLmIJbITAUxEQy4CMqUd/WTQ1kfc6uKDGmttox1yPLTkUmCekkXlAvODMBIH6IIInVm5aepZKhQ1lHMRoj43HnOVqJsAfVZaJUP+l41jgj4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=WCO4JCRW; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="WCO4JCRW"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A4678722065;
	Mon, 02 Feb 2026 19:25:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (100-97-34-107.trex-nlb.outbound.svc.cluster.local [100.97.34.107])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id E3FB4722597;
	Mon, 02 Feb 2026 19:25:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770060349;
	b=BCqI3JHFkEQmzYm/OJv8dbksvoaFLeCYtqg8LVo3mgey1JGkPGjZONNAyC5UOWuKKChGWy
	6IopRUzXxOZZfeTDM0yUy8eoU/7ZnyUMur7GLSvqGvpIqQcMXFUxuaWCpUnVNI3hxm5M6B
	XH/2oskXMz5BzBfk0BOtUMBB7zG7NALv6OSU80EPlCH1a1mnd/59sjpqFQktLKinifoj6W
	LKfDV42nmOuiqbYVOBpOjk4ESqSI1N14y0jgowC7sFTkAqNooX0aqvvNtzTPoR+cny97yA
	MeeqhAsvcWi7MOXxjYTxb6ZtmvD0wz525bFIseXqnrAyKPvhlZZRUOQpazUGSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770060349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6efM5ioHVxaPcmDXBceIc6/l9+DmGPStmA0f8wvROMw=;
	b=C+jbJvey5GOHlk9QArAcGHVmzokl95LTFr4aaR48WVEFmrlA/Gc/ZtV3KJToYmMckl8ave
	KqZoZ7fvR8MhAFd17J5uPIcvriqMUVujqWJMw7qadX4x2hNLqgwv+7CvBVGg4AzVM7yjEY
	waHh9En6JH4iwjCH0r37o2659zlmSINUd9hFqgeKgBhOlETsYOfWhvNn5ovw1Gs0gI9hHR
	kDFmr7Rz03y88iwzU18tM86Z+fAFmGdhXWBb9HXzu2hHxrRX83hJ7yMotBZKclY671Eeep
	BTWwZZxaLnc1pZOzyUkAensUiI5tdu5r6IAs5XJ+7wSINcRkA/mqHopSDOrBuw==
ARC-Authentication-Results: i=1;
	rspamd-c758cdf4d-snh2h;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Unite-Duck: 530efc1923798ccb_1770060349388_4224958092
X-MC-Loop-Signature: 1770060349388:1589015351
X-MC-Ingress-Time: 1770060349388
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.34.107 (trex/7.1.3);
	Mon, 02 Feb 2026 19:25:49 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4f4c641pgXz105C;
	Mon,  2 Feb 2026 11:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770060348;
	bh=6efM5ioHVxaPcmDXBceIc6/l9+DmGPStmA0f8wvROMw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=WCO4JCRWjfsi22lnrM050ugqbUu1iYENQpgZRXeskDTYroGdPe/45byqPFIeEDvCL
	 Uw4/UtlU31wu0EAlnjQ4Y0rK7aozlm3blsDK6IaNMOfDdq/OhCa5lLODGce9OuneSj
	 WWMqXdJaGVS3GLQECvvYufwaOEUHtzU4GeKyf27zvETMvHdfzqszJC6egFpv1wIV08
	 ukpwigRGh2B2X2wAdNWhA9CVIfB83PpCraT6GGc+car46tDPOWho1tHMZW0xmoxiK7
	 Qa1oPGgKhPvqHMsYSgDFMsHw13u0DNt+UrPqFVNX3I0KQ2bbjoy0ijZzWqSg8hToLX
	 jEZjacqFfgR+w==
Date: Mon, 2 Feb 2026 11:25:45 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/19] cxl/core: Enforce partition order/simplify
 partition calls
Message-ID: <20260202192545.3ld5nmk5jou4lnpx@offworld>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-4-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-4-1d4911a0b365@intel.com>
User-Agent: NeoMutt/20220429

On Sun, 13 Apr 2025, Ira Weiny wrote:

>Device partitions have an implied order which is made more complex by
>the addition of a dynamic partition.
>
>Remove the ram special case information calls in favor of generic calls
>with a check ahead of time to ensure the preservation of the implied
>partition order.
>
>Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>---
> drivers/cxl/core/hdm.c    | 11 ++++++++++-
> drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
> drivers/cxl/cxl.h         |  1 +
> drivers/cxl/cxlmem.h      |  9 +++------
> drivers/cxl/mem.c         |  2 +-
> 5 files changed, 24 insertions(+), 31 deletions(-)
>
>diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
>index c5f8a17d00f1..92e1a24e2109 100644
>--- a/drivers/cxl/core/hdm.c
>+++ b/drivers/cxl/core/hdm.c
>@@ -470,6 +470,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
> int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> {
> 	struct device *dev = cxlds->dev;
>+	int i;
>
> 	guard(rwsem_write)(&cxl_dpa_rwsem);
>
>@@ -482,9 +483,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> 		return 0;
> 	}
>
>+	/* Verify partitions are in expected order. */
>+	for (i = 1; i < info->nr_partitions; i++) {
>+		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {
>+			dev_err(dev, "Partition order mismatch\n");
>+			return 0;

return -EINVAL?

>+		}
>+	}
>+
> 	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
>
>-	for (int i = 0; i < info->nr_partitions; i++) {
>+	for (i = 0; i < info->nr_partitions; i++) {
> 		const struct cxl_dpa_part_info *part = &info->part[i];
> 		int rc;
>
