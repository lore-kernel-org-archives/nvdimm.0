Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F4C26C39E
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889209; cv=none; b=t9NBTh2OW9iZat95Un96OaZNawBQblfLI4ezuNAJ8CBqvp2zGKFmdbczmTgdb757EdMiU2dZk3avvhvWfFO8iDSPvCTcMoPf/LE7/Uqsb5CWuC1R6tzpao2Gy2a4BYWI5U1k+vXsKWMMOTTzU4sN+7UBBm8PDmeEr7m0kpGXLiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889209; c=relaxed/simple;
	bh=yvNU1AvVWUsd+D1YN7GGiy/e4EfmDjtr0T/TuSwjWKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjjEZPqSwbexiXv7FYWlNk3BAvpiP6arW7go/NxOTXok5pXRqM7noK4OyF1kdFG7HoX4RDd98oFcDowmEkqwxSnSh/Q1grQaNXGFNnDew2hldagyURrHCxpyYGquHUjbIl0ubrvXwSQBW0cpslfAnZBqwCJhYahb3u+UtpTEs2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbNP4iBd; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbNP4iBd"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7cac8231d4eso2009890a34.2
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 08:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767889206; x=1768494006; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HVhhJuuiBGoK/sFvk0bqtRfj9CRgQvxP/k+MrdnYe6s=;
        b=EbNP4iBdEFKAkKvn5ORtAYkqTcrIBwreiLvFasQlDXSn9h6alK4RjnHkjWJGKngcp+
         rZl5m+2BdICMa1wphfa3mIb0AHsx+pIFyJobdbpn5rAGt4Z+02RsSLaxsYhXQqv1PwUB
         FK2Yf8Opu/5FSSn5lVoP2WFwYrG8E/ElOJiu98YN1Ao70gGpYB3WRpd9XTyPBpF2O12t
         tzfrXiCqwOfRnSlz0RKUxX+Huf/OsnnfYZcgaIHVwOxS3WLXZSAXPLnSrezOK7Rbw7MX
         BghZchaeC6dkdKm1ibastsl21jDG5kHtWOtPeyR1HlLhGCkhURT7W7hGva5S1miO1yCK
         r8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767889206; x=1768494006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HVhhJuuiBGoK/sFvk0bqtRfj9CRgQvxP/k+MrdnYe6s=;
        b=eQE4rQGwQSejW5Focdm51/UjZ9xl5C0lF5nBHnd/ydAhuLkDes0TRmU5MgkQGhdEbN
         kdgs2KqlnnHYsZETaBRd80gu3DqL+xg5vLte9yN3uLQyJLreNqxL99/yNsKJQ0ZJE9rP
         tZe4+RQUI9gs31IDQqwnSDirYTbaQbu6ce7fIHgB5gC4UbTwMHBwqtPkjvWjY6PP+Wrz
         Lqw7H62acFtVDNtPvZyzb+/StBS5bhjsu5FhuohjDNApff6NNB7EnUeCQ9GkgzwNLTve
         klhDXaWjPEQlFJcZIUH+zrAEBtQAbbm4uZiRip/tshrOtd5Uh0aXJ6ulF+Tyk1ccpUZ+
         NvlA==
X-Forwarded-Encrypted: i=1; AJvYcCUASmwqPJdEZTsRWheGNF3Q47OE/LOzsrZLO0hqjXJnqEyGd7z2JJxUKhyKAIDfuXy/F0ETJhk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJpu/RFUmQQPmwGLxSLetesg6VcYba4PcBAC6l4NN/xcFwsuYK
	sk2wwHUi+hFoIKdXi+7faVRNqjbMfvPRFFqFSVJQw/xJyc4WEkuejEVw
X-Gm-Gg: AY/fxX4XMbjMkqfkyAloUw1YufDakLxJYd2u6U4Wa32o+kPVZEg6YhHgm0Gedwz3JiP
	DV3C/NDccu2PWdUBPKstRW4XeaMHO4pENL2UOZ8s97ftFjL3nQgGBzQmT4LgzTkC0LfUz9+QbLx
	inh3eXG53n5v28utV6GRDYvSPvM/1Vhv36mxyjGoIJcg7G80JjAfXZtuFRxzXxXks6tw8zcjQ2E
	qprGtuBfGkj3sShV2jCYDdPTcEP30h5SQwMBX3uVKHwcqALXo4rlckjLFtmlCgWdryzjUYxMsTR
	l/QG4GlQbZ79FBAKqFDsApdn+rb13h96tfgBFvy3enxdh6FsRG3KKZ28+rcw99UMVdV5aLx0PIt
	W0f+sbSgtcecWh2zGeLZ/NXwrMvxh7R+XACOJwbXBAvEPBPVL2ab9KDcMZA2hinykI1EqVAbP2k
	A4KR8kr0uABcxZAEdQCZ3f7sZ7liYUjQ==
X-Google-Smtp-Source: AGHT+IH6THnfmjfea6h0UnYX2fNH0dcgns7iJzl58Bvp4j/zTpmPcfdP7f0qEllI2ONh7EMKMC6yuQ==
X-Received: by 2002:a05:6820:f002:b0:65d:1e7:9526 with SMTP id 006d021491bc7-65f54f06dfamr2864960eaf.10.1767889206030;
        Thu, 08 Jan 2026 08:20:06 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48bec1c4sm3344121eaf.8.2026.01.08.08.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 08:20:05 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 10:20:03 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 05/21] dax: Add dax_set_ops() for setting
 dax_operations at bind time
Message-ID: <tndv7ezryq5m57r5iyoyr5suq5lliy37ciqluia7gh6znaecry@nfwbtzmsvcyn>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-6-john@groves.net>
 <20260108120619.00001bc5@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108120619.00001bc5@huawei.com>

On 26/01/08 12:06PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:14 -0600
> John Groves <John@Groves.net> wrote:
> 
> > From: John Groves <John@Groves.net>
> > 
> > The dax_device is created (in the non-pmem case) at hmem probe time via
> > devm_create_dev_dax(), before we know which driver (device_dax,
> > fsdev_dax, or kmem) will bind - by calling alloc_dax() with NULL ops,
> > drivers (i.e. fsdev_dax) that need specific dax_operations must set
> > them later.
> > 
> > Add dax_set_ops() exported function so fsdev_dax can set its ops at
> > probe time and clear them on remove. device_dax doesn't need ops since
> > it uses the mmap fault path directly.
> > 
> > Use cmpxchg() to atomically set ops only if currently NULL, returning
> > -EBUSY if ops are already set. This prevents accidental double-binding.
> > Clearing ops (NULL) always succeeds.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> Hi John
> 
> This one runs into the fun mess of mixing devm and other calls.
> I'd advise you just don't do it because it makes code much harder
> to review and hits the 'smells bad' button.
> 
> Jonathan

If I don't stink up something, I'm not trying hard enough :D

Next iteration will be full-devm.

[ ... ]

Thanks,
John

