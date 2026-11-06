Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961850;
	b=SzUBDFSD6KAZslJnF2d6F/Kzd/0ceYBmXNfmHsCz6yCIOrMfn/COljG7uRcLIn2Ql+rh
	 tLXI9udak9hisyyoSFBy2EiAwf4B7+VM5tvoX0XhDDMYpqo/J9dJLJm1s07t8DTgEuN90
	 lSS3VBJyO04d81wLraAxDOQMNsonPZkIrLmNrRX4TlAOXygQjs7t2XWt2ryVwslTsaQD3
	 6oZtWazLSe9Gs8qonayKPcGnuUAMf8CEWICLT+7CVtxIaHgxQQZNdXmw8fjFyreHJiXTp
	 9RVUdxOhL6M2N5VkS1Uj/oYorPnkkifff0PfaGrhyf/fsuYoEoLqj8Y5jaYCEFw7LAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961850;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=SyHLvzb6celL0jDL0tyCZxUmWdmbDgVpxG3dwtVayYo=;
	b=uJL+6m5193zZ9UJTMW7BCI/Axms/Sq+5S0jLY80MhzUAddLxjVTwkna2IhtBjKrrXYoB
	 QkV8UP1u9qWBCYdqbm/kYVNTd2Iqr0ikIwRgBar5zbIfI2PecRGeSg4JaNqFMp8rWXBb1
	 kinfZx62SnqoSfBLQnqVV6v7Nu1/t1PtyoRrdaaee+xfEfvLEMDDHcqO5shcEsWKLW5gM
	 BNuUUAgyaVEncRuzelVISmUtWqRIgX1My6w0CzhE0nAAOYpEkoy4MBwy4Jrq68T01zOhl
	 vGkyfUfFV096AdeVYz+7zQ+QWYt+tTM2arOjpMGUY5MKjjiSW39tLBBKuZ7c0adKunA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8886C606A337
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 10:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8886C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CCC268BEB; Fri,  6 Nov 2026 11:44:04 +0100 (CET)
Date: Fri, 6 Nov 2026 11:44:03 +0100
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
Subject: Re: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted
 inodes
Message-ID: <20261106104403.GC5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-6-mengmeng.zhao@linux.dev>
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
In-Reply-To: <20261105065847.196540-6-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think contents-encrypted should be content-encrypted.

But we really need to find a way to make these checks more
systematic instead of sprinkling them everywhere.  E.g. have a flag
in file->f_mode to allow it, which then only leaves the direct I/O
to buffered I/O fallback as a special case.

