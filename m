Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043C10E8
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 07:52:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 585336C0E92;
	Thu,  1 Dec 2022 02:15:13 +0000 (UTC)
Received: from pdx1-sub0-mail-a202.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id C64546C0F79;
	Thu,  1 Dec 2022 02:15:12 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1669860912; a=rsa-sha256;
	cv=none;
	b=NxsR6Jj73U15L6piRSl0ZbycgFjl2wX5RohkL/nqedOkw4c6JXwvEJst6Keallmq8g5/Xu
	c+PbiAISrQws/oqfH5Sof47fwjgJVtmgW6D1MesHHTq7/CzU+ZZssqh6PDtOtdeqwToosZ
	zEbEw1sLXE0itfgkwtz7op+OYbQIvvPIPj8qMH3ZgoaLfRXW5zw9yrfMOxkhnNpklQvuiI
	yGOpJm72pN0iFx0q8YIv4GjGuPHPlO3VIemUpxwah57qICyt+o0dZW+x8NrTsP1rNBevpt
	ui3k/E+dmE3MXi9OUy9EgW5ngPV2HrHtj1TaIUPs8oTpR9z3gwxLqv0tv1q64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1669860912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MecQpOLBlhNaVohuoQrJl/iOQxLaftkYK1Bh2T4EElQ=;
	b=bkS/q24uShvL+mmns6ns1KcTux0H57wXqg1mqqOoyGK62W9PNvMwoaC9kJhghg48Id+6a5
	tpHpJREAM9Tlb4ZNp3ZVV3ceBHQ2fEdWhtH+NVwXd7ZjR2TVuykIQG6GS99Pe4BLU8r0ds
	p9pvVhUtcVHY4ydXW3uQcA++mDEU99WrpuDluNnUDgmrbk5Xgc2njJ+UqYV0fbNqe7evk/
	N3zvJ3pD46V/ws8118euP69+vVwcs2e0tJMnzHce1MgNe9sZJxmi847fuzx9oCsFmZJuEk
	CYCofv4rA/x+ujPcqLohDFAq9fatAtIRmxQtts8XjP4WJtXp3r2aX8kJeqQUTQ==
ARC-Authentication-Results: i=1;
	rspamd-7bd68c5946-vwsx5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Lettuce-Whistle: 52bd040e3d2c2c35_1669860913120_2818222599
X-MC-Loop-Signature: 1669860913120:3335339097
X-MC-Ingress-Time: 1669860913120
Received: from pdx1-sub0-mail-a202.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.24.20 (trex/6.7.1);
	Thu, 01 Dec 2022 02:15:13 +0000
Received: from offworld (unknown [104.36.30.211])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a202.dreamhost.com (Postfix) with ESMTPSA id 4NN05q4sqrzLH;
	Wed, 30 Nov 2022 18:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1669860912;
	bh=MecQpOLBlhNaVohuoQrJl/iOQxLaftkYK1Bh2T4EElQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=KBB2Fatfa28wt4am8/l84PydNFEzs0/EPZUk/1LEjNpEs9htF8WFu1g6KWz/htw8y
	 WMWjG+FfilIwHJrwdDFLzE2hIfFCKJcDzKbai8ZmQI4BqIwbsuvHR42qEoQB14Epdx
	 PogsaLhw7IFnOORLTHAGzWLYFn6AbK34Ln2LSwicH6ME991OQhXYf5utOSyhChAoUE
	 7J2P+CVdPLzB9cUadEQ6n65rm9AYsf/nLOwXDBhwY5LTT9b7uNHuIiPUapc4kTsj1j
	 A9ivXAeP02VvwOLO/lCB7A5waOPiKVmmvv51iPaLL36Qka9Yc1Vr6Vid73CWJB6tko
	 2/lVFqETizxxg==
Date: Wed, 30 Nov 2022 17:51:27 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion()
 when in test config
Message-ID: <20221201015127.mjq7pa3yo4b7ygfj@offworld>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
 <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
 <20221130221641.hban57icdww2fie5@offworld>
 <6387ed1b67fb7_c957294dd@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6387ed1b67fb7_c957294dd@dwillia2-mobl3.amr.corp.intel.com.notmuch>
User-Agent: NeoMutt/20220429

On Wed, 30 Nov 2022, Dan Williams wrote:

>Davidlohr Bueso wrote:
>> On Wed, 30 Nov 2022, Dave Jiang wrote:
>>
>> >Bypass cpu_cache_invalidate_memregion() and checks when doing testing
>> >using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
>> >QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
>> >cpu_cache_invalidate_memregion() is not needed for cxl_test security
>> >testing.
>>
>> We'll also want something similar for the non-pmem specific security
>> bits
>
>Wait, you expect someone is going to build a device *with* security
>commands but *without* pmem?  In the volatile case the device can just
>secure erase itself without user intervention every time power is
>removed, no need for explicit user action to trigger that. So the
>data-at-rest security argument goes away with a pure volatile device,
>no?

Well the spec explicitly states that sanitation can be done to volatile
capacity devices, which makes me think the use case for this would not
require rebooting.

Thanks,
Davidlohr
