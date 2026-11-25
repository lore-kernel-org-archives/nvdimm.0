Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587120;
	b=BvYoMPmw6tU6Lbghp/6oTSh9qqjsO0R/OkuUXdOSwhd6OnLCD7anpmhFHt81SJGVBH9B
	 cY1m/aCgqcKsUOgTTyK6cr1MkJtM0lB9Q3pUuni1Kr74Jvi9scbkHGuQVVrVGMX47aHOt
	 r986eTDfbXajsX2FB3VYWhgmBYqCOY552bqTV4oIu0d7iMgw+K70jMjDL1Rtz8vfnElL1
	 v+P5aGiTXeRf4aQwSTVB2uwlApdfp6UYD1Csvs7DKgSqS8qUNIoc2C5Wi9bXNoPYQ6Gn5
	 d5Wz0ce/QiUmwer/LPHAcLkIq4ViJglj0D73C9b986VHxtYfaIycf6E0bNcm3Lok8xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587120;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=QFqAXcQkxOquMyWdhHaXd2jZau8ELeRT34k6c5WkgOA=;
	b=tVSPC/k5xad5v+J52dLp/UeiclLbKDIJcZaGMsbxxOM6f52a3D4GgjoMUOp7uGiKFYsa
	 HmPSGVrTJ5QWO3PyGgyHcLHMo1BRjM/46onuVWwjmtkYHOVrc9PtdAhmbhBnWp/1fcp86
	 es8Hh6nKbEYdkIqVJW+y7IRVluW6iTBKOWmkk3+oEcbeupB3ZPszLiOAvTs7kWWe1yfcl
	 s1CcAcYNMSHOo7GC4GFRGEsLm/HSt5d07vt6KSCBNxr6IVeoVwXB2MOYbnj94uttgnFXv
	 VKxu5rW2isngEoYpvqC5GnFTxeA8OYiE+mSgADON6nVe0saVkfYXvK95FCXB1aKcXFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D661606A321
	for <nvdimm@lists.linux.dev>; Wed, 25 Nov 2026 06:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D661606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4D49468AFE; Wed, 25 Nov 2026 07:11:54 +0100 (CET)
Date: Wed, 25 Nov 2026 07:11:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj1072538@gmail.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
	Sumit Semwal <sumit.semwal@linaro.org>, christian.koenig@amd.com,
	Philipp Stanner <phasta@kernel.org>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, asml.silence@gmail.com,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: Re: [RFC PATCH v2 6/8] fs: add FMODE_CAN_DMABUF_IO and require it
 for dma-buf I/O contexts
Message-ID: <20261125061154.GA20910@lst.de>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev> <20261113070621.273953-7-mengmeng.zhao@linux.dev> <20261120-faust-bohnenkraut-reduzieren-a30811186a15@brauner> <e9860ead-c5f3-4dd0-beaa-d92396c266d9@linux.dev>
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
In-Reply-To: <e9860ead-c5f3-4dd0-beaa-d92396c266d9@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 23, 2026 at 09:28:07AM +0800, Mengmeng Zhao wrote:
> > This is stealing yet another FMODE_* bit for special-purpose stuff.
> > We're really really short of them. Did Christoph suggest this?
> Hi Christian, thanks for pointing out this. If I understand correctly, 
> Christoph suggests a new file->f_mode to allow dma-buf check in RFC v1[1]. 
> 
> Hi Christoph, do you have any comments or suggestions? I'am happy to adjust
> this in the next version if there is a better approach.

I didn't suggest a particular approach, but the FMODE_ bits seems very
fitting here as it sorts out the support issue very well.

