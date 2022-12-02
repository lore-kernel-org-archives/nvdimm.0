Received: from hamster.birch.relay.mailchannels.net (hamster.birch.relay.mailchannels.net [23.83.209.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A0210E6
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 06:39:56 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 9812E101F76;
	Fri,  2 Dec 2022 02:09:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 24498101F31;
	Fri,  2 Dec 2022 02:09:09 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1669946949; a=rsa-sha256;
	cv=none;
	b=Rqvy3RUSlLLa1RQOEU22fZ7AV80iuQ7Wy/8IdK5FPljgzU2eUxma1LTDKt5g9uHTxTqnsb
	kr8yK/MrTOZYA4T+AGAeeeQDdn2Ow3QXcRI6+sY9wnyrGySyA+wADenyBRFPJpfLV5FA7+
	QwHTbS9MCN6YxvL9ofYwImsuJCbNjErXE94ZyvO8lCOg6saS3NYlkEDPncVYSF1oULPLJx
	bq/8TXM7aARHuB/P7duZcaYZtIl5ts/BROptyz9ljgoG+1T3cTXTjm0L0BzUCuCzoaS082
	EcbwRSSni3Diyei/xIqqP6rzMCKhbMfXiClL9XetTilbgku8bkj+NgM+Z5TRww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1669946949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEGf0dZSGTElTTBmwy85ZHKSEGx6K8XIitMKRvHd7lA=;
	b=NQtP8yK3QZxfOr8w4QVGidLb0hMoqL1pn+7jeGljl/usH8/8IdMesZtK4glfPtQ0YwJGAy
	TirOi5rPjtbxXx5LG4iV8yBjWs6jUAGehEJ/ixa49qptFVaAMdZt0J7mmJaoNIugtfA8kq
	pnqPAYvpOATLuYGvsbJ7iF2dybf5BP7KyCyOb+kvuEbM+Tz5LFSmojjfb3aLiIwMpcePZd
	ALzP4FWYIVOP1OGJa3ZbkAJ6W1//nIOFrMkAIvChHkFlbcdEcGO+w7wJKs9ZzgoC1lgVep
	2XPLXQbbzS4AT2Oop9QsKhlZT1QdDcgEzGYzmQCGsY4zirsSHcPbb9QWIYy7gg==
ARC-Authentication-Results: i=1;
	rspamd-7bd68c5946-vwsx5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Exultant-Stretch: 2cb3d65d6964c8a5_1669946949419_331043249
X-MC-Loop-Signature: 1669946949418:1109263677
X-MC-Ingress-Time: 1669946949418
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.138.39 (trex/6.7.1);
	Fri, 02 Dec 2022 02:09:09 +0000
Received: from offworld (unknown [104.36.25.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4NNbwN0nYYz1s;
	Thu,  1 Dec 2022 18:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1669946948;
	bh=ZEGf0dZSGTElTTBmwy85ZHKSEGx6K8XIitMKRvHd7lA=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=qQ1TMm+NboCLDR0I2LRIjg5DbGDH0h2lBxZH7vUaXsBLFvegjTIO/EOsmT5PCDpnV
	 Ygta8ZlHHZmIezzZmSot9+W380OAHkqkB18m7+Gg5fpfzrxLSON7n/xfsM9DoeonxK
	 LmYj0hj8gHF5iRV42dL57llZoYw351vEhOGpPFqzLgdo+cWQk9EkImUJY2eg+qQMJP
	 OSEC/ABR6gPTqXDlSEstHDMc5cUBffKV26erqyKEbJgndOao30IvEMMWmh8Pzp2H19
	 GwhV25ian8JUstRdIL+PufhLHbS9fcphS97W2L7XyiqpYdiYV9UsgyZpQIWBAFO2Sg
	 XSB6Je020S7EQ==
Date: Thu, 1 Dec 2022 17:45:23 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, stable@vger.kernel.org,
	Jonathan.Cameron@huawei.com, dave.jiang@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/5] cxl/region: Fix missing probe failure
Message-ID: <20221202014523.twkiqa3ewkhp6zdb@offworld>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: NeoMutt/20220429

On Thu, 01 Dec 2022, Dan Williams wrote:

>cxl_region_probe() allows for regions not in the 'commit' state to be
>enabled. Fail probe when the region is not committed otherwise the
>kernel may indicate that an address range is active when none of the
>decoders are active.
>
>Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>---
> drivers/cxl/core/region.c |    3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>index f9ae5ad284ff..1bc2ebefa2a5 100644
>--- a/drivers/cxl/core/region.c
>+++ b/drivers/cxl/core/region.c
>@@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
>	 */
>	up_read(&cxl_region_rwsem);
>
>+	if (rc)
>+		return rc;
>+
>	switch (cxlr->mode) {
>	case CXL_DECODER_PMEM:
>		return devm_cxl_add_pmem_region(cxlr);
>
