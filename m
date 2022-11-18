Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6F9194
	for <nvdimm@lists.linux.dev>; Fri, 18 Nov 2022 18:56:48 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 298FB5C0FD5;
	Fri, 18 Nov 2022 18:56:42 +0000 (UTC)
Received: from pdx1-sub0-mail-a244.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3FE955C1AD8;
	Fri, 18 Nov 2022 18:56:41 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1668797801; a=rsa-sha256;
	cv=none;
	b=EUJxafB5x0s/wbS++inRKdUSMEbIekQHJoa0dk0fvjWtgnQV/Ff2Jpy0mkDMxh0+pfqQBO
	2dyFGP+sYb1P4nuzCBkFLwOQxPH6VwW1dHXLeCsudk3Tv6dk93+zn159v4g38ZQHjevPDs
	3GpQL6LmcxUmOjAWRJD504JOJhTb6+gdsd7JTUFTGba3u3Tz5lnG3SeSvI/JtdObXMJzQq
	hrRXZ+wkucGH9bddQ0IV/2lXxAKTX4MLEVSCB+iTNSeGoKwaLaRZx50zFW+/nzUddYuicB
	hNjpFj1lnKnLs5b2duIm1V7hs3AF345g69wwd7t1uGfH2CBujuW2SExTL9+lbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1668797801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrKeyD/LuOH0FfHqsn5YsDjd6ae6efe1AhjlZ+ZTD2M=;
	b=DZ5Fg+F2vHjIspEr3N9x4Hh9qOQaxjIGyVYPHJtFnNNYmtRzCdqJvOg4qi7gINygbGZ/sg
	VYh5h/8tA8yFfA4pwqMWBCbBIDcljIyojaykpspGuW3hN9BXBkhY6Mn76wpFvQEWwX5WfO
	Bm2aMBDYFuGG1YxPJYxMNXhJJDRSzbTWldOgWeK5AVWSe1WgbtvjLNkaRrPGIFqbL59VPE
	hwWiPBnqZN0EPOZc6TRt3b/Ea3Ojzi+DzvodJ9qm3HHBMhyf2iLdIKShJ03KkWDgt3LTsK
	Mzlf+yhN/bsIPMZwqoTWou35rS/5+fQui0ISgs1WX0bgRdkyR3LMiYXMzULlMw==
ARC-Authentication-Results: i=1;
	rspamd-64c57ffbcf-d4l49;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Ruddy-Left: 7aac27b225895fd4_1668797801579_1095553049
X-MC-Loop-Signature: 1668797801579:3557388476
X-MC-Ingress-Time: 1668797801579
Received: from pdx1-sub0-mail-a244.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.200.113 (trex/6.7.1);
	Fri, 18 Nov 2022 18:56:41 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a244.dreamhost.com (Postfix) with ESMTPSA id 4NDQxN35Pgz3p;
	Fri, 18 Nov 2022 10:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1668797801;
	bh=TrKeyD/LuOH0FfHqsn5YsDjd6ae6efe1AhjlZ+ZTD2M=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=VRslIYt4Nl+erQA9bS4VsphgF0xWoCCcsfK5Shh6VlpRzGmh7n6xhWy2JMaM+p6oB
	 0Xf3jOV7IW9ia5gjXTQYyEQe9huZw0vNejuP5yR3+RxI99J3iHkdE6wLsU+aWTJg1E
	 wUJ9GSt2lEFdGQc1yKKAcWKRz55phY6qNyVnWpYYAFYBZVTb6S4IAL7uh9IlMYlzCN
	 LV2+vYo0GJ5d9DbWP8PlJXV4aC1S71gqkPBm53+7oxU3/gBWhpYRBMl5mgjAXZUQIm
	 MLUPKYB1qRp78iMDpqaM8S0+wBUdkvnYtMCD+ZuB4F74zqw1cnlvHtB7vpn1nJWZrr
	 Hcjzbp69fjkVg==
Date: Fri, 18 Nov 2022 10:56:37 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com, benjamin.cheatham@amd.com
Subject: Re: [PATCH v5 00/18] Introduce security commands for CXL pmem device
Message-ID: <20221118185637.v7h7ynuwrs5mp5lu@offworld>
References: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 16 Nov 2022, Dave Jiang wrote:
> tools/testing/cxl/test/cxl.c               |  58 ++++

fyi these changes conflict with Dan's recent fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e41c8452b9b204689e68756a3836d1d37b617ad5
