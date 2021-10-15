Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7486E2C82
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 06:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K97DMnnazcODhbgliFQHh1Vy35s1DHvETiPvQk+kYvU=; b=II9nnmGbJHPhf/kRHW6+QL4OlR
	Blde0ncvwiIimQOlKudkXZn3iyQNXilqe646yZsB84SzBGx5bHJGUrzXajr0JRSQu/pPrHE9i4thm
	aMNPY3YH7V2wV8FKkICbTAoidHBGLsSgTYgdJ3jTMqJukTgxruRacULWLm7VzSk3rUt+ZVrKC6FmW
	AIMvrtM2ey9wU0ivoGElozmoNTzkmbWq5d7oAamQ9C3RvFoGmYElirhH2pDuRmMSn6pzC0bClI4j5
	HLBAUCb/b7QEgWE8wIgE5yN/JnIC3EVe7FpGwy0gnd4IOiXa2A1Ygw86Sa9bqmifdGsrjx5A3n84r
	u+LO46QQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbGrG-005ZKF-D9; Fri, 15 Oct 2021 06:38:22 +0000
Date: Thu, 14 Oct 2021 23:38:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v7 8/8] fsdax: add exception for reflinked files
Message-ID: <YWkh3mNc2+roMn40@infradead.org>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
 <20210924130959.2695749-9-ruansy.fnst@fujitsu.com>
 <20211014192450.GJ24307@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014192450.GJ24307@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 14, 2021 at 12:24:50PM -0700, Darrick J. Wong wrote:
> It feels a little dangerous to have page->mapping for shared storage
> point to an actual address_space when there are really multiple
> potential address_spaces out there.  If the mm or dax folks are ok with
> doing this this way then I'll live with it, but it seems like you'd want
> to leave /some/ kind of marker once you know that the page has multiple
> owners and therefore regular mm rmap via page->mapping won't work.

Yes, I thing poisoning page->mapping for the rmap enabled case seems
like a better idea.
