Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A333CEBC;
	Fri, 21 Nov 2025 10:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721136; cv=none; b=XTiUzuksHymb5itKl6U6vNHCtaL9QjN+55TL7TLAaFDfgvGVlr7KObhCGYe1kZV8oZDUWUFS0bx3pNUgcNSIju/9w6RlsbgFpnVj/0ZdqXOWsZZyWa4ZLfVwjMIAHlI9plVNYpXvHfFC3rK/fOavYaZxUsv5uB8YA+6f9/9/Wcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721136; c=relaxed/simple;
	bh=+xLtjVUlP9uPE0zuZqDiF+8+7BZuIcZrmj6NjlI8quA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nrXofsSjVX9/3BJjvSdvyLa9NQHMsbTIWtOaY9Se+8j1OHRPoqZIDy47Pv6Q9Y9vjJAzzc/0wtQ/M/7FcfB3AMfPb6SdgqAk083urVy48l4DixW+pyGJG0krDO3l2NwxQHxt8psZoh9/xutmYCI5xRH6eIv+Xxi60C7ALbK6XvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gypv0FMb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gypv0FMb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n8dFnN/h+patZiXqhujYQZUHBKysv1dYEpiL+1UtwKM=; b=gypv0FMbX/tc62KhUgFPl38gxZ
	yxB27U2Nt1gVfhnwmj23N3jQw1C2xpkKAP7G1P3J0Ofs9d6J0b96F1m/7dLO3llOWVeJRpkwlTZUV
	50WRBkLSgaGKL7k2i+iJf9CX05Vd8qvY0CWVe5qHhvTo6Rv9BDE/4X91X8pZt2IwGfkYOOitbDPeB
	GF/DD9licgj9ddJZnbwYekC6aYd746uNfmk+odiLyH0vkJY+0aVriG2ec86BgtHQgd/K54hkIhNs1
	Uet8bmuYX2Ns3v+1KZ1rFOYZAUy4vDhs8xNo0uURxk5c0MLeWjWhwXwFARcQdcSDSiCPLg2YWI+2s
	iMk/Bdyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMOQx-00000008Eyz-1ePV;
	Fri, 21 Nov 2025 10:32:07 +0000
Date: Fri, 21 Nov 2025 02:32:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH 2/9] block: export bio_chain_and_submit
Message-ID: <aSA_p2N_IK3I-KmM@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-3-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081748.1443507-3-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is almost missing a commit message.  Also I think this
and the following patches are cleanups / refactoring, so maybe
let's concentrate on the bug fix first?

