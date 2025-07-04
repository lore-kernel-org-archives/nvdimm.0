Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A251DC99C
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 03:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751601212; cv=none; b=IWtpqGUbCBRjfXvIH11Z8sZIWWDHBcU04oDsHSGXjCedL2ZDxB0i5YQAk7oOvYIZ3iaAIuZ0zAd2SXs46ofueJ0AbY4+/q12pKOU9Owi0Td5z6o+ZPY+RG0X7wFo6vok8GE+KxsmPEPCrpMzZdExI5Pbe+1Pht63hF8tvFI3MYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751601212; c=relaxed/simple;
	bh=zwRLPwT2eQg168Wfug2SYslZnKArpTcPqpw6Tg/LhSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUhzvMNtxa855IQWnQPPxflDH+GGPs1erKj5/Ati2Xro/F9g1kLYSJR/BmDqeQEyxJhIwD0TgmTOW7ggsWYGPQP1E+jkE+FJOi2LtlP07G3s2H1pyrPQ3xbwd8HsYbWf2SNpgpSCTq3Ve3jQYwq7936VtoyNKe2QXXx6cQBPwtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIs0fh0F; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIs0fh0F"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-313cde344d4so606802a91.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 20:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751601210; x=1752206010; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V98NwQHZpZ1xGgxUD4OMgi+d8tY5VWQjICNCxbkdWoI=;
        b=FIs0fh0FFTo/G4AmZcB1CxTgHEMySyCBvRRR+ErEOQFH0lPCiQ//SK+UJ0nJjdh1tO
         J+aQXy/DQTaZjtIOSakXFkacZEi2JFiztjurKmWFI9mg3YS2Ls0K/1b8oA96syQzpq5Q
         NV2Aa1ifSPIXpWCcKdIyGS4yfOgEWghf5Nsb+uOE1PZ4uSxr1VKluHyAxuQTkjK1oBVA
         HnPgmGUdNAmZ7NjoS1xD8TawIszDjYohriOyBLIODvQelpwDUj022tK7xfhXfi+DuEBO
         m2LHmp/mU02vCiZCZC6QICdFxW52bYEnuuV/LXkFIJZ2a2W8KXKpzbg0qwLWZiMNjPPg
         QG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751601210; x=1752206010;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V98NwQHZpZ1xGgxUD4OMgi+d8tY5VWQjICNCxbkdWoI=;
        b=bL8dqbjDDo+2b5qgCVTaqUqbcmZWPRZioUF3lbcTIHPFK5TtItF3X45KBHSJyy502O
         uLpdI1kxDkADG1OV/f64itxBBt9T8hfaf+UOojhx0rxK9cWIrYWq1bKu0PddCnk4r5bW
         CZvR9M3VmMdISnP/OG1wmcpOpiCSazJpDnHCXe816X6Y5vVcI7ZN1XuyKn3NVkh7Pile
         HiaJluR2ppFf89DMKGJJAKWWlJl0ABQUozzmd9Xfn0lVTk86ilQH1Yz9Bo13Ud4GBAiJ
         qu9vS+vEQzEcD26WeQuidw05pp9J9dloWIIyhr1OOswjknSa7/r/9+7AlNAes4EYEm4M
         41nw==
X-Forwarded-Encrypted: i=1; AJvYcCUhRHy/qlRn+ziY/IwuXOmSVlLKJ6/H/BkY4JpRzt513rCzhHV0GkoJlYS8zZu3WfFug1NKDpg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwU5LQ1rcBxIw+D3zqzV+wvKcLD253NndtjieXfJ5ylkcwT+cqo
	BfU5Nkq2kEfpQ/4iADJUi4ZiojsSXtF9c1+KYUeJxsb0MVZ4FNW+Bsru
X-Gm-Gg: ASbGncv9Sf5/vaUNtHwLm67srb3ilyIPEjfxrM0RBL02wu4NmNkr7dw8Rj7/KIK+wqi
	Ah3+6EvFtqJIt7NL1+X0H2evSFd96ow3nzlwzaosPu61Tb3Nbddle0OJM3v/hNFbQmqpEHQi091
	KOwJBb2MIVA+3K1gdVmB9FOEiQR16/S5COeAOM+CaDjCcvnJQTWSP4tmIB5tYrHbVFFP1hsGjLE
	8Cyk6GEjiguuJb3SW5MMfvZgKJ678IfxypD95Wa1pmreQdev56wWhasjiCWwYh5o+47aEc5/ciJ
	wfN3ASfcOCMlUW0kwiII4+qIBtXAxc7mUsjG7IRg4TqwsSJiDhOkVFmCppKiVA==
X-Google-Smtp-Source: AGHT+IHogvr66NhGLX5buUAq1Mw27chMolznrtFETznmKR2+R2UdttsZVVX9IjUimzMH84E5+HrBtA==
X-Received: by 2002:a17:90b:3e8e:b0:311:eb85:96ea with SMTP id 98e67ed59e1d1-31aadd231c8mr890732a91.9.1751601209705;
        Thu, 03 Jul 2025 20:53:29 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaaf2cd54sm831381a91.23.2025.07.03.20.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 20:53:28 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1E7564206885; Fri, 04 Jul 2025 10:53:24 +0700 (WIB)
Date: Fri, 4 Jul 2025 10:53:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, John Groves <John@groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
Message-ID: <aGdQM-lcBo6T5Hog@archie.me>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-19-john@groves.net>
 <aGcf4AhEZTJXbEg3@archie.me>
 <87ecuwk83h.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ecuwk83h.fsf@trenco.lwn.net>

On Thu, Jul 03, 2025 at 08:22:58PM -0600, Jonathan Corbet wrote:
> Bagas.  Stop.
> 
> John has written documentation, that is great.  Do not add needless
> friction to this process.  Seriously.
> 
> Why do I have to keep telling you this?

Cause I'm more of perfectionist (detail-oriented)...

-- 
An old man doll... just what I always wanted! - Clara
