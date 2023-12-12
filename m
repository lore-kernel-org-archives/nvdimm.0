Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC182A1D2
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 13:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="boRv2crS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=67rvxc8KF4Am0jhrdB27CpUPgtiBS4+Z+YV3L6uI8NY=; b=boRv2crSvsM4V861vsFYqPudVo
	oG6u3FHR4FHHElcP1zSEgNE+5kwcrLl8Uz1eXzDuU+QSB05HYIyBVVwkOtXpg6sFkZYx9mqFKQjJM
	CXisjMmelC2DPUsL58SML8bx6tCM58JvtFZQEwgmQOs8rP7cRr4IW8hQuQzWegRit+rlMtWPUetU0
	KpVjNA38PW2wXGCw2uTGgg9BxSr2A9zNj44dE7KI91wfU5RQzskEfu8I4zBHr9uonz3WBXwvKc/s5
	KmNCYBg+ld1Sb/eG3XxK7KRizFgVP0sSFjlESHL+pIF2sj7jbF+BxiL0+eJ/kF74k423hjI106Lm6
	x5CzPzPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rD2Sy-00Bko8-0I;
	Tue, 12 Dec 2023 13:06:28 +0000
Date: Tue, 12 Dec 2023 05:06:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Curtin <ecurtin@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	Stephen Smoogen <ssmoogen@redhat.com>,
	Yariv Rachmani <yrachman@redhat.com>,
	Daniel Walsh <dwalsh@redhat.com>,
	Douglas Landgraf <dlandgra@redhat.com>,
	Alexander Larsson <alexl@redhat.com>,
	Colin Walters <walters@redhat.com>,
	Brian Masney <bmasney@redhat.com>,
	Eric Chanudet <echanude@redhat.com>,
	Pavol Brilla <pbrilla@redhat.com>,
	Lokesh Mandvekar <lmandvek@redhat.com>,
	Petr =?utf-8?Q?=C5=A0abata?= <psabata@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Luca Boccassi <bluca@debian.org>, Neal Gompa <neal@gompa.dev>,
	nvdimm@lists.linux.dev
Subject: Re: [RFC KERNEL] initoverlayfs - a scalable initial filesystem
Message-ID: <ZXha1IxzRfhsRNOu@infradead.org>
References: <CAOgh=Fwb+JCTQ-iqzjq8st9qbvauxc4gqqafjWG2Xc08MeBabQ@mail.gmail.com>
 <941aff31-6aa4-4c37-bb94-547c46250304@linux.alibaba.com>
 <ZXgNQ85PdUKrQU1j@infradead.org>
 <58d175f8-a06e-4b00-95fe-1bd5a79106df@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58d175f8-a06e-4b00-95fe-1bd5a79106df@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 12, 2023 at 03:50:25PM +0800, Gao Xiang wrote:
> I have no idea how it's faster than the current initramfs or initrd.
> So if it's really useful, maybe some numbers can be posted first
> with the current `memmap` hack and see it's worth going further with
> some new infrastructure like initdax.

Agreed.
