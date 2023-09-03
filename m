Received: from dragonfly.birch.relay.mailchannels.net (dragonfly.birch.relay.mailchannels.net [23.83.209.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCD7F
	for <nvdimm@lists.linux.dev>; Sun,  3 Sep 2023 04:26:42 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EAF586C127F;
	Sun,  3 Sep 2023 03:50:02 +0000 (UTC)
Received: from pdx1-sub0-mail-a204.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 640246C12A5;
	Sun,  3 Sep 2023 03:50:02 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1693713002; a=rsa-sha256;
	cv=none;
	b=Y4fACaP6aCvIbHOcmLIIqeKY4qCnOO3qvjTF/gRN0moDmnIvbZDZD4pEXEdtbjpZfWUrhJ
	wnT7LWao7I2l5vse+Ts46I9r/RmRR7wxDbm13hzniXoExV11BYs9Tt4QcMvUZmnPBu4GGt
	1MPxfFmj7j5/obeJrk7LHx2KwWLs99garVorLWCKtg/If5GLX3yi3R5mMmmJz7h8Sqk5K7
	/pa+M0swmoGTskxhL30aLQUUU8W82/g+BfG+V9bQFyknJpK4yQfDkvNJKh8gzncR4w39sW
	20CjrRoKL/uPay0S65tK4f8pLznGEQ3LJxPWZXrB1wmIcn5BsIQMrwRaQFTnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1693713002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BePsC7rFaxjbn23KRwb5OCVn4of5KL0WDjwgjNX36Bw=;
	b=53yOOWINlOchZF8h2yU4JPiadGUtoCTRa5VHp5Df5dApN59HbaXh5yP+feAA6wX2zR34js
	oeTgS91zyPk+qNa1arIuvSp89QwtiLIMgW4+pj5ppcyTUXYDX2kUe6qCqmSsogdwDgUs6g
	k8K4X+MZ4cpGKgXU0RXQoywy0BE7nlGbbphmY5ynokEmWh35K0K9HBQHrjcSVrLkd7nqmr
	/ky8cIp5w6JVHkTQNn0R2ce2RMQwZpFBpDx3i0TsL76QfeHW6jCImAWrgX6eBTtkJkdwHb
	uD/7uzbQR3flVtJbzv+pb55jklfGDUPCprCZFvO+DtI3tBl8DYfwuNEwsaVkcw==
ARC-Authentication-Results: i=1;
	rspamd-6fd95854bb-gnmmw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Eyes-Stupid: 61834c4156dc80d6_1693713002709_1766917109
X-MC-Loop-Signature: 1693713002709:2676728161
X-MC-Ingress-Time: 1693713002708
Received: from pdx1-sub0-mail-a204.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.46.210 (trex/6.9.1);
	Sun, 03 Sep 2023 03:50:02 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a204.dreamhost.com (Postfix) with ESMTPSA id 4Rdd7s3DfxzHr;
	Sat,  2 Sep 2023 20:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1693713002;
	bh=BePsC7rFaxjbn23KRwb5OCVn4of5KL0WDjwgjNX36Bw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=E5DAckcfPowuqaISs42CZ6taKeE++Jea6Cc5SznrGFN1tlvgb8ZL+wMyOSgQgTIZY
	 Zf6rmDcx2xGq4oqUGLf56HIV7GQkWmpI+xMtU9MKAs4GFOaWyAInznyi4Gi3w93es6
	 RrAhWGFrBEUKFpydMTvEZ4EIKLhfaRByVUN0Roi3V1wCQzDD21LgLfUBbRRH18+Bzw
	 nbxTbohGzAQW2iIHgMjfzjdqoVuc7IiR26B4IaStKMOu+RWgNWjyZm9nt7Qy0uhZab
	 eb8lQERclSvRT+7oThHXd6mRf0dDjwf/IN5nRlCaUzYLTpQMTLgyi8tsyDAhn7gPNJ
	 ScEtlahskN/Bw==
Date: Sat, 2 Sep 2023 20:49:58 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jehoon Park <jehoon.park@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Kyungsan Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 2/2] cxl: add 'set-alert-config' command to cxl
 tool
Message-ID: <v76symilqy5onz6n3y7e47r5xqpaf53nunbb5kz2pcesvjocw7@42o6dotjncu5>
References: <20230807063335.5891-1-jehoon.park@samsung.com>
 <CGME20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a@epcas2p2.samsung.com>
 <20230807063335.5891-3-jehoon.park@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230807063335.5891-3-jehoon.park@samsung.com>
User-Agent: NeoMutt/20230517

On Mon, 07 Aug 2023, Jehoon Park wrote:

>Add a new command: 'set-alert-config', which configures device's warning alert.

The example in the cover-letter should be here and also mention explicitly that
the get counterpart is via cxl-list -A, like you have in the manpage.

>
>Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
>---
> Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
> Documentation/cxl/meson.build              |   1 +
> cxl/builtin.h                              |   1 +
> cxl/cxl.c                                  |   1 +
> cxl/memdev.c                               | 220 ++++++++++++++++++++-
> 5 files changed, 318 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/cxl/cxl-set-alert-config.txt
>
>diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
>new file mode 100644
>index 0000000..c905f7c
>--- /dev/null
>+++ b/Documentation/cxl/cxl-set-alert-config.txt
>@@ -0,0 +1,96 @@
>+// SPDX-License-Identifier: GPL-2.0
>+
>+cxl-set-alert-config(1)
>+=======================
>+
>+NAME
>+----
>+cxl-set-alert-config - set the warning alert threshold on a CXL memdev
>+
>+SYNOPSIS
>+--------
>+[verse]
>+'cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]'
>+
>+DESCRIPTION
>+-----------
>+CXL device raises an alert when its health status is changed. Critical alert
>+shall automatically be configured by the device after a device reset.
>+If supported, programmable warning thresholds also be initialized to vendor
>+recommended defaults, then could be configured by the user.
>+
>+Use this command to configure warning alert thresholds of a device.
>+Having issued this command, the newly requested warning thresholds would
>+override the previously programmed warning thresholds.
>+
>+To enable warning alert, set both 'threshold=value' and 'alert=on'. To disable
>+warning alert, set only 'alert=off'. Other cases would cause errors.

So what's the point of having to use double parameter to enable the warning?
Just do alert=threshold if you've established that threshold=N and alert=off is
not valid.

>+
>+Use "cxl list -m <memdev> -A" to examine the programming warning threshold
>+capabilities of a device.
>+
>+EXAMPLES
>+--------
>+Set warning threshold to 30 and enable alert for life used.
>+[verse]
>+cxl set-alert-config mem0 -L 30 --life-used-alert=on
>+
>+Disable warning alert for device over temperature.
>+[verse]
>+cxl set-alert-config mem0 --over-temperature-alert=off
>+
>+OPTIONS
>+-------
>+<memory device(s)>::
>+include::memdev-option.txt[]
>+
>+-v::
>+--verbose=::
>+        Turn on verbose debug messages in the library (if libcxl was built with
>+        logging and debug enabled).

Should be at the end.


Thanks,
Davidlohr
