Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E112CD9D
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708963948; cv=none; b=DlfSwrvi6DpDWFG4Cbv01wnjbZltKxh2RTPtU6Rvk5PVfavEJ+tf5sw5p3Is7uOTLSWrzb3VHdgnmdkDs9hz67j7k8kzYdd2oEhzRiI+oAzVlhijOUxFL8EeI6QND+jlsmLCQ03SayyfNhrY17kBNm/PKxa97bdNmNAVAAwj+YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708963948; c=relaxed/simple;
	bh=tQNiq/mgSFz2PUfr0gE59I6IY0MHAe5YR/fIFXdocZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvCgcKrvgZ0y0xd+FrFdwkJGx9LVZgNfTybn+ZK4xNIr32ZnjyHw1k9gNgJrkROrRgu6YtUxg1i6m8STu1fHwhi5Rng/H7msuVoNdsQxzQGRzNXNwI5p+eNWptor/wB3gCFoZAK7poLIK+XIan6XiG3EUwgXT6H3HXdlUSKXlPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C2dFyw2Y; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2dFyw2Y"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6e45ef83c54so2059117a34.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708963946; x=1709568746; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3G9TdB9RDZyiGXRBXvJ+nwad2XnEGLHfMJJdqndI5mg=;
        b=C2dFyw2Y6OdeGfH65v+7JE1fSw9DzJ83OIDxuYrx7kVejjz88GtVQLDnH/UVUdDqAT
         i0xYHoUXJM3RjB+C5v1I8yTcf16Td2GuiAC1vXqoS3bWb3gfPc/k2z+esO+kMCiaBLKn
         g9mQv2/FuPtab4qjIcUrBdNvAvroCNMqUHsjjapPWbgw5nkMhHUL6d3lBlX17nDIUg1r
         nfcWZQK3XWejZPWOHclGfVho/pPd99+hryNEXdC28X2i1XcUAOAyE22X6Mfk8UV7uYQM
         R1LS/Wnl/S248YsYpO++zHUQSzRhD8qZnvtaIRwJ7Kt7gVRZbisuUnUteCkRXNPg3x25
         YcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708963946; x=1709568746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3G9TdB9RDZyiGXRBXvJ+nwad2XnEGLHfMJJdqndI5mg=;
        b=bJ6XpRv25KeWRk7DHxzEJGr2/Z3yUxY/Mpz1TVIuF2aIwPDl3/HO2YLmbj45PkDqED
         ZL5MbsKWkeei6FsSBQLd9MTDASSOxeCVJ7MFH93K72zXtYMFWaQVHZNjRJUFLdTc4E/z
         5XCz0JzRoMDMLCaCi2APRUYmTXW+Q49/EqGawNXVVb+AfodSAG85kGhti704vS8f94la
         1a722uShewEkP7lu0R9Zf+bATZdKVX+rJDysGnERf3pmFYZnk4Dp2KlbRfgatIlkbnJ2
         m4rKoqjX5rDPjcpc8QhOA8YYDr5w2Csy/y6OWnlYtcjCmiLGOBSxTufZMVHeOr18KBJC
         8rWA==
X-Forwarded-Encrypted: i=1; AJvYcCUb/cHR+Tr7iJXoI1T9wuyEVh2/+jpCSer5htSyz7FW9JQivzwQxmb7vnhRLJi3+5dcdsMBySyMeOzhvs2z++OuAUNcjRDc
X-Gm-Message-State: AOJu0Yz/n7j3+4cN12Sw7P7E2EGSm7WGnbssVzb50IphYUHOPfAVyPjZ
	CNOwbqwYcPhumlJ4e6xBpNNre4fxj+BXOju+2lFDGmkut9qgigAL
X-Google-Smtp-Source: AGHT+IF7XFSvjH18bFGEx9CdpnvASYnU/JfYs8/rfFLnUGwRoKon7Rt5YnfmRZ/vr9pQMg4VgCwROQ==
X-Received: by 2002:a05:6870:e413:b0:21f:ca80:52c5 with SMTP id n19-20020a056870e41300b0021fca8052c5mr7306817oag.4.1708963946299;
        Mon, 26 Feb 2024 08:12:26 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id xd12-20020a056870ce4c00b0021f86169b99sm1583576oab.43.2024.02.26.08.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 08:12:25 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 10:12:23 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 06/20] dev_dax_iomap: Add CONFIG_DEV_DAX_IOMAP kernel
 build parameter
Message-ID: <52dovqfrfdvtwa2l5oiujxoe2e7asbz2qpslq7fb3axf5hdoem@m4j32p6ttrrf>
References: <cover.1708709155.git.john@groves.net>
 <13365680ad42ba718c36b90165c56c3db43e8fdf.1708709155.git.john@groves.net>
 <20240226123416.0000200f@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226123416.0000200f@Huawei.com>

On 24/02/26 12:34PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:50 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Add the CONFIG_DEV_DAX_IOMAP kernel config parameter to control building
> > of the iomap functionality to support fsdax on devdax.
> 
> I would squash with previous patch.
> 
> Only reason I ever see for separate Kconfig patches is when there is something
> complex in the dependencies and you want to talk about it in depth in the
> patch description. That's not true here so no need for separate patch.

Done

Thanks,
John

