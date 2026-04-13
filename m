Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003053BF68E
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776094639; cv=none; b=S0YMqDLP5UFSIhJu5fFfONecKhBne3Z7fOQWj2nT5koMEiT7bSrIUosSI12ZCa57R7ZJQDr2O04QoeykPa8po3LKkoew61kZnP/QaQ5z5y4ph1hRXNtO4wbsZnQ5w/nCTxyAXqM7l9o3PlbweTTluslmND7GVMASls1XDrNvScE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776094639; c=relaxed/simple;
	bh=y1ke5gb2xuiN8FFIldU6UiCwJkfDC5LydsNnw3HHWhs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Q9kHiWMSWZMIq9DVxQlsU0Jf4OfztQrOb6PC7M+Wk/wdPklIL7SmlLnW+T+cSbrguYrt0AJD5JXpABHsFZWZIONpzYgFkzfLhQFgAzwCMxn/QPMHTJvCm8vZVhjSkoqmcLWama5f6DbmZ1dhRmduqTPlyMmTNkv7/AhoU0g/lJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=mPE3fXBT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZsWBLItC; arc=none smtp.client-ip=103.168.172.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="mPE3fXBT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZsWBLItC"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 5305613808AC;
	Mon, 13 Apr 2026 11:37:17 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-02.internal (MEProxy); Mon, 13 Apr 2026 11:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1776094637;
	 x=1776098237; bh=isCljd4BCPG3HJK3zKTboOtcG/nGAMzjBZJjfS3t7zU=; b=
	mPE3fXBT4Lo63Sk4v63CEqsDKsRcwI97kff+KeB9LQR2tUpKYaCqMvWqTKxEhW8H
	C9Dx/4A+80ppCBY6lUWY2WpyiMHjSav7gr0oCGk23LRLLF/hdjToXOmGxxh+5DLE
	lKP/ZI6ZgoAUkR7XFaoDusMM8Y0CmR7Va4+amIoOUhVAbwE40zIirAnud5Q7pE0/
	BQVkiU5DzXbPNSEkXIplJX+jjsivT+Wq7UJOVVVjbOfRBIUWSZci0U69isIMD3RM
	qziK3q8NTabAoWsqFoyzQ1OmBP1JMbnoRJxjTCx/rV64d38voDa+8gB1aivmJw0n
	qFkTZ25b9hUfB7OjVFsf8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776094637; x=
	1776098237; bh=isCljd4BCPG3HJK3zKTboOtcG/nGAMzjBZJjfS3t7zU=; b=Z
	sWBLItCgpBLW/X6TabAqj3l3aIiS8a0TYoVYaPSNPRBZ2iKpB1NEV73Ahpp59RKB
	sftAEHOUKjoyxgIe6nbyIcOGvgjzU29pFQ8resA8yi7Er7hCbUH3aizc64hKQakm
	qNa0Ot/XMfPL2UXgnkV6MguNDImir/NK+UKmiuB9F1WRdKv1HgSnCZ/iN3Pk22te
	WvUk2dUjLNhlkQGm4646vqQlkGrl5FBAAM9FNOVYojqXz+F57QGXbvIySKRF9rTv
	YKKoCxFeDnPC2xB28WHBDAveb7fGXruAH3QgBucNlTxuiIlE9f5euJniyhhGIHjE
	9EeM4O8eXA5b0EQmVGsfg==
X-ME-Sender: <xms:rA3dafbKyfHCZFXBnTEPuvC0o_BMQP3cGXb6poi8d54fQp50gNObvw>
    <xme:rA3daZNCm4mzv_27s33XNPsHhCwXjga_UrYz2JAg2Jvm3Tnueoyusfra5nxrtRTrg
    OIm_zRCAeqLatSu8cY7-YO3OEg90qE9sFWjL4du_-lWhaqnV-mkq34>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdffrghnucgh
    ihhllhhirghmshdfuceoughjsgifsehfrghsthhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdetgeejgeejvedttdejffelgfeihfeuheejvdeuuedvffefffetudelveeh
    vdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepug
    hjsgifsehfrghsthhmrghilhdrtghomhdpnhgspghrtghpthhtohepledpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhgshdvtdduledvtddufedtvdeggeesghhmrghilh
    drtghomhdprhgtphhtthhopegurghnrdhjrdifihhllhhirghmshesihhnthgvlhdrtgho
    mhdprhgtphhtthhopegurghvvgdrjhhirghnghesihhnthgvlhdrtghomhdprhgtphhtth
    hopehvihhshhgrlhdrlhdrvhgvrhhmrgesihhnthgvlhdrtghomhdprhgtphhtthhopegr
    khhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepnhhvug
    himhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqtgig
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnh
    gvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhg
    vghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:rA3daa7UgkgnOcKmbpDfbGNVCFL9bKINCRKOsbNa1LCdDu0e-3sm1w>
    <xmx:rA3daW_jpY9GG4EB6LqBG7YBTEgQ7KPUrYPVdJ4TpZCbuOnVkIOXwg>
    <xmx:rA3daUFoaXyYeaNx3xekkOxg5ij_9j54m9rMLPjYzZYkkzIhGNxkRg>
    <xmx:rA3daTVBev91FR0bkoCh0n9dFgH9fw_F_tC3WM7WUJp2wwtqUqBGbA>
    <xmx:rQ3daa-SZ64h0KPuE4HUUnuGyo2NJaa6KOuu4_-WGpgtNv8vUacWfeQr>
Feedback-ID: i006e4b2f:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id BD9622CC0083; Mon, 13 Apr 2026 11:37:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AcMtGZTwwEIV
Date: Mon, 13 Apr 2026 08:36:55 -0700
From: "Dan Williams" <djbw@fastmail.com>
To: "Guangshuo Li" <lgs201920130244@gmail.com>,
 "Dan J Williams" <dan.j.williams@intel.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Message-Id: <adf2a8bc-ce1c-4b88-957b-5d5643810d19@app.fastmail.com>
In-Reply-To: <20260413135625.2890908-1-lgs201920130244@gmail.com>
References: <20260413135625.2890908-1-lgs201920130244@gmail.com>
Subject: Re: [PATCH v3] device-dax: Fix refcount leak in __devm_create_dev_dax() error
 path
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Apr 13, 2026, at 6:56 AM, Guangshuo Li wrote:
> After device_initialize(), the embedded struct device in dev_dax is
> expected to be released through the device core with put_device().
>
> In __devm_create_dev_dax(), several failure paths after
> device_initialize() free dev_dax directly instead of dropping the device
> reference, which bypasses the normal device core lifetime handling and
> leaks the reference held on the embedded struct device.

Like I said before please focus on the practical problem this causes. It is always the case that device setup will have some steps  that are handlded by direct kfree before switching to a put_device() model.

In this case the practical problem is that the memory allocation from dev_set_name() is leaked. Also the error return from dev_set_name() is ignored.

> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.

If you are going to be doing more of these please make sure not to just rework code just to get all freeing done by put_device() when not strictly necessary.

One issue to avoid is early returns in the error goto path.

In this case I believe you can address this by moving the device_initialize() later in the function. Make it so that the switch from error unwind to put_device() is the last step of the setup.

It would be nice to fix the dev_set_name() error handling in a follow-on patch as well.
