Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795656374;
	b=yjdKr1+xi3toJbibmtgI4XF5Zj1OKENtsXOF2EsoMp45b1BXi7nmbuLyYPSUS4rrEPY6
	 HzDfnuZC3Zvk93RGEy21oywC4qhHS6hUjA6jLGFdqqPxY5q03jOMFxoSWJ2o6PP6gKb+J
	 cQrXgmCnooQv3VC3iM5tZgsyf6KajNZDJoisPqqz3aNSjDNCyLce0vnPJqGgwHs7ArBZD
	 UKXS6+ENsZ8aAHEejopNDOPNhwLyU2EeyRb5bcpq/mdoRfPk998oV9tqGpX64OWU6/W3J
	 odq9CFJoNvvemnZv+ifz9pfHRwWuP1ql3N2ObaHwxEIUoVe09g78e2BWxJr1Wnngf+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795656374;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Z/SO45JEq1Tj9RqYNIrS64ldH+SeEVWmw+AWikVk48g=;
	b=Dk7iBV7bTycSZbw6HW57iZAXU1F0buA+NbCMtnDSjRzKrLCSOg/GDy8UZ4rVnLViziGx
	 /5dYCcJt5S8LAwitTDT6VjsTM3350MlBBzY5Pu3+cHJ/xjhILYcAjzAnAIzjCs+VeP/aM
	 yDVLRcoZZdYeRFTq72FtdVIvqSlLXH8aN+Qw581t0QIzFxrrgMcbBI4UiE2ZnxRBUe6gw
	 FXBJH5s79xJUJh7c5ofkLQKyyKyeeERqe7UuxYoaogQxfNS9+vR5KqYqTxEtELy6W6EYU
	 sLOa6AUyZkeOOyKo3vuSxhTzDJQPJ9Iz6M5FuVCL0IITv29Ol47NQ9FtbiDhhsp0KbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R0zpMVqd;
	arc=none smtp.remote-ip=95.215.58.53
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C95606A331
	for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 01:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6C95606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R0zpMVqd
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=D1UHaW0a6adTmdkfzXoJGoIQXD78CQO3jmkmbRoDsZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795656372; v=1; x=1796261172;
 b=R0zpMVqdGMz2bgOKOCAVSp65ZLCVTZOgRGpG6NtKXLEr3DCzD1Ft49dZfa7mVknWsYpyNQ72
 1WzMjsM4zWSFFNqYfsJLMbcpNpt+zPQnq+omBqAPfBBrw3ixq4vWexCkaoEjvK9XOJMaqdoOwPY
 BP8JbPP9PB7DsBZyfxPgaENs=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f65ccc0d161a6465;
	Thu, 26 Nov 2026 01:26:10 +0000
X-Mizu-Trace-ID: f65ccc0d161a6465
X-Migadu-Flow: FLOW_OUT
Message-ID: <3bce3a69-e41c-4683-b1ca-9477dd41a7e0@linux.dev>
Date: Thu, 26 Nov 2026 09:25:51 +0800
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
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
To: Anuj Gupta <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>
Cc: Anuj Gupta <anuj1072538@gmail.com>, Nitesh Shetty
 <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Christian Koenig <christian.koenig@amd.com>,
 Philipp Stanner <phasta@kernel.org>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
 Mengmeng Zhao <zhaomengmeng@kylinos.cn>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261120154153.GC28611@lst.de>
 <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
 <CGME20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d@epcas5p3.samsung.com>
 <20261124084025.2101804-1-anuj20.g@samsung.com>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261124084025.2101804-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/24/26 16:40, Anuj Gupta wrote:
> On Mon, Nov 23, 2026 at 09:51:41AM +0800, Mengmeng Zhao wrote:
>> Hi Anuj, I'd be happy to help pull our patches together into a single
>> unified series and send it out for review, if you're okay with that—and
>> would appreciate your review once it's posted as well. Please let me know how
>> you'd like to coordinate, or if you have any updates in progress on your
>> side before I put the series together.
> 
> Hi Mengmeng,
> 
> We already have updates in progress on the XFS side.
> 
> We will consolidate the combined series along with your ext4 work and
> related patches, keeping your authorship.
> 
> One more thing that we are looking at combining is the ability to share
> the registration across files. Pavel had mentioned this earlier in our
> xfs series [1] and posted a series too [2] which needs some more work.
> 
> FWIW, we also had ext4 changes, but intentionally started with one
> filesystem (XFS) so that the common interface could settle first.
> 
> [1] https://lore.kernel.org/linux-block/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
> [2] https://lore.kernel.org/linux-block/cover.1793751001.git.asml.silence@gmail.com/

Hi Anuj,

Sounds good, that makes sense given the ongoing XFS and shared registration
updates. Thanks for including our ext4 patches and keeping the authorship.
Feel free to loop me in once you post the combined series—I'd be happy to
help review and test it.

I looked at Pavel's patchset as well, and noticed it adds a new f_dma_io_tag
field to struct file, whereas Christoph and Christian want to avoid bloating
struct file. Did I miss something, or do you have a different approach in mind
to avoid adding fields to struct file?
