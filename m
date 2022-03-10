Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64247A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 10:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41595C340E8;
	Thu, 10 Mar 2022 10:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1646908386;
	bh=PG7nVQzs60HQfTios5ZRzSgoy8K4YGTG2YZ7gK2A+mQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YARB3g9usKlUsLX7I7Zoj3pRTftcAEVuUJOwxfJYKKnxlNBQib8o7kRuYOTRzVReB
	 Z/kyIB47DKJDMEUg/cBj7AfB9WFWgioKze+/F/DK08xcHagzvNwxeu4RdDrDWxtAPu
	 tBrzP4j10Yaid7ZzUIqoGWS0pjS/WpHyL4NsvtrTwp8Y51B29YgPPcg2Reg/bTvLUe
	 asYxC8uEvPRig9Ao3MNl9Lzps5DlSGV08WctbDNH9XHd7d490kKuICcqgr9YbY3zyu
	 RtH91dbpngYngD+aVQ29FXG3KIxCHf7VfPaJtCGWPHR7gmNQf/CuSgOTAnnP4d3+OM
	 vStsgN4Vhsn9A==
Date: Thu, 10 Mar 2022 12:32:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 3/5] mm/hugetlb_vmemmap: move comment block to
 Documentation/vm
Message-ID: <YinT2fO2cDmoLYXG@kernel.org>
References: <20220307122457.10066-1-joao.m.martins@oracle.com>
 <20220307122457.10066-4-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307122457.10066-4-joao.m.martins@oracle.com>

Hi,

On Mon, Mar 07, 2022 at 12:24:55PM +0000, Joao Martins wrote:
> In preparation for device-dax for using hugetlbfs compound page tail
> deduplication technique, move the comment block explanation into a
> common place in Documentation/vm.
> 
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/vm/index.rst         |   1 +
>  Documentation/vm/vmemmap_dedup.rst | 173 +++++++++++++++++++++++++++++

Sorry for jumping late.

Please consider moving this into Documentation/vm/memory-model.rst along
with the documentation added in the next patch

-- 
Sincerely yours,
Mike.
