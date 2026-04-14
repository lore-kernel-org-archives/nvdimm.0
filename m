Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486E38423D
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 22:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776205243; cv=none; b=rqBfUCgOYuqslBUwbW7tTD29PbGainYIrB1PI2L3W9e8b4si3muxgvPipHCfXArlPUka0Aj79tGEStX0Ue8UMa2TK0HOtcXJnuNBhc8xVbeEZruKpH3/DR7vEpxLrr74WlW0sEATTjXhpNUM/gjpbZKFL0kEiuyVV9mwXp4Zk2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776205243; c=relaxed/simple;
	bh=SCz+KPN9YjbCfPPXmoZdkTDhatvU1qb3F8G3qjLE0b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEZz6rRmthPQYiK11+M1PVLamoJnQHUERdCITfQFvqnFWf7pLi37mRUNRmjDkES+lm0akvJsKz70mYxFQOkWLk79kh6hCP4SzZF2LV4mPdPmPub5L5ctS7PAUGu+RBA62ksWUtj7f+rwsxs55onvqFpce0UKDFnb1rAlbWLrTy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nIm4HZuX; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nIm4HZuX"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a016799d2cso67752666d6.1
        for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 15:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776205241; x=1776810041; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U1TOx94HrlN1IHqKeiPrm5D2LnSk9lF2MFk+8RNa9pA=;
        b=nIm4HZuXVMvJXMOzbhskVTBVyHQTGgCYbSOMPendl69KT65huwaFnpCP6c8UOVlCWk
         RitZmAvolAc3P0im2wMnCkiHiMkEruAygRPEw3AfAlDzku7T2W9nkKKUZNMc1YIhoLBV
         YfPFYc1r4dIjNA12F7A0Hg5OUyqnbv00yPjp06t8ulT9rJBgMjvgsPEvMCCOXvrzBcP6
         yd1Z9SA8AV6vEa8K3pVS8oDhEFuQ/F98EnkuEuLkocQOG47kO2EQDFBTvEEBlrassmVY
         TU3ny6KoVaaeF54SYSgVVGqhveX9A156qW+RGCgGu/iYTmCHirIn72sJtTrDzCDxluIN
         7sSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776205241; x=1776810041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1TOx94HrlN1IHqKeiPrm5D2LnSk9lF2MFk+8RNa9pA=;
        b=oEdvE4jqkOylPRPYSO5YXNTyy3ErBHZWiRReFdYK8dWr4kLh1iL7QPnCEeBvIElVYS
         4ygxONeDdOP22N2AY+2/MYOjz6nuFwuhkSKlezGA3kR0EvKaHQkOAEuoKusZ2F0J8f0f
         MA5lJX7y12KiFe0YietArWHI/URtBWFxbh0pDroI0hV/9OQuCm7FGXqGvkYTHazcGTIz
         A0rXxeHSk+tJ2ayG/z6tkaRFCL/icTzAJ3dZVA+hfY3S1L86a+ZMhBBzxKCFdSCqopLc
         vl7i8HO/TJQQFOIUW+wUjyInmh3QSgVfb1bM0yq+s3xNVb4TIKcqpeDd9m9itgwiWhoT
         4usg==
X-Forwarded-Encrypted: i=1; AFNElJ9NSgkKy5Q+qFoycp0uVIBH3lSmi58iiujGoY3o9c5jDzxgJIcc9VVOpkae3g9PQ+sDs6IZ1ok=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIcrEojvmj4RktOCJgxgON4k37F3NRbgWFqRpuI0/Ky/SVjEUN
	3pGoqSpqHU/ibVPeT303/bLTLNOJ/3PP4wL5giSq7FJ1xy/fziE8oqFljS97xj9v/CE=
X-Gm-Gg: AeBDieuHsEcQHPcCCKRB8JSpdkTlx09/E5wJkDj6xRjrsK+KqrRVzvibXpYY0+XKoJf
	ugsZnW4YqXvSkyLxpasS2hw8UrQOhSNRE8KqUdCg+TMZFtIanFWcT46ddgHdyWd46omnt2dOuPx
	Ggef8sWMskiY2YJ2Q269D+pr8TQhyGC8386f2R78pj6mW1k2wbAk6/l71gB80XbbKGwKTcLiaUa
	GRKDlHupE4Sh0C39lWl9uaJmUnsh3FNqaLJGkHjpjyexEt7Cs1CSesID5b3JTeinBB41bFHltFp
	vYrmXEgxFud7q4syAbC6sMA2nHhEfKUux9hnu8TZb7LKoj/9wHrcB6JHqMCBJkMEnoF7m+Vcb6P
	hB2IRVskp4lQx9WIjch40qhj01zwndpItGqpcKkCOp122buesaMdzUsqholRv9cpmxoaOfuxYsG
	tDEhLmaix/oum46dzxDSKcMghR8aO1Djzph7CeYuY2XYwWS6vQrvFEE42SGMI+6ACy1604PdjIS
	U65zccQysRse6RPhCJTm64=
X-Received: by 2002:a05:6214:260f:b0:89a:14ce:4e35 with SMTP id 6a1803df08f44-8ac861e5945mr307212416d6.21.1776205241141;
        Tue, 14 Apr 2026 15:20:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84cb0474sm132683506d6.40.2026.04.14.15.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 15:20:40 -0700 (PDT)
Date: Tue, 14 Apr 2026 18:20:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414185740.GA604658@frogsfrogsfrogs>

On Tue, Apr 14, 2026 at 11:57:40AM -0700, Darrick J. Wong wrote:
> > 
> > I very strongly object to making this a prerequisite to merging. This
> > is an untested idea that will certainly delay us by at least a couple
> > of merge windows when products are shipping now, and the existing approach
> > has been in circulation for a long time. It is TOO LATE!!!!!!
> 
...
> 
> That said, you're clearly pissed at the goalposts changing yet again,
> and that's really not fair that we collectively keep moving them.
> 

This seems a bit more than moving a goalpost.

We're now gating working software, for real working hardware, on a novel,
unproven BPF ops structure that controls page table mappings on page table
faults which would be used by exactly 1 user : FAMFS.

And that singular user is harmed because it turns an O(1) offset
calculation into a pointer chase - on the hottest path (every fault).

John is right to push back here.

---

That said - I'm looking at fs/fuse/famfs.c and I'm asking myself what in
here is actually famfs-specific.  If you just s/FAMFS/DAX/g - the file
just reads like a simple DAX-iomap backend with optional striping.

Would it be reasonable to refactor the dax layer (and users) to
create an ops structure that becomes the basis for the BPF solution?

We don't even know what the whole BPF scope is, and it seems wholly
unfair to John's and his users to make that solely their problem (for
negative value!).

~Gregory
