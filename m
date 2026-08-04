Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF114734EF
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785859258; cv=none; b=nujBQmiylTiS9wYAYacLFuyVGM3mZLEVOpP04ZjF70rtErhFxM8NnPnxu9Fm+5+ryk+++olvOV1qlBRc0mRIarGjJkef0HclD8CijhYCFoDIdCP7Bm+hMz7qvwFZn+9KgqV5Pz5SR//tBe/u2gQTkiKJFLOJcqIFhJ4T4Bu0sGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785859258; c=relaxed/simple;
	bh=LZRF7XvkTJh5mVX/xE5sHCqUfQy1DFUWTGiWnGs02HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOyvzpbDiDUBYiOmnJPwOTZURb3zh9bFPOqRMk79LEm658+nwsjH6WofY1RaqFYSwDhCEOJZSqA8CLGkNT5JsT6uNhei92tnVWBQiiWLEqzWA4wk9OdFL378qeVfwnkge6JMjGKr1ZTU2pGnBEGgsa/WF/BivfgXWeDbtEhg4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TTHlqt1D; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TTHlqt1D"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e50979c71so187085a.3
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785859256; x=1786464056; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gIywxDE/xXwcJzhaWMUxRZtRSyfvUoSn8AJ9dIdrl7c=;
        b=TTHlqt1DFuXjAseZzd3O+2t7m7MeiDmzSKgRh0cTeKZIG4szp96ucpyUDj6OShQRyt
         g4+QARXxCm3vJZtYmvUBnrpnFPF/YyS7nyOD/xUN9mzEo3Kfs1/jnqG/ZhnftKjJdgMY
         LEuNX3SRkMqEqexO10jplHcqEm5T65+b8NNU+vLtbR3ljsoMqenPIdC0l46QFXwHbJPg
         455nSDw28abws1NKDAZwvucw8gt5rtpkb7w6xCnJ72vgBB1MxH+8q7bgoOrlYGSENfiz
         uSgdLfANrpi9LXVkDag4aT7YX4b0tcEtWUSeZypEIROtNDgw0BFJYDzyMj1UWTZLeHW1
         hoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785859256; x=1786464056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gIywxDE/xXwcJzhaWMUxRZtRSyfvUoSn8AJ9dIdrl7c=;
        b=DeejRIvbHFKOhA9J4kM1RvfR59SUzr0unywe1iTcIwzC+VO7pTni0KlsHFsTydTGoi
         hx78cjqJy8xdx23Q44LdLLf4jCfVCf2hwMVzvkvH3zImoxqoRqbhezZiGRB4Ykzsqhyp
         t/omXmLee3C6QZLUwu0MmXyqp2cM9S5GgdQh+NipQDa+RbhCnMkU54Bid4mrAzpyo+DV
         75NjjBDLUPNaHV41MauCsWNVCSuLn+W1zUIf/cDFvWCIgKw4BUe7/sSb8pivCjjjvwCk
         bLDuXzaWdLK2+0PT2sMVoh6i0nl67iqIoDEeo3eTGVq0hCrnM8lw0HaKMbNo3cww4X76
         AE9A==
X-Forwarded-Encrypted: i=1; AHgh+RphxLqjg/kjasayB30Qe//IVldzgsOe0BoAy4WEPXbzJToY5zEoB6d3ayFU37cTr7r9dWkH3Iw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq2XfNFzcZUiDEcH8YW8HZsDQ0A12BAgQ1RVdqTQnBsOugsTrX
	C+sy/AbQTQvyiRNzF8fejdFZQElCF+Q5Wq8jDDD9mgKEEIHUeS6wUwUVFekPWLp6h9g=
