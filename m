Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C622C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:34:18 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09B961168;
	Thu,  4 Nov 2021 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1636047257;
	bh=AR8NcrNj5hyA3HWt9nLXt5h1bS993/cghgbNSGVz0kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JxlU4yVvWXPKAVgMlcKtQCmxXE/TikimATxyIFd8unO637JRzA9xVEGorhtbue1Al
	 eAjNGYaYn/WxnzE1oojAaGA4jsOHFJledlnSyk5GXBYjtaYzo6Vrc7SNp5YLO8KXm5
	 GnXLyjMFRczpgqpxzikwuszii7B+smdLRFlqr6ePyrQtkdaWhWxNadYJyLsd2jgbpP
	 Rc+pttEDLYdgyZbTpx0NqCCj/YwPUR6PiF/crWlSmxacWLyoEpUGMiWV6we2w37+Rm
	 T+p9bgJyo3VrNLtooKl07eXMQfg5tpv2X7xvy3irecWZ0ZYekQFGKTDVcUnLqQe3vh
	 uWg8NUeRjeEXg==
Date: Thu, 4 Nov 2021 10:34:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: futher decouple DAX from block devices
Message-ID: <20211104173417.GJ2237511@magnolia>
References: <20211018044054.1779424-1-hch@lst.de>
 <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
 <20211104081740.GA23111@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104081740.GA23111@lst.de>

On Thu, Nov 04, 2021 at 09:17:40AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 12:59:31PM -0500, Eric Sandeen wrote:
> > Christoph, can I ask what the end game looks like, here? If dax is completely
> > decoupled from block devices, are there user-visible changes?
> 
> Yes.
> 
> > If I want to
> > run fs-dax on a pmem device - what do I point mkfs at, if not a block device?
> 
> The rough plan is to use the device dax character devices.  I'll hopefully
> have a draft version in the next days.

/me wonders, are block devices going away?  Will mkfs.xfs have to learn
how to talk to certain chardevs?  I guess jffs2 and others already do
that kind of thing... but I suppose I can wait for the real draft to
show up to ramble further. ;)

--D
