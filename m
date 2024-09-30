Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C831185B78
	for <nvdimm@lists.linux.dev>; Mon, 30 Sep 2024 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727737231; cv=fail; b=qbKADtavk53FoCF5stv+mV5R0+54mPid0hr5UIEgMZwZGPRPF/WNzwyHmb6mpBC7mql22QyKNKsa7fo8DSCGhQuhIXCjll7MWUSfVPL2TlLKf9olXTeahLB+1to9aS8NGtbN6tlWuWg1NWwpE/+hshQBPzDFdyYZtkG5Gf1E020=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727737231; c=relaxed/simple;
	bh=KGQa5lwA0CQtpO3ICzPVu3rf6sS/+2ak6kzxmj4+Z7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJYCPDtVO7QFPbMiO6X9LX/me0sTbv21gb9IeEJu9jVw9Pz5Y5QnwKd1SbaHr5F/RD2LlnW5MB5qFZsHhoOWzyw3ycAeCql9rJFY2LgQdRu9XXlCzR0reDIUwZ/HSAav86qwZ7YvYUBsr+lcYB6KKmqx1IH0Qaec+ZMxgPy1NWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=AXP9ciQm; arc=fail smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="AXP9ciQm"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 9DE3D163FD9;
	Mon, 30 Sep 2024 21:41:01 +0000 (UTC)
Received: from pdx1-sub0-mail-a244.dreamhost.com (100-99-145-32.trex-nlb.outbound.svc.cluster.local [100.99.145.32])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 36B221640C0;
	Mon, 30 Sep 2024 21:41:01 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1727732461; a=rsa-sha256;
	cv=none;
	b=bBGaeKzoz+76+3M42BDwGGaxwdm92yOnu8h1sSyaldwXstSGEtvNrDtBj6LrXnC4I4qReY
	ZdFe5XEy46uiO7BYs+hea7zfXlsn4Fbx5LGByt3YtURDwkPmBRXcraSLS+5fG2IwQ2lRdG
	2S1wUwCQC2NrBdjNRNayAJxQ8XPg5bYWVm7BZ2JvcdzJEpeEY52/Tc+UZSdWKVWZM+M2I9
	qbcHvEeuV6a527R9G78SRUPE2ZVjPMNHPpVLdM6ABHx+8eN6FrRH2c2TOHzM43nDo26lCk
	Rs7pIQRJtI/2ERce+6TW8RrmVx0Ah3xfXaAr3KDac/66NUgmLlpTnXamUiZ31Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1727732461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIdkrqI+cq4xAtYGgNrIChsgwaZla+y553BzB6wMkVM=;
	b=Sj9RptH9POwyd6VqZECa5+I/FHcSCM/f+Kd/cPHEFDPJSbTuwCpJgTLtlTdv935WRweMnT
	S3Yu/dzVLqOxjbqSFX8I55F+fFdWE5hDe2hm2mcskQ905hgVk1RVnGyusTuXVZE8jEELSS
	jPkgdc99BbSw4+Gb7l++euDpzfB3v/7Pl6zTn5RSXOMu9y4wTb+Ex8xjCcuHdpIPDJw+C7
	LE6eQfCEPwsh37LIis5yRQFLS1z8ol5jV5WyCjlIRGErSwgoEAQrEKzwcbiQ2cPOfB8cFw
	xcgqRd1N//D07rvdqfP+ul4jDnkqjOzCH0ZYcSTXyKRuyJ60bPkwrJ4wSRF8iA==
ARC-Authentication-Results: i=1;
	rspamd-657f47799c-zn9dx;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Cooing: 7f33fdac763de419_1727732461461_1316246610
X-MC-Loop-Signature: 1727732461461:167932956
X-MC-Ingress-Time: 1727732461460
Received: from pdx1-sub0-mail-a244.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.145.32 (trex/7.0.2);
	Mon, 30 Sep 2024 21:41:01 +0000
Received: from offworld (unknown [104.36.31.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a244.dreamhost.com (Postfix) with ESMTPSA id 4XHZJD3B3lz5Z;
	Mon, 30 Sep 2024 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1727732461;
	bh=UNJQohW8Zsni2T4+DfIQDy74rbrJsCFmu6epjouBvf4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=AXP9ciQm5e5NVzOgO6pth+7WwL7y7BQTfZOyg2qIr1Kb5X2UmXObx9aD2Ms0VAhvV
	 1nwp9Vd1iwHygUMAxCzwXWibVFE4W1Y36mShgMpAUBbSk0Mfig8cG9qTqHNDEjLOWk
	 0jzPUbYbrMm7hrvOG9nLTZKgHzXnpqKvg+4eajAg8YtU71/+x/G3cOO2ynPONsCcYQ
	 MJQjoxtKg/euvPnYA428Ahff6Zret7l7jNbFMMzOJBtaoskIFKv7yIe8sPaa4JNOpM
	 ObddNgkRCryhGFwtx7kAa5D8fNU2tHL3vcmhfm/gzyB9pIn2SFddvOOxYMz9Psz0pK
	 22kThuS6RnKtw==
Date: Mon, 30 Sep 2024 14:39:33 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: vishal.l.verma@intel.com, y-goto@fujitsu.com, dave.jiang@intel.com, 
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <ngnoxz6w6q3y6korof6mepzvw2jyx4trlii7zon5jcoafobbfp@4z5ld55qgvqy>
References: <20240928211643.140264-1-dave@stgolabs.net>
 <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
 <f6ybfabcft5wcpx2wuoxf3qgwset3h4nhngn5c4jk6ssudl5gj@o2ssocnihy6t>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f6ybfabcft5wcpx2wuoxf3qgwset3h4nhngn5c4jk6ssudl5gj@o2ssocnihy6t>
User-Agent: NeoMutt/20240425

On Mon, 30 Sep 2024, Davidlohr Bueso wrote:\n

>     cxl sanitize-memdev -e mem0 <-- secure erase
>     cxl sanitize-memdev mem0 <-- sanitize

Not related to this patch (I will post v2), but just for future reference, and
perhaps someone has thoughts. Whenever the kernel supports Media Operation
(4402h in 3.1), I see this utility expanding to something like:

       cxl sanitize-memdev --zero A1-A2 [B1-B2 C1-C2] <-- zero-out ranges
       cxl sanitize-memdev --zero mem0 <-- internally use all the mem0 range
       cxl sanitize-memdev A1-A2 [B1-B2 C1-C2] <-- sanitize ranges
       cxl sanitize-memdev -e A1-A2 [B1-B2 C1-C2] <-- error

... and perhaps the kernel would need a security/zero as well as a
security/{sanitize_range,zero_range} set of files.

Of course the underlying memdev for the specified ranges would still need to be
offline entirely, just as is now.
