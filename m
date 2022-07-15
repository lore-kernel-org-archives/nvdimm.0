Received: from hamster.birch.relay.mailchannels.net (hamster.birch.relay.mailchannels.net [23.83.209.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BE4C99
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:25:05 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C92F88224DD;
	Fri, 15 Jul 2022 21:24:58 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 431AB822466;
	Fri, 15 Jul 2022 21:24:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657920298; a=rsa-sha256;
	cv=none;
	b=FlG8tZVwa8kPTjOfSoZEjJMEvUuKKXYKd+5YQgWwAjdOSgnqaLKTT5UKD0KNyg9tj9WbIh
	dEHMlYsfS/mueKmEHqWQ6eq3TvvCFZoFXDIJedPR29UYMcmwTD0Hf62EHM43vtzzyCrdwC
	GC4p67mLQz+hzuVZNXBRcJvWDtJQJUh9yNcnhbx+YObNpN1b16dLvCpcgzDeAaxOPuiMvQ
	8Bnjsv9V94JkjKA1Dn6OyVJj5XRH93w/nRoCJX/6W0N7W+NdlaPDimf1CExYds6L1Ienw7
	uGLcr4pzP+4OC3cUL5yuOnRo8XR4Ch3E4yM0oAmUaID9GByPq1dZKMZX5UMSeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657920298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gca+rK/1/omRgEtGZGppY4fPcaCmjyddkV4hHPuKIyY=;
	b=KbR0DA744voFhWCsATz/wgXd1kf2Mq2F6xZW5W3C5zkmuYTeg7/omyJR/mMSUzeJkHULyt
	0XeeCYjHMURbcIZ57Rlj3zzvIXn1rEX2s6dSTRHhz1b/yxAah766CexOyW/R7ssYiGb92g
	QK6Um4wm+3c2KksBHAA9tfp/5dVWWr5st7JC4s0iVn6Tu9JYY6OO4QQo+D2956HBPkSQFh
	DUPTs9304n3YTbjOtCLJiQ7Fj7HVOQhZEYnQheIPnyZ3LpHvcQzjdu/dElSzeElu0dRc/s
	JKiK+jlyPh9QMhv8CH1pm1m75oCSX4681raiIE9LZyAanFk8UsGvACabeNygrQ==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-l28hj;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Wipe-Fumbling: 4b8c9124732fcad9_1657920298585_3064067684
X-MC-Loop-Signature: 1657920298585:2481239309
X-MC-Ingress-Time: 1657920298585
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.106.85 (trex/6.7.1);
	Fri, 15 Jul 2022 21:24:58 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4Ll4Bd2HZyz9g;
	Fri, 15 Jul 2022 14:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657920298;
	bh=Gca+rK/1/omRgEtGZGppY4fPcaCmjyddkV4hHPuKIyY=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=lzDJIS2jEWSIE8aTXDQbvygB8SdONXMlSw4N4kkNfqzzRWdVDRpFgzEMVHVOheWcD
	 gbLxgxsXY7AXG1Q8sSABqEautgFcarW6CmHmLpF5Vy/VC1dOCOD/DDQGF6bhCbx8nK
	 4rjVl3dTnCw859tGm9wzhRYuNqTFh2AEMO9POg/zKKO88jyLNcohLvl3Qpfxxf8WoG
	 ohMUKK3AghSiw84cF+nykGGROFo56vgBw8ASQSzmgnqilAMBaXdCDJ8b32/8iyBHSv
	 eBUkskWUk6p606b+hV026dhiRZHQbofE1SiiSrsFXrwBbEaQKgoirB5rR4vQTjvVid
	 1OH6Nhag3/f5w==
Date: Fri, 15 Jul 2022 14:09:04 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com
Subject: Re: [PATCH RFC 01/15] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
Message-ID: <20220715210904.bwqbahyya7kwixim@offworld>
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

>+config CXL_PMEM_SECURITY
>+	tristate "CXL PMEM SECURITY: Persistent Memory Security Support"
>+	depends on CXL_PMEM
>+	default CXL_BUS
>+	help
>+	  CXL memory device "Persistent Memory Data-at-rest Security" command set
>+	  support. Support opcode 0x4500..0x4505. The commands supported are "Get
>+	  Security State", "Set Passphrase", "Disable Passphrase", "Unlock",
>+	  "Freeze Security State", and "Passphrase Secure Erase". Security operation
>+	  is done through nvdimm security_ops.
>+
>+	  See Chapter 8.2.9.5.6 in the CXL 2.0 specification for a detailed description
>+	  of the Persistent Memory Security.
>+
>+	  If unsure say 'm'.

Is there any fundamental reason why we need to add a new CXL Kconfig option
instead of just tucking this under CXL_PMEM?
