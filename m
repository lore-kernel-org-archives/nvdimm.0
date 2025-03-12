Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAB1D5173;
	Wed, 12 Mar 2025 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741803118; cv=none; b=sCG58hze+6jWalvdj4z30E0vFGvK2kPQ4LvsWT+dU9n2WAejFXOLoq3lc8Kj3wsY6fNdakAvRsWrPVtq1cBs4UhXcutQNeG/vKaVm8heSWYVGxV5nYieLrAK65o/FhLjSwQzAgCB3w7vz34No/QwyNxRRx2YyXgUW9rvmh968B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741803118; c=relaxed/simple;
	bh=cV5aSqFJ33K30QuBwrJdyen4GmLJdTHeksSaAnwrNvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6ty9vsVb7asw9LyVhTBaUYkHKLsRxBIF8TCkq5rvyBYZWpWMU6mnslZR84bUdfQ/I618+RKw2evQ3ChtjbtSf4krFA9JYzoE61ncUUv0WMzbCydQZqroT6f2ZgrPEJ56H1HCR67aQiISY/0/dnsZ6l0lhHEeV2YbiVSSOyUHno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0pP4BPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0pP4BPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4192C4CEEA;
	Wed, 12 Mar 2025 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741803116;
	bh=cV5aSqFJ33K30QuBwrJdyen4GmLJdTHeksSaAnwrNvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W0pP4BPua5VsTBkh0FpSVUqjdFqimB1E+VhzMfKj3ctZXHRbRoSqGEi2sXcYjAHkM
	 AghgELe61AVdvO6cTJzCyvvnuYRi9FreuYv0GjGr2oYuKJVm7MWfVPuHHtqn40iGRI
	 IErzgBV9Kmr6i6sTf90ZySBfDMiH/bQYM9r5ZlrkZw5YjXZ7hfUhD+bDu9izHJmgJ5
	 oDzftJeZQckOAzX/RDfLlhNnH5zknbTIl++WmF+AmRWd6FwaC4UKbe8I4XddiJ6vzx
	 Gv72okJGBz5sy9Xen7AHpUVXS84F/DtQxccnT+nnBBIsv2gxNPmEF8Nl/iyJ7JF6uV
	 1vr8/HHt4tnlg==
Date: Wed, 12 Mar 2025 11:11:54 -0700
From: Minchan Kim <minchan@kernel.org>
To: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chris Li <chrisl@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Kairui Song <kasong@tencent.com>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Barry Song <baohua@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Casper Li <casper.li@mediatek.com>,
	Chinwen Chang <chinwen.chang@mediatek.com>,
	Andrew Yang <andrew.yang@mediatek.com>,
	James Hsu <james.hsu@mediatek.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from
 kswapd
Message-ID: <Z9HOavSkFf01K9xh@google.com>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>

Hi Qun-Wei

On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> This patch series introduces a new mechanism called kcompressd to
> improve the efficiency of memory reclaiming in the operating system. The
> main goal is to separate the tasks of page scanning and page compression
> into distinct processes or threads, thereby reducing the load on the
> kswapd thread and enhancing overall system performance under high memory
> pressure conditions.
> 
> Problem:
>  In the current system, the kswapd thread is responsible for both
>  scanning the LRU pages and compressing pages into the ZRAM. This
>  combined responsibility can lead to significant performance bottlenecks,
>  especially under high memory pressure. The kswapd thread becomes a
>  single point of contention, causing delays in memory reclaiming and
>  overall system performance degradation.

Isn't it general problem if backend for swap is slow(but synchronous)?
I think zram need to support asynchrnous IO(can do introduce multiple
threads to compress batched pages) and doesn't declare it's
synchrnous device for the case.
