Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85488811E2
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339033; cv=pass; b=MujmNc+MLrFv0F/ry0yBxwm5jOY99dcFx58aS58GKfLNYmTtrqtavvA60FZH0KKnaoU2FDWBx/axmeT8WM79z9aN6eGcyYIwhW6B8cw9zOKR58EZea6Ir/tmph5iDhEgZ3ycMzof9h84ZN0SaiSEryXR1IW7xSICHhSZCeGeUVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339033; c=relaxed/simple;
	bh=rNY4ZEsKz1XcAvfQ3B7Ej6wRo9eCFo6EpoMo41PYFgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvinwkQfblxXsWVwKTOn8O2ARodMrZzI7hAHoEDJsSYq884h8eBjJ29eZdiMcWoact2ksDHWQDZdzGzh8W6nyPddZ45DV1csijfpcJoVtTc240DY9vno7jTrg7+p2VKi3e/6bB3YaFKhQ8sQaSygykr/8HNheVCbpAhmUaG2wsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Rp5zyH0D; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Rp5zyH0D"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C103D81DF2;
	Thu, 31 Oct 2024 01:34:45 +0000 (UTC)
Received: from pdx1-sub0-mail-a302.dreamhost.com (100-101-211-53.trex-nlb.outbound.svc.cluster.local [100.101.211.53])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 4793281AE1;
	Thu, 31 Oct 2024 01:34:45 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1730338485; a=rsa-sha256;
	cv=none;
	b=pPgL2BH4D1O320WRi6wXpIm4KJqWpTYwnSyI/NsCy6j4rY7aL43kXomYW44GLv4B8SKUhe
	NWeSH55Yg7C+XS7ImUXzL7TrqVj6tohceLFipOKCZE5QbEPiqxDxVVkd0w/6fpH6G4db27
	Aegn26H/8mUh/uieaHjymY9ACVJZHtdSpZ4etO0+lLitzA+LmMempgAV66lW5DtJI7Hbf7
	eIHrOVycZ5eEtn7ka9JSbgAHtd8maXtkZ6W5dszu7ka0ufylhhVsjxyBIjc+03tTHxMWrk
	oW49OkigmiEuYlHwd4vt+1U0TwQiqe10vxCoIRlfKfYUiCQ4k5Nw1LyHd2iJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1730338485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RG/uXRPHc0RIEwtk48jA5QoUoXx5IObwxDejHafllLQ=;
	b=DLRmi6oqmm6JypnXglUVRdlg1qEmpa5k2SHlcD1PzATs4hlPYKzOdky8/Ueanlv/qS/nxT
	z8GvughOk5jDRq9SbgFOV1qaHlCzNEcx3NPdEY9WMdNqKZTyMqMl8M01TLzB8VovL8Ulza
	e2Bm90Rv/vT6LLwhex9SrLodly38QuctaX2Q80gBJKEEkAa1PrHl7I4mnFQF/aGuhWf4V/
	S5GeYENIKUum5h6UtGB5CK9BZlLf7SOTA1YSA5VetpDJxw2Apk/JCuVoUO+FKcftJh8wwv
	zhTmLJlpvBYlFY9c3gb+LFE1Pebokr1dSeYJpeJfWy32BoEkME/fykwMLkJOKg==
ARC-Authentication-Results: i=1;
	rspamd-77cfccfb8-fr6hp;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Inform-Spot: 47ec64386e760ba2_1730338485657_2876808699
X-MC-Loop-Signature: 1730338485657:1963751466
X-MC-Ingress-Time: 1730338485657
Received: from pdx1-sub0-mail-a302.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.101.211.53 (trex/7.0.2);
	Thu, 31 Oct 2024 01:34:45 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a302.dreamhost.com (Postfix) with ESMTPSA id 4Xf6440KMnz4F;
	Wed, 30 Oct 2024 18:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1730338485;
	bh=RG/uXRPHc0RIEwtk48jA5QoUoXx5IObwxDejHafllLQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Rp5zyH0D3vQoov9tU7mIKSQT3ghl2d8YMauHrveQ0Fn/uPNcGFDx1EHYSlguRW+7V
	 uNiQ0JxdnCHDOq8hE9Pl0SvGVokt/2zHdkvt2UY3YlD90zBaQhbakgLm7Toz7TUjBw
	 JkHUUcS+x0pnl8b5BFp9mjDzUGPOS0WkZZamOSJjWDcukGEpFUiUvhXvVHcvDLOgYR
	 dOqbShMYCIe4FN7X2Hp26TcF5Gwz/XkVcBi78T6V0ynYzgWeo+RfyRnrmpWHVH6kGH
	 O/qbDkjKSHF8osegaIexo0DUXnMl7c+z8W6HwXq3d+RC/agy81CSeT7EkbhQvRl0Ez
	 t45epL8qEdlxw==
Date: Wed, 30 Oct 2024 18:34:41 -0700
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
Message-ID: <20241031013441.tsuqkrbqbhwsv2ui@offworld>
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
>+	/* Trailing fields unused */
>+} __packed;
>+#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)

Fan, is this something qemu wants to support?
