Received: from silver.cherry.relay.mailchannels.net (silver.cherry.relay.mailchannels.net [23.83.223.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E61C07C3
	for <nvdimm@lists.linux.dev>; Mon,  4 Nov 2024 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740211; cv=pass; b=TmzcL2PXNPUMEM9r4VV48PoNqntGxFRObYu6FCOSQn6wWIzU8Yx2ayKHTKVua0lsgcS0/siPZOMuMQ3V9xoYR2CX9g5BB2flIyOSw7ZcdTcTfDelHykcDF/JnG2DtuLuLH32e22e1xvGuMU7139XzOLSpP11c/oxfhheitfTQ0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740211; c=relaxed/simple;
	bh=Frw8kbtAjBVVCciXSX1r8i47gxNY6wwNd2Hun+4Z/ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNR0q0cKXaPpmPk28ngEQM10tJZcbxXJVx+ygc+WawsDu87zncJcTdOCaWcB1Ni1vYuEXbipynLjpyjwiMPVabyGbm6OR3sqxmIdKenDKPtHbaD/CGbO4bKdbukTalVGVhbRSdgNmDM1+rE8d9dUObbYORUzZ159fLWyeq4r1J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=cLFkz6ds; arc=pass smtp.client-ip=23.83.223.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="cLFkz6ds"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 9BCF5C40C1;
	Mon,  4 Nov 2024 17:10:02 +0000 (UTC)
Received: from pdx1-sub0-mail-a258.dreamhost.com (100-101-211-194.trex-nlb.outbound.svc.cluster.local [100.101.211.194])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 11A6EC5C46;
	Mon,  4 Nov 2024 17:10:02 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1730740202; a=rsa-sha256;
	cv=none;
	b=jUkeV484MmCPZs/erbZ9d3nDS1wFv8nQNTjm/iJbIvuKvCdLCF/+e9ZhpBlVGJg2VXm1Hm
	kTNX6F0h0OMT/AAuSuKZKwcL8jeB0A+xaMdfbFo9XrQqqp4vsMJhmYEzwx/0ej7pMPFG9+
	csaHQq2CwdFcjhoUJVVWHejCC/TXArL7DRFRk837VE/RQvv3GqYGxNMug7zyUnb5ItVTrG
	nxGA+NxtSFIZ3qgNibcqfezNEqG1WB463YpNBodknB6YBDzjH0OiEJXti4bmZY5+wZwzM6
	Up1OmOGh26L0PlZLvi4iVATwhH8wvIPSm5bKWHiyHYGhMRG0LCaxjgU1VIuwwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1730740202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djeiyArVI2uFrm3uwF32I+TnLqOcCdOJyErXRw8sf90=;
	b=h625JFI/Hzg7GDPVBvGfKVPBPQRutobeArZAUUDN6s+sh8bIldFVyGrIZPDKHW2HNldMBs
	HS/dQpnDKJjJ6qIegGkTBxyVp8oDgKLUfxjgHcd9LbJLNP9zlG3nRkQDqo7a1tYtqux5S1
	XtKSeKbPF4i8rKHZX/KoeOh2g2dClEq7YYN1mdbiltcm6zAIcdFfTnw6apZAMuL88f5rAo
	UOOuwPwffEBkWTFuWyUgonSUZmoxD9cWTmrK95lBRLKYnFJ089IoMw94km/MZRp+ue1foI
	vlgMhwzm0MyL/wG2hU8Ce9TdUzyjsG/VNBiZ5o8UY7r7jeigVX+Wupkl79JCpg==
ARC-Authentication-Results: i=1;
	rspamd-57ff586b7f-9lkcj;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Suffer-Share: 50c4f2063b14fee1_1730740202439_5728283
X-MC-Loop-Signature: 1730740202439:3750142550
X-MC-Ingress-Time: 1730740202439
Received: from pdx1-sub0-mail-a258.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.211.194 (trex/7.0.2);
	Mon, 04 Nov 2024 17:10:02 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a258.dreamhost.com (Postfix) with ESMTPSA id 4XhydN5ZFdz7f;
	Mon,  4 Nov 2024 09:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1730740201;
	bh=djeiyArVI2uFrm3uwF32I+TnLqOcCdOJyErXRw8sf90=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=cLFkz6ds+WpTY5zg9wuuYvEd/NO/U3juHAI5RX5rIUR4sj7kLz3KjqBx5vgMqVoUv
	 imO+VG9fMNwr1Z/3IAdZ7BdHrtr+M/rdYLJOcokuDvYLUO+szwMd8SlUwBfMc5nVU+
	 3vqAdJJkOy9LibgPqcPx//DOhhwwdbjdJlkfhWM0YLrF7V9JFCLmRWk+kIGoEgmmQw
	 tnNNEen2ZQyFSSdb1z5FsuOlWbp5ESuRkjwNefzdzyR/JsEzqJrPA+Hr1acZTugVMK
	 bAjLPTDf7nCdgzIIwE0b04Kby1c4/D+0pXL5uTEd3msj9QK5se4nMkOy2Pr2sf+7Og
	 bxWIBCsqYNQtw==
Date: Mon, 4 Nov 2024 09:09:57 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20241104170957.2vxxpnjwvmaiwrt3@offworld>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
User-Agent: NeoMutt/20220429

On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:

>+/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
>+struct cxl_mbox_get_dc_config_out {
>+	u8 avail_region_count;
>+	u8 regions_returned;
>+	u8 rsvd[6];
>+	/* See CXL 3.1 Table 8-165 */
>+	struct cxl_dc_region_config {
>+		__le64 region_base;
>+		__le64 region_decode_length;
>+		__le64 region_length;
>+		__le64 region_block_size;
>+		__le32 region_dsmad_handle;
>+		u8 flags;
>+		u8 rsvd[3];
>+	} __packed region[] __counted_by(regions_retunred);

s/retunred/returned
