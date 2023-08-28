Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6569FA4A
	for <nvdimm@lists.linux.dev>; Mon, 28 Aug 2023 06:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5xtken3ztdTUny1OMfzFaKlaMxo854CajVDA38Kiekk=; b=NcopADFc2/ECJJnc4sPTJV2HCs
	oucoi3FqWUgmmWL2TBAkAp6f5/UWWSPbYwMK2t1FmNf9DCFana51kICNmLtKkXJ761PmFHB0kIciE
	tDPU+fPlvqzYN8rAM/mSYi0biQaE2nJXWR4/LhXs6sXOwn+rDi85UgDnSeFEYvprxuyB0OJDS3X7o
	v2xpNI5oF0c/7+f4qUhZDe9jzBoCkqp/fWoSoiT+ozzUuABOWCY4mt+L1Go7qVWjjcWLM8JX/eIsZ
	5tjE66X7sfMtVGm7PjjSjRMkHZipPHTZVAj/5fkfJ06RMhfPBT227rR2yLfmee/6rVsL/f24aLc1t
	55V7kRVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qaVri-008xc2-1x;
	Mon, 28 Aug 2023 06:36:46 +0000
Date: Sun, 27 Aug 2023 23:36:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Xueshi Hu <xueshi.hu@smartx.com>,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, jayalk@intworks.biz, daniel@ffwll.ch,
	deller@gmx.de, bcrl@kvack.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, miklos@szeredi.hu,
	mike.kravetz@oracle.com, muchun.song@linux.dev, djwong@kernel.org,
	akpm@linux-foundation.org, hughd@google.com, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: clean up usage of noop_dirty_folio
Message-ID: <ZOxAfrz9etoVUfLQ@infradead.org>
References: <20230819124225.1703147-1-xueshi.hu@smartx.com>
 <20230821111643.5vxtktznjqk42cak@quack3>
 <ZONWka8NpDVGzI8h@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZONWka8NpDVGzI8h@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 21, 2023 at 01:20:33PM +0100, Matthew Wilcox wrote:
> I was hoping Christoph would weigh in ;-)  I don't have a strong

I've enjoyed 2 weeks of almost uninterrupted vacation.

I agree with this patch and also your incremental improvements.

