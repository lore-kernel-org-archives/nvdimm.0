Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AE7C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 20:26:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2BCEC82071C;
	Wed, 21 Sep 2022 20:26:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a310.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 900B4820A4A;
	Wed, 21 Sep 2022 20:26:02 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1663791962; a=rsa-sha256;
	cv=none;
	b=CcRjFwW1sdNyImL7tb/wuyqR1VD3j8Q/KxmXnR+6wbotshaDDMvrFJk2uLe/5De0OZOA+L
	P03QxoL8BloUemS5IoORDcbCFXkJQOfansiivNQQDc0b7HlO1RzMqQouKmaWsdTCI2ONi6
	Xo2/ILFVvF1hMJ5QPzfVOlQyXCrJvbzDmfLLd3BO07v98o5UUjfgPGfhtmBgLK2w20zykE
	aDPf1qGn/QoQX4G6ECl/UgFPRJ2W4K+nqedzyacGDI9QfvyQcp2XZBUuzRoH8vrwzBj/K9
	tzGk4glG4YdQrdvzGANIl5BzJwbzkMbOSn/ITzGEEnyi8Z4Lr9CriDmXZiICcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1663791962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gNn9GXdaprldy68ck+nCSRssW19Ybt37ruPfMJr4rs=;
	b=Z1z34qQWr8mwA8wVrh88UPZUtwZieqtDZdDDxlJ0NOQdvATOHqECcyk/rRqyqKfHiW9Qsj
	cUvx7oKeC9Y+fqHvu8uTSRzawIKJLB+XZgng5u3Fg/DfBQE8yaw/wbJQKxgsrEBpBPOtTK
	HT3154X1bM+i0mbniDuNsOjf9tD54QNGhs2t/D6k8bG7xJzBcrQAZhjgkRonP8sntF0bhx
	+r9z5KGO4imtpYGVLVgj3Z96ZwifikHBX8XxdEPUZLo9sQ4iV+bpAnjB6YpwDy8A2UI/0B
	LUcAMjJyEA3s8p7O4WVR/6lrMncb+Tx2GrzWxFZahCs/ybWXo97I9UwwQTV1xw==
ARC-Authentication-Results: i=1;
	rspamd-f776c45b8-ct74j;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Turn-Print: 6a4912b5315076dd_1663791962938_998667278
X-MC-Loop-Signature: 1663791962938:2116262794
X-MC-Ingress-Time: 1663791962938
Received: from pdx1-sub0-mail-a310.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.144.146 (trex/6.7.1);
	Wed, 21 Sep 2022 20:26:02 +0000
Received: from offworld (ip-213-127-200-122.ip.prioritytelecom.net [213.127.200.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a310.dreamhost.com (Postfix) with ESMTPSA id 4MXqgC3kr8z2J;
	Wed, 21 Sep 2022 13:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1663791962;
	bh=1gNn9GXdaprldy68ck+nCSRssW19Ybt37ruPfMJr4rs=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=HEhwiaZ15wBMA42fBVOU+YxsZN0WZBGOUj5pOFV0T+ZV1tsmmf92iAE0eiCMn8LyV
	 HGA8sfLB3pZvirBg7q6BxvHoiI5T0fuW4iVTqR8kkARGvGS9m42QC6K8T/h1h/KfD0
	 T9GLaXWtmtHy69OUGt+Ex86A7Mu64f9P7C3tt40ebnP85Temt107OOBMtKbHx7V7yj
	 d4vEXWoQZHc8KrZ4URZHeGgQW8+UyRBM4yB0JoBZzWwJJFZOe04zZpNhxBZJoaDzNb
	 fQKiUeOUyNa87L7JT4iDmSrcgIZo1kyFUg+OJsmJHxbipLB1a6JRHUV7a74OkvsNFx
	 le3kiOmsVgZwg==
Date: Wed, 21 Sep 2022 13:06:16 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v2 04/19] cxl/pmem: Add "Set Passphrase" security command
 support
Message-ID: <20220921200616.wxp4babtpfc4sdyw@offworld>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377431129.430546.9754430497259586325.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166377431129.430546.9754430497259586325.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 21 Sep 2022, Dave Jiang wrote:

>Create callback function to support the nvdimm_security_ops ->change_key()
>callback. Translate the operation to send "Set Passphrase" security command
>for CXL memory device. The operation supports setting a passphrase for the
>CXL persistent memory device. It also supports the changing of the
>currently set passphrase. The operation allows manipulation of a user
>passphrase or a master passphrase.
>
>See CXL 2.0 spec section 8.2.9.5.6.2 for reference.
>
>However, the spec leaves a gap WRT master passphrase usages. The spec does
>not define any ways to retrieve the status of if the support of master
>passphrase is available for the device, nor does the commands that utilize
>master passphrase will return a specific error that indicates master
>passphrase is not supported. If using a device does not support master
>passphrase and a command is issued with a master passphrase, the error
>message returned by the device will be ambiguos.
>
>Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
