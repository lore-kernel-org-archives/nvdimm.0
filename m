Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8182D73463;
	Wed,  4 Mar 2026 12:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628930; cv=none; b=YN+ht1BpU5FAb2+S7R7heu0GWpCIiZcqbIL+5GLoT6a/x5S+gp6aehXkgomWIUIxKGOR/CL4o1x44qGdzaSwafdPbq5RWssGa7PGfG2LxeWnOSAcKHWAd1G3nFK/+qJR+OVHIz61p3Wr2y+lonu7DorNrbXFQv/gFh1dbWIHckQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628930; c=relaxed/simple;
	bh=YOVUcvbe65ZJpd4Sa/Gyz3S1wnefhK4mWrP5HMD2COs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2X7vIzeuec8PMGVUQzQRUux0svI3q3aKFPCLIQavPPjRsQOVrmb+wE04QVNxl4EmmjZ5YtIutJr8mHXGX+otOU+1HgHOkBEQAWcU/9HW78tRWoS7LTjiwvmCn9OeJzaFYDzcFeSNXqH3frk0ozBKg3qj5zECrfzUvNiODjflv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXJ5tALs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXJ5tALs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17ACC19423;
	Wed,  4 Mar 2026 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772628930;
	bh=YOVUcvbe65ZJpd4Sa/Gyz3S1wnefhK4mWrP5HMD2COs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sXJ5tALsZ3x+Xm8IRWMMkdygQLA/rJbgtfXgLxP5e79JNZxC1bITeYuabK/RzE1Nh
	 bhWGnOkCOdDPttDDSCP36m/lnqK05MwEJURAtHv8KeRvCIK3CFPV8lnQn6hMcxAYUx
	 0/gWHfjp/TNahdP9yDw/ZBMLVn4CMyFUPfXcwnT89dEM3x29orr58m3pQYKvIJNgFh
	 xHKrmO8frvKRU8hlUrRZt4KecverAwoHXSr4Sf/pligM0Bd/X5/VuJ0y6jRdbD5xSw
	 fhbLQo4KQ632nxvSOa6IpSftyx4aUDfoMt926sT1fOObQVz4ygu+GbjkWS6x3SASzA
	 uphtRWGOcqyrg==
Date: Wed, 4 Mar 2026 13:55:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, ntfs3@lists.linux.dev, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: support file system generated / verified integrity information v4
Message-ID: <20260304-sattel-filigran-aa002d3e3983@brauner>
References: <20260223132021.292832-1-hch@lst.de>
 <20260302-legehennen-musizieren-08d0e3caa674@brauner>
 <aaWVQ3g6vsDB4GvQ@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaWVQ3g6vsDB4GvQ@infradead.org>

On Mon, Mar 02, 2026 at 05:48:51AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 11:11:22AM +0100, Christian Brauner wrote:
> > Applied to the vfs-7.1.verity branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.1.verity branch should appear in linux-next soon.
> 
> Note that the branch name matters much, but this is a different (and
> older) use of integrity compare to fsverity/dm-verity.

Yeah, I know it was mainly named for the related xfs work I had expected
to require some infrastructure work. I'll rename this to
vfs-7.1-integrity which is a bit more generic.
