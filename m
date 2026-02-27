Received: from dog.birch.relay.mailchannels.net (dog.birch.relay.mailchannels.net [23.83.209.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E203346AED1
	for <nvdimm@lists.linux.dev>; Fri, 27 Feb 2026 19:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772221539; cv=pass; b=tI7+02Y6YLq81DlkKT9N0sj2rReCIvDLAcc1oqfIBuUBi4sMd3BBlO3K//cIqW+V1MqjYalUVWUR0NnmzzxnzRJi+nQEfe/BhJxcJ0TtIqf6jNmwoVH0TThLiYMKf7aVMKkTk7GGgmD9G6XTZ1xvbr0vSgmiO7HZgyX08q+ielg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772221539; c=relaxed/simple;
	bh=8YpyPmcU6KUT4IZ6nx8xoVkVKcF+bX8XaoHmx7dTr5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLB09qeGUUtuWM+xUVgkwaqDYIRGl1M4Z5EBHAZYIxzwfKJueZ+gPdoMMmHKR4n0jY1opG3Ux1Zj5j08xQBPxnLP4jdwYKjagle7vSK/7RZ+hbQxQREmYdhd6WO/R1J/3eLZ0a3LrnjMwMEFSCyMUmOWRK8AC/BvjyYYslViI2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=QJ0zKQvl; arc=pass smtp.client-ip=23.83.209.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="QJ0zKQvl"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 91CA41823D0;
	Fri, 27 Feb 2026 19:27:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (100-106-233-169.trex-nlb.outbound.svc.cluster.local [100.106.233.169])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 249D6182CE3;
	Fri, 27 Feb 2026 19:27:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1772220474;
	b=0K/2nEJJUkb693tycqhBLva07Z1RjaBWQgW8qbo7YGwGBtWbXySMDyjLGYA/8Ex97r4KAz
	9L8vpecE6fmXyug3avGWlEMvfSTQuzNs46/QJuOGYwaNkqQQI65dAwO92J8TAnKJn42Nxz
	6n5FLhxu7OLnqTLPggR7uA4j311GchLL4r2Nx6hKXHiMp97xPmfZ9hOMOzh9VbRW5Xs+Bu
	3lH6RVYRaIC+kdpPKwwuPzKSxwZxMmm1U1wgBMcep9H4om273hpLHGjUIEDPaY7c/r9tMs
	2fKS6iNfArvXf07TY5QWgIoRQRpkFhvzw+6FHfDQylAEzBk0BROBgq0NBqKArA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1772220474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YpyPmcU6KUT4IZ6nx8xoVkVKcF+bX8XaoHmx7dTr5A=;
	b=eSOFWzvgzw2FGzej4a3UFMPkusjFXXNbdP8vFDoY6DLzjVP2QTeLXvIqQeeLUkQgBbOfw+
	PxkO+n3bYrvfdIUCfqJLmVk46YG/UuPEGKt9HbE/rhIPTmKIll57NsY+QJXikzUab9UAFP
	a0OqIje3SIllYuDNX61+6dsD17TsP1VS/q4UUt5zWVzBIFOPCJ6i81oA5nbmZqBHWo178w
	2gqDtHv97rDoFKtl0iwmSRDc/M8oXJj+FyfZpvqeF4VIA4+X+gNLyO3N4HgffpE+PY7r0s
	2Eobgg5qla2e6IfUyA40yBIxc8/592mx+ogzPV/FGfLlCHuzRGBwWxcVJRrOzQ==
ARC-Authentication-Results: i=1;
	rspamd-7f65b64645-qt58m;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Oafish-Left: 6e4a0f537b925262_1772220474408_2743807188
X-MC-Loop-Signature: 1772220474408:2705388933
X-MC-Ingress-Time: 1772220474408
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.106.233.169 (trex/7.1.3);
	Fri, 27 Feb 2026 19:27:54 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4fMyyw4cBRz3K;
	Fri, 27 Feb 2026 11:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1772220473;
	bh=8YpyPmcU6KUT4IZ6nx8xoVkVKcF+bX8XaoHmx7dTr5A=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=QJ0zKQvlpE2sDKJGjSMKtF904mmSpPQcs6DLIm0taTw/9cFiG0c4V7TtjLWJw8qvN
	 wU9JjfgEy6MaaeK4/mHl8wkCmqz5+Uyam8D8CaFXahxMDpDEFQeOf4e/0QhmciQ9GM
	 5lX/PBR6mSr3B9qKf0qaWhjPPmZHtWf8c+q+8Ex9KxuwruXPpfSIgn54BSejPBMk9f
	 aXHdUiX496fXH3/HPypdw2DWK1WvU/K4M6VPGMEikF1ozbjiO0ffxMTnkEHpZTwIBr
	 /YZZG+DXTPc8n8QsxdzkwSRYr4sMFhYNAkMyuiXuVNWnGJNSqILhed2zbUifRcYVqj
	 PhHsFPTMhFHpg==
Date: Fri, 27 Feb 2026 11:27:49 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, akpm@linux-foundation.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ben Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2] dax/kmem: account for partial dis-contiguous resource
 upon removal
Message-ID: <20260227192749.bl46nsia4y4bgawx@offworld>
References: <20260223201516.1517657-1-dave@stgolabs.net>
 <aZ_TlK4r41P0xBDO@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aZ_TlK4r41P0xBDO@aschofie-mobl2.lan>
User-Agent: NeoMutt/20220429

On Wed, 25 Feb 2026, Alison Schofield wrote:

>Do you have a failure signature w Call Trace to paste here?

No, I have no splat, this was found while getting more acquianted
with dax code while looking at dcd topics.

>If not, maybe just insert the expected signature for grepping:
>"BUG: unable to handle kernel NULL pointer dereference"

I don't think this doesn't really adds much to the changelog. Not
worth a v2.

Thanks,
Davidlohr
