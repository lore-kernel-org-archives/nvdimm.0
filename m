Received: from aye.elm.relay.mailchannels.net (aye.elm.relay.mailchannels.net [23.83.212.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E9413B7B3
	for <nvdimm@lists.linux.dev>; Tue, 18 Feb 2025 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739897745; cv=pass; b=jRHKnRRBHwtRT/OG1S2JdvERs33Cv4/+FMXnvYnakY9YT4gafVHf7/n628j6+ztqPx90jok2qhHT4Cjry2rFDrWXKFz5GP0U7Cu5l/y/44VRjYp/tI5xStcnARs7pfX7tY7vx6Y/2DzjOY/Eyz/S1p70vfGBxTAZnf+E3Wk0uGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739897745; c=relaxed/simple;
	bh=fnsW9e8reO4O19QVzQGDSJGEQGnR4Etfhe4kXr2PV54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0u25EjDW2ivsbPuCJ/LBkoP3pdWFMbgltGauP9sD9r0pngecvYJ2/NWHfH1/21GMKcyo/jikiHcFtX1mhOYJnMiBD1jHy5gupZFOzAh3V18mETCUmGOUrkuSnUJ+CDZBJWCLo/SIuV6waxkmIsJZYgaVTq6uWr/jX94xhhIWeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=L1LZBfGM; arc=pass smtp.client-ip=23.83.212.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="L1LZBfGM"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 26B1E2C3D63;
	Tue, 18 Feb 2025 16:55:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (trex-7.trex.outbound.svc.cluster.local [100.127.240.155])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id ABAD82C56E7;
	Tue, 18 Feb 2025 16:55:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1739897742; a=rsa-sha256;
	cv=none;
	b=n7y2g4wQqzDrXHV1e9xIMbS9ScG3fwgJl1/8eCGNjZtU1sQm1n0ik37HDgLR8n56BUKoNA
	Un2tf2NErL/ccfm7DxS0LyhEPOUCQC3hU/LQgVM3M4frAmFZUaHuVFZXxGhXYTr/Il9oxc
	BluZN7h1cqV+RyHIVncldEFwj2VBSrQsbwXzlVoM32C+Bbl65qsllxHcMBdJfxmKFCvll9
	ImH25ZSCk/RCvVUWNm5N3Hrozwij2x8vC+7JUIuRZ7U1yb/wjn678nlZZFiwvzKUKJYA6l
	Fpuof8YdgZ+BEGe1KwYYATkwDI9xOGSAggIzRP3RJkr6g2FAPJ76nHoWGu9HlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1739897742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnsW9e8reO4O19QVzQGDSJGEQGnR4Etfhe4kXr2PV54=;
	b=13pZf3Ot2nryslNA+bczUUF07DG12pp3Z8lNUrwVLtQQNyRqOBch3n7ns1yDdhS0d+Hwy+
	Wy0ocFdyPfvbW9HSkuzrajNCqKmjVzF8sSwYM0x5HMWobjCuyYrcM4jB2M//j9Go74Bssv
	ulRZVlwQHpo167AbZAr4SMFDSdFEH9mst9q7wMYKLkzDpEleQWY4Ea32FWTFasCV3BgE4E
	gm/6sZ/N/1oODGYB983gl2CCdTxMyO+NXUOGs/afgRSaK8JarEMjcAR7WfkNsEO9Trxyqy
	Ky2KwsMHhz2oUDE/M2KQe/pDg5w06gmLwrLMooWKyYFoaASMQJI6+AtcdJwySA==
ARC-Authentication-Results: i=1;
	rspamd-78ddd997cc-whmpx;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Exultant-Company: 15a802750605959f_1739897742944_2776121294
X-MC-Loop-Signature: 1739897742944:2764716646
X-MC-Ingress-Time: 1739897742944
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.127.240.155 (trex/7.0.2);
	Tue, 18 Feb 2025 16:55:42 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4Yy5Hy12nYz5x;
	Tue, 18 Feb 2025 08:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1739897742;
	bh=fnsW9e8reO4O19QVzQGDSJGEQGnR4Etfhe4kXr2PV54=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=L1LZBfGMTMGCRcMzsuFKtUMbmIyB0xHj7Gi74ySFe0ypjB+SqzXOP8/p7jxVHXJ6h
	 9OVJMLtNTsZmaR/mBzW8F2RiBl46XXo/4kyGvOoA/KKZBZOAW64eXGNKHYVudIdGO4
	 YsieuIeVHI2cDx1J2ciRuyXGL06YXEOYcw/AlLHahv6mGrsYnuxHi9JqlCWU+kE+B2
	 cHbqbYWgqYrwPbWTJ3yGA2UKtIdrupO3OaZn3pbSCsKr6gAr553r6VA52Yt6QN2zR+
	 PZO/B1SgLhMa2EWSTSzHRp9+pTd7LZZK2+1aPWvZstRuoVdrFsO5nZZy0yo8SSQ/KO
	 9pAucCm/KRaqw==
Date: Tue, 18 Feb 2025 08:55:38 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: vishal.l.verma@intel.com, y-goto@fujitsu.com, dave.jiang@intel.com,
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <20250218165538.ifbh35zcq4bxwhzs@offworld>
References: <20240928211643.140264-1-dave@stgolabs.net>
 <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
 <f6ybfabcft5wcpx2wuoxf3qgwset3h4nhngn5c4jk6ssudl5gj@o2ssocnihy6t>
 <ngnoxz6w6q3y6korof6mepzvw2jyx4trlii7zon5jcoafobbfp@4z5ld55qgvqy>
 <Z7S2e0Bi7OMUviWo@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Z7S2e0Bi7OMUviWo@aschofie-mobl2.lan>
User-Agent: NeoMutt/20220429

On Tue, 18 Feb 2025, Alison Schofield wrote:

>On Mon, Sep 30, 2024 at 02:39:33PM -0700, Davidlohr Bueso wrote:
>> On Mon, 30 Sep 2024, Davidlohr Bueso wrote:\n
>
>Hi David,
>
>Checking on patches we noted as needing review in last months collab,
>and now I'm thinking this one is pending a v2 from you. Is that right?

Yes, that is right. I will try to get it out soon, its just been low on
my list.

Thanks,
Davidlohr
