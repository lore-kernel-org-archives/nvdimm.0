Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F115B7A
	for <nvdimm@lists.linux.dev>; Thu, 24 Mar 2022 06:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Az4s3bgnP2MWmqVLeQ9zbh1ptxR6Ja+G4u6TZKomgpM=; b=b9oW72pO9kcKe2RPoYFeS5RvI5
	v5/A8SCcQHs6Jg3mpv4MUevHfq/A2ays5LMEi/XH6sS6+1klLfjAufAcDkzQHjpQKKVXI2kWoj2lc
	mjzJpmns+bOtpgCk/CqrN/DjKKIvLPhsOyDv9pTxVP24GO+kyu2b9+Vix2CrKNG9aHjhlEgLBAewa
	VkFk4hWpVd6mS7Z7POqqk42oWB3QzppS4ZF78V3mUxoLfp8zztpbtGcquBebQjaHY3Ilo41f4tsqn
	oRnbNQdJV8/KpAYrKyA6F7G59QeYDOyJysI/pG4UP0F1JphgVEJEtdO+p0r/kOLGZm+FXx6+mueiG
	drV5ia6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nXH6I-00FrP2-JJ; Thu, 24 Mar 2022 06:37:38 +0000
Date: Wed, 23 Mar 2022 23:37:38 -0700
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
Subject: Re: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Message-ID: <YjwRssvQSMLx5xhc@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
 <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
 <Yjq0FspfsLrN/mrx@infradead.org>
 <2897ca93-690b-72ed-751d-d0b457d3fbec@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2897ca93-690b-72ed-751d-d0b457d3fbec@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 23, 2022 at 06:43:06PM +0000, Jane Chu wrote:
> > it onto ->direct_access.  But nothing in this series actually checks
> > for it as far as I can tell.
> 
> The flag is checked here, again, I'll spell out the flag rather than 
> using it as a boolean.

Yes.  The whole point of a flags value is that it is extensible..
