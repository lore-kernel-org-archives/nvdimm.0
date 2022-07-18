Received: from dragonfly.birch.relay.mailchannels.net (dragonfly.birch.relay.mailchannels.net [23.83.209.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C357FE
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 06:37:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6AD311219E3;
	Mon, 18 Jul 2022 06:36:56 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B335F121D51;
	Mon, 18 Jul 2022 06:36:55 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658126216; a=rsa-sha256;
	cv=none;
	b=LhNy5xfroBRTUFcAJIvBrl9g3HllhExzfEfc9f65/JoN+rSOnS1lw8U5ZwIrshd/D8zkDQ
	ZyzFD1n2HSTz8dnvxlvTNDLGqMCNbnYUdkPjC3hBHEahx6eQaW/fGb6yD8Hp8HxJMJZL1g
	MfJJIif79V4d9PRJk85JG7etCdfS5csbEeR2Ok2yALDfUZp91PUheAMl410mV0BfXwT+aZ
	Sox5YlOCCulUHdFCPgluq6wq5VmQkaqpQ/1KlD7IMJv3G0ce6wyjfnffxIyBJ0OYcc2plG
	byKHdkbtL+IeFt3nS7sbZR3k2FdDLudK8QBVsvcX3RQtZ4UKFcaI2s9WlBvuCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658126216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOqHZ3Ea2jaBwNaMDxKw0tnDrWnm+OTtYiPgTLSio3g=;
	b=NMou+Hdhy1Hsem8qM9SKefDlaOi8GdfFZeTMMJR98XIpu8DS3IBQZqmE18Wh8+Z4+omcz/
	2FCFuRM0BK1hXuZlNlszed1Snmw19apnzl+kdUSUJcBxbH4ca4rl5DDxBYaK14CBMBohdW
	kXH7r0GVbTsUozvr5uU60ytemByOLZP9kGEo99i0MW2fjngTjIEPaFObSyaweixfvbT6Xz
	CU4cDPVh+2NHh/vR7SzfbVxxtV25hbhxrls6EX1nslmcgAhHWmJtZOzwNxHSGk6l2adsyT
	UXYEEAg+kHTtPG6vNi8Rd2UFvGzNPgCeOgiJs+HHqkllDs0DMLEc5OR+01apGw==
ARC-Authentication-Results: i=1;
	rspamd-674ffb986c-v42bq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Cellar-Illegal: 124b19796256e14c_1658126216225_88675048
X-MC-Loop-Signature: 1658126216225:866721001
X-MC-Ingress-Time: 1658126216224
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.28.222 (trex/6.7.1);
	Mon, 18 Jul 2022 06:36:56 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4LmXLZ5zqzz75;
	Sun, 17 Jul 2022 23:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658126215;
	bh=SOqHZ3Ea2jaBwNaMDxKw0tnDrWnm+OTtYiPgTLSio3g=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=beT8ePTscmNRd4/tJFIV9YYaIAo7OQgVhFLlio4D61f5ceAfc4FAUEsGJoLQOJtQs
	 B18QmwR+zP3e2jfrx0kzQEhSDDrTYMCuWYA66Hczgi7Oj+zD8T5P/FyWrZXdc9TK/8
	 Jjpuj6gMB1iCuuSIZqpXkWagt9eEhmojJR63gX0tmf7Wxhh41RL3HQvVbJRU7Spqz5
	 motoP1rs+R0Be325X8C9hj+t7Q49KBpfS90k7q0ASlFUX4vuL9JezwTQ0oTrCgrQ/x
	 Akze913PFUvcDFBWXuw4j6m4d28TrVlGkpKIHUNEEMmCblRsowZgT0N3yCvdcHM7Wt
	 cZ8KKMp4XwOWA==
Date: Sun, 17 Jul 2022 23:36:52 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com
Subject: Re: [PATCH RFC 4/15] cxl/pmem: Add "Set Passphrase" security command
 support
Message-ID: <20220718063652.osytkh3sji3mntfn@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791933557.2491387.2141316283759403219.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165791933557.2491387.2141316283759403219.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Fri, 15 Jul 2022, Dave Jiang wrote:

>However, the spec leaves a gap WRT master passphrase usages. The spec does
>not define any ways to retrieve the status of if the support of master
>passphrase is available for the device, nor does the commands that utilize
>master passphrase will return a specific error that indicates master
>passphrase is not supported. If using a device does not support master
>passphrase and a command is issued with a master passphrase, the error
>message returned by the device will be ambiguos.

In general I think that the 2.0 spec is brief at *best* wrt to these topics.
Even if a lot is redundant, there should be an explicit equivalent to the
theory of operation found in https://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf

Thanks,
Davidlohr