X-Gm-Gg: AR+sD1009wFJdXyCEE4tXEyxBTtarzfVNITYvdj2kqQbDz39X9/JvtuoViXJukWjwPB
	0pqVFyqFkZQ4aZGjkjCCthnLY7MjubIlxUobfJ7Rb6430t2Hf9cvsDPTl6/xv00BEgnBYDYu+84
	nvRo7p7dCNkE49blWTlh70jr3+5lDfyIB1+fEujAmCn3rVbPMmtqkECowXmZXT/QWucjbeuefEH
	4jTXgLDWKH0kpy4p5s5f4vM3kygOOe7hAOeqjBQHNXRH6jUTK0gy5RBIPdnV3Yb2Kq9f/lVXjCL
	QAjI4wiPowxbncKPvpcrS2HU1nMXjMhKizGBWBU53KOFmHBJDQyhEVSLGZaNdnIPcHS7rgM295W
	N/T0CGeIGX7/oVnhXFrvr9f9BAJY0DK84Byacj8pG7eYpgvVdJFZMdAkNb4+n1ZrQw9Q5dHGi/1
	La61GEP5A5JB09l+3B4nOAOUrWsD9VRVJNsxbPFsFO2I5oc+wEgo+P9nqAXvT0kb8qQlWclqHRi
	itqe59oAyWzva6bgUceCoLkZdi8gEOnyejhznLjh7LD
X-Received: by 2002:a05:620a:a189:10b0:930:f271:6784 with SMTP id af79cd13be357-934a0ab819amr2203775585a.38.1785859241734;
        Tue, 04 Aug 2026 09:00:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800ae043sm4255856d6.40.2026.08.04.09.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 09:00:41 -0700 (PDT)
Date: Tue, 4 Aug 2026 12:00:39 -0400
From: Gregory Price <gourry@gourry.net>
To: Anisa Su <anisa.su887@gmail.com>
Cc: Alison Schofield <alison.schofield@intel.com>, 
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jic23@kernel.org>, 
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham <benjamin.cheatham@amd.com>, 
	Wonjae Lee <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, 
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anIMLnbG_KmRfjv6@gourry-fedora-PF4VCD3F>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
 <anENkWO2G5tdPtNb@aschofie-mobl2.lan>
 <anGtDPQ41N-SGQFG@AnisaLaptop.localdomain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anGtDPQ41N-SGQFG@AnisaLaptop.localdomain>

On Tue, Aug 04, 2026 at 02:12:44AM -0700, Anisa Su wrote:
> On Mon, Aug 03, 2026 at 02:52:17PM -0700, Alison Schofield wrote:
> > On Fri, Jul 31, 2026 at 01:48:07AM -0700, Anisa Su wrote:
> > > From: Ira Weiny <iweiny@kernel.org>
> > > 
> > > Devices which optionally support Dynamic Capacity (DC) are configured
> > > via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> > > the Get DC Configuration command in order to properly configure DCDs.
> > > Without the Get DC Configuration command DCD can't be supported.
> > > 
> > > Implement the DC mailbox commands as specified in CXL 4.0 section
> > > 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > > information.  Disable DCD if an invalid configuration is found.
> > > 
> > > Linux has no support for more than one dynamic capacity partition.  Read
> > > and validate all the partitions but configure only the first partition
> > > as 'dynamic ram 1'.  Additional partitions can be added in the future if
> > > such a device ever materializes.  Additionally it is anticipated that no
> > > skips will be present from the end of the pmem partition.  Check for and
> > > disallow this configuration as well.
> > 
> > Hi Anisa,
> > 
> > "Additionally, it is anticipated that no skips will be present.." sounds
> > woogedy. The paragraph starts with a Linux limitation of only one partition.
> > and next mentions skips. Is that a Linux implementation rule, a spec
> > rule, or something else?
> > 
> 
> Sorry for the lack of clarity. The commit message has been revised to
> make it clear that DPA gaps between partitions are a Linux rule. The
> spec permits a gap: the DC region base is device assigned and only has to be
> 256MB aligned (r4.0 Table 8-347). It now reads:
> 
>     Linux has no support for more than one dynamic capacity partition. Read
>     and validate all the partitions but configure only the first partition
>     as 'dynamic ram 1'. Additional partitions can be added in the future if
>     such a device ever materializes. Linux additionally requires partitions
>     to be contiguous. Therefore, check for and disallow any gap between the
>     end of the pmem partition and the first DC partition, as well as gaps
>     between the remaining DC partitions.
> 

Is this limitation something we expect to ever change, or is it
something like "The spec doesn't disallow it, but basically there's no
good way to reason about this otherwise"?

Where reasonable, we should try to work the "Linux opinion of how this
should work" into the CXL docs in-tree so it's clear where we put
constraints in where the spec does not.

~Gregory
