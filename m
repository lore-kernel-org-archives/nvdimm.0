Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192731;
	b=4cXNl7L7JO2nPpC4O3dx49e0wjTl3J9/jTCZvP5hGltuoR8tM8Ph6INcwMxhlzqIxsua
	 Bpe1/VyBvcJhot9qOBbh5+6+l5FM0z1Tc8Lya9LIQg8c9jU3tuSkMWvTFOUahFNgbJp8q
	 5Z/pjoZgJ8FolIkR0yOl2Hlq6zAcuBoHMMdDpbF/awed23YAm1lrG1DhlyLlwyDUHTPjr
	 6HUCyXaU8UfZY09f2MiMD2pvkvBUpqDyuUqA2xsmTHJs4enpHqU0v44y+IL8t48zgMtYN
	 npi12omEkM7IykhH61TsRdoziHpq5FE9CUcHBYNKUPfjXvhOKpZg2YwBIgFt39QI2VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192731;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=nWqWiduDQX/+eDY/lBNMvXq4xgQ2WR9If/niokbocYQ=;
	b=WulQ+i2TFPo0gY3prbrI/jKRwzyw0YtT9nD443P+uSCax65K1jNvXInrXi/GKuiFj88j
	 IgaUxjWtTYltjQMuJasvdcbBp3WCFERxQs3Sj6rBqsgPh41Pw9Aa4vQeyfLBlSgfA+cF3
	 f93bUt91Hl62BvsyKG8O9kVHj/zHYe6U6XZzUbswDp+TDH3xWa+QHbxof9wLCv8Nv1K0e
	 0vj/Tyy0AXpn9yHT766h9iI7qCpgtMUsY8fqYeJ2YF7kr+ZGOLbNLYEL/3uu6oxhEtcGq
	 GGwOHqhIKZdwEAS60orlekVuUQJ7e5xfxxO8+SmKoCTKZnp3bHmmQBN7I95u7bS3qwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKqbz5+1;
	arc=none smtp.remote-ip=91.218.175.239
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC793606A326
	for <nvdimm@lists.linux.dev>; Mon,  9 Nov 2026 02:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC793606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKqbz5+1
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1zQrA1miKQ/sO3U4FLD9eN7ND1EAn4eFHq58nFmS/2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192722; v=1; x=1794797522;
 b=pKqbz5+1nAKvoDjratDGIzCVYLRnYWqr1KkI/51AbwTsIOLh1H3KSkwjZnitIUapDrfX3moK
 iBDOjWlEa0LcAglhZ0IIVJXQpa10JvLhgoeorLL1bBrmrzYqTSk7F/F73Ux8tJumFsmES18Q1nY
 WVU2IQ4+YlREcEp/U62zWKW0=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f8a5242679d67f97;
	Mon, 09 Nov 2026 02:52:02 +0000
X-Mizu-Trace-ID: f8a5242679d67f97
X-Migadu-Flow: FLOW_OUT
Message-ID: <3f45a5f9-9c87-420d-b6a5-6145c834c0d1@linux.dev>
Date: Mon, 9 Nov 2026 10:51:46 +0800
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto
 context
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-2-mengmeng.zhao@linux.dev>
 <20261106104119.GA5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104119.GA5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 18:41, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 02:58:42PM +0800, Mengmeng Zhao wrote:
>> +	/* a dma-buf bio has no pages for integrity work or contents crypto */
>>  	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
>> -		bdev_has_integrity_csum(bio->bi_bdev))) {
>> +	    (bdev_has_integrity_csum(bio->bi_bdev) ||
>> +	     bio_has_crypt_ctx(bio)))) {
> 
> This could really use a factored helper explaining all the refusals.
> And maybe we should use the chance to sit back and think what else
> would blow up and add it there as well.
> 
Hi Christoph, thanks for the review. I will extract a helper in V2 soon. 
There are several buffered io fallbacks, it's really necessary to discuss
how to avoid these. Glad to join it.
