Received: from quail.birch.relay.mailchannels.net (quail.birch.relay.mailchannels.net [23.83.209.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104C83E3163
	for <nvdimm@lists.linux.dev>; Wed, 11 Mar 2026 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.151
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249089; cv=pass; b=reTlcuH54oCps/uu1eapYrQxfus2MJN3FOphoMOc/oobAS03h1HXz2KObxtuOZuQ31EiTq/FzAkoFmDx/CEmOi0jNtvIalrdktBZEraEU5ytbypIa9E93ttuRXWy8RlIROGGxJO+Vxm2NoqhgAHGn9r/BahvJOYVL4zHqtUjvb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249089; c=relaxed/simple;
	bh=JAgdeM4Ke1Dkrhx/CHg3BMeA1mj0bIhBfoCkm1tkHA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYf1USO6u61HQDyHBYd7n4kFwzRMxk5XP0gjByjjJ0CJx5oHMOwza9SRdEZZSEu0+nBiOoVbgdWlTmfRoOuK0u9mzv6DGIyhD2kW0G4JizxuLTpN4SsKhL7SkxTv1O7qn17lUFYLwd1qloZ3e3zjwDi3iAKzfVvIIaFlldIijMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Qz6eR1EV; arc=pass smtp.client-ip=23.83.209.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Qz6eR1EV"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 09DD75627A8;
	Wed, 11 Mar 2026 16:53:46 +0000 (UTC)
Received: from pdx1-sub0-mail-a246.dreamhost.com (trex-green-0.trex.outbound.svc.cluster.local [100.109.4.168])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 987E856209D;
	Wed, 11 Mar 2026 16:53:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1773248025;
	b=P/gfB7yHkAZXraMUF1Y6b+jkBhO4SaM1ItRKfIo2BhOTEs+0Ds2vVYIts7pP7SZyGDo6bn
	kn/Qc21vgIO+K76Do+jcKUOeuXw8TLV/iq4LZNCa8EQgnSluBrCy7GEhayLMDN9byfV2ff
	QQgjIDWOxDlMKGgZ2Rx9bie8GMWV0MEYl+xL3tykOIJr58493jKupoO3Wl+dgWMJNzcM86
	0lPdLlnRDLv3QVucE+UR/T3oKWDevJyOlMHDEK1XeiBwtRStw208ihETbYyU8NIq5lQj9O
	cg8pG65RmcDbJqQUvWMPuguNtz/5hG98K84XCcJAdoxAJrj8mshB0pCP6Q+jcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1773248025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtle+xYE9YnWYqaqAsyLZIyWyiGePR8NM+/BGKFEyjE=;
	b=RlgOIc5Z/7xkF6Xu0dOmEGdTDV/KJ9heNqVzQn1FSrM4nwyePC+zW9Vh2OqEkJHZQ2bsr0
	Zh7293qofIrYToBxL9hx2n/znC37yLanWNcbcO8XXkSc6nudnBIlv8xuNjEeXIl4qle3TV
	NDX4tNnczgvjDw3UNT+eCYimWfshYE0M2vYhbMEP6EXaYG7trLCnLJUNeYpeYPQ36m+f0/
	drxetYFV0aHweuLRi1R7+RuVsARZksmLhU4BQLQS/bAtyLOmoG3RpWNDcdMGRIHgUh63GP
	kevwIVYFbSqd9330vNJEni05FYPTiKZ5I7BLKGluTWduM+5Tel4zCOYvUKhLOA==
ARC-Authentication-Results: i=1;
	rspamd-99596b4c6-zz7s7;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Cellar-Suffer: 6376200a00038f0e_1773248025880_1866873222
X-MC-Loop-Signature: 1773248025880:3690606441
X-MC-Ingress-Time: 1773248025880
Received: from pdx1-sub0-mail-a246.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.4.168 (trex/7.1.3);
	Wed, 11 Mar 2026 16:53:45 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a246.dreamhost.com (Postfix) with ESMTPSA id 4fWGzX6q3HzyrC;
	Wed, 11 Mar 2026 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1773248025;
	bh=mtle+xYE9YnWYqaqAsyLZIyWyiGePR8NM+/BGKFEyjE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Qz6eR1EVIyrz/U9d7GdeZdMeuqjMnDPLzaq+JPsMJDGkYVyMRLkImmdsejGg+QJYI
	 AsCKY7nv2GtxUJtvdXsVEFhpi9Dzk36D8CA0kjTOBqCiA8wjWHmUoQHbruvEfIaB5d
	 LBlHjZ6MRTp4sIq0wGn2KkK8andK/al4rL9xwQibyMUSATw6PdtSaaibPl2XJWZAQs
	 ttOiE6B886rnHwTe9JBLi1G29usvXCvEJDH7M+Qt8wNTY4i7aXA7L/HCJuQZJhA8Lg
	 xnh0h5W1Nixy7nfcTMxeqQGocDNRZft8I7Oqo8heUplFjOuJrBTNRPwCngFQ+tLtPX
	 zld90hnMPYtJQ==
Date: Wed, 11 Mar 2026 09:53:42 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ben Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2] dax/kmem: account for partial dis-contiguous resource
 upon removal
Message-ID: <20260311165342.skd3cxn4byn4etes@offworld>
References: <20260223201516.1517657-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260223201516.1517657-1-dave@stgolabs.net>
User-Agent: NeoMutt/20220429

ping? Unless any concerns, can this be picked up?

Thanks,
Davidlohr

On Mon, 23 Feb 2026, Davidlohr Bueso wrote:

>When dev_dax_kmem_probe() partially succeeds (at least one range
>is mapped) but a subsequent range fails request_mem_region()
>or add_memory_driver_managed(), the probe silently continues,
>ultimately returning success, but with the corresponding range
>resource NULL'ed out.
>
>dev_dax_kmem_remove() iterates over all dax_device ranges regardless
>of if the underlying resource exists. When remove_memory() is
>called later, it returns 0 because the memory was never added which
>causes dev_dax_kmem_remove() to incorrectly assume the (nonexistent)
>resource can be removed and attempts cleanup on a NULL pointer.
>
>Fix this by skipping these ranges altogether, noting that these
>cases are considered success, such that the cleanup is still
>reached when all actually-added ranges are successfully removed.
>
>Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
>Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
>Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
>---
>Changes from v1: reword some of the changelog (Ben)
>
> drivers/dax/kmem.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
>index c036e4d0b610..edd62e68ffb7 100644
>--- a/drivers/dax/kmem.c
>+++ b/drivers/dax/kmem.c
>@@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
> 		if (rc)
> 			continue;
>
>+		/* range was never added during probe */
>+		if (!data->res[i]) {
>+			success++;
>+			continue;
>+		}
>+
> 		rc = remove_memory(range.start, range_len(&range));
> 		if (rc == 0) {
> 			remove_resource(data->res[i]);
>-- 
>2.39.5
>
