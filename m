Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=23.83.218.252
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793738942;
	b=KBZBIXjgtx5iV5dbTtXYIDxcv/lnZsBgpe3+MR8PF4+InLQH88RfCssj68XPtYrQJhFq
	 VRB1Xlp/MyVFb5dtgxgqC3j8cCJl7o9OmHkVw7yVeCJ0Q8WGUd56mSQ2W3kB6YNtjKsZB
	 fuoox/zhrGi9A0Sds1jYByUm80H5Q4mbBHIAriDhwxtf93yE3N9c+oFcaZmX9ptXYj8cg
	 NnXW0RlsBWNKinkVDoKrgadM6XfVtK/jhCV390/aPmlxuI21YnwS2oc0rdE6kMbPlirDJ
	 H9wtIeWWcbhUU2D01aAAsd1PcNmV5Hfs2JYqGQ4u7AIatb3N9pxTrdK5rNoaCmmb4hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793738942;
	h=DMARC-Filter:X-Sender-Id:Received:Received:X-Sender-Id:X-MC-Relay:
	 X-MailChannels-SenderId:X-MailChannels-Auth-Id:X-Spill-Robust:
	 X-MC-Loop-Signature:X-MC-Ingress-Time:Received:Received:
	 DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=CixWyglPjJq+NuYBAuybNSUrDT7S8FVzUuoegqk0l5g=;
	b=ytW7qK4e/aretlgCk49H/axCq9I9i5d7Yc6dG1XM9GujI/rfJOGU244yi6Q/sRwfYWeM
	 qVgMTQRe7YCwLjwt7cnbmisxOdkyNo1kcJ5xkhy3Pwsyoh2N2Q8eCZ9NioTRX3wTvV5k9
	 ih5vZf/wuftUJVMap2odY8IFCDU9LUa05FXMd9AYkvBE4ZEfQyBa0VM83mR/ucAM9TPc2
	 PgAZThS/e4hGP5q9PNNc4GCvj79MJZKJXkCiyG52bwrsrKdhgSN4cVWjkkQTwFzVVkavX
	 VOM0rOpUjuKFb357xJYPLd1EBES/2CDLDSh5XTscyBquAryJB9Sdf+kopsfMiJPJNnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stgolabs.net;
	spf=fail smtp.mailfrom=stgolabs.net;
	dkim=pass header.d=stgolabs.net header.i=@stgolabs.net header.a=rsa-sha256 header.s=dreamhost header.b=b8zCEMv9;
	arc=none smtp.remote-ip=23.83.218.252
Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4630606A31B
	for <nvdimm@lists.linux.dev>; Tue,  3 Nov 2026 20:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4630606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stgolabs.net header.i=@stgolabs.net header.a=rsa-sha256 header.s=dreamhost header.b=b8zCEMv9
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 885DE4C1392;
	Tue, 03 Nov 2026 20:48:55 +0000 (UTC)
Received: from pdx1-sub0-mail-a249.dreamhost.com (trex-green-2.trex.outbound.svc.cluster.local [100.99.192.246])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2EA7C4C0C00;
	Tue, 03 Nov 2026 20:48:55 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Spill-Robust: 300bfe26607bd16d_1793738935457_4122454896
X-MC-Loop-Signature: 1793738935457:1005928785
X-MC-Ingress-Time: 1793738935457
Received: from pdx1-sub0-mail-a249.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.192.246 (trex/8.0.2);
	Tue, 03 Nov 2026 20:48:55 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a249.dreamhost.com (Postfix) with ESMTPSA id 4jK0zV1BM8zymd;
	Tue,  3 Nov 2026 12:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1793738934;
	bh=CixWyglPjJq+NuYBAuybNSUrDT7S8FVzUuoegqk0l5g=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=b8zCEMv9bhNCGM1tlmBK2EMLJBD1rcF1sm/u/EJTNNWWz3OG1iX9Mq2VL/ghE/4ch
	 eqIGuBDuWjE/XvR9GDMpJYcW+YN4O6EOHwLc6oCxjxXAmxmm3my/Pm9mfPSUeqD+r8
	 8LymCeE1FL+poryrkmBlBe40sOxdEo61oLWoduxYafry4p5ZKyL+1KoaggZy1x3tnR
	 MPUBnvbI4fmY65BFuS1xCcROWODExD4KaFCSJLB4WxsmSTa0PRyDNOq0FHF38KFrY+
	 wFO+5dUpyRyhr5qxbyRbWNgFPjJwznKh18a7eY4Ho1+qvk7sZ7M9bzfyY3Wq1JAdjw
	 HwXsk1TKvFPOg==
Date: Tue, 3 Nov 2026 12:48:51 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Jonathan Cameron <jic23@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Message-ID: <20261103204851.v2blzpa25xopouc6@offworld>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>
User-Agent: NeoMutt/20220429

On Tue, 03 Nov 2026, Dave Jiang wrote:

>Dan is no longer with us. Removing entries in MAINTAINERS to prevent
>people from keep emailing his address.
>
>async_tx will be essentially orphaned. There has been discussion of
>deprecation for the feature on the dmaengine mailing list.
>
>fsdax will no longer have a maintainer. But there are reviewers still
>and Alison Schofield will continue to wrangle patches for DAX overall.
>
>Cc: Alison Schofield <alison.schofield@intel.com>
>Cc: Vishal Verma <vishal.l.verma@intel.com>
>Cc: Matthew Wilcox <willy@infradead.org>
>Cc: Jan Kara <jack@suse.cz>
>Cc: Davidlohr Bueso <dave@stgolabs.net>
>Cc: Jonathan Cameron <jic23@kernel.org>
>Cc: Vinod Koul <vkoul@kernel.org>
>Cc: Frank Li <Frank.Li@kernel.org>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Thanks for sending this.

Acked-by: Davidlohr Bueso <dave@stgolabs.net>
