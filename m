Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85104AED7
	for <nvdimm@lists.linux.dev>; Fri,  3 May 2024 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750692; cv=none; b=nx3seC8mzIdcuDSoDAfRjx9CrX6wzfMGljK4p1VChETM9XVyqydWupzLwABmajUfF9KyhWqPT6BDM+95QoyFH7eb6eXu9/ei2Tll0WuQNEbG+1W5dAtcVxLpKo2H3QhZ2+VVr2F2FyGQthD6pxFQjsXCJiWbnn5uPt2YvG1LKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750692; c=relaxed/simple;
	bh=cDQ3u/CXaUY5Of/Cl26YkTLnL8uhLQ6U1jCRpoQi9ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFD5KNWMg8+xmYoYJwOC4p30guB55rYbw9loVbt8xSdlXGuOBL9crlEChRcR1o1Yz3hwduMPLOMVkVBtwb+aMqmSY0idroDYnqQvoepQExJAyGBEi/yG5dkf1orcsS1tg64d9OOn/+NLx08N0R4vQqJRcd3aphDNAWKBwSTFQ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IFwm8Uj9; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFwm8Uj9"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5aa362cc2ccso5783452eaf.3
        for <nvdimm@lists.linux.dev>; Fri, 03 May 2024 08:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714750690; x=1715355490; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/B6VoK43BAi8AR2X/X4aT3bzABV07D0UCLRCGFiZBM=;
        b=IFwm8Uj9sxoj5Iz/eqb2wfUjXh0WUAY6+VC9GZDUYoT8paRmNCG3jL3dZd4uRKU6LZ
         RsqS+KOZkP+yrRDBNObg2TuiREZtz+GXo4prQUByxsgt/xzn/HTuBROrB6Gldw1SI7ZC
         jos05dUnnSjc0QQzDJzpT4R60nuPv2RyGuYQfMW7Q+AUME08Q43tZxp980DRYiBATixF
         SyuwY3FfMNQHf7o9UcAkdID1RlaqeCu9qsF2PixXliNAdk7vhNmmAP4gJGFJmzJ8ZcXi
         es46kZP1YRfSbmdDPL/gfnAshguR2VCt8D7ZmId/P5wrpHe3nirqXS5/820kMUUT3RqS
         JSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714750690; x=1715355490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/B6VoK43BAi8AR2X/X4aT3bzABV07D0UCLRCGFiZBM=;
        b=rLrYQewsXLB/rrEt3bkmDSjuAcrT6JyB4VdSwheTp80NFTIrUChU/TXrik6DEQKyGp
         Gww4n3WgRNZcROmTJkMYigPtqjAPA6x51ziaWd74QdHTAux65AHQqBufQDCO2PuQlWpW
         QNlPaRktND6/yahslp6pOVRCPKk4f1/6+GN3I5TJZwnAOf/y/evQwEa3MzV8FMPiw681
         r1U0wDS7cYCWpH6Goz0m5+yTkNpMfBa0DOa2qAESUwt9nWvR/lmH+k5QNSrkkIC7yvJd
         F1v5O18m2xcF+OcyujX1WQoIrMczHMA7A5UKB11FS5Qqazrbu3zzOu9gtTxZSl6c1jXm
         r/sg==
X-Forwarded-Encrypted: i=1; AJvYcCVo6y9fEjU1E4D5dXKvcjWRymvtgd0u5IPIaPEJwuve5hNTVtcJ46WZLY8GKU52DlvRYp+3vZNMh8bFKfypME1x6G0tBoRS
X-Gm-Message-State: AOJu0YwooS8wbuW/saAS89MvtzED+vdpLPmkNy738dIQfJ5EGcZoolFe
	6vH+EdfCxgL50P5g2QA7I1ey2ikXQ/Y9fvwSMvOVm4upih738yhq
X-Google-Smtp-Source: AGHT+IEFu9BR0ISADGxJbE24i5mw/wIXgLL+GRAWkh90N+Ksp2ghyt7cJKEfDnfpwFO5lNH0gx5osg==
X-Received: by 2002:a4a:ae42:0:b0:5aa:4e19:39aa with SMTP id a2-20020a4aae42000000b005aa4e1939aamr3144492oon.2.1714750689801;
        Fri, 03 May 2024 08:38:09 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id s19-20020a9d7593000000b006ee4db9f637sm660586otk.52.2024.05.03.08.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 08:38:09 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 3 May 2024 10:38:07 -0500
From: John Groves <John@groves.net>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, John Groves <jgroves@micron.com>, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com, Randy Dunlap <rdunlap@infradead.org>, 
	Jerome Glisse <jglisse@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, Eishan Mirakhur <emirakhur@micron.com>, 
	Ravi Shankar <venkataravis@micron.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Chandan Babu R <chandanbabu@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Steve French <stfrench@microsoft.com>, Nathan Lynch <nathanl@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Julien Panis <jpanis@baylibre.com>, Stanislav Fomichev <sdf@google.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 07/12] famfs prep: Add fs/super.c:kill_char_super()
Message-ID: <fqothg6pcgsmuctiydtyfmcwbmkr3uxd2h6rpbfchtfu5a3caj@dy5u7xlwqtt3>
References: <cover.1714409084.git.john@groves.net>
 <a702d42c922737c4f8278617db69ce2b6d813c5f.1714409084.git.john@groves.net>
 <20240502181716.GG2118490@ZenIV>
 <eiobix2ovov5gywodc4bqyhhv7mshe7bvbp2ekewrvpdlnz5gh@6ryuna2lfpt7>
 <20240503-vorstadt-zehren-caf579725c2a@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503-vorstadt-zehren-caf579725c2a@brauner>

On 24/05/03 11:04AM, Christian Brauner wrote:
> On Thu, May 02, 2024 at 05:25:33PM -0500, John Groves wrote:
> > On 24/05/02 07:17PM, Al Viro wrote:
> > > On Mon, Apr 29, 2024 at 12:04:23PM -0500, John Groves wrote:
> > > > Famfs needs a slightly different kill_super variant than already existed.
> > > > Putting it local to famfs would require exporting d_genocide(); this
> > > > seemed a bit cleaner.
> > > 
> > > What's wrong with kill_litter_super()?
> > 
> > I struggled with that, I don't have my head fully around the superblock
> > handling code.
> 
> Fyi, see my other mail where I point out what's wrong and one way to fix it.

No luck with that, but please let me know if I did it wrong.

https://lore.kernel.org/linux-fsdevel/cover.1714409084.git.john@groves.net/T/#m98890d9b46d9c83d2d144c07e6de7ae7f64a595d

Thank you,,
John

