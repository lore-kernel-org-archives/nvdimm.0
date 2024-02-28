Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13469EBB
	for <nvdimm@lists.linux.dev>; Wed, 28 Feb 2024 01:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709082374; cv=none; b=hg1W/0uOPJKvCh/V541GHPFosA0wcGOODwDWUZy60iuGyMVqSr/DaD9Ha1e4EeZsXRGiZnPz18Dap1WQFvjsrXu1V71x/OENh12OYUQ6r+u6F4welK0kxAJ5rh/WzxEO7bDJjvGFz8Ok/F1JyGfM9sG6tq1Puq8SvshQM/dDEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709082374; c=relaxed/simple;
	bh=Sm75gcCv9xKtIq0Ia+ywMl1YZw2dek62rJr+oQKTC1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjU7IsNrefAwEcKZu4AKTe6gYJrnZ0ACGQd62WGCGsU9yHXfmN7lzcMZ6HrcheDdZxS10bOJ9oQm52ZWwR41HyxCKHTwuhe+QIXzACDuwb5gKlJrjo4kyUGTGATmsIhpF52vIZX/Ndu2OhV/anyRBjMOKYKKAlP5f3Mllqo54oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5bWynDn; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5bWynDn"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6e480fe439aso2596191a34.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 17:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709082372; x=1709687172; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DhG2DGa6pDHH1VG928nucKPhUiyDvmB5uJFD8WxCLAk=;
        b=W5bWynDnDxCJ4WPILIOnL19vm6s52o6QrcGkE6LhKnqUnshnzzZf9jE7p04NEmzJ1M
         KunXHFYd1dlohOgAq0//h7/VS4XEILhevNf9aTVuv1yCj2dIFraR7Vu4HuX1DXsQHEOJ
         1BkEsTR4ULg4uBf81t95NqtD7x7C/JvloTElvljzAqBXMoB2kDWD1W5b4JvRzAPWvu39
         A/Ebk5G+/bIcw9Tz8wSjZEpX7nRB229I4EuYeqbxGJSwfzI8By81GDxU7/K4gMT9BNb4
         z7BjdtfnPBZHSQOVT48shiBZFbZri8u4zkBo5lDP896LSTmvL6sKyARhlOv0EkUFA8OZ
         XNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709082372; x=1709687172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DhG2DGa6pDHH1VG928nucKPhUiyDvmB5uJFD8WxCLAk=;
        b=D+VrGuddG1MFbTfoYmqD+XqK8na1s6B8JiVuIVYz8RO+aRpSWFiKvM9bAWJ/UdhbpG
         pX9WPWTOU5DF346IDCSKHFZi+OcFGL/8Zy/nTJgVBN3VF7K8H4y03+GzJ9uvQBc9dI5H
         RwVV2dFlKzTxWmTP2d08Fs6Wq4tjg6n7uhn9W7ueTDT/4eXslcPoUR2f2pmQZaeJQP82
         19B9FLljcM20ax1zw7QtnpOFeaI2WIPBPapH04Q/WtFv1ajS8RkzpA6KVGfQM/19cIpp
         CK3bUkElEAFl0lnQHgbJDYKcrmVQ8vphDF+rPONzhFYtLm8cR3cmm0oacempDGCJ2nUO
         MvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVizH5AnYSgBneoS0SNntR+x2Hy/sk7uJZi5/fMSfFB18vvL8PBJ2JS87bCJHe3ECzO+EKYr0HfctJp0ZC1tlEb+T8m3uYO
X-Gm-Message-State: AOJu0YyQIQSVBXXBWU0jy7o+VHNzHrkquiFWrhknxw8b3OfC8QAdAYOl
	AO7MbtjzcrRVJEXWqtdRHnpbQT96VXaY90P3Vi47DwGGybwqtMWP
X-Google-Smtp-Source: AGHT+IFKfO0y13JodeF6eFlc6IWCbbbk2Jvw3nQLEBpJsjWeW7+WZ/Ry4CGjgxNXq0G9thCXP1TIMA==
X-Received: by 2002:a9d:6a9a:0:b0:6e4:8d2d:64e5 with SMTP id l26-20020a9d6a9a000000b006e48d2d64e5mr11096665otq.13.1709082372064;
        Tue, 27 Feb 2024 17:06:12 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id p4-20020a056830338400b006e2d8b5d9e5sm1713834ott.21.2024.02.27.17.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 17:06:11 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 19:06:09 -0600
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
Subject: Re: [RFC PATCH 08/20] famfs: Add famfs_internal.h
Message-ID: <agvghv2lask3iazxtycynwkdydrxqula3pwbrusvwn3e2fz6jd@nrmpnbamp6f7>
References: <cover.1708709155.git.john@groves.net>
 <13556dbbd8d0f51bc31e3bdec796283fe85c6baf.1708709155.git.john@groves.net>
 <20240226124818.0000251d@Huawei.com>
 <u6nfwlidsmmhejsboqdo4r2juox4txkzt4ffjlnlcqzzrwthlt@wsh5eb5xeghj>
 <20240227102846.00003eef@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227102846.00003eef@Huawei.com>

On 24/02/27 10:28AM, Jonathan Cameron wrote:
> On Mon, 26 Feb 2024 11:35:17 -0600
> John Groves <John@groves.net> wrote:
> 
> > On 24/02/26 12:48PM, Jonathan Cameron wrote:
> > > On Fri, 23 Feb 2024 11:41:52 -0600
> > > John Groves <John@Groves.net> wrote:
> > >   
> > > > Add the famfs_internal.h include file. This contains internal data
> > > > structures such as the per-file metadata structure (famfs_file_meta)
> > > > and extent formats.
> > > > 
> > > > Signed-off-by: John Groves <john@groves.net>  
> > > Hi John,
> > > 
> > > Build this up as you add the definitions in later patches.
> > > 
> > > Separate header patches just make people jump back and forth when trying
> > > to review.  Obviously more work to build this stuff up cleanly but
> > > it's worth doing to save review time.
> > >   
> > 
> > Ohhhhkaaaaay. I think you're right, just not looking forward to
> > all that rebasing.
> 
> :)  Patch mangling is half the fun of upstream development :)
> 
> > 
> > > Generally I'd plumb up Kconfig and Makefile a the beginning as it means
> > > that the set is bisectable and we can check the logic of building each stage.
> > > That is harder to do but tends to bring benefits in forcing clear step
> > > wise approach on a patch set. Feel free to ignore this one though as it
> > > can slow things down.  
> > 
> > I'm not sure that's practical. A file system needs a bunch of different
> > kinds of operations
> > - super_operations
> > - fs_context_operations
> > - inode_operations
> > - file_operations
> > - dax holder_operations, iomap_ops
> > - etc.
> > 
> > Will think about the dependency graph of these entities, but I'm not sure
> > it's tractable...
> 
> Sure.  There's a difference though between doing something useful (or
> even successfully loading) and being able to build it at intermediate steps.
> I'm only looking for buildability.
> 
> If not possible, even with a few stubs, empty ops structures etc
> then fair enough.
> 
> Jonathan

I'm through at least the first stage of grief on this. By the time we're
through this I'll be able to reconstitute the whole bloody thing from memory,
backwards :D

John

