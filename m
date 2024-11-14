Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD9A1C1AB6
	for <nvdimm@lists.linux.dev>; Thu, 14 Nov 2024 04:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731558181; cv=none; b=pS6HObpau+gaPpfiSIfpyrqFEUkyhcHpPzLsCOjC8btUKXdRBQNo4XpafEVL+pr+wybCoaqMBCNhb1t/EW90qUFDTjk7wPXLQmP+n8dI+bgi+KOuBKOtjLRzyTumMkwA03mjywIWkKMKiIsU7jDyhsyrER4jc5F5Lv1AhbhdvNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731558181; c=relaxed/simple;
	bh=xFavDyvF54FrqMhRA18VNsLk/1Fd8EGbcYPxJX5+bvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsPupDBaAGOBMgX6Y8boSHasYf3/ZZgZVmrHOs0JLtJGUqJ1gG3ATSxtSlnsrMK+uOypM1Jm1Oep50j+hHsViLc5w/kKe05H54jTTkbRYP03Jo0tVmThWL6jjsdAdC0L+UMWIhRvFZ5G17chWT1vFIarBly9wSninQvFsRRXX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MjC66o7j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MjC66o7j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uSJaM0ZQnPRM6YdytnaeM31ecNKP9G9MVDjyxFYFWhI=; b=MjC66o7jlA62TWWyZsthe19kCO
	jk5ru5/MfywYkw8bFH+GuavzLHo6/aeu1WJxvAELuJN+YcD9Bu+6/c3VJv8IelWcRau3Q7ONC2KQV
	d5s4ADHuaOZHc1LAfOdx0gBibqlHfHYEOs4uMyaH0UQiuwUwecRtoZuSmxctYcf5fNYhU/mfuOnPo
	nEG59ak3s4lbZYqizz/LHfT0UYmcw2OKvD0g8D8rZW71/LpKD3ajbE7tbv2+slxOGCMi+KCpXAtkm
	k+2A52KToHU/tENxC24IRpMkvG9h/kNxQvYf1w9dAAA+1rHU30FP48mxvummU1miASCWSxwgnq+6g
	BYeZGcKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBRNf-00000008lJW-3kX4;
	Thu, 14 Nov 2024 04:22:55 +0000
Date: Wed, 13 Nov 2024 20:22:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@meta.com>,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <ZzV7H_hOrcLk3nxP@infradead.org>
References: <20240830204255.4130362-1-kbusch@meta.com>
 <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
 <ZzT8O_yvAVQDj2U6@kbusch-mbp>
 <673519f07bf7c_214c29470@dwillia2-xfh.jf.intel.com.notmuch>
 <x49bjyipzup.fsf@segfault.usersys.redhat.com>
 <673522ca9efe6_214c294b8@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <673522ca9efe6_214c294b8@dwillia2-xfh.jf.intel.com.notmuch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 13, 2024 at 02:06:02PM -0800, Dan Williams wrote:
> True, I think it is worth starting the deprecation process and see who
> screams. It is easy enough to revive if there are still users out there
> that have not since moved back to NVME for storage.

Were there every any users?  I've seen bug reports for all kinds of
weird drivers, but never ever btt..
