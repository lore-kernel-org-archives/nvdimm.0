Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D3F481FBC;
	Tue,  3 Mar 2026 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772551312; cv=none; b=ohJEkPTPpKaNNJB72LCGvKZxInkScFKBfLL/8gpvYStoNVQiI0JEsx6U+q4SFjThptCsiOBUj49GlMi5t3ABN83QOOw9f4ecyd58Lz1vYQCXQq3ELxOivVINz3b1H5TLWT428QCawFpkTlQcsNUYOTgFeDGOBJAzVTCVtjOaS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772551312; c=relaxed/simple;
	bh=zsl35lOlWRqZs7HyG0+nz3w60o7BiBp5MRlbAc9v8c0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0Ok6YZHe224FnXhHDUlOonk5G28gP799R6V1rEjFHF099AQty7YKAxhZVrEOpSKaJkvzxBAGY18WFZ3EvIWcbc9TJwtrKM0VIjH53OA2Y/XvSN2l67kZLv3diiObsgekyfo5dd4OJ0a6Ouv42CWcpKy3+GgiMuhII4dy2M+eLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5DB6668BEB; Tue,  3 Mar 2026 16:21:41 +0100 (CET)
Date: Tue, 3 Mar 2026 16:21:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, ntfs3@lists.linux.dev,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] ntfs3: remove copy and pasted iomap code
Message-ID: <20260303152141.GB5281@lst.de>
References: <20260223132021.292832-1-hch@lst.de> <20260223132021.292832-13-hch@lst.de> <449fd474-0b61-42ff-afbe-56b728d69262@paragon-software.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449fd474-0b61-42ff-afbe-56b728d69262@paragon-software.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 27, 2026 at 02:46:08PM +0100, Konstantin Komarov wrote:
>
> Thanks for the note. The iomap helper was copied because
> `iomap_bio_read_folio_range` is defined `static` in iomap/bio.c and thus
> not available for reuse; that prevented using the exported helpers in this
> tree.

Please talk to maintainers and authors before copy and pasting their
code.  There's usually a better way.

