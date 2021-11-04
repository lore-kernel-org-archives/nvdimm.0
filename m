Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD152C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tn7iBDCVplhudJn1Ux5LldDOEDc1onv5gHvRnPNYjoY=; b=yNUKz++ApoBdUXngvrYX5CyGvg
	imcgGf09ZQFQn8B/Ee7PnzFCt/y0wEpicnJbz36cUsZwLnTBOLCzQiPvMObEtppAHHiT+iwKCIv3v
	YM3pkfqQ0ybk8FdXBjlVgGFdyY/8oL5RKJf22EULpzMFBecIFIADXNJNHEgFr4h4Qm5vfvr071iI8
	p9PWVU7GgOM6Pvcjgy+SGT1f6eYP8p9EAy/CYiVtw4IDPx2a8P2W0HAFXpIBSn20YbB4iZTCsbYj5
	nANIm9Zuj7H+UYdwYJRbtlc0fWioZtF2TJHh+fxNkljFwBlYD3wIBi8pide3ZbgJOyUVd+tGx0QPJ
	uAg2UgxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migoz-009i9L-Fp; Thu, 04 Nov 2021 17:46:41 +0000
Date: Thu, 4 Nov 2021 10:46:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
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
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YYQcgdRShSji3LfM@infradead.org>
References: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org>
 <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
 <CAPcyv4jLn4_SYxLtp_cUT=mm6Y3An22BA+sqex1S-CBnAm6qGA@mail.gmail.com>
 <YYObn+0juAFvH7Fk@infradead.org>
 <CAPcyv4jaCj=qDw-MHEcYjVGHYGvX8wbJ_d3kv5nnv7agHnMViQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jaCj=qDw-MHEcYjVGHYGvX8wbJ_d3kv5nnv7agHnMViQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 04, 2021 at 09:08:41AM -0700, Dan Williams wrote:
> Yes, atomic clear+write new data. The ability to atomic clear requires
> either a CPU with the ability to overwrite cachelines without doing a
> RMW cycle (MOVDIR64B), or it requires a device with a suitable
> slow-path mailbox command like the one defined for CXL devices (see
> section 8.2.9.5.4.3 Clear Poison in CXL 2.0).
> 
> I don't know why you think these devices don't perform wear-leveling
> with spare blocks?

Because the interface looks so broken.  But yes, apparently it's not
the media management that is broken but just the inteface that fakes
up byte level access.

> All kernel accesses do use it. They either route to
> pmem_copy_to_iter(), or like dm-writecache, call it directly. Do you
> see a kernel path that does not use that helper?

No, sorry.  My knowledge is out of date.
(nova does, but it is out of tree, and the lack of using
copy_mc_to_kernel is the least of its problems)
