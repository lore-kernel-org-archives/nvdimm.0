Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE673BAD96
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 22:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439291; cv=none; b=f6rj/Yak5//XrUH73GEcyuq4c/rHg0YEfJRdjXAVDv4Z04nLuPQJBd71QLrp+QcumSmkS7IBGqgDgMEr0+GO6JtSVYJUl5kYJwlFUfvwBYh1ILL4rvYQ7+TtlTMZccbD4TnRnIiwJlBtUpJI0nLFqfKLlnNKFikXI487yqBkKYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439291; c=relaxed/simple;
	bh=+pMv4X7bQR6UeFfuGC2LYtxgHg3wt+U8czs+0iCG94w=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=l9giiOhwR5P+w2D7sz2BPkKTftFzlBntKIuGVnMdob8yl7Xn+OdXUAM7q9UQXmJUJ0OxK7wUOY7HLCucH+3CkRUzlELvgDxoxdS2hM2uYEiCdyuUSDP6+rEWcn4kYYdsaJhUX0pxG5YSXkF19bQKKRIv8TouENeeDLxGXZvTStI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=atbO2Xrx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=POEGbUN/; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="atbO2Xrx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="POEGbUN/"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id 8D92C1300365;
	Tue,  2 Jun 2026 18:28:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Tue, 02 Jun 2026 18:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1780439288;
	 x=1780446488; bh=F34b1hUbJxZD2bXt3Lmg+L1DOUXFzTn8nRLFgXfeAHU=; b=
	atbO2Xrx9Rn3638FVu63eFs4aKN6QWfyPz4Ts4I2nsKnfTYJhCvLI/c7mpg3juzK
	0KTeaT7/QBccQsLzGNcILxJ6+3XQyXpsq88mfhnKJqWmO/UAJmZSCZn31b7TQ9v3
	GDtUmvJU2VWFgbfHHKgNFmmApky8wxNK7ToiwLkHjKVH+CNNOY9u714wlDDGVK6g
	JBaesuNNVSKACPZxJduMQ76dH5GX4Punem/w0KpLj6BNoPvIxzTF4xduF+rF4g7h
	b7RwRTdL1aSvKzEzdltVtoVavGNQTwQVUj2UAF3u0apRdtE2CRphzndGU/REVgnB
	mdXzDs8bKHTql54zOT9/bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780439288; x=
	1780446488; bh=F34b1hUbJxZD2bXt3Lmg+L1DOUXFzTn8nRLFgXfeAHU=; b=P
	OEGbUN/jzV1QkNtZVZ6dWcRC9JAlBXlsiRpdta5iRN7AHYWGDyWEKfd4FJvniLDr
	Lf3PJIkSby7KiMOtjmpsgm36Bf0PkvLFszhgDfmQjvfzrOM6mnQQGAZo0Vd0x6f4
	cssfNkbNAXpGGeggZbozoEBkFD5y9NhIJ+2NhTbnu8qfsdYsBxXjiZf6DAoiY85J
	yskzuPGfzsgmqvHUwUFKsm9up8o/JNF5FwJ9aodHPvl3eAa/lZ3XlCpeBL6QVHnZ
	h7a6+a5H0mdm0oNqT1dq0Y3YmarkqZswx+9hH5MiQLWkqDSdA0/aeMLPOu33r48r
	AFGZsgC8NmsG6wI2vVTzQ==
X-ME-Sender: <xms:91gfaoWmVndgonyL5KNZNTRlOBKr1VlKz_fSt2oz8JuMQZnoeSN06w>
    <xme:91gfanY4q11fU7drLQd-yBRCBWZCt6HQRfYKdHiHKk-uJjPjbR4XM7rWqd88REdIR
    mucja5FDnlgCR7m6bKs90VAB4sta7XulkmOEZov4o1c0KluA3LYKA>
