Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F0323F
	for <nvdimm@lists.linux.dev>; Wed, 29 Jun 2022 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dM4+ROKUOOXAaf00uyOfnLm4S33M4aOobSzF5uH6GQc=; b=J/EFS/06taiacNokV5Ktu40WHu
	CmN8tJ2KYfKB9OBCF1ggM+OKiUi7O6T3U/jXmIjt8+U6yVxlEn063aLPj++GMn+azmID8d1fUMWdY
	hZ+RJQ6oofyZe/DI5mwSy8qLwg3hiP4qJmVtmcwSu/PIjc4yBGp7rk1mGfkBp9m871FQIZrD3D/7D
	q+szyG2xGRy/CuNo5f60lZY5rhiRsCmDu+Xus6y4w6sGFzFuHsMHklAQxqSUc6E/y5hgdVYtvQQ0X
	WmNnZrU9EfFKKirkNc0t7ND9ycddW+QYs4XUr3jibEVdQdYqjX5wZV9Vmnc2TIUPK8tlexzi+/4Yt
	Fubhlqbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o6Zap-00ChIe-10; Wed, 29 Jun 2022 15:27:03 +0000
Date: Wed, 29 Jun 2022 08:27:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Dennis.Wu" <dennis.wu@intel.com>
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Message-ID: <YrxvR6zDZymsQCQl@infradead.org>
References: <20220629083118.8737-1-dennis.wu@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629083118.8737-1-dennis.wu@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 29, 2022 at 04:31:18PM +0800, Dennis.Wu wrote:
> reason: in the current BTT implimentation deepflush is always
> used and deepflush is very expensive. Since customer already
> know the ADR can protect the WPQ data in memory controller and
> no need to call deepflush to get better performance. BTT w/o
> deepflush, performance can improve 300%~600% with diff FIO jobs.
> 
> How: Add one param "no_deepflush" in the nfit module parameter.
> if "modprob nfit no_deepflush=1", customer can get the higher
> performance but not strict data security. Before modprob nfit,
> you may need to "ndctl disable-region".

This goes back to my question from years ago:  why do we ever
do this deep flush in the Linux nvdimm stack to start with?
