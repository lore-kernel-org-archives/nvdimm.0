Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com [209.85.160.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13F230AABE
	for <nvdimm@lists.linux.dev>; Fri, 13 Feb 2026 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991494; cv=none; b=UMeVvSsbdpPHeWHzBy/YG3H4a4cav6wByHfOdu4Y6fgayeG7aty3FRXIj6AMnRvvNvJbvVORmQ7z6HfGciao1savAbZZF+AiiLbBRtZXk70nJovSOndrWVQgOGXCzXgCnIpGPOnQWNXkl27ibNYCAshdtlPXX0HaGJHR6RXk06Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991494; c=relaxed/simple;
	bh=UNLPzY8JFs3m+p/4K1jQF1/vnb71y/aulIlYtpFcVHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kX2uFo21bxbGogD+r/toYKRz5jtAPMw7teXTDpRZG2p5PTESlaW2UiXidgJaA7Nd5z6w3mPu47ZUrC50hBYWHwXYAsfpUdUKUTiABAtCv/1mUl3C1rQOLbuHAMapdByxD9T/6mE30tJEPePnaIDmj5fJMv1CZGieOkCsvvUyaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Py6dOf8t; arc=none smtp.client-ip=209.85.160.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Py6dOf8t"
Received: by mail-qt1-f193.google.com with SMTP id d75a77b69052e-505a1789a27so6196421cf.3
        for <nvdimm@lists.linux.dev>; Fri, 13 Feb 2026 06:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770991492; x=1771596292; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7HcHHO+WcoSrrQ3nEIW1ykb//ECy2ZkTsyQF8ciVO4=;
        b=Py6dOf8tKZZHewhsh7/fni8y+qZDNDOZY7N+076j+eYl+bZQ3ibbYTSMuS3aBFws3q
         54LzRLuvxZaQibbwvjFoaWZAwTYQtTdLfap5lCrQbrwWVNytBmmkja9KylXFPgt0Ezrt
         Uorsy7taz3APaFeaTnRz9RomGpQaRSuTWpMGqErCv0akNRSntp/LoANMGRUX4WHV0W2+
         yPKq/dA5cHaNAha66fN2ObsaPpSi8DoPlmT7tsEfrrpt78cp7mzZI9y0LwifA0vQpOIX
         rMGPz09FRNNF0gjSQC2ABLe1tTM96/M4Y+3pxWiiBH0aclkdBe5h4mHdHFyPo5OW6ZSX
         tEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770991492; x=1771596292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7HcHHO+WcoSrrQ3nEIW1ykb//ECy2ZkTsyQF8ciVO4=;
        b=GRbfR+hMWkKALtxdtqsiYqn+SUKe5W+2YGC2LJ0g/om43dAM9fSYI3llvcnNeXpukH
         v4ikuUxb0fuf6zilbxFCbaqm/fmtTOMam+AVWUnGk1BC+VEDEJ7bKLsKKU6sw8OgnXC1
         PmVkRtKWfFQQFoFiEp5tyEjMmvkw1sS8mYUgxmSu6ATvP3P3D832xIVvLam7nRaOUf3Q
         ZoAWEScx4smpBEZo3oSawqOAoFqCy38kVXAKHqZsU4Jg9fuTkeR8e4eLJWLMFuVbGGCc
         KQu5ATiioHsnb0qXdwzQPp6z1hYARDof5lgsDT5LOiZkXlRkgWxyU+gUgE68KEzgqPmF
         Tu1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXu2RYhtIO44o7Zj14fWsb0EipaJ8SuBxf2wXDMhT8yrtXppWmZ9LzF3mE+k653h1rKEw3nsYM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzimpF6UFzsrkTk0vWnDz72gc/6Pkce3Y7Jr0pkMdB5uU1J6/Df
	kVe0Tc8CgvwJakhZRr1ExFPzrYLHlGZVYb+QzNZL99urq4L4QJ/JDV/cOFfGV1dwsV0=
X-Gm-Gg: AZuq6aKQBpTA7jf66gQ1te/vKWQmhGtwJdAPALh0/Y5c40XvMLXxK9E9T1xeFFKNMNW
	XTxBYDKBOdyMcYXKvsPcGQe+zwG4yGBSLeVSvWjpxVI4W5RZW3tCRoTEsX3TRAOB2HPhNYdt9KZ
	8YFSRF4iUfsu+2EJDX/zzehUOpLbDn7GFPsOmL6DP5HAOY8P8L8pdPvVsJlMSlMIV+iTncuLe1/
	g8N73hpddsXKlAnPvPLpUJzGgOGI9Tqc0kzi4UCvaSN8Fzti0s+PTqpvlpQzljfl6EVmXXArBI0
	4ZskJBLCgsDhikMc/ab2LOCUbQbHTctCx8Pwnw5m/X2YXFGVZhHriqeVxPoN2BUZkTcRzOBSI6n
	AkwqFkVanQSQGzjvWFy61sdGRKhD14BcF9BVPDb/fhWN3w0N8qtgn2BgfggmF4Wawj5lChLZQjW
	zOYHa/H9CdEA+Sdz193SM23bSeIqzhKXw37GwyB1XOVX7wKzhLGwfHoI6GmQkeWUH2wcFsK2P/Z
	1hh56HE6g==
X-Received: by 2002:a05:622a:204:b0:4f1:ac12:b01c with SMTP id d75a77b69052e-506a825a264mr22509531cf.3.1770991491488;
        Fri, 13 Feb 2026 06:04:51 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50684b94e9fsm60689721cf.24.2026.02.13.06.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 06:04:50 -0800 (PST)
Date: Fri, 13 Feb 2026 09:04:47 -0500
From: Gregory Price <gourry@gourry.net>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-pm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
	Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v6 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling
 with CXL and HMEM
Message-ID: <aY8vf75vVQ-poVBN@gourry-fedora-PF4VCD3F>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>

On Tue, Feb 10, 2026 at 06:44:52AM +0000, Smita Koralahalli wrote:
> This series aims to address long-standing conflicts between HMEM and
> CXL when handling Soft Reserved memory ranges.
> 
> Reworked from Dan's patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/patch/?id=ab70c6227ee6165a562c215d9dcb4a1c55620d5d
>

Link is broken: bad commit reference
