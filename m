Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634C4625
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 10:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Agj8zzqvWDpZMOBEEasMzSNfdr1gbrYwMIOAO4LamnI=; b=J1iPv3ZhgUKOquThe2zFhWa0mI
	llIxIKvuAlGogtQY7vnhQNxlFPGw5+bJmgRTsvhvVY9mEsgccHsSxCgxG/KEfmJce7AOCxD4K8Exj
	6kuuBQG9Vmd677+eRtKWzL7lxsm/BUAVy5TLvhjgNUwWD/OJJwZsSVkVkvtreQb502vp/EEi1s2M6
	NFxa5560Tf7Px3KaBClsWI3kzPxxI8mg6BfUY4KMZtYDC1WqQWZChQE1IU3L621fCEbnmNusYLn6O
	ic2aNhKBzSwNA/vY+vElPib2Cj9VgGe3HRjtK6gSH2MAiVwbn6OoSbXgapUMIKTkkBDQssa/py8Dd
	3C47CEBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZVKC-00F9X8-Rh; Wed, 30 Mar 2022 10:13:12 +0000
Date: Wed, 30 Mar 2022 03:13:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
Message-ID: <YkQtOO/Z3SZ2Pksg@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
 <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 30, 2022 at 06:03:01PM +0800, Shiyang Ruan wrote:
> 
> Because I am not sure if the offset between each layer is page aligned.  For
> example, when pmem dirver handles ->memory_failure(), it should subtract its
> ->data_offset when it calls dax_holder_notify_failure().

If they aren't, none of the DAX machinery would work.
