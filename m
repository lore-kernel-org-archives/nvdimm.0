Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89589332ED3
	for <nvdimm@lists.linux.dev>; Thu,  4 Dec 2025 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764838829; cv=none; b=ruURNwiA1X98PQSkkoMB20pEqbOolTDLP1li5a4gj/fCOBW59rLrxXoviun4/WqWmCo/9zSV4Jf2Zff19q7rGDeX3f0hcAytwbZQZaag32mFLhJCL3OqQiSAUi+eBy5/ZrvvtssaEeeosh5uee2kdJxA5HBxUeigPpxUcLz9m6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764838829; c=relaxed/simple;
	bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KToNWI1/BHEhDOM5YoLDnmG221Q9yyGYfgSgaKjN9i4ty9+eK6ZhOdPl6uj6ONRVwiuW7eSEguhDdfXPcbCyRhXNGyxiaOUyj+MKVIbl2ttDo3iPiXaN9EhLe7ZYl03eIVO9i3IjlWSkvPZsWS+u4FZ5uWOuNokOcTpnhashOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=igovSEmi; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="igovSEmi"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7bc0cd6a13aso457412b3a.0
        for <nvdimm@lists.linux.dev>; Thu, 04 Dec 2025 01:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764838827; x=1765443627; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=igovSEmiM3VFjlr8Ft7y3d2JWffkwjyMa3Jk+5j8pZscG8okwuasY4R/D+k6VKMLuZ
         x4bz1fSQmxIAZIx/10j4mf4lCFL/tGYMk597ftImVxCORaPPEWpZJKpgq/cXxu68g0eu
         lNfkK8lThDxP85qkdjsVW8ve7KcGhZ1rKp2lc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764838827; x=1765443627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72GPm1ULAj1WA2GXdfhiS+jYjGnUAprwyZKKNmKV62I=;
        b=gFXSLi+GE/zBY2XhEJNKLG4NqDQ4zXmmR3I/TvOGp6jM60kAYR6F5SJ9vaF5T+XbYF
         eoam7FkzibQ7NXegi4HOfgDeVxjWxMsaqMTC0E4WZITQ5FPwnKn4gSiO5gEset5wLV7W
         OhweWVU6CW9Khl9IpbUHFSzF4HALNK7MHXyzZspa9F2bDWg/6JPo9tpXIUZTUaqDBnrS
         LXmGHZFmMlTmmyYb+UOa42fmxfwDxFFU5zVODQflFiYxkDm1O+TlBDz21aiF1UgOQEXs
         RFE0C69UygRRHubBK7C/XRoIwfzfyM3ywmsMaDCj8uPr2vyriZZTlxApIgbLf/9bmmv0
         hmGw==
X-Forwarded-Encrypted: i=1; AJvYcCXt6EHckH0r8Y4UMFkX+4udFPYyzhHAScAno9pb0FXbSR5NaIw2aZPbFDHgAEUex2mTATGSgXw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwV7iNs6jB+R6tG35VRHRLnLyoxYILb3WggigxXZv4CNZv0aMgO
	btlAi5X13NFS6NNlOwXBkrWnc/jv2h5b/PfUFgIKPL68sLWJUNuTubTUNu3Lz3To2A==
X-Gm-Gg: ASbGncvLYZvA+B9gxC78typrXf6l+KpRlqs5iruIZzasR+/khfNpwFxr0rj190xbBzB
	pcx8bl+GP8st1G7EdkL1Dn/A+jIL6ggxnk4zZA4PQLgiElEEqX0jA4ut88hdcGw4YKrOCI4h9o3
	h1qP9Bh8JRG59umaGzvjQwl7Qhuh/D+9v0JyYXzDgEy3bQXjThF/sw8zab3tDaTXAgnHERagpbg
	UIXG4WP3oB0jRB7BDxEy6qh0ntwk7gkCt0rk4HMIG31BnfrU+x0k9uzaECeHHAkKbvuuC3c3HCh
	tVJ5dLYLh0DS29H0y/9FDg0L1l/vy63zVWw8ohgHf2J5hEl4w9r7AuHu3vZ16G++LnwMZDNzRvC
	bm413hw+cDGc8/oB0AmJAkojRLTZzXsDOmJqVUkMvtrIpV++to+2P8h/bv/dgr8xVuhLT7xVYnk
	9mT7wFUQdbd0+4I4K+x5Negxp1yUj3EIXOx4yab25FLPDyXdjYHGA=
X-Google-Smtp-Source: AGHT+IGrCmJXKAQtdU3NALKnC/NLtRATjkDSaaivHemq5nPaEpusucmf2NZ3eoouqNk9cTRRShNDMA==
X-Received: by 2002:a05:6a00:6fcd:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-7e2020650a4mr2076684b3a.1.1764838826661;
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:803c:ee65:39d6:745e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29f2ece66sm1483482b3a.13.2025.12.04.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 01:00:26 -0800 (PST)
Date: Thu, 4 Dec 2025 18:00:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, csander@purestorage.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v3 8/9] zram: Replace the repetitive bio chaining code
 patterns
Message-ID: <d3du6mmazbygxo2zkxqjxamfg44ovrfiilbof6rnllfjzxnnby@becwubn7keqe>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-9-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-9-zhangshida@kylinos.cn>

On (25/11/29 17:01), zhangshida wrote:
> Replace duplicate bio chaining logic with the common
> bio_chain_and_submit helper function.

A friendly hint: Cc-ing maintainers doesn't hurt, mostly.

Looks good to me, there is a slight chance of a conflict with
another pending zram patches, but it's quite trivial to resolve.

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
