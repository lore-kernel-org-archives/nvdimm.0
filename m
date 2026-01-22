Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26535029D;
	Thu, 22 Jan 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104949; cv=none; b=dtb5BPhLp+mJJTys5UoJMjCD7bQSfdVdy5tOMeIVSdffVVHXidp/UJA+2otSdtISc05khqmbOFve3oR54POfabUurXWdaP2Z5XhhTOT7TCVhkYniznxt6iQ8WVyZovz5+cyctRJUUePkl+BVuufgaxmh997gsyxS1t4L27wtTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104949; c=relaxed/simple;
	bh=CH83nVbv8pe69poTeVmWvk4K7nkSvE2shqYV4ZdwS28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMy8D4aAbbcRTflX3FfEqe6e5H/84i/9VEm9Pd7nr0VD+tQ0sxLvJD5Qxz3sIQhaOezsHxF/+a3yoVNLrKSmji45iTl6PUHthWR+Cm37LBU0x1YAk8f75l0VfTBqq6pQV5US/vu6Ngr9LV/cNtf5gMVseQFWpHYpnGQeiIzWbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OC5Kj0Lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OC5Kj0Lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BEBC116D0;
	Thu, 22 Jan 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769104949;
	bh=CH83nVbv8pe69poTeVmWvk4K7nkSvE2shqYV4ZdwS28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OC5Kj0LjKUd4cUSFjtArBhgJvrgYRugpo9nmGRyVJu6N6UAECo1g49jORZv41R9o8
	 7SxrVUvtGmx4AagoBoDNeSx12hqxNEy8zaKChDFe2ey9zCq4XWoIi8MLGpwXnDCoyr
	 d0ntukAW5/+UqQxY1uYbCTvZ/omPSwdGBM5v4K6TRwQYljROzQKFFA5biRBawj5mEL
	 iXM6N6tpjW/fnbSFZLxKRqjT4VW9ehoORQmvpmfxGfhJWEoE/jauS0rgvHOlrJ78+L
	 qjz/FHU68c6Fd921N2hI2aunJsyjQYOuaWOaESxEkjfwL7dt7XTvJrRPlUu1rJhqdR
	 qEUo2df1HZxvA==
Date: Thu, 22 Jan 2026 10:02:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to
 bio_iov_iter_bounce
Message-ID: <20260122180228.GA5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-8-hch@lst.de>
 <20260122010440.GT5945@frogsfrogsfrogs>
 <20260122060400.GD24006@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122060400.GD24006@lst.de>

On Thu, Jan 22, 2026 at 07:04:00AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 21, 2026 at 05:04:40PM -0800, Darrick J. Wong wrote:
> > >  	if (dio->flags & IOMAP_DIO_BOUNCE)
> > > -		ret = bio_iov_iter_bounce(bio, dio->submit.iter);
> > > +		ret = bio_iov_iter_bounce(bio, dio->submit.iter, UINT_MAX);
> > 
> > Nitpicking here, but shouldn't this be SIZE_MAX?
> 
> bi_size can't store more than UINT_MAX, so I think this is correct.

Fair enough, I was just surprised that this later gets turned into a
min() involving SIZE_MAX.

Practically speaking, they're the same value so it doesn't matter much.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
