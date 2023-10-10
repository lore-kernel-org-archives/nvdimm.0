Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDFE7F0
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 05:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="ORbCy4L2"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 718DB7A0839;
	Tue, 10 Oct 2023 03:14:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a235.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id DBFFA7A05A2;
	Tue, 10 Oct 2023 03:14:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1696907646; a=rsa-sha256;
	cv=none;
	b=A/Z8sEwti3/SPs5vocSXRM6xxAMXwMVljA9faKekI0DmYvo12hrHBIj89i3xvtjhhM6r0g
	rP0rWXg3Bo51MYZgfgzAM7eiO5Qy+Ga6Rsq3E+GdyXJdFgmQ4eXbW9A/ybD4FxcggI/3Xh
	ZV936LEWsr8WrpTe6dNhh0i9VAr172R+u26yxh0YPR0yIpB258Af3R80UqzX2htn7+CUX2
	B0O3ZkcEvZUCn5g9n3n2EBMVSO9RVuNlSB2h8R4QitKh7tU46GZoaYLIT7IAomiUK9uvBI
	6S/djxN8DtzFSZXmaa/yVR1thPg/+b8ZInDgijAi3tfdfJOlwpfl362WljEQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1696907646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+SZN67++GyUSiUcgaw3Eqe/dc3FXjQ0GRoUofM930w=;
	b=4/RRscuosMMpJUug0T26V+UN6BqjxcFM9OHL43ug3/MyMGv7n0VypzrF96+9fz+V1wgMeg
	EZ9QOjP75a89g1Ock9PBR0J4SiT7nxRQNF28b25BIlJ4u1wJEmPEDMGqHf8bkzTb4G5ygP
	MK0K5/z8X/PuDXgx/IcqC0ZOqqpU0DaDOJx+yA+yGVCrHYgGU9Anan9L0lLFlEHF2hXjwg
	IDPkEwdYoK3MH8jCtsgp4fcHBZEcT/voRAStOAGyBNBVpksiRNXX1r2x8iplyMq7S6Gm7Q
	GEjXPXtJtM9APGCDxuPVmyyOjBTkAfFN67vOi+BDq2+xh0Oixe6CHRzHRnIF5A==
ARC-Authentication-Results: i=1;
	rspamd-7c449d4847-7psdc;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Oafish-Industry: 2a4356147b765099_1696907646257_2743175540
X-MC-Loop-Signature: 1696907646256:3500760118
X-MC-Ingress-Time: 1696907646256
Received: from pdx1-sub0-mail-a235.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.135.46 (trex/6.9.1);
	Tue, 10 Oct 2023 03:14:06 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a235.dreamhost.com (Postfix) with ESMTPSA id 4S4LbK0pHFz2D;
	Mon,  9 Oct 2023 20:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1696907645;
	bh=H+SZN67++GyUSiUcgaw3Eqe/dc3FXjQ0GRoUofM930w=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=ORbCy4L2D6Y4pS15KZgycoVT17KzfEBeF0zfvDA8C17Y2p1vOnYB5e3CT9Ffd2FcC
	 TCTE+jZi+8FImt5sBmRDEI9vW45OLLVziddpun6L4iZUosw6KIZHUeMu9MB9EtQzAE
	 FltbOppnNSWlMspN3ItH5/X0wMREPQOCu54tzfGWTmSDoiJYX2iZhNG1QaSFdhS2yw
	 MiKEomyHafFHwxSOiNv80FAhwsfVs18qH8d9VfGCiYZ6fO2RNHQLYhQgARaVP3rASJ
	 hecgjB9SGUG9bu8W21gW01AqSYkommsD07EMCUBKZWp6r4+y4UVFe0fskRUMHExdmJ
	 w93CryJnt/6uQ==
Date: Mon, 9 Oct 2023 20:14:02 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jehoon Park <jehoon.park@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Kyungsan Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v3 0/2] add support for Set Alert Configuration
 mailbox command
Message-ID: <3qqfaoruluq7jd2cnz4mhpq632wov5x7cfizuarlfyjedkwi5v@aimuecxmqgvy>
References: <CGME20230918045208epcas2p36f0c80940e86e5165a3036414a32d7f6@epcas2p3.samsung.com>
 <20230918045514.6709-1-jehoon.park@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230918045514.6709-1-jehoon.park@samsung.com>
User-Agent: NeoMutt/20230517

On Mon, 18 Sep 2023, Jehoon Park wrote:

>CXL 3.0 Spec 8.2.9.8.3.3 defines Set Alert Configuration mailbox command,
>which configures device's warning alerts.
>This patchset adds support for the command.
>
>The implementation is based on the 'ndctl-inject-smart'. Variable and function
>names are aligned with the implementation of 'Get Alert Configuration'.
>
>Changes in v3
>- Reorganize cover letter and commit message (Davidlohr)
>- Update details of the example in man page
>- Move 'verbose' option to the end in man page (Davidlohr)
>- Link to v2: https://lore.kernel.org/r/20230807063335.5891-1-jehoon.park@samsung.com
>
>Changes in v2
>- Rebase on the latest pending branch
>- Remove full usage text in the commit message (Vishal)
>- Correct texts in document and log_info() (Vishal)
>- Change strncmp() to strcmp() for parsing params (Vishal)
>- Link to v1: https://lore.kernel.org/r/20230711071019.7151-1-jehoon.park@samsung.com
>
>*** BLURB HERE ***
>
>Jehoon Park (2):
>  libcxl: add support for Set Alert Configuration mailbox command
>  cxl: add 'set-alert-config' command to cxl tool

Looks good, for the series feel free to add:

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
