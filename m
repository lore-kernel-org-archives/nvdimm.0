Received: from buffalo.birch.relay.mailchannels.net (buffalo.birch.relay.mailchannels.net [23.83.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60C910EB
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 02:13:21 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DE3E9102167;
	Fri,  2 Dec 2022 02:13:20 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 69DD8102131;
	Fri,  2 Dec 2022 02:13:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1669947200; a=rsa-sha256;
	cv=none;
	b=3AXdu4HoGtOSHZMEZWaaIV/2gOAKSrLR5vFSuzF5CWYeulcf4HjhkQE6baFwnCc823io2/
	oF3lImZc4mIM1wY+4FukNB5SKVQuFNVuahAAxl5YAWWp+zWSVDCEjPNkGMWJQlKEqrcujV
	20W2Rq7pb0ZSjAuQ/rhykyFCU6e6Bt8t5rDyw/NzvD2i87AEGG/weuEmwZAxbB3ZGOT7Mv
	g5Fbo5Y2PkL1s/nvxBjwhrS2fiUpXKmdMXMb66G8sDRLZWEIpqZ2GfW1jzFz/5M7na47mZ
	gx//IIeJIuVO5gmhK9d7gvO9y45+FYlz2SVDLe3zt2HME5Lg00wSGek4eShbBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1669947200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQji+z74f4E6soM9sGBl4GiPXuleBXwxbQN44q+9BAw=;
	b=XTWAPXWs7Gf1GAKF9bMUDv1rPizapIaE0RLgXiTYM1l+cPRftroAW5bmniufBo56s1tTxC
	mhu+XkwVSwsTvuXVG23uWQDvCexrUHwD946F/GTk2la02KJTcS6HMBD4bVHGingi8N6l1k
	GpWE6fVI/3kO99KYY6II/aG8rmOMustD9MFGjeaNm6MzgHpmraYCgrnhZluA7BqKduqHcH
	c9XKunchNSASclPWqWc4OAeEJC7z5aRfhTQzBQ2wP8RQYL6dWX9ItmGjYn8KhK3zC8AKTC
	T3rg74Z8i9QmWiGYExvBOvnTy6CXsL4ndmUdSBlCvuHQw+e74SWA5sFQ08McAQ==
ARC-Authentication-Results: i=1;
	rspamd-7bd68c5946-5928w;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Vacuous-Obese: 53cc19cf68824da6_1669947200698_2625663902
X-MC-Loop-Signature: 1669947200698:2343190255
X-MC-Ingress-Time: 1669947200697
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.24.20 (trex/6.7.1);
	Fri, 02 Dec 2022 02:13:20 +0000
Received: from offworld (unknown [104.36.25.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4NNc1C5VfQz1s;
	Thu,  1 Dec 2022 18:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1669947200;
	bh=UQji+z74f4E6soM9sGBl4GiPXuleBXwxbQN44q+9BAw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=k1/CRQnmwLCCYTJ7jy4/8DxX+G/aCUPbW2htf/R8xYqdFhSQhbg5iBczbqTliB3eV
	 bkHfhM3dULI/4iQX6B80bxp2utmgeBmlIkFkbW+IQRrwlB4yfyLKlu+pyzEjduXkj8
	 lVg7ggpFzwEB2y2B4cdlNUasffDD245PpJOLB5EVoDhgMVWCL3JrRYHLuqTeo6w6pa
	 nNfzVcuWW6C2E909HMyzk6SLTwarwzY1BJWuT/nLbK7OGDZk/M0zUykrAvZN0Hv9ni
	 G1jGCOjXuJP+dogW+kLXBDYjgQjwbd/lKIKoCqdFZ1AuVQopn4im4xel+dvHYoisC4
	 vUwRWY4pSJVbw==
Date: Thu, 1 Dec 2022 17:49:34 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Jonathan.Cameron@huawei.com,
	dave.jiang@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 3/5] cxl/pmem: Enforce keyctl ABI for PMEM security
Message-ID: <20221202014934.bwcfdmzg773zfemb@offworld>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: NeoMutt/20220429

On Thu, 01 Dec 2022, Dan Williams wrote:

>Preclude the possibility of user tooling sending device secrets in the
>clear into the kernel by marking the security commands as exclusive.
>This mandates the usage of the keyctl ABI for managing the device
>passphrase.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>---
> drivers/cxl/core/mbox.c |   10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
>index 8747db329087..35dd889f1d3a 100644
>--- a/drivers/cxl/core/mbox.c
>+++ b/drivers/cxl/core/mbox.c
>@@ -704,6 +704,16 @@ int cxl_enumerate_cmds(struct cxl_dev_state *cxlds)
> 		rc = 0;
> 	}
>
>+	/*
>+	 * Setup permanently kernel exclusive commands, i.e. the
>+	 * mechanism is driven through sysfs, keyctl, etc...
>+	 */
>+	set_bit(CXL_MEM_COMMAND_ID_SET_PASSPHRASE, cxlds->exclusive_cmds);
>+	set_bit(CXL_MEM_COMMAND_ID_DISABLE_PASSPHRASE, cxlds->exclusive_cmds);
>+	set_bit(CXL_MEM_COMMAND_ID_UNLOCK, cxlds->exclusive_cmds);
>+	set_bit(CXL_MEM_COMMAND_ID_PASSPHRASE_SECURE_ERASE,
>+		cxlds->exclusive_cmds);
>+
> out:
> 	kvfree(gsl);
> 	return rc;
>
