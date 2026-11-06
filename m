Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961685;
	b=C/fUnzjpxFM92dO98VjTxv38Iwvr5PQ0azRDXJ0ZYc+DJF82IjNtmDZETnrynSYDqDIt
	 b8FsVA3N8Kyj+CqWCUrRQCVlEdPdH15utKOKnFVQeBqNzXh7b+wZMWHr2FrEd9gylgrjY
	 7slChH5bFqTMjsE9pL683fkAEIhLWPfH4i9sSkYswyD+F83w/PSDwPdVyjsCbK0C5Vc8T
	 qqdvDbJejMRFHbzbkwKVR4YiuosZaFBJ0UAAfx+PGaDdqK72nXTIVtdXRlsd2QyIbGCmZ
	 J5BYJUmy+sWAyVRpTlFZHnvazgVYGBFjViwZtXHZMbdgpYhm1O6JeZeotw+quTiGL1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961685;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=Y2B3K2s4CMkhzGfN/sXBCg6vT5zF/XqqON8igl9xOC0=;
	b=DUfpZARFebjMsbTjZ+M2Tl0Defrb0Zm2YHuARkWO9q8uJYXRf8T4SBf+kTgbK9FNLAWA
	 GvxQGSzUCsgKl8p8YCRqenUvEhKdjh1rnog9i9ggNtbxvZZby/ZFfxyiLfwqV6h8MQxiI
	 jpMs3KHvwXukjUBah8P2U24u1vyBIMlcu8tGvUqnVQM9PY3OKiY/RQocoZmZiCO1s3US6
	 zKlPbXtWPmXNy2I+FYDKRDRQ7MTusqfRPbZ44/5H6CMMB6GVRxnaioD+o1b6qZkI/UYW9
	 pY9KRAcZP+Tzcv8HoodSE6OcFODDTMwXjXuzbQ516ZdvI7f/tuY5UHNSZrgK5ahdU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39BF606A326
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 10:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E39BF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6E2C68BFE; Fri,  6 Nov 2026 11:41:19 +0100 (CET)
Date: Fri, 6 Nov 2026 11:41:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
	hch@lst.de, Anuj Gupta <anuj1072538@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
Subject: Re: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto
 context
Message-ID: <20261106104119.GA5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-2-mengmeng.zhao@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 05, 2026 at 02:58:42PM +0800, Mengmeng Zhao wrote:
> +	/* a dma-buf bio has no pages for integrity work or contents crypto */
>  	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
> -		bdev_has_integrity_csum(bio->bi_bdev))) {
> +	    (bdev_has_integrity_csum(bio->bi_bdev) ||
> +	     bio_has_crypt_ctx(bio)))) {

This could really use a factored helper explaining all the refusals.
And maybe we should use the chance to sit back and think what else
would blow up and add it there as well.

