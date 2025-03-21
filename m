Received: from silver.cherry.relay.mailchannels.net (silver.cherry.relay.mailchannels.net [23.83.223.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DED79C2
	for <nvdimm@lists.linux.dev>; Fri, 21 Mar 2025 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742518086; cv=pass; b=scMQ07uV1yHFK78LMRyjs/SQq/RoNjzeiW43EeKzciZ0S96WOdsXXV73Cbpp5f5seWrmGM265L3ndwXIiRnNQLbA5OpkpmS4oX81WYJjA67IISXXaDLPQF8T2Q5ZakINxWfXlxmO7GXtMVFGpjMpTBCTYtiAcGGMkDJniQs1+IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742518086; c=relaxed/simple;
	bh=88MU1BHAIXJQ+vvzwGpSpBOkiBwPs9MlckYpqtNKfXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qi8dtTLMy4GtSgRuX+++cpsCcbu3HBFj7cLEd2iFcv7OwmSLjIw5KngaFmzv1d2BCg4wqnMl1zYG3DX5zWvFL63p6OpEwoYMbRTNmDUgNUG6U0Xb6tDPzNSqgs320bypLjr50yvVAcpbPq3l/47emVa/1uPPxh98rA+C3GXJisA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=QEuemAtX; arc=pass smtp.client-ip=23.83.223.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="QEuemAtX"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 013992C4302;
	Fri, 21 Mar 2025 00:41:52 +0000 (UTC)
Received: from pdx1-sub0-mail-a240.dreamhost.com (trex-4.trex.outbound.svc.cluster.local [100.122.87.77])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 750BC2C315B;
	Fri, 21 Mar 2025 00:41:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1742517711; a=rsa-sha256;
	cv=none;
	b=EdpyJDI9J6Dnj2zGioWQPjUupJLVhU+bKxHkC+67hpHl8EoFihsHMnBrjqjKopX+uCGg+e
	/A3iXMkZjjwjwAdblLkMo4G7VAr7Az/kaUu/TFtKoWcuwS9itHY78a6docRud8Y1qBPJcZ
	C/OQWto6GhOAcJNTIRUi9lPlXhLpxfk5O3R/yRvpYzyzbXWXJWt6Kpb4IHiE80A6aUJ7Z4
	BBBf8ZImcQe6QNs/awGuMy/lq6wCrFQ9KSTGHkOTNIdiiUcM1xUaniU2O7JJUTyn5Uz0bt
	H8kPCOZiAIiFa2ZTAtU1z17mnXFqy1hYput9aFHveIBYlm/LEmlcUUzjFPEX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1742517711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOtDI42ZGjjwvvzuw7glUl+ZjQqc359tKgmb6CyB3dQ=;
	b=Edu2cpjlY65VTBQTvDMzv4OSfytbxoRLBuG0pe8DvodcxrRrc2C40CZgqlcwmlkTQkRf/v
	jsGmqvZs2N1NVff4rBskHddpiEx0YMlBbagRgmQcSLVPvdAvrPFeXsaTrK7KC5nRh32W66
	TUF2u4AwqcStyBOejMqjvgrMSjVmC1wWY49m8GUJuUAwIz12mSdG39QFSqmrkALGMr5ASo
	7+HkzMI0r4uU+lBWySlAemcadsJ+haBGKxzprvtbCxgQAw7m1txdO1kiUxVAy+fr8uU6LJ
	MiuoqDXSmrbutFWEH4QisR9ITuflj94FRz0DCU2FQaUx+PfJyU14rQgguwuJKg==
ARC-Authentication-Results: i=1;
	rspamd-74d566c845-rqlrf;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Sponge-Absorbed: 087d149e4fcfde5a_1742517711826_894984705
X-MC-Loop-Signature: 1742517711826:995818340
X-MC-Ingress-Time: 1742517711826
Received: from pdx1-sub0-mail-a240.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.122.87.77 (trex/7.0.2);
	Fri, 21 Mar 2025 00:41:51 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a240.dreamhost.com (Postfix) with ESMTPSA id 4ZJkCy4xkQz9p;
	Thu, 20 Mar 2025 17:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1742517711;
	bh=GOtDI42ZGjjwvvzuw7glUl+ZjQqc359tKgmb6CyB3dQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=QEuemAtXEM+XNxSv2flluufr/l8Fv5bITczZIE32jf3PeKeeosZr/Tqw9u9OQCvqW
	 Lgyg/B9JG1fLmhtHY0LmLjWzth8miZ/pCVjHLLjn1lfZ5qJWJiHRK1j34pGW34cfLz
	 GAAWC7TgCRhvDeUQF6bK72LDInTQkdfA6nQjgG82oZLAl7g0O+ciMVpDHPiNwoR+Ez
	 jPuiL4ft1L2hnWunPLGEev6di8/1BQhGRbbWmTzZLPVewNPYSF58NKXMJCVWA4obVs
	 gNUTvX3RhAtry673l/G0BvM2FB36Le769WfNw/4UuSEaVmHemEHz+LvAWqJBkbrpKQ
	 RHYqZrks70vAg==
Date: Thu, 20 Mar 2025 17:41:47 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Robert Richter <rrichter@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gregory Price <gourry@gourry.net>,
	Terry Bowman <terry.bowman@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH v2] libnvdimm/labels: Fix divide error in
 nd_label_data_init()
Message-ID: <20250321004147.i55w5i4whrar572x@offworld>
References: <20250320112223.608320-1-rrichter@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250320112223.608320-1-rrichter@amd.com>
User-Agent: NeoMutt/20220429

On Thu, 20 Mar 2025, Robert Richter wrote:

>If a faulty CXL memory device returns a broken zero LSA size in its
>memory device information (Identify Memory Device (Opcode 4000h), CXL
>spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
>driver:
>
> Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
> RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]
>
>Code and flow:
>
>1) CXL Command 4000h returns LSA size = 0
>2) config_size is assigned to zero LSA size (CXL pmem driver):
>
>drivers/cxl/pmem.c:             .config_size = mds->lsa_size,
>
>3) max_xfer is set to zero (nvdimm driver):
>
>drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
>
>4) A subsequent DIV_ROUND_UP() causes a division by zero:
>
>drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
>drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
>drivers/nvdimm/label.c-                 config_size);
>
>Fix this by checking the config size parameter by extending an
>existing check.
>
>Signed-off-by: Robert Richter <rrichter@amd.com>
>Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
>Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
