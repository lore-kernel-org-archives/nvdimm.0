Received: from frog.ash.relay.mailchannels.net (frog.ash.relay.mailchannels.net [23.83.222.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE671BC20
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 00:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730335392; cv=pass; b=mzbCAq9zMLjHK09LhwsCLGK6DIP1dgERixSAfugSJhjr98KFBbj5LpQt/L97ISoTEJA5uxKfmweKAr/4l9J/R++omw118nVLg3n5Yr8iKHnFojqQ+RKQA2uvGAS4b8hxvJp6PXtgAJ/kM7KrRlnhxAszmdDGdZ2CyKgTCgisvGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730335392; c=relaxed/simple;
	bh=WTl87RQkqlww/DZ/h7NLYjUuHdj+O5o9Q+Ag4BktaTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+C8wW0G81IiEWQgScUjcy1KsATfsN5BAwikRbiyYZtvnxg8Mx7PU1CGOhMksLw/RQpGkMQcWa5oo0yDOHJovpZU2hf1A0UeAZTPft/f85WtrU79WhUsw8bw6UgbOGTTPcFlXplJYyZ5F7xvgm9iKPSlqyRRyFsSZF5EUZPPBsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=qICge/9E; arc=pass smtp.client-ip=23.83.222.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="qICge/9E"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 35E38820457;
	Thu, 31 Oct 2024 00:24:27 +0000 (UTC)
Received: from pdx1-sub0-mail-a201.dreamhost.com (trex-2.trex.outbound.svc.cluster.local [100.103.135.51])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9FF0C82045F;
	Thu, 31 Oct 2024 00:24:26 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1730334266; a=rsa-sha256;
	cv=none;
	b=7eY8oWzwGOZvFx4gHG7kckh9Wt3nnJDBb+weuR/rbwkZOMejersBC9AuKJV1WKhaKqmVOE
	rMi7CXEqc0KlHc5M6QP2yPGeVYhCwYzla1EwYIZkl0RODq8YYJF4haLnTvS6I8UHwX1lQm
	q/l2U5vVAJXAlzJeHSmEOBlz+yviT85WpFKel2q+ye/0n1tMsRZnZGi15WVFuoCMqY2bsz
	F71bJ8Hkw9kaOJe+HQMTXUIiR5kBcrynJK9r2dfRqU/ir0OkUD94jeHqOqx1Yu0tBDkXFm
	y5rRtaFNMdZmi5LgaAbGRwg5uEmNj1Gqj77sYJhQgsyCWkQRyPekulM4LlXMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1730334266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuXlpIw0PJXm36Lz6ZyNwU9vLZ39FakjoxZxnkGPBe8=;
	b=KHg0+Xdgxgwg3lzoNZexY1CUE4S84vtpzWYDpyVHk5ueRxt9tNKEko/QKCD4iPBIOTyhTZ
	kTJGgbgfPhEVeWFlQvCLZcrAj+GFarYWDh/742Zmr8AhmitYcP9ECxsDQjyK4H1xp2Qx5c
	hj1X3OkzqbAhVEKXdVRRfkg9E/q3/DeLJn8DtbAN7KjkiBGVnscCVIA4LBTVMucU/2pJrD
	FSSyKTG4fqSXY/V/nergpCxuB0CT4eRhoTdi0Ml4br4hv3fU+nuG48SWHorZ+rYcHP/fzp
	fytsdWAjD1M53TuUT/ZDFFC8VxTzpuW7NFr4m9woNA5+Y9uuL8Q4YJ+tirPIXw==
ARC-Authentication-Results: i=1;
	rspamd-77cfccfb8-nfplw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bottle-Imminent: 360d44ef2cea4da7_1730334267004_1979216034
X-MC-Loop-Signature: 1730334267004:410076141
X-MC-Ingress-Time: 1730334267004
Received: from pdx1-sub0-mail-a201.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.135.51 (trex/7.0.2);
	Thu, 31 Oct 2024 00:24:27 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a201.dreamhost.com (Postfix) with ESMTPSA id 4Xf4Vx13whz2P;
	Wed, 30 Oct 2024 17:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1730334266;
	bh=CuXlpIw0PJXm36Lz6ZyNwU9vLZ39FakjoxZxnkGPBe8=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=qICge/9EGh1sCgjvu7Le9UN2Qg9MwAXZQ7t3F9WmJXBDrg5A4OntS2Gnz/mTB95PK
	 sj+wYiXX4eWZLOMIvsbQPpNUxvau1dwiGjRMwNU1nTWfvkh2wftH34KF8v4jEe1+VL
	 anHN52vVOsozgGduDVunzlYLUWSboCicy3e/tc7ENecFvKQvMARuoO+kklSlVfW87s
	 kk4z6IZmCTj3idicHhZGhwN9WfKhjTfGMbt349s6AZ+XgebJM4+sMEghmx25VHS41I
	 rmRS58xzqam2jX3oZ/1Z9BJamTyX6kGFW+SK6NU3Tg1cfcP1pNu1ZKY6shCUd9uaMw
	 VecWxriZkradw==
Date: Wed, 30 Oct 2024 17:24:22 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20241031002422.cu53abpaimetzrdx@offworld>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
User-Agent: NeoMutt/20220429

On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:

>Linux has no use for the trailing fields of the Get Dynamic Capacity
>Configuration Output Payload (Total number of supported extents, number
>of available extents, total number of supported tags, and number of
>available tags).  Avoid defining those fields to use the more useful
>dynamic C array.

More of a general question, if anyone knows: why does the spec define
the fields in that order, and not put the region config structure(s)
at the end, as with all other cmds, afaik.