X-ME-Proxy-Cause: dmFkZTE73+p5uhQtg4vhv7+7FfVsEhMDvDaEr7zlAfmZA2plZqa1/pJ+m/vQdV9QLZzLF3
    2nAZVfDZPDPRHrb5vc7mOAUSl77an2XZizYWX3/evGjAlomFjEtKPDZeproZ0jlVJduyQs
    dAI5imOnpBv9Jv9xoVkFGCzg1V+JdqAaGN2Ult4PPPhZeJXB/kAkh6YBXKQ2AxPMz54Ouf
    vZs/hONJL1K2ZF+NU0iyrSsD1r9TQHdxHl3766qcJkEjBXnJssVUHn8HI1d3/30GP0g3oN
    xmL+1FnajOS1ITNP/I9YmU2gnAgoQY3IuxgmaGUYgfzHleUXekuaj1Ky1/XUgfDqaNRSMZ
    P+H8e2JH/4xrI/1S2QwDYk7M/WPNNDm1Au09MIhXbgJMtJU5ZJijW37d3S/3IlbmOvc6Bo
    L67B7hNxCUmIvz662IPqUPNX0zoaCcYPT71pmMKYeWOivJKdSK3gqYtawa9Qdn5f7Avj8a
    9hV6XRqcBxaZ4sTSDoyxm9TxbVM1kAzJFuaEnzvHzmWh7a5WGuuvrwYcRGwzhY+SBROXT4
    3AT9yZyGs/vOLBVz+eIrELeVVmntkRlRd+dERA7YX8eKxMzFMyS6dS/Pge3+SRav+NaVAm
    NAnjKLpC4kVaL/wYseN+dVCUbykNyG8mzjtQ3NfIjkNS7v7hqhUYRfZGO94w
X-ME-Proxy: <xmx:91gfaq5MCnq1Ni5NqhlBN3yteZm00qBSNz5vpxtMSI5KSUalgChaLQ>
    <xmx:91gfakVtWf-yLf1rd7MkCXVhh69tNNgq2k1pBz2Ypdxqg7GvJE-MRg>
    <xmx:91gfapP0vgNdY6HGsKjun1vp4ZbumEKpbDSgvmKSufAMz2oX7rGocg>
    <xmx:91gfajgEIHCPCNBT25DwQVykcghfyoIPo6aS7RMkJigbfE55MuTbXA>
    <xmx:-Fgfakk4THXoWMPCs3g3A2Oj0GER-koU5UwTQQL0CYxC1L9jeqGDyTmh>
Feedback-ID: if7ae487a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2CB2B700065; Tue,  2 Jun 2026 18:28:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 02 Jun 2026 15:27:45 -0700
From: "John Groves" <jgroves@fastmail.com>
To: "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <john@jagalactic.com>
Cc: "John Groves" <John@groves.net>, "Dan Williams" <djbw@kernel.org>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Aravind Ramesh" <arramesh@micron.com>, "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "dev.srinivasulu@gmail.com" <dev.srinivasulu@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Message-Id: <35827e07-1faf-4168-8fd5-932afc37d620@app.fastmail.com>
In-Reply-To: <ah9RVik9fE4H8Uxx@aschofie-mobl2.lan>
References: <20260526170148.56398-1-john@jagalactic.com>
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
 <ah9RVik9fE4H8Uxx@aschofie-mobl2.lan>
Subject: Re: [PATCH V6 0/2] daxctl: Add support for famfs mode
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, Jun 2, 2026, at 2:55 PM, Alison Schofield wrote:
> On Tue, May 26, 2026 at 05:01:59PM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This series adds famfs mode support to daxctl, alongside the existing
> > devdax and system-ram modes.  A daxdev is in famfs mode when it is bound
> > to fsdev_dax.ko (drivers/dax/fsdev.c).  famfs is a shared,
> > memory-mappable filesystem for disaggregated and CXL memory; see
> > https://famfs.org for more information.
> > 
> > Patch 1 adds the library plumbing: mode detection helpers, an enable
> > function, and the device.c reconfigure-device wiring.  Patch 2 adds a test
> > that exercises mode transitions on the nfit_test emulated backend.
> > 
> > This series depends on the fsdev_dax kernel driver (which provides famfs
> > mode) and on the famfs kernel patch series.
> 
> Thanks!
> Applied to: https://github.com/pmem/ndctl/tree/pending
> 
> with minor touchup to the unit test patch:
> [ as: drop -nfit suffix on test name, wrap commit lines at 70 columns ]
> 
> 

Thanks Alison!

John
