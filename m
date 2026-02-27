Received: from relayaws-01.paragon-software.com (relayaws-01.paragon-software.com [35.157.23.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A789736EAA7;
	Fri, 27 Feb 2026 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.157.23.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772199982; cv=none; b=krwCqNrZmc6m0+WkvRsZ7Z7KzlAPalizkSBmH//tlfK/OL3FK3JuXZ2AbN+rIQkjpPcBxvTW/5+c5RFfm0e7i/VpBqJOPjhTdpOW+aZnwkQoQuZg5PWOK07iAxGfR/hQrQh4UIosuQC0JYmyoPVFgrUohKcph1Wcn8k6Zs4foYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772199982; c=relaxed/simple;
	bh=z0K5yqmsvL+BPpTl9z7t4zFYOlZHqtcMweAFoIYy2jY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hXqRUNjpdOffrjUiBDHUikD22ci0AtEkAGp6WlYPCqlmMlSAmoC8DYyKksxuJJ/QcVFm9m8JIMmYCcM2OOiPbivTFnSVJmzkateV0WGAu+F15j9+5+mGPyNp6g9EjQ3Yrd6PQs9cfREDed/onB+H5KqAwDX2DHSQf2ERnP4yHEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=paragon-software.com; spf=pass smtp.mailfrom=paragon-software.com; dkim=pass (1024-bit key) header.d=paragon-software.com header.i=@paragon-software.com header.b=I5A0/iNh; arc=none smtp.client-ip=35.157.23.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=paragon-software.com header.i=@paragon-software.com header.b="I5A0/iNh"
Received: from relayfre-01.paragon-software.com (unknown [176.12.100.13])
	by relayaws-01.paragon-software.com (Postfix) with ESMTPS id ED2C81DA1;
	Fri, 27 Feb 2026 13:44:27 +0000 (UTC)
Authentication-Results: relayaws-01.paragon-software.com;
	dkim=pass (1024-bit key; unprotected) header.d=paragon-software.com header.i=@paragon-software.com header.b=I5A0/iNh;
	dkim-atps=neutral
Received: from dlg2.mail.paragon-software.com (vdlg-exch-02.paragon-software.com [172.30.1.105])
	by relayfre-01.paragon-software.com (Postfix) with ESMTPS id C95D11D1B;
	Fri, 27 Feb 2026 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paragon-software.com; s=mail; t=1772199972;
	bh=2JG+S5Jc4wy67khMF3eE3EWJ7FaXlM8z1txAXuFhg/g=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=I5A0/iNh89QpX3dy7d0Wf1SN5zLZOiTlZ60YJ1ObBTMAlhQaDS4AIBpre04cVmdC9
	 wGZffi4SsIj4sft1VHYKx+BExHSRUTVv9r2l/CnorFRl47vStwFXU6HpPvih/qb5bk
	 Kzq21KZnMJDKs4xC/ZlgI1baFHZCoIPxSXafXtq8=
Received: from [192.168.95.128] (172.30.20.153) by
 vdlg-exch-02.paragon-software.com (172.30.1.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 27 Feb 2026 16:46:10 +0300
Message-ID: <449fd474-0b61-42ff-afbe-56b728d69262@paragon-software.com>
Date: Fri, 27 Feb 2026 14:46:08 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] ntfs3: remove copy and pasted iomap code
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
 Brauner <brauner@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
	<ntfs3@lists.linux.dev>, <linux-block@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>
References: <20260223132021.292832-1-hch@lst.de>
 <20260223132021.292832-13-hch@lst.de>
Content-Language: en-US
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
In-Reply-To: <20260223132021.292832-13-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: vdlg-exch-02.paragon-software.com (172.30.1.105) To
 vdlg-exch-02.paragon-software.com (172.30.1.105)

On 2/23/26 14:20, Christoph Hellwig wrote:

> ntfs3 copied the iomap code without attribution or talking to the
> maintainers, to hook into the bio completion for (unexplained) zeroing.
>
> Fix this by just overriding the bio completion handler in the submit
> handler.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/ntfs3/inode.c | 51 +++---------------------------------------------
>   1 file changed, 3 insertions(+), 48 deletions(-)
>
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 7ab4e18f8013..60af9f8e0366 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -605,63 +605,18 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
>   	bio_put(bio);
>   }
>   
> -/*
> - * Copied from iomap/bio.c.
> - */
> -static int ntfs_iomap_bio_read_folio_range(const struct iomap_iter *iter,
> -					   struct iomap_read_folio_ctx *ctx,
> -					   size_t plen)
> -{
> -	struct folio *folio = ctx->cur_folio;
> -	const struct iomap *iomap = &iter->iomap;
> -	loff_t pos = iter->pos;
> -	size_t poff = offset_in_folio(folio, pos);
> -	loff_t length = iomap_length(iter);
> -	sector_t sector;
> -	struct bio *bio = ctx->read_ctx;
> -
> -	sector = iomap_sector(iomap, pos);
> -	if (!bio || bio_end_sector(bio) != sector ||
> -	    !bio_add_folio(bio, folio, plen, poff)) {
> -		gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
> -		gfp_t orig_gfp = gfp;
> -		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
> -
> -		if (bio)
> -			submit_bio(bio);
> -
> -		if (ctx->rac) /* same as readahead_gfp_mask */
> -			gfp |= __GFP_NORETRY | __GFP_NOWARN;
> -		bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs), REQ_OP_READ,
> -				gfp);
> -		/*
> -		 * If the bio_alloc fails, try it again for a single page to
> -		 * avoid having to deal with partial page reads.  This emulates
> -		 * what do_mpage_read_folio does.
> -		 */
> -		if (!bio)
> -			bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ, orig_gfp);
> -		if (ctx->rac)
> -			bio->bi_opf |= REQ_RAHEAD;
> -		bio->bi_iter.bi_sector = sector;
> -		bio->bi_end_io = ntfs_iomap_read_end_io;
> -		bio_add_folio_nofail(bio, folio, plen, poff);
> -		ctx->read_ctx = bio;
> -	}
> -	return 0;
> -}
> -
>   static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
>   		struct iomap_read_folio_ctx *ctx)
>   {
>   	struct bio *bio = ctx->read_ctx;
>   
> +	bio->bi_end_io = ntfs_iomap_read_end_io;
>   	submit_bio(bio);
>   }
>   
>   static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
> -	.read_folio_range = ntfs_iomap_bio_read_folio_range,
> -	.submit_read = ntfs_iomap_bio_submit_read,
> +	.read_folio_range	= iomap_bio_read_folio_range,
> +	.submit_read		= ntfs_iomap_bio_submit_read,
>   };
>   
>   static int ntfs_read_folio(struct file *file, struct folio *folio)

Hello,

Thanks for the note. The iomap helper was copied because
`iomap_bio_read_folio_range` is defined `static` in iomap/bio.c and thus
not available for reuse; that prevented using the exported helpers in this
tree.

If I’m mistaken, please let me know.

Regards,
Konstantin

