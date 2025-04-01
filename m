Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B483A2046A3
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518621; cv=none; b=so1BUmzevx5x8coLjjTaJGtb/jwdP3BZNLzI9OQfQpTmbE9QP4G4vP5rOSPflBXKxIhBX12pd5myDVswbK1YERUfMook37YJwNt91i3GwQoqmW9gCO7+4X+evcgIYZIWK6/DB/ImZ+ibYKRcxnuNv5MYU5HxMMglfkYFXxIGFog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518621; c=relaxed/simple;
	bh=SAerp0QX7HEQCu5qAwjKy/c73J7h5TTZmQ/PG1g5oNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hjaq2UHqiUrcmLBoJih0o6xVZTO4Yvp+IcZrhxABo7//egyz0xpP1oyCK/LserrkcXTlhHqfaUYCYZatK69uoTn/SkZ+JjWY+XAUFxetqws6FeBtRY2pKXQNIz7U0COaydN25GKuzzql6Gk/2XrAyKsDqwXeuBarK6Us97IVYLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BgdCug9V; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BgdCug9V"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-476805acddaso60530411cf.1
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 07:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743518618; x=1744123418; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HN94Rbb3C+JRhW7V34+pZoioef1Q69r5rGBIntjnuf8=;
        b=BgdCug9VwjX5A5bfeKELzlOfiPeHboUzElmEV1inD3K8tKR7sQlwHhtmPnO96W7gfM
         n9f3j0qbqZrNglmFVjnqe5VonR3lXNJ5YNOGKzsfvHeuVYgAaWpgeXGy88vAT/L6zKBW
         nV9l+fTuU9zyddyuaypRAOHgufoF55YLn95e4cPviUFCdE+GSqCk5hF4WGnzf8/iP2rv
         ad696kAq7SwJzL5WDbadlO8AOcVtcq1ddjKmB403CGZO8n3h0Gm8g9HqjVBZKaP1HOUO
         5skYFCFb+jZxbJXnwfR4vv+IEoBb5paW1The+YUE0ZRqaWuIFHlo7fc9Kmr5Vr1VkkBm
         aqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743518618; x=1744123418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HN94Rbb3C+JRhW7V34+pZoioef1Q69r5rGBIntjnuf8=;
        b=TQFpZRcoegYFlVs9xrD7DOIKiNIMZvZfC8JUYfT64UvgmLWeiLp/oz5wh4Je/ZYqmP
         I/9t7J2d7feghQH1iZSHd0exLvPZozxstWGRxeMm2l0TSVtrAJSEEzw+rUcUVvIvkoCn
         EGSJKPTd+GL5FDWt7c50Lqts7b8yHWXW6kyYaqHB8zOr/l0K8DyFGQDct6MaZm0Zgyw9
         SEhiWNY8QgOfh9vQdbDtFpV6t9MlpKNUk6SjuOQT4thzAitV/8WY0l7WlVfJd6sg5/jP
         h3oJiyZh7o1tgLny4mOEUScrsQJn1GoApKvHvmQ2uUDwImWZVBaeVuJ9wEHdXZsGw9kK
         if1w==
X-Forwarded-Encrypted: i=1; AJvYcCUKqI8fbN5OjO8EYPaaGj+4TJMaOKTO/fFPdQUHYwLUdERjT2W1pWvvgJ3llroACS7rs/49/ZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqCbPUqZSXSMX5JD0ovDJ3xJQ35FKmi7YCsk7vaq/7nSD6w+Mt
	dfqyYb5UHX/fgUTNkmdi4w7RkPQ40WxXEUO05YXoNkxl/VM5LouCG0LHBRCa8No=
X-Gm-Gg: ASbGncv8kTMomlZNPCjOs9zBCB5OuFr4SVIGj8LhdACIs7Lxm3OvtE1P0b7RzhqiKfa
	AGOqcV0S3uXyJoNj3u28rDvVU09IR6ogfpB3CoiB8t++moxwuVWYM3r74vm/hp50SvSeKOf43nu
	Q1oETXfXC7K8xvZZZ4ybh7IML5QpVYGMD2Db+d3/s/boVFPxtRc22336XxKMQRdmAwOKw+SkXYG
	2zrkY3kAfpEh/GyEU8R2TmXMiHZPswXUzwtTVBjhTGEdhoMO5Hb1DeEMhFOYZvpUBUetElocVBu
	uQ9hif6ZSYQIsq9KMqmqq1+yEr5dtt2/iEQ2s8bWM9LeJ/tCqi39g+ntsDwbqYUg6LkxTrpNxxu
	vurL4GFAsGxsYZj7yV4JPLKxyYsg=
X-Google-Smtp-Source: AGHT+IESWMLbS4rdl9AVCYJaEJTqsnnFG5ywMnL9FotwkE0oq8eGuaFBq1K5pnITmIFvf/Sd3O6CnQ==
X-Received: by 2002:ac8:7441:0:b0:478:dcdd:a257 with SMTP id d75a77b69052e-478dcdda41amr84695291cf.25.1743518618588;
        Tue, 01 Apr 2025 07:43:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47782a4a709sm66857571cf.20.2025.04.01.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 07:43:38 -0700 (PDT)
Date: Tue, 1 Apr 2025 10:43:36 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-v7mMZcP1JPIuj4@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
 <Z-remBNWEej6KX3-@gourry-fedora-PF4VCD3F>
 <3e3115c0-c3a2-4ec2-8aea-ee1b40057dd6@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3115c0-c3a2-4ec2-8aea-ee1b40057dd6@redhat.com>

On Tue, Apr 01, 2025 at 11:33:59AM +0200, David Hildenbrand wrote:
> On 31.03.25 20:27, Gregory Price wrote:
> > We discussed [1] how this auto-sizing can cause 1GB huge page
> > allocation failures (assuming you online as ZONE_NORMAL). That means
> > ACPI-informed sizing by default would potentially be harmful to existing
> > systems and adding yet-another-boot-option just seems nasty.
> > 
> > I've since dropped acpi-informed block size patch[2].  If there are opinions
> > otherwise, I can continue pushing it.
> 
> Oh, I thought we would be going forward with that. What's the reason we
> would not want to do that?
> 

It seemed like having it reduce block size by default would make 1GB huge
pages less reliable to allocate. If you think this isn't a large concern,
I can update and push again.  I suppose I could make it a build option.

Any opinions here are welcome.

~Gregory
