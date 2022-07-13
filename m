Received: from hamster.birch.relay.mailchannels.net (hamster.birch.relay.mailchannels.net [23.83.209.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D397B4A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 19:21:50 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D47825A1F35;
	Wed, 13 Jul 2022 19:04:14 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5EA735A1D80;
	Wed, 13 Jul 2022 19:04:14 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657739054; a=rsa-sha256;
	cv=none;
	b=ocgqM8rHdw7CJFAVxQrOOpAqYWo+//m/rVQzdlUZ61Tbi3xJ7guK/OxYmAU6g1ds3OE/PV
	GcB2D85lM9yWIoW6XsMjZjAT3u8j6eLBMl9Zo4VjLxI8YKHQbz9VhZ+UsM5moQzMkK0w/Z
	IET901QzgDsqODeKb0CbTCdaMwh3mku2hkrgmPNyLvwvbWhopGyyhUykQRSg1z1d7ilrna
	r14Q4E44KZ75GOVojA6CU30z3+u2YgxUF6nlYzhSD/lrGstAjZHncIm3QT7+D8obahhL44
	qUxRhASDhPpAsBDYzupD6wujUI/3Zvej0WzT3Tu3Cvon/eEjX/zCtDD3f9ox/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657739054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwAbIV9GS7MUyfQ5yMD8a/0YG2yQmMOza6THyO0Yyx0=;
	b=DUwaoGyZrY1rFAJEhaPwWkWZTT8PvqXhqiDeaYtm/83yhX/JvTNTG+s+fgc8unjXZ1hPZi
	nWPWfr9mTQ3Ag49t6bQTWRP317XIZGP/P/huqRXpcdj4L+1ChRtmw3YYb08TpolemVN/pn
	xj4d9CZiMao+PpDJRT4Mkkab7eRRUF/pZ0vRKJWhIdXmsh27+e6byx5AEsbDbgDV2CVmwd
	s+hysxV/1UfRUZYFrNQK5K7jFyrLOvnEQaiGQ8H+2q7DJaWH4cUds+0dOaIatQiiBB/u2y
	lrxm57fzvCGOwLYfrzARVEb41FkQAIaKRLObcEumEiLJuFN4nQ0NAzttBy1iRw==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-fmvc6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Inform-Descriptive: 28c3465d5ec77d8c_1657739054698_1789728461
X-MC-Loop-Signature: 1657739054698:3395718113
X-MC-Ingress-Time: 1657739054698
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.115.45.52 (trex/6.7.1);
	Wed, 13 Jul 2022 19:04:14 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4Ljn994hslz7x;
	Wed, 13 Jul 2022 12:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657739054;
	bh=VwAbIV9GS7MUyfQ5yMD8a/0YG2yQmMOza6THyO0Yyx0=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=H6MQsn54ue4DlpjXbPLDMbx6S3Gj/+qp0WSs46nsOiqxkgiuj08OrQRHuSb98GSlN
	 bfH/0skyq7AtPJIHNS+oY6C9Z/UHy7cpx/n5ohsEoHdM5KuBIhpWxtCMx4U6n4uI17
	 e/zSxKaAVGQSEJbu9ooB+Z34epo8TGiayIMOyKYh2MLapqOlZKZFR1GcDGZD6ltbPL
	 mtidB1Fh9rz+I+47R64dwqZ5Z6sl6IXfv5+WZLeCK2LjRljsSOPzdEhX/f6O1GygKj
	 1/b4JgfONK8NjaMEMrouE7Pdizg8jfFGmGjAnVSTNF231oXJCOQNxFQxQbRQwlutF8
	 nw59qM8UDVPZw==
Date: Wed, 13 Jul 2022 12:04:10 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	a.manzanares@samsung.com
Subject: Re: [PATCH 1/11] cxl/list: Reformat option list
Message-ID: <20220713190410.jjggbuzwkgyakbw6@offworld>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765284992.435671.17218875214208199972.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165765284992.435671.17218875214208199972.stgit@dwillia2-xfh>
User-Agent: NeoMutt/20220429

On Tue, 12 Jul 2022, Dan Williams wrote:

>Cleanup some spurious spaces and let clang-format re-layout the options.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
> cxl/list.c |    9 ++++-----
> 1 file changed, 4 insertions(+), 5 deletions(-)
>
>diff --git a/cxl/list.c b/cxl/list.c
>index 940782d33a10..1b5f58328047 100644
>--- a/cxl/list.c
>+++ b/cxl/list.c
>@@ -36,8 +36,7 @@ static const struct option options[] = {
>		   "filter by CXL endpoint device name(s)"),
>	OPT_BOOLEAN('E', "endpoints", &param.endpoints,
>		    "include CXL endpoint info"),
>-	OPT_STRING('d', "decoder", &param.decoder_filter,
>-		   "decoder device name",
>+	OPT_STRING('d', "decoder", &param.decoder_filter, "decoder device name",
>		   "filter by CXL decoder device name(s) / class"),
>	OPT_BOOLEAN('D', "decoders", &param.decoders,
>		    "include CXL decoder info"),
>@@ -45,11 +44,11 @@ static const struct option options[] = {
>		    "include CXL target data with decoders or ports"),
>	OPT_BOOLEAN('i', "idle", &param.idle, "include disabled devices"),
>	OPT_BOOLEAN('u', "human", &param.human,
>-		    "use human friendly number formats "),
>+		    "use human friendly number formats"),
>	OPT_BOOLEAN('H', "health", &param.health,
>-		    "include memory device health information "),
>+		    "include memory device health information"),
>	OPT_BOOLEAN('I', "partition", &param.partition,
>-		    "include memory device partition information "),
>+		    "include memory device partition information"),
> #ifdef ENABLE_DEBUG
>	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> #endif
>
