Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F5632779D
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721480; cv=none; b=CVgnJQRF14Mv71P/VkG8iKGcSfj6JsEyTA75uqHtVKSwwY02KHwFC0FcmT4rtxgqxWZEOV28D8RmKvhPJwE5uo04drGsE/1KpEZbJXg3kh32OVrgn15hzWPUoZZsNtgBA8DLf0X64E90ItaWuhsx8Zil22uM3EynErn0zDsO00Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721480; c=relaxed/simple;
	bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNIWJx1IIht02bkrwPLfmThNae1gXhC/HKEjkRiHQDj7QE3z2hvwFH+koslZca3ty9APfABOmuz1x4YfQpCnawy/VVSvJl/6n0eQLPQPAse+Xt1iZx4HXWem6PySnj+o/hcl/cPqdPk7LRoBKD2dOQszVIxwPNWyI8ApnG58OTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=l+JtAQEi; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="l+JtAQEi"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8946a794e4fso16776236d6.2
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769721478; x=1770326278; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
        b=l+JtAQEiK7tjegu+63GkPIUTkolB9K3UqBfnOm5jwQO2kH+EDDbpXoMF82JqKGI+mv
         1ld9frYb8t9H+HtA3BMJLCkyZ4FUR2I1LvDRTOOv7M7riqH8q1z1voLQNkkAHOVlNhM2
         2G/JRyPcHi/UNWGsaTKrNLf6ubbgrfWnceGN212bbIFvtto1/ckrcLLMokiorGzv2XTT
         C010PyuSpePSpvCSDmQWkUD4vikAkZjayyc3tlHxzrK8L3OjyntP0e6xDfxQdrsvpr3e
         F5zvXGMuVFlGOndZg03H8s5uXYa1jwETM/msalAu+VlukAeEQsLNtjG419Bg4jJyE3hT
         8KGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721478; x=1770326278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9xIkbZKM30zA9x2QI+alFDGiuf8CP4pmINW3Kx7q0w=;
        b=NsilOPXnBExhI5q31sGZrHLVXRXHr6iqQIMGszsxgivc9cMuI4vFnxxu4ojT0UZxnQ
         cn8JwvLgiOlgeCwMqNKCrlmNZEvdXjGJtLONSg0Zl7gKB8A114N+xlz+bdFFpMbzA8Zb
         r7hSS9/N6sFCzkDR6Rz4I+T5WoIXPGGqIAUUSvSa8PxRRHEorve+dFYrIqKAjfc2uI4c
         dlcmXmpYYcgvn9knCbdHn4p6+pKlMfSCtz2xxGqXIOC8uEWz1TLb+eiAmuHXDZe6WrCH
         AbExIr/M1M3IclMRQpWlQnLG0tcNG3UHp9lGSt/gjB/SY6PbMzAWZsRj7ssqP0mYHeHN
         rqlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBpHnCORcx24y1RhHVioW0FkmxBZejHQsbnf/YZiV1JY5FBXmOl1u/Q7rbEdRkI4277wvPX/U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLR5PlwPctlZ9b9+OYjzJDiZjAtFuWkz78cGF1HYd+0XSvWTAI
	J/Bqmy85ikd3ga2uzckH4vefIw6JxpPQDKQko8p6/YB9Sm2nPR8bFqVMer+l7gLZlqY=
X-Gm-Gg: AZuq6aLNJJgo3DRVjjvTxhRLkZQH28rT8UpcbfDP9Z5UOUrTSp08PckuCav4CarmOA8
	QjD6f1FyKH5BkIn5UWzTKVaILbYF9HRHZNX8EIf7ucDhq5nd3Krz85R9THHg1zcQv6sTnyMzeD8
	VP+X4l8ma9hOR+2hkij6EeP5K9AYHHAVsDEjEai0pclPuItb5+yoedK7GI7cZvDNOdRyWeNykMw
	syazHgIdJfC5vEcMdC4ec9tzI8SFw0ocZ/lpwTr/DWniimCFFcl9Ltmf0x8by3xJyjJlOXkBgNJ
	uWQJfLhhmDs2vzf8jtxB8fd9wzYGxsGWIuwe3ftNUTks7Odf0zQVHbmxHuU/Q1RF8/OJdYeu4bK
	nUgH9++3PQW+Na1Iw1ZRZFbo4w0MTjzVsk1dGwNKsjfhhfoSlz+xaaOo70ccSX6QMxTSkaFDvnt
	O+JYaA/R9kFC4c+Btch1PhwMgtzdsqkZVdAwaI5o9hfQ21wfE27kFYOBf0k0qCcXuDyZ0+QQ==
X-Received: by 2002:a05:6214:401d:b0:894:71c0:6fc with SMTP id 6a1803df08f44-894ea1170b8mr13110576d6.57.1769721477709;
        Thu, 29 Jan 2026 13:17:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36a5ca2sm44936276d6.7.2026.01.29.13.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:17:57 -0800 (PST)
Date: Thu, 29 Jan 2026 16:17:55 -0500
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Message-ID: <aXvOgw2rc8X7Cqxa@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>


Annoyingly, my email client has been truncating my titles:

cxl: explicit DAX driver selection and hotplug policy for CXL regions

~Gregory
