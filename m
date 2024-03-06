Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3411B279;
	Wed,  6 Mar 2024 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709762253; cv=none; b=oEM0QWYRTgbRR0JPvQGPLRifThrtuMPGrVFNhebDVbxIfN/8fPsc1WUjaElJcw5Ox8+QYUXBpzrwkTZRzIHpLKsutaYdZPwwXAHgCZKZWKuqoIR4wSk/7t39+jHORS8pMOt5xbX1X+siMebr+kMn2CAlYkNCozewv+pVc4x4RkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709762253; c=relaxed/simple;
	bh=Z7iU/ZzNOLLbK3i/Dg9ssyRtd9kA3yaWRFZz6DBw2DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rf5FiV/m2JpTvfr67pdvCaiBhEXkd2+MfZ6rf5H8BrTvNlk3b0lEhu6a6AMOEp/1N1GhpEGaLvktMjj1B132Fzl6CsjqHHjd1UYG79eMGJPAzkt5HAOpXIEY096VszjCiyVfv5LRIKkrmnuzNCh8GtghpX/JK2zbfbXqOwhW7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B71C68C4E; Wed,  6 Mar 2024 22:57:26 +0100 (CET)
Date: Wed, 6 Mar 2024 22:57:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] dm-integrity: set max_integrity_segments in
 dm_integrity_io_hints
Message-ID: <20240306215726.GA8529@lst.de>
References: <20240306142739.237234-1-hch@lst.de> <20240306142739.237234-4-hch@lst.de> <ZeinFsPEsajU__Iv@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeinFsPEsajU__Iv@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 06, 2024 at 12:25:42PM -0500, Mike Snitzer wrote:
> I've picked this up for 6.9:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.9&id=f30e5ed1306be8a900b33317bc429dd3794d81a1

A yes, dm was already passing the limits around so there is no
dependency on the block changes.  The dm tree is defintively the
better place then.

