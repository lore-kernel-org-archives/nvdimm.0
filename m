Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE967C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 20:50:39 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 44F087E22AC;
	Wed, 21 Sep 2022 20:34:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a210 (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B29017E2319;
	Wed, 21 Sep 2022 20:34:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1663792498; a=rsa-sha256;
	cv=none;
	b=v8lRpjXpnHDG9fkLJpsQiKIJx04Hf8RZs4+jDncS6IqWEgFGemgt1nJ0UHGzFq1vGa2b25
	B97D/RxBL7E9OynIFRThefWlBLFtnw3Rq4FRRIFledW4c13vCTeiCynC7IFDRjXuUlLJS0
	FVZeZmKbdcpYYeE6AhiSw8Mk61vg4m4eqbIKwBLlcj17wxAdRVv4rV3ck0tPVxNJT1pV+X
	NZd3gxM3WO5eCBUVpvWfQ891l6t4Unjav/5eQmpNTQrZGXIfvncx5dJiOyr8GQpjYCsHk3
	OvcG5K6yLYB1WV+uwLJAT+6BakgMnHSnjuYb/1k4YZh/TqZR1SrwMeWvgaUXDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1663792498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVPRerw+2idjYU/blJzjBqkFXAsa4TzOH85zP/CzbTo=;
	b=EheDYRlHERwTX7QOYVW412SmiLMEVHL8pob206mRSEgUXmdawGJqI0iA3M6zfv9EdP54cN
	vSw9RRh2RJXukAIDojzlR9xs0BD0MhF4rPtZlNysuKtlsGNnWpIxIQ8HG2jpce3SfTNG9p
	B8QdUHZevnEsgU+kw9VhQkFk7dyY5hmlU8ZSTnxaBsWLFkISlPL5jn/9+GVPyO/Z9HQlO8
	Q3wTCIxP6SqxfdAvSictH7lFQ7F+4gphOGay8TcybWK9KeyRFW4XYnJN0E4AgxUUAylNJs
	2atU/euXyxlEXDBE0ZlIL+0p7M4hGaXyKFoq6fjanexiy8wkMFALfwALA1LQmw==
ARC-Authentication-Results: i=1;
	rspamd-f776c45b8-2q8n5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Army-Thoughtful: 292ec5eb13d7aef2_1663792499066_4030479703
X-MC-Loop-Signature: 1663792499066:558639079
X-MC-Ingress-Time: 1663792499066
Received: from pdx1-sub0-mail-a210 (pop.dreamhost.com [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.126.129.208 (trex/6.7.1);
	Wed, 21 Sep 2022 20:34:59 +0000
Received: from offworld (ip-213-127-200-122.ip.prioritytelecom.net [213.127.200.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a210 (Postfix) with ESMTPSA id 4MXqsW6KWbzVw;
	Wed, 21 Sep 2022 13:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1663792498;
	bh=ZVPRerw+2idjYU/blJzjBqkFXAsa4TzOH85zP/CzbTo=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=cFBHvhAu+Hiw71UBpBvSykNzdJW7CLZroOzyacdCG55kpoZ5BzTX/5VKVZrvhS2sC
	 mgRvTSOnRA2PRcvMj9vZtrS85A6e5GhRw1s02FIqs2F9BtbFxri7SNfPFtl2iRZfY8
	 u6SH/ot7/XoHCnbYIxMyoewI/TidoX/gh6gwkXYvcPpeGNK/QrvRNfbSrDmB9tqcbp
	 EF5famasJX4P/ZhkArg2npWashZZ0OaPBmNKS2rONpuRzzK+zQqm6jcaQyCYmP90kO
	 74zdBC4SJBaT5pRM4ICuB4bSQfuG40iYUJHkY+TD1UC1azvn41alXA5RwSz7eiRrgA
	 zM/ghoGp5DXTA==
Date: Wed, 21 Sep 2022 13:15:12 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v2 12/19] cxl/pmem: Add "Passphrase Secure Erase"
 security command support
Message-ID: <20220921201512.7tjaquhroo6qezfe@offworld>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 21 Sep 2022, Dave Jiang wrote:

>+static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
>+					      const struct nvdimm_key_data *key,
>+					      enum nvdimm_passphrase_type ptype)
>+{
>+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
>+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>+	struct cxl_pass_erase erase;
>+	int rc;
>+
>+	if (!cpu_cache_has_invalidate_memregion())
>+		return -EOPNOTSUPP;

The error code should be the same as the nvdimm user. I went with EINVAL, but
don't really have strong preferences.
