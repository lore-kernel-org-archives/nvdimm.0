Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091DABA51
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 22:16:52 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id CAF29821FB7;
	Wed, 30 Nov 2022 22:16:45 +0000 (UTC)
Received: from pdx1-sub0-mail-a284.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 4C2E6822073;
	Wed, 30 Nov 2022 22:16:45 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1669846605; a=rsa-sha256;
	cv=none;
	b=IvjAnPCy1qGu2EHjwLNLxGdlAyY+X4TRzPx+vW+1cB4KVQdhbgzPnf4x5rKDQ78LPcWg3B
	WUmbAS8ix3QE1v15DSRz0OBst07Q2Z4zlHcl0OPO4KRFjiIf5O/45dWxSbIVPk/chrotPO
	HUlQzYT6TmUMHBVBycGfE/TCC89kqUTdsMIiR1RA37EqfUbz9cyRb8vmPXbl0njIjVk3Im
	HquyaL5fs5dAsWbmohSSeoQ4bLUbVKHGj4FRFQKBDbDU6xTGPf/nyQoQUQ3dhan7c7ib+F
	HFt5B6tBYW813vcUkapulwl23qPnmMzfc42IIEkygDaFG01yunBCtCP1bx14QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1669846605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbqvHP/2eUrfH8hjbwV3+Qcr32QYkNKThxJdrCSPvoU=;
	b=t5ZtzBVzeJitSJWzv40X8T18h0FmXYgR8F/Vf/INl4+702bNCgVB2F0fGRjy1tuJlFgToX
	kTI04g/7KxDup4fgzNtB2FPnAbEcL8D3aHkcZKq78DcmkeyfNl972NVi2Bx7KS1bDvdRvj
	Bw/fQdL6vr9PojtZ8Zi/Ktl22oiawa5fFDqUTGAwaL96+FuriIIEfQ42SpGSsVGcLgCLKD
	GZYNKevbFr4luYIQ3fY8ihuWZUitTUwcmoPjCnx2jQvMyD+NuadYWHuVtfRb9cm2HAucce
	+4cpoEPimx1UtT+6Wm+6VotT6qYodG+FcLmr7dKfTL4um2AoJ3f/RM6kS+x5Ng==
ARC-Authentication-Results: i=1;
	rspamd-84789cff4b-hk4jv;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Obese-Towering: 60ec59db2b2add72_1669846605632_3430092359
X-MC-Loop-Signature: 1669846605632:3489540757
X-MC-Ingress-Time: 1669846605632
Received: from pdx1-sub0-mail-a284.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.196.241 (trex/6.7.1);
	Wed, 30 Nov 2022 22:16:45 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a284.dreamhost.com (Postfix) with ESMTPSA id 4NMtph3kJBz8l;
	Wed, 30 Nov 2022 14:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1669846605;
	bh=LbqvHP/2eUrfH8hjbwV3+Qcr32QYkNKThxJdrCSPvoU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=EeNZMl+QLwj9GeL9ZC7UW9i11jchL6VuD5MT4gebv5DEYHqg02p06G5uLoWCN1Pc5
	 R31F1LqNeFm0HESta0jSQi+ZO/fa0EMkQH68KLC3rOMGGz5fAaInrcqRttBPzJwlGm
	 AudHt+nFxggwP7ajEAOIxBhHTXi0t+gpvL+IuiNoDt20qp9VE2ALImH39nFzaLHme7
	 ulxoFkaqwNryxA35cQ5uyg9Yx1Hk1V1TmU36LzojmuC4EWu2kBym/DSjbTWX20UP5+
	 GrzlkL4ugBacj1wcEQ2amNMV9tZEPUxosNJNP48BZyu8vaV6GwVogU+l5XrtsBpZr8
	 /7Ms3ZrxMEMcw==
Date: Wed, 30 Nov 2022 14:16:41 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion()
 when in test config
Message-ID: <20221130221641.hban57icdww2fie5@offworld>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
 <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 30 Nov 2022, Dave Jiang wrote:

>Bypass cpu_cache_invalidate_memregion() and checks when doing testing
>using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
>QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
>cpu_cache_invalidate_memregion() is not needed for cxl_test security
>testing.

We'll also want something similar for the non-pmem specific security
bits by extending these wrappers with CONFIG_CXL_SECURITY_TEST. I
think the current naming is very generic but the functionality is
too tied to pmem. So I would either rename these to 'cxl_pmem...'
or make them more generic by placing them in cxlmem.h and taking the
dev pointer directly as well as the iores.

Thanks,
Davidlohr
