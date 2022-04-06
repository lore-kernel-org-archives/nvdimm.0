Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E687E
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 05:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DNgj8SdHFn5QyKE9xYEDK+F70Z
	m0ofosTmoG+EyUWhzwmrzqDyFHySJ2ikh9+dfxctxaI6VNiUqqNWdkRaHvQ8atm/PgEakfwpXVQzN
	sXOxuAmRulf5fTg61U1NvaAhd3ca0u22q53daFuB4CsGhUyU5l4vQV0hqGKzQdGL9psJzG5mZ+1DE
	9fOAra00qfmg5d7jJL4niqLTrH5K0JY8lEG8GhmqeA2uu1/aTWRRMnXapkhB5mhqIopaWmgbDsRkA
	Qz+biNG1/WHQ6iwp4UbA+iqIz2lDPnpcj3+r8EzDkEowlQQlWg5LQBT2U/Bg3QbGRCUKnQNMfX/fk
	qqE9GUdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nbxnk-003n4s-KZ; Wed, 06 Apr 2022 05:01:52 +0000
Date: Tue, 5 Apr 2022 22:01:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v7 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <Yk0ewEadBLCjhtpC@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
