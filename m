Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F533C193
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 05:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750096; cv=none; b=VkryvPCPKK5M3P2PnetE7AYWA6kedV99gHWttrDSoQrSzkXisT72Ymv0uGEHVSp8xwfFYIEY5GXoPB3lCPX08Cl0tHTknTpfe43X7oAtsIXFa9xouvQEV2fkH0gAD26pWdSI1D2Xczfo51eJRvPMFTYLP1CHfvV1JJ4YfFogHS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750096; c=relaxed/simple;
	bh=KH/zOLdHihwfwDNEb1amYcKOkWfqLYJIY3/IqZFqY+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNy1l0OM4R2ht5njKQ0KEgbLKGm5jYIUjyc3UbTbv3e9Bxa/oSc+Nam53GOpWnulZTBFj2G8lD+Tnky7wDnHbIRmSBUPekwbq9UFr/UkaCNOnpin+UCrooK5hARj0BCr4wIBYbLoD3V0slh96liVLxNEWrvfgxEw3l2Pjfjjlpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A02868AFE; Fri, 30 Jan 2026 06:14:52 +0100 (CET)
Date: Fri, 30 Jan 2026 06:14:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: support T10 protection information
Message-ID: <20260130051452.GA32597@lst.de>
References: <20260128161517.666412-1-hch@lst.de> <20260128161517.666412-16-hch@lst.de> <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 29, 2026 at 03:51:58PM +0100, Andrey Albershteyn wrote:
> > +	struct iomap_read_folio_ctx	ctx = {
> > +		.cur_folio	= folio,
> > +		.ops		= xfs_bio_read_ops(XFS_I(file->f_mapping->host)),
> 
> Hmm, can we use folio->mapping->host here instead? Adding fsverity,
> read_mapping_folio() will be called without file reference in
> generic_read_merkle_tree_page() (from your patchset). This in turn
> is called from fsverity_verify_bio() in the ioend callback, which
> only has bio reference. 

Yes, deriving the mapping from the folio should work just fine.
