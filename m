Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8226E6FB
	for <nvdimm@lists.linux.dev>; Thu, 19 Feb 2026 07:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771485466; cv=none; b=Z/ZxRUwvUwe/3M1KIuzD4WxSQ0zBxaU8bcefgbx7l43ox29AQ6O2FQzqWqXsJlgk4CnwEYcTl4UP5CqadRvxI0rhr2ir5Tbh2FbKHoYKO8WWSuZPA8P4URxVjoZIdRX1rSllOv7D1cbozKahrMo3PtIhKOeKYlEJZANwQjwWOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771485466; c=relaxed/simple;
	bh=ICUE0bteUdxkiGpe4n9eBKgwJb7CEd6x/aJ0sGAuQDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVmLFP8bapdWYHrAw/cSyyMdn3YehCnVz1Y6ROWNPO1qH4EI2pK9I9ig4VIv8Js6JSSvF9OREVtRIAZxTEpnXqANO0vrgSPcZMNZ7JMlw5GFXgE6CyOBWP6JKCceAeEypbPlMeUPtK6N8ZR7AF6YBnSMfpxdno8Sn++sv7wbJfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 84B7A68C7B; Thu, 19 Feb 2026 08:17:36 +0100 (CET)
Date: Thu, 19 Feb 2026 08:17:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there
 is a read_ctx
Message-ID: <20260219071736.GB5460@lst.de>
References: <20260218061238.3317841-1-hch@lst.de> <20260218061238.3317841-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218061238.3317841-11-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI,

for some reason neither my local build not the initial build-bot run
picked up that ntfs3 added an instance of this in 6.19.  And oh my
god is it stupid things, so the series will grow a patch to fix that
ontop of the fixups in this one.  If only we had someone to actually
look over file systems pull requests :(
