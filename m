Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934311DF248
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182233; cv=none; b=l5OVa3hk5PoWH0lNlqBRSHclNfsgmN9EZGcdr1Yx/3VJUS0DnzDTOYzvNNrxImzBzGsN77mzaBTf5GZTXdBoTEMyV/5qLhdKe1t9H8cnq8SQxw5hysUQ2wcQwIifPF1RgVg9/gJuZ7hGeZ2F0qyb1Q4+jU1yOEvy+Wk5fDh5SfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182233; c=relaxed/simple;
	bh=NOpPaMEGwARq4CHAFNBf771d9jPnS5ZeE6rfKhlvASU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2Ykeo10mNwrmh/+gQIPLI0pDWgpj6o7QNQwBunwnae1QCfR5KGZZKYGCIa7mx3eSeovkg2HHjcIRn3HNZBChKXBW7azlmp4mcBqInbWzd9rCSk2aCfS4ijyS+M/gmZy8+zeo8Xt1pCsehT8hX9R5695kjfax4tfrjsOR2LHnIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Ihugm+2g; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Ihugm+2g"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b109c6532fso9227111cf.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 07:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755182230; x=1755787030; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=thFJCyGfhvQRRqY0DjMQa3Qo17IKtZ1G40gUR9k6ews=;
        b=Ihugm+2g0ABCriOmf9qjApZ2cESoLvfDTgcw7ProloU+rnfmez9RUk0ih6XQGiigy7
         E/8ss330WJwlv4RqZ5SH/p3AvOGMBV6JWtV3h7xIBq+Yjde2qbYXbcmwLnbnWiKgkKfR
         ipxMpp6yTLB4sPJUpYeISczeFsxogIA5noMeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755182230; x=1755787030;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=thFJCyGfhvQRRqY0DjMQa3Qo17IKtZ1G40gUR9k6ews=;
        b=b0PrVMXypXtuz/a05rIxSmjM/krC66lCu6PyXneU1C3SeeW8nXs5gZ5Gz/9cM5h9jR
         gDdAlJ3qAJxdWuYrfmHYKhSBw6Jc9PwweVEfSAB4zg7Vxua7yDWzNn3xkf/+lYPZe/mh
         rNMaQOgHD9cLpZTYH0PcBGL1zgDNxMTxg33p4tP9293Wnw4P0fQEaq6sZyqmxW8jYMXi
         n5wxu+45GsZO+72/j9aTbMZSRTdIxXoBExU9TZyn9pPmhqJY+S8YyaMPmHKvZT2A4h15
         3WZV1pkX+JctlbECJHb/VBZ00Mh7v8kHZ/sFBoGwxZQwehyip77JUerxioeh8IvNkaof
         4Hbg==
X-Forwarded-Encrypted: i=1; AJvYcCVKrqhwP2PAB72ThMm9ecyzUg3XDhwNlssVEHzkfCjiUoKAPWI8ZXHA76PEkdMhRVjnLIeHy7M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1jK+TIqe/ld+pLapiHdOir5ni7SBW1uBhkxQt04gzesOlEXgI
	ZcCftaWiPxkS3TwZbVqHjQGzEqY8SyvcoQKqMVu/cO59YHu66qzjEqSnFR2Ayb7Vwsj+SGD0MqG
	kgoLpH2LOoe3/m/nmI+qkznzx/Yk3qjSiONeXprSkZw==
X-Gm-Gg: ASbGncvFjJO7d2391bWiZ73MiaqXwq7fxrnSuIDPNcFk5TEHhPE0BbjE2dReucPhZoQ
	7YSKJUXYmWY1Ocud8vSGWuE7+ktoD/CcH3k0Acyp2xayiIUa0Nu5p8cPy7l0jYgzfGT3yTz3Gex
	4NGa/tShxC444DfTB/AnXlLNbKTscjwh08wlABwgSweSsKdMnBH6D+IA3xERF4xaZxK+xTAOzya
	iV1
X-Google-Smtp-Source: AGHT+IHnfRI5xHzwEiwbnlj4w/zFMDDNEEaatcq1mpqAAB2GV7mMF1beVsw/Q/x3FPL39V74ikfbsx8wh3qug5aBccg=
X-Received: by 2002:a05:622a:1926:b0:4af:15e5:e84 with SMTP id
 d75a77b69052e-4b10aae7b12mr50528031cf.42.1755182230192; Thu, 14 Aug 2025
 07:37:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-13-john@groves.net>
 <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
In-Reply-To: <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 16:36:57 +0200
X-Gm-Features: Ac12FXxrfsSu-05pCnMumsCzYXADqTJ2OFTZfF8uQPidyp6kmWUcoLNSx-lr5VI
Message-ID: <CAJfpegv=ACZchaG-xt0k481W1ZUKb3hWmLi-Js-aKg92d=yObw@mail.gmail.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Aug 2025 at 15:36, Miklos Szeredi <miklos@szeredi.hu> wrote:

> I'm still hoping some common ground would benefit both interfaces.
> Just not sure what it should be.

Something very high level:

 - allow several map formats: say a plain one with a list of extents
and a famfs one
 - allow several types of backing files: say regular and dax dev
 - querying maps has a common protocol, format of maps is opaque to this
 - maps are cached by a common facility
 - each type of mapping has a decoder module
 - each type of backing file has a module for handling I/O

Does this make sense?

This doesn't have to be implemented in one go, but for example
GET_FMAP could be renamed to GET_READ_MAP with an added offset and
size parameter.  For famfs the offset/size would be set to zero/inf.
I'd be content with that for now.

Thanks,
Miklos

>
> Thanks,
> Miklos
