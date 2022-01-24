Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F99173
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b1/8izjUm0n2+N8ysi9Q6kNMaHYdwfsdc+0uzdhqR28=; b=Gr3E0sYWvpmlukvGcIyCeWMCn5
	Z/apR0XnbVs4OKm3O2+z2bVwYO2l4NzxFftyAoa/uRuPSxs1UtDosMVd5ASvn4oXVZaMg8dC+ZsrE
	qBaoD08HVUAsm9u7S2kaHTqv1NUzl54YnQ9enXBC1Wv2GU33tXVNa2lrgMeyPsZwNGo0douzIRJfZ
	nDupwsD1kUitnDyzhbXy+yBe15kU9ncPnfi6E/UdahQ6wNuJUIRX7i7LEPyA1HFx5V5x0qyRnxo8r
	ls1Hpe+/LnnvR2/s4fnCbH6BibGaUDH2v27pkTPtbOBOKyQkqq3/S7jRZ4qumRy3mMY8Cdb1UWmWg
	exxXrKnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nBvEC-002iR9-UK; Mon, 24 Jan 2022 09:01:32 +0000
Date: Mon, 24 Jan 2022 01:01:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] DAX poison recovery
Message-ID: <Ye5q7MSypmwdV4iT@infradead.org>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
 <Yekxd1/MboidZo4C@infradead.org>
 <4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 21, 2022 at 01:33:40AM +0000, Jane Chu wrote:
> > What tree is this against? I can't apply it to either 5.16 or Linus'
> > current tree.
> 
> It was based on your 'dax-block-cleanup' branch a while back.

Do you have a git tree with your patches included available somewhere?
