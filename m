Received: from antelope.elm.relay.mailchannels.net (antelope.elm.relay.mailchannels.net [23.83.212.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A61A46
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 06:13:45 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 5D7EE21F49;
	Mon, 18 Jul 2022 05:34:57 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B009D21EF1;
	Mon, 18 Jul 2022 05:34:56 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658122496; a=rsa-sha256;
	cv=none;
	b=GpR0aY9RITC8plMQ3GAnkODcSGydKEVKuUwhQ9gCiPEO8/S7PlPJM6qBdSMqoCH6FT83Be
	wdmnQWWYCMQcijscXTndti3qc0AnYVDAuCdm/qEYaTdkUSVnpiCYlsaFh5DDawesXBDmrf
	meipPAEkJv7x6UsGeKSiPwFYIBnRo474H/WbAzZAOYy5z6qjaOFlvFEhmvDZ4EkfeuPp0f
	NvZJKJCEhK0R+1TZDSLDRK+V1UYEF6cTd9XwTrA70N7qR74J+UWRhajB8UAIZaBRTO3GEO
	Vz4As5qby6polv+JIzWT/Y33oVRW59rwAlKEJqLYsc4wlWaIYoV07jM+ej7TBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658122496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7p32pyhlwYNPQPxZWq9NBe05dDDwYC3kOsylo6MJT4=;
	b=q6Xz18aAvXuSjT1t3P554HYqZToXhyqE3BLvLtHYNmgA+Uh4b3lcMV18Lg3lhJNeeEUqZ3
	smrUdEJyrl69rYNDXYwxov5do4gUHNA97RD/xfMT4LSYYwI3zrUflQVwd0E8bpsN8j8PGx
	H9zgP231guEQHgubfpVNZU8xI809BRkhgWSwrdU1O96dYvK5srpwgL+I/PvQp5yS4buNQG
	CtmUWKapWWWEh5c6c2vVmNPEnnz3N5LyH0pxZOxIsh66M6eMBuHF5qXtKJpq5dgvlhINNX
	16AQG8NhM3/vsAb16nY37HEuNAYM66ZUNoe/zP2caoAyE0WQk9bD+jO7q5tS2A==
ARC-Authentication-Results: i=1;
	rspamd-674ffb986c-sh5xl;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Turn-Whispering: 1f9a2e2857271bfa_1658122497072_4130917283
X-MC-Loop-Signature: 1658122497072:2885307300
X-MC-Ingress-Time: 1658122497072
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.161.109 (trex/6.7.1);
	Mon, 18 Jul 2022 05:34:57 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4LmVz14JV3zF4;
	Sun, 17 Jul 2022 22:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658122496;
	bh=c7p32pyhlwYNPQPxZWq9NBe05dDDwYC3kOsylo6MJT4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=eny7Xr+SOe1K6ReIAcDTpoPNlTLbE57OcgsWTBKlcS+H/BRAnjhYa8cV9eEfM99k5
	 SiEvBoL52n01JTkmIGVlBwCbPMLwgQwyJbnlsqgJsjcJ0wjVVv8levV64kjqj2PHbu
	 OJIo76ZESPnqMZIIEao4RMoBPdInDN5921/P/4Q2fMlK8HOYfchoQeADujVLXU3kRU
	 nNvF0Je1NtfSLoygUM74gErCBtDVuQ1nyLysQrCaoT2lBuojJjT6hVm6xX++AiTheX
	 jH5wT5IcTX0O3prYMiT7Ujqn+ztMp9oA9jpOC1DdP7mXvGzVoxF+Ba0mepd9x6gGlF
	 NbjVlU2Ul3EaQ==
Date: Sun, 17 Jul 2022 22:34:49 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com
Subject: Re: [PATCH RFC 1/15] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
Message-ID: <20220718053449.5t6mxfjoknajs5fi@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791931828.2491387.3280104860123759941.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165791931828.2491387.3280104860123759941.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Fri, 15 Jul 2022, Dave Jiang wrote:

>+++ b/drivers/cxl/security.c
>@@ -0,0 +1,57 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
>+#include <linux/libnvdimm.h>
>+#include <asm/unaligned.h>
>+#include <linux/module.h>
>+#include <linux/ndctl.h>

ndctl.h can be removed.
