Received: from aye.elm.relay.mailchannels.net (aye.elm.relay.mailchannels.net [23.83.212.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644AFC13A
	for <nvdimm@lists.linux.dev>; Fri, 25 Aug 2023 09:09:13 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B0124360BA2;
	Fri, 25 Aug 2023 02:24:40 +0000 (UTC)
Received: from pdx1-sub0-mail-a275.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id E790336086B;
	Fri, 25 Aug 2023 02:24:39 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1692930280; a=rsa-sha256;
	cv=none;
	b=AwnIHM8o2JXSxn+u5npIRQId+eUv9weU1YSFQdB6uedqjyIWIys8P9mr2pBzCDIlX7wKwt
	EbfG3cmWYrUcYWPgJpa8sFpte4dJxP8EgkcciSfdHedz9bEzLKp4pswiWZG23JLWICOd1g
	R7Am5YI3exMhKY0gWfQxwIDC7QfQwbl83V+cz3vmGzXEn3U1fXSdom1JTwd+ob/4M0Pb7z
	zB13Gxys0L9W3kgmXtkcbUEbn8RQ2sI301IC0PIz1kSGtJWab3XWM6h5ymiXtEuiQDBrlI
	CAy3EY+qTmyQo1RehYGCKK3iKbK57HAjOFVjaptLkRMP3ECzqwBJD1zUHUBbEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1692930280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FiUY95G6f/ePFrHgwjnmP4RiCp7+rjLMxL3mVpMY7E=;
	b=u7cGFvkAZWC9LbOAVKNEpqCGGYQZMhiL0gWMr7919yQmzx4wDRYQKxamdzetIlCJv09gpy
	pFFNpUKNtFrVHFQ9wNAgTBGI5ZjBd6+LSWptOqiJeB5AphiA2f0ymCQh3rzKLIObwwreBU
	uNJa4yyk8AcimMCcDa5Xcx7Xwx/Yhjm5SzeliSdUZKN8MI/AZbQTCWoluJUKsbeWNCUoa3
	IBCVgC/CJ0AxgO1r4XxqRzpaSW4dMN03jnrQczAAM5WZH/z5tflx0Ma5crpnmUnT+KYCm4
	kSrYRz33QSzIhZlCIg/YFFPliT/zazC+rYXMN594ITH+3ohAvm10CJ/xyVI0UA==
ARC-Authentication-Results: i=1;
	rspamd-749bd77c9c-xbks5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Trail-Irritate: 452a0a641a141cb9_1692930280511_2720139096
X-MC-Loop-Signature: 1692930280510:1481878772
X-MC-Ingress-Time: 1692930280510
Received: from pdx1-sub0-mail-a275.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.4.182 (trex/6.9.1);
	Fri, 25 Aug 2023 02:24:40 +0000
Received: from offworld (unknown [104.36.30.210])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a275.dreamhost.com (Postfix) with ESMTPSA id 4RX3gW1DT5z76;
	Thu, 24 Aug 2023 19:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1692930279;
	bh=9FiUY95G6f/ePFrHgwjnmP4RiCp7+rjLMxL3mVpMY7E=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=oGoe0RB4l6BsbgfBXao3OUHBGaZnG9a4yUt60xQuelNXBzVczjnZsKwju+wq6ZjEp
	 UEb08gucKnkBO7p4LoxUUqAFNyNSXpErU5D6Tm/CAij2kwq4oql7G/M5TY2KStV4mw
	 mfQqTS/M2uoqpQPXE1gP00ztllc6hrg26kPlUuyFbXcZQIPBoh5r/osJot93nE4zuT
	 8819aaMtF4BTxE/GgP0ZIuHBC+wTh/GsHaIrSjL2e1nG7l3kcOwZFd+Wzpq8rwpNkZ
	 4OfgIZNmGmO5DuVFvRwc83Mu3650J3Wxoe5bgFDV16fmKY8ARFWDNaDsT+2bL+i/N5
	 ROfOtaY4UAntw==
Date: Thu, 24 Aug 2023 18:45:38 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jehoon Park <jehoon.park@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Kyungsan Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 1/3] libcxl: Update a revision by CXL 3.0
 specification
Message-ID: <rqppgl33vfd3hprnvqfxnr27iv2mwxnsom27yyttyhowfepiry@yurvfa4bk6jp>
References: <20230807063549.5942-1-jehoon.park@samsung.com>
 <CGME20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998@epcas2p4.samsung.com>
 <20230807063549.5942-2-jehoon.park@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230807063549.5942-2-jehoon.park@samsung.com>
User-Agent: NeoMutt/20230517

On Mon, 07 Aug 2023, Jehoon Park wrote:

>Update the predefined value for device temperature field when it is not
>implemented. (CXL 3.0.8.2.9.8.3.1)
>
>Signed-off-by: Jehoon Park <jehoon.park@samsung.com>

With Jonathan's feedback in the changelog,

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>---
> cxl/lib/private.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/cxl/lib/private.h b/cxl/lib/private.h
>index a641727..a692fd5 100644
>--- a/cxl/lib/private.h
>+++ b/cxl/lib/private.h
>@@ -360,7 +360,7 @@ struct cxl_cmd_set_partition {
> #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
>
> #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
>-#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
>+#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
>
> static inline int check_kmod(struct kmod_ctx *kmod_ctx)
> {
>--
>2.17.1
>
