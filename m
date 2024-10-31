Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919471A08BC
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730390444; cv=none; b=G8T2M2u1eXH79sL3crgoYqQbcWtZQtvn1RT9D5Zu8VhHqyTmxC8FoLCJR7Vey/i14ib1f/8TivR3ofuWxiiyzmMmwNcIsWzHifVslxGtCQo6i7+4418nAh0Br2OGq9G38A0l4+8NYjteX+iKARMNuMukAaS2/8JkSp5PCkaAnzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730390444; c=relaxed/simple;
	bh=tzGE177RLHryW3K1wOEfN8lfRCPGCZu9JmmGUyvowHc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXSrCaM3GAqSNxZMTw4lfYTS4BJUuQQmCnNXYEJw+t/ksSkNKxicTgZrSPvdSjjx2TUDXNfpBxaU7JdA6pAKbDSEHd2t65WbvkwSnHv4FoxevfL9ice3sr7jq5vop2mVs3EZKT4+7YHqUmkfNoMxMJVFNQQKj96MjZZelvVCT/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KnPZIDOn; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnPZIDOn"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c805a0753so10589025ad.0
        for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 09:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730390442; x=1730995242; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uGOII5KIoNBsInbqpRl52akNzPjgV4X/atjPgk2L0S0=;
        b=KnPZIDOn567rwgxT7IkEq3349KC0MgtRbHI33i+0OYQSRHL6lvn6Q3YJ0mBtyuYEMK
         TEcyouZtoPiMsB4B9bgyLnsjNtAdyEJ7Q50d/H8dRapVHBYWIw7sjYQgkCrmOfTAdntp
         z77RDYt8AoVVNNep00xG7pEMkDoufk5gJBa/x2dDLth5Y+GVuLJMlYv7xBcenkOH7set
         XNcMLxq9w2yXYuiM3fR11MAOZNNe/49dzNsohljQtxRQEF9dpSQ1Job0kYUODOOmImmn
         jFPV9tM+WDvSeJhxD1f66suXmO6oBYgj56Bnuh+Sf8hVSr1U7qROXheyfegkJTfhCWeo
         RT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730390442; x=1730995242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGOII5KIoNBsInbqpRl52akNzPjgV4X/atjPgk2L0S0=;
        b=CqtvMn9G5R4wqpynstqIme1TJnnMET1VNTP6LKs4ahhp0n2yuQigLXaqL/tRHiW1bW
         kfl9f4r65JoUguAg+CVECy2ziyaNoYsbIuTV48+PVIY/7zEwhbuCfr29DaKVYwU7EhR0
         SLKSAsqDC16GTRm/nTjsSFvBDpDv5xXPmZdE2qv3oCkJGaMxzY6gx6zA4Mo8Ai4NK3KG
         abyAiIDW6NaTRegwWQo94cK/llPjSngO0cDRwmiDQVVpacWbnosSuMnZxxJdR8EB0+K7
         hTk2B0H6cG3Hw7eeMNIi3SI64VN41JAng2daESxOeJWnslpmc7GXRcLeklX/eUuoBzk4
         DbAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMipQolWCkTvfiKRjiDMvZfcAt8Uzobxjq35QtwW3AIE5RUczmlP6h2+7J70/TJ60iqVuJHlE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6lX0TXVlYyLc6MOqJtCiKXaI4EMz1YoZE8rylUzzZDG8opF/k
	p43Vw38C4IDnvkKBfV1ykO9yqeq7fzKBIVqc2I/hl1gv7aiGie35
X-Google-Smtp-Source: AGHT+IEZxzYcoAhXfDOCE5PcQurxLpXSUsNhIhkZfiGW5USQnME/GkuMHGv05NbuLGuW13HRjlUd8Q==
X-Received: by 2002:a17:903:1108:b0:20c:e262:2580 with SMTP id d9443c01a7336-210c6c3ffb6mr216530145ad.44.1730390441822;
        Thu, 31 Oct 2024 09:00:41 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:1a14:7759:606e:c90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c083fsm10264155ad.187.2024.10.31.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 09:00:41 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 31 Oct 2024 09:00:22 -0700
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: ira.weiny@intel.com, Dave Jiang <dave.jiang@intel.com>,
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
Message-ID: <ZyOplknEK6XkqE1Y@fan>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
 <20241031013441.tsuqkrbqbhwsv2ui@offworld>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031013441.tsuqkrbqbhwsv2ui@offworld>

On Wed, Oct 30, 2024 at 06:34:41PM -0700, Davidlohr Bueso wrote:
> On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:
> 
> > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > +struct cxl_mbox_get_dc_config_out {
> > +	u8 avail_region_count;
> > +	u8 regions_returned;
> > +	u8 rsvd[6];
> > +	/* See CXL 3.1 Table 8-165 */
> > +	struct cxl_dc_region_config {
> > +		__le64 region_base;
> > +		__le64 region_decode_length;
> > +		__le64 region_length;
> > +		__le64 region_block_size;
> > +		__le32 region_dsmad_handle;
> > +		u8 flags;
> > +		u8 rsvd[3];
> > +	} __packed region[] __counted_by(regions_retunred);
> > +	/* Trailing fields unused */
> > +} __packed;
> > +#define CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG BIT(0)
> 
> Fan, is this something qemu wants to support?
Currently in Qemu the flag is not used, from emulation perspective, I do
not see a good reaon to support it for now. Maybe we will need to support it
later when we consider security?

Fan

-- 
Fan Ni
