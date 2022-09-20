Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50C187D
	for <nvdimm@lists.linux.dev>; Tue, 20 Sep 2022 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QlLWgD8hH8VEMML/lnKrKbbOY8OsVVslAl3FeCo563k=; b=JD3StW5yL7XaTSGYt2pRl9vRoZ
	dV+b3CD7Ly+8dChwGxED8Qsiapud6PJqLFw76FTtkAWGcWQrjoR+JOrw8qewhPlqJPUiQJcQn+Y5k
	RbPNFCj38aBUXK9+8U9gqiRf9r+jdHO35BB/gFBiYF4qnYcIyNvgCF+yYDoWmfv7hRe9XEeniGRlF
	+QjHCk3QI8C+YcBHGOHlcZVpw0WSGUSjRq4MY5qQk/Fr8hM29Zb2E8VC5KUERhsLXu/04uFwmdx38
	vRFhMfc6fWHgjzFmyl9tsrXH5orLkBNFSQ5QoZK2RIHxTnanUsZCEErNQAmWEfhZvF3nW/kkiKNAW
	Q/LVnu5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oabhY-003RwO-Cq; Tue, 20 Sep 2022 11:46:08 +0000
Date: Tue, 20 Sep 2022 04:46:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Wu, Dennis" <dennis.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Message-ID: <YymoAGbaU7tOo0Lv@infradead.org>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
 <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
 <YtefnyIvY9OdrVU5@infradead.org>
 <SN6PR11MB2640AC955668C96D5664F10BF84C9@SN6PR11MB2640.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB2640AC955668C96D5664F10BF84C9@SN6PR11MB2640.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 20, 2022 at 03:08:03AM +0000, Wu, Dennis wrote:
> Hi, Dan,
> Will we add this patch to some new kernel version?

How about addressing my comments and explaining what the exact
data integrity model is here first?
