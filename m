Received: from donkey.elm.relay.mailchannels.net (donkey.elm.relay.mailchannels.net [23.83.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3417C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:27:46 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 85F0D801AA9;
	Wed, 21 Sep 2022 21:27:45 +0000 (UTC)
Received: from pdx1-sub0-mail-a310.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id BBC4F802EE0;
	Wed, 21 Sep 2022 21:27:44 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1663795665; a=rsa-sha256;
	cv=none;
	b=ceN0aTV8GChl6B0/r8LwsJ8cjBuUjih+Asl/FX5HRoR0xQI8fNPQJ7x2PZTY9UAx0Pg/cb
	MijEujHP4OoC+oDSevUW8ZH86ejgu+JF23jRhvrQ+sSjtr95XHISyNuQL8h44c2ET+Drkn
	r9Fbz5I1fBIIiw+yzIcHKTaW1irxrq637Z7MDQI6KyKA6tJ0EjA5U/kdG1i4WSVDqRF1U9
	dsoPNcw9F/VjVNsCbHhInH++vQNbPi8h6mRSPQNVXNZN3rU82VTE7AJMYidsw3TrP61Gq2
	2zihsL0HkplmEfNmMq1wMnDlBnYunVRIrjHoa3OVOdyNDdo7iBbP7Ce+hO2WKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1663795665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGfkkVIZzvmBbglcyFtO5jLrAJHm6IVhMbw3wBg2HE0=;
	b=avMAKmKsei3VprSlvYLt2nO+xfQ3uqeXZeNt1Otkaaz1GrcAPz2ZKJ8pjTUc2BiSO7v8f0
	kLXbssNpNN9KKvDug0Oo8M/oLfLnFKQyHhloPmku8eQ4ZtqZQRYXmi5PaAgpKeVFoVQ7Ty
	9nJfC1fedazi1cp6s9SBD7pdYw06MRhQqs/Aubmc3XbUUJxYQCCbMjkY6G7AsAOsGDrqMz
	hQI6r5cN7JmLsr6RHx8Hsr9sWFBxwP8ksq5pZTt5z0k8WHo4rqucyQKtUHEWvWH9YZr3Yi
	i4eDGsDp0wHHPEcgcIcYjgj3+pCDURaEOi4fmMubbNpQpdL42judD5MasQbKBA==
ARC-Authentication-Results: i=1;
	rspamd-686945db84-zznm7;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Imminent-Irritate: 3ebb68131532623a_1663795665284_650998431
X-MC-Loop-Signature: 1663795665284:661351820
X-MC-Ingress-Time: 1663795665284
Received: from pdx1-sub0-mail-a310.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.28.250 (trex/6.7.1);
	Wed, 21 Sep 2022 21:27:45 +0000
Received: from offworld (ip-213-127-200-122.ip.prioritytelecom.net [213.127.200.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a310.dreamhost.com (Postfix) with ESMTPSA id 4MXs2P5LNkzlb;
	Wed, 21 Sep 2022 14:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1663795664;
	bh=yGfkkVIZzvmBbglcyFtO5jLrAJHm6IVhMbw3wBg2HE0=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=lceymlMQBx8ta6jtHO5kAFmrzAPUJWMERmqDMOQgNjC7jzn+DZTz+uzi8zSsNtU6+
	 6VeEIwNUOmaUDwMkGBs9MKRi8n6S7EushWj9JcLzfmbvMbEKYTF/TC279N1+g/P6DC
	 58WhddTrdQxyAv1wuCk5zuxm/+VoQmIoxSgbLxYw26JRN7CxzCb5ZUuEIbSjjvZWRs
	 uFHRs0W3XrI3w+MaVub6tDCAaJTdYc/g8Ae9uglWOcnHl/8rhUZKC00LvUpdNa8PKd
	 nI9Kj4ZIS+NcEn+NNbiZPHLr2AZqeJZLmRGjOJR4yZA9bbcYqQ9EX7sz/XC8dZKGVC
	 86Ckp8KbKvHMg==
Date: Wed, 21 Sep 2022 14:07:58 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v2 02/19] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
Message-ID: <20220921210758.6nmdv656zmpbhcla@offworld>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377429922.430546.3219384653732905207.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166377429922.430546.3219384653732905207.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 21 Sep 2022, Dave Jiang wrote:

>Add nvdimm_security_ops support for CXL memory device with the introduction
>of the ->get_flags() callback function. This is part of the "Persistent
>Memory Data-at-rest Security" command set for CXL memory device support.
>The ->get_flags() function provides the security state of the persistent
>memory device defined by the CXL 2.0 spec section 8.2.9.5.6.1.
>
>The nvdimm_security_ops for CXL is configured as an build option toggled by
>kernel configuration CONFIG_CXL_PMEM_SECURITY.

This last part seems to be left over from v1.

>
>Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
