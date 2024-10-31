Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87721360
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334702; cv=pass; b=PvXc2BdB5w5dRIwYVbxkNxLD1RX8MUmcrlweW0R+Q9UphtCrRlEksq6a1lWxZdEJXc5fBbGRErccOgDPO2QltlwNnp6wcWjL74MY83YBMTs2i98RA7vBpcOYqugfiRlEmhC6CdCxo/wBtMHVkp8Ybk9bh0AaeR2mbnlqqNwaLmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334702; c=relaxed/simple;
	bh=S93jTs0T/Pz6vwp0A5bpRuNy7QZZyewYmfCPIEckU5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKj5a1MpC/6sXCIAr8gv1csp/0E2l/oXmvZu7Agnba9MeznYgB7aWY3Zi3XWP/afNIMqvHuVLOe2BaAnB8Ua/jG6CkJSDW4uDkYneig+oFJtWVa0FRXTAbICzROiyPQg7vgXB6fV8weLnH7V+n+T2fffV/J8g1bPQSkfdIcsJT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=alroabwX; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="alroabwX"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7F41A8444A8;
	Thu, 31 Oct 2024 00:16:11 +0000 (UTC)
Received: from pdx1-sub0-mail-a201.dreamhost.com (trex-10.trex.outbound.svc.cluster.local [100.103.28.225])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id E2ACE844796;
	Thu, 31 Oct 2024 00:16:10 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1730333771; a=rsa-sha256;
	cv=none;
	b=jSyUmiGmwl5BVFmugR62fdfwTfnLTdNnYLV58x8SktxY8JyX4Qh73kSkVTCGRbRE8nKEHC
	OtjDoKMJcUqx/3O6PMjpYEHgkKVuPBd3+BskJnwHu3lz1ZbIwQyTH4+kNWPup7/suIECz9
	27Iv2ZSrLKN1m7c/dj3jaG2XFUVQJabLHlpHJ9IQjGedQCOHCzzfygS8cFFNn9NjsDySLT
	+r1wsYhXcGdqIdnsK8TVMvXkEjvrXwbyrMfJnmg77FeaGY/DPlvxWFzh+Ke3duQivxccUj
	r6hJBktnzelCBMiOzZNCr6soUiAV/lMDpO4mjIV/M3amYabStXDUw+Zabga2fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1730333771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S93jTs0T/Pz6vwp0A5bpRuNy7QZZyewYmfCPIEckU5A=;
	b=NiBqEyBlq0zc6EHHdIGI6O0bOBAGkWy5SuXnY8qVcN39LuFniQGq7BIvK8Coy0+mHdrVd6
	2xHLb6xD2jw4XA0Xt6jXS/RFdpHIA8EAiOsDBUiwUly7Ggic5BREUWRJDLEP1reKpYXydC
	wsSCphQraZXk0qKWV0aYKVn1f3qtH5wkqiqR/2I8dbmdDKsJseGCiX9EuZIYVyAe5Cs0lM
	h9ydKT0d8eh/3+L2YlNVb6Myq78oWN9g7WYl+Ht97iBqkC5Yv1PMgI8Zqt31eYI+aKzocF
	BO9k/pxMsgMsrBEnk3eM28rUl9NrOvkFD2UOmig6vqY2KfHkaLm/EcrbvyTtIQ==
ARC-Authentication-Results: i=1;
	rspamd-65cf4487d9-9nv87;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Cold-Print: 7f661b066fcffcc3_1730333771339_2064918239
X-MC-Loop-Signature: 1730333771339:793382286
X-MC-Ingress-Time: 1730333771339
Received: from pdx1-sub0-mail-a201.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.28.225 (trex/7.0.2);
	Thu, 31 Oct 2024 00:16:11 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a201.dreamhost.com (Postfix) with ESMTPSA id 4Xf4KP58K1z76;
	Wed, 30 Oct 2024 17:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1730333770;
	bh=S93jTs0T/Pz6vwp0A5bpRuNy7QZZyewYmfCPIEckU5A=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=alroabwX7ltwrthsa2X/P4eC6LcOuDEvjDugX/zmyx5hSmk/KYeANKElaBrQ62zDF
	 ZBc9y7rhbY0GUWOmUWQbscp6noUBFGemoRKEqNpfuL4jRu0mq59d2s2ST0qRQ1JOzv
	 7cXfeDr6UIl4SnUHhVVz0FavqyudJ8rRunExEEZITT1x+rT4DuhaUWOGCeHGfx9ULu
	 NXUBgpzCywq1NXcE/dtS9OpWw1zvCw604ZhpvDEltvYsyptZJClK7IER08r73Mj0oc
	 OigvZEq1z5XWO9RjXDaAy5EHFnkdLA6lR6JOHMIUAfD/IA2qCJ+YVr6XtpJ5ZB8uy/
	 otw0TlbEGpeBg==
Date: Wed, 30 Oct 2024 17:16:06 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/27] cxl/hdm: Use guard() in cxl_dpa_set_mode()
Message-ID: <20241031001606.6notvdsajoebalhd@offworld>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-5-8739cb67c374@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241029-dcd-type2-upstream-v5-5-8739cb67c374@intel.com>
User-Agent: NeoMutt/20220429

On Tue, 29 Oct 2024, Ira Weiny wrote:

>Additional DCD functionality is being added to this call which will be
>simplified by the use of guard() with the cxl_dpa_rwsem.
>
>Convert the function to use guard() prior to adding DCD functionality.
>
>Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
>Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
