Received: from butterfly.birch.relay.mailchannels.net (butterfly.birch.relay.mailchannels.net [23.83.209.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3414A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 19:34:42 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 94B84762338;
	Wed, 13 Jul 2022 19:16:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 931D5761A62;
	Wed, 13 Jul 2022 19:16:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657739818; a=rsa-sha256;
	cv=none;
	b=7swGmr6wWrYfANjqQEDglFawlhjnO//W+U/GG40RJoZgH3ex+DQXNj2CqcenuiBwEPkQof
	y2QmSWsR2euwzMdHs89Ue9OKCqBLYUB1MzDLzJkW9HGqAo8uah/M9mXmAmrzRDbOpPtd7C
	5oFmLWq3H6nNoSIGCZMdtpz2BrxBCsZg/AIEtRMoJv2apMwpgCuNu2KFpzZCKz2TnROS4T
	qrkZId4L8cHi+tPhWKH8aFHZNWd2KhTkjgY0reR2LzmiBfAqozP4pCyU8RUWs7y2z2auWT
	zUI/B+yqJQtm0huqbsjZTIn/Y7eYASBNgrhqBJB6Ay9Fe7pvmzJcb3/S6HDljQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657739818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtnrY32R/+9mZ5YrSCLWOQYYgorISzcRRnbF1Zo+g+E=;
	b=BNiKPz4jkcmA8+To5gkFNoPPryyZd7RgTozsyEUHeW4AIAodzXXoVdrPPXoDfRUxIhTIyS
	H4OMxOIEBzqOxqpEwjDnjltKJrx9Y0CEpEqiN7p6ZxrPjgq2zdz3FE7l9wkjeuTNB4xCGR
	FGltCRnLlVzqJrDFzY6lVZ3Dw9icd3JVn4QeB2ck3vQjOr3jzPEUVZEYpsj/saCIydnzcR
	Q9END5Ut94bAlwiAo1nFCHKaD+6jS0tbsspcXiEl9SkrVgXkySAIU6cAPru9qNSHp6DDwO
	BfKm+S+BmmgS8TIlXRW6d3yjbou66flE24PyXZaYNG1u9+iPik+MOxE+8Z5QSg==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-wjhnl;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Stupid-Spicy: 110651c164c1c2ba_1657739819093_3217146296
X-MC-Loop-Signature: 1657739819093:3798450868
X-MC-Ingress-Time: 1657739819093
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.67.142 (trex/6.7.1);
	Wed, 13 Jul 2022 19:16:59 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4LjnRs6nhNz7x;
	Wed, 13 Jul 2022 12:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657739818;
	bh=KtnrY32R/+9mZ5YrSCLWOQYYgorISzcRRnbF1Zo+g+E=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=pAZDauZForcRkhAYRR5u6ADLflwGS22TprIAH/i2tbUibLVxpQCHgwQ5YsetH3X2u
	 e1mBa2AHpF+BXYxcNUbc+7dQm+Ze4H7rprhI/wQyTAG9RY1pc3D1Jn7bkKdKHJ1DJ2
	 rHs8+p3AgnrSGMoYz5tW+X4RZT5KJyVtk0SJ6laAz1nFCT6e+JuPRMzkK7TPoupRji
	 BdEe8QuQMJ/cOV4/TP/AzQ1d6rJhz+Etwd3Gj45g7TT+WEmj2ciLHC8lSb1sEBV0mu
	 OA5nh4DW3yLwwDsCV7yvcowIc0sDn+vp+p8lzizP422Av+YBiwO6kiTPATvQHxWfCH
	 zaxPwnNCggu5g==
Date: Wed, 13 Jul 2022 12:16:54 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	a.manzanares@samsung.com
Subject: Re: [PATCH 3/11] cxl/list: Hide 0s in disabled decoder listings
Message-ID: <20220713191654.olqymzpyl5n62jft@offworld>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765286159.435671.9172753303612160309.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165765286159.435671.9172753303612160309.stgit@dwillia2-xfh>
User-Agent: NeoMutt/20220429

On Tue, 12 Jul 2022, Dan Williams wrote:

>Trim some redundant information from decoder listings when they are
>disabled.
>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
> cxl/json.c |   12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/cxl/json.c b/cxl/json.c
>index fdc6f73a86c1..a213fdad55fd 100644
>--- a/cxl/json.c
>+++ b/cxl/json.c
>@@ -442,7 +442,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>	const char *devname = cxl_decoder_get_devname(decoder);
>	struct cxl_port *port = cxl_decoder_get_port(decoder);
>	struct json_object *jdecoder, *jobj;
>-	u64 val;
>+	u64 val, size;
>
>	jdecoder = json_object_new_object();
>	if (!jdecoder)
>@@ -452,21 +452,21 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>	if (jobj)
>		json_object_object_add(jdecoder, "decoder", jobj);
>
>+	size = cxl_decoder_get_size(decoder);
>	val = cxl_decoder_get_resource(decoder);
>-	if (val < ULLONG_MAX) {
>+	if (size && val < ULLONG_MAX) {
>		jobj = util_json_object_hex(val, flags);
>		if (jobj)
>			json_object_object_add(jdecoder, "resource", jobj);
>	}
>
>-	val = cxl_decoder_get_size(decoder);
>-	if (val < ULLONG_MAX) {
>-		jobj = util_json_object_size(val, flags);
>+	if (size && size < ULLONG_MAX) {
>+		jobj = util_json_object_size(size, flags);
>		if (jobj)
>			json_object_object_add(jdecoder, "size", jobj);
>	}
>
>-	if (val == 0) {
>+	if (size == 0) {
>		jobj = json_object_new_string("disabled");
>		if (jobj)
>			json_object_object_add(jdecoder, "state", jobj);
>
