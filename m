Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E77815C8B
	for <nvdimm@lists.linux.dev>; Mon,  5 Dec 2022 19:54:15 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id AD2D36410D7;
	Mon,  5 Dec 2022 19:44:52 +0000 (UTC)
Received: from pdx1-sub0-mail-a218.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 332F964121D;
	Mon,  5 Dec 2022 19:44:52 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1670269492; a=rsa-sha256;
	cv=none;
	b=2ke4FJU/Gun4ChIsB8WpnB2E9P0lfhP0wsdl9am9hkD7iOfPibpD3znJ5ccLGfF6/vFXmB
	bhUigQ436WgjFxBMbAXWTWYBXSbgaXBWlqyikOptRdyQO5PX+V0nVGUOsGl7dgy9Yq7XY7
	ViBfnPc2Q0xorTWueqFFAVkFuXoHpzMQO8CSna7JIffc/5YdXcL3E+7kOo/s7VYB5Nyz2G
	YzpaKwNTv+QHVcEEkvGiaFxNhABevjOucJ18sh+rYJG/OPUKvy6mYUWSUdWvagc8TmvnTj
	+E7A0Rmer/y5X7F00bPYfweyFT4MPUChdZKjtNHwrn9btFvqTXQyGOpZwHbI1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1670269492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqN+U92L8+vPyfHj+mA9XaRgexau2UhdUetBK3hNQMk=;
	b=jtrAcW8MCztOdRx1TuVXzPzyawymL+dU6y3/fPSGRO4giQ0hkR+Ho66Kid3EdFGeh2iphr
	24bUbbCqsl1U4n7F0psSo/HZZbRtJYi+MHuUdYpCv5pupWg6nWDKCKQ0dVIJ4VpyO28d7U
	gBOBQM9GrqQU94bgkv6uirZhtUj6/boOoHZDa/WfisOeAATEjiq0zXfWnpI4e9RxRNQxzu
	i+eDP5sllN0tY2sHpEeQcCKMefsw6zLDBM3ajbxtlIMfX5VKoJ4k5WvZS2I+4mRgEbgZYd
	/WSlNBj7JAXv2lRMAZ9Xz8rko9kbPOadGTOl1SMuBK/85Pyjy5hz4N3/ajRi0A==
ARC-Authentication-Results: i=1;
	rspamd-7bd68c5946-dtxhm;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Blushing-Madly: 105b53433fe5c3f7_1670269492496_2829289219
X-MC-Loop-Signature: 1670269492496:2332268954
X-MC-Ingress-Time: 1670269492496
Received: from pdx1-sub0-mail-a218.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.227.191 (trex/6.7.1);
	Mon, 05 Dec 2022 19:44:52 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a218.dreamhost.com (Postfix) with ESMTPSA id 4NQvC72ZHsz27;
	Mon,  5 Dec 2022 11:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1670269491;
	bh=fqN+U92L8+vPyfHj+mA9XaRgexau2UhdUetBK3hNQMk=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=fmGYVrY4HWSlBPKjm8YXPyIaOjrngJu/dJiD33PvqYA9XMVAnbZM3ZD2e/igG2kQR
	 MfWR8RtPr4q7Vj8rKGnlYVNOollrkYaCphzqBF5FBbliUPNVQxdu1dGsiUjDkVytQM
	 cOHhMgBAA4rmQZlbDnRHoIMr8jVfA4QGkhko5u1Lmwnz1M+xGhg8G2+r6C9QW2m6uK
	 Powmw+z36O9Uqg2C1Oot1Pl3eKzBTXy6gIaAQW3g8CgUOHw4ZDDRWWbzfxLtfsTUZj
	 XxMRFTrko2d4Iz4tkXMJ15uTjVmbMYYx00/9wfA/7pFUPXwA85XdQ2UTqGeyrWBs/j
	 dZj0MnKpl806g==
Date: Mon, 5 Dec 2022 11:20:54 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Jonathan.Cameron@huawei.com,
	dave.jiang@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 5/5] cxl/region: Manage CPU caches relative to DPA
 invalidation events
Message-ID: <20221205192054.mwhzyjrfwfn3tma5@offworld>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993222098.1995348.16604163596374520890.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166993222098.1995348.16604163596374520890.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: NeoMutt/20220429

On Thu, 01 Dec 2022, Dan Williams wrote:

>A "DPA invalidation event" is any scenario where the contents of a DPA
>(Device Physical Address) is modified in a way that is incoherent with
>CPU caches, or if the HPA (Host Physical Address) to DPA association
>changes due to a remapping event.
>
>PMEM security events like Unlock and Passphrase Secure Erase already
>manage caches through LIBNVDIMM,

Just to be clear, is this is why you get rid of the explicit flushing
for the respective commands in security.c?

>so that leaves HPA to DPA remap events
>that need cache management by the CXL core. Those only happen when the
>boot time CXL configuration has changed. That event occurs when
>userspace attaches an endpoint decoder to a region configuration, and
>that region is subsequently activated.
>
>The implications of not invalidating caches between remap events is that
>reads from the region at different points in time may return different
>results due to stale cached data from the previous HPA to DPA mapping.
>Without a guarantee that the region contents after cxl_region_probe()
>are written before being read (a layering-violation assumption that
>cxl_region_probe() can not make) the CXL subsystem needs to ensure that
>reads that precede writes see consistent results.

Hmm where does this leave us remaping under arm64 which is doesn't have
ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION?

Back when we were discussing this it was all related to the security stuff,
which under arm it could just be easily discarded as not available feature.

Thanks,
Davidlohr
