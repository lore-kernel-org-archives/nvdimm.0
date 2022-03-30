Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF697B
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 16:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A51C340EC;
	Wed, 30 Mar 2022 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648657093;
	bh=cjFQuqoRMfu2TXAsiXRv9EQjKvH+MdFIXY9uc5fhIeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qL9r9Yws/hUGzKuvIFY+RbuwntrMSK4P43CyL2/dnXSTyynijAjGxTx5jk0MciJBS
	 ZU3K1UIDqMzxA88epboJ1p59x5irJJj2JLdT3IY0tPJYmpTuab09WoUfTrxDR16Dfq
	 r8N4tXQdQIaPnia1AslHnGmOplVqsKsaI34w3RLi6u1e7bfXjxM+6aYBDQb0MMyTSr
	 YPN+3zKng+bKVx0qXsPftkro+4iih8aIVgkJzS6owkJGyF1RHMzDG9okK9EYv0u6/k
	 DPUA6Xn7fDXsQPvseUvtae8Ads0cYctEDf9QDUz5BscGpr2wMHyw7xssUbm6ZRtK/f
	 ndefofeH+jTig==
Date: Wed, 30 Mar 2022 09:18:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	david <david@fromorbit.com>, Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
Message-ID: <20220330161812.GA27649@magnolia>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
 <YkPtptNljNcJc1g/@infradead.org>
 <15a635d6-2069-2af5-15f8-1c0513487a2f@fujitsu.com>
 <YkQtOO/Z3SZ2Pksg@infradead.org>
 <4ed8baf7-7eb9-71e5-58ea-7c73b7e5bb73@fujitsu.com>
 <YkR8CUdkScEjMte2@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkR8CUdkScEjMte2@infradead.org>

On Wed, Mar 30, 2022 at 08:49:29AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 30, 2022 at 06:58:21PM +0800, Shiyang Ruan wrote:
> > As the code I pasted before, pmem driver will subtract its ->data_offset,
> > which is byte-based. And the filesystem who implements ->notify_failure()
> > will calculate the offset in unit of byte again.
> > 
> > So, leave its function signature byte-based, to avoid repeated conversions.
> 
> I'm actually fine either way, so I'll wait for Dan to comment.

FWIW I'd convinced myself that the reason for using byte units is to
make it possible to reduce the pmem failure blast radius to subpage
units... but then I've also been distracted for months. :/

--D
