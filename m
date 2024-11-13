Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC217BB16
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731525694; cv=none; b=kvaKykqind4EbJQMhpZl7f1Tuxnu83/qUc7p+rSZdK6L4GhSpnPvI34GrpwkczFZZYnj4J9AU9MZmgeDgY2gbQ2VcHmbpUptPIQfztqiJ3wiFZRtwzr3PrQ1PxRcuD12/rx2wcILXUD5RBOb8EP97GuRNLy4t6PN4+rTjChRJiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731525694; c=relaxed/simple;
	bh=xsxA78JJw4MR9gjZ8hwrwa4EaWkqWSdpRVWCwHIGOio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/eYzSNIQe5Xs9CfxglVFkw8sg2An1/jnIhJB1bMLkp+kS1Ke/pQGUk869XkJU8HJKxp7QcV3Q5PxiRngB0lwYfetb9ULB5gX6kp5CCMnpduUo6lhO2CJ6adfzrQgttt+IzSIOCBeZ9qQMRQVcXG61HTVp+xrf/m5t0o37ZASKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qxlawwo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qxlawwo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F4C4CEC3;
	Wed, 13 Nov 2024 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731525694;
	bh=xsxA78JJw4MR9gjZ8hwrwa4EaWkqWSdpRVWCwHIGOio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qxlawwo6DgFqw4ANkE+G5yY2QgLvFlCqOyLcS6VTQpJpxsWeEpjXrBX0ICCg2aNeH
	 iKfU7M5IysQ9bO422sfMeJCI0hNiu1/s1/4rvc5SSfs+gNNSrD2uSlpAvGjUKWUqzE
	 NUk3+LU6fnW9Foawu2GCAwsQtyml09syrGJ8qcPJ+q1rTPHPLwfU4aHz0ozJo69f3p
	 ifv2dpXS0jyxhsN47l6qLCilDLUNd99xvanWj9d3DEz13UB+qv8fm3YMOHYorkHkvS
	 7fafTZ3hljKR22FYMRKN4LwOGB95FM4hXu1SqRQVal6M0fFd2j2nPsO0yQvouxaZE2
	 6ssXf5+ikD65g==
Date: Wed, 13 Nov 2024 12:21:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Keith Busch <kbusch@meta.com>, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <ZzT8O_yvAVQDj2U6@kbusch-mbp>
References: <20240830204255.4130362-1-kbusch@meta.com>
 <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>

On Wed, Nov 13, 2024 at 01:03:58PM -0600, Ira Weiny wrote:
> Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > bip is NULL before bio_integrity_prep().
> 
> Did this fail in some way the user might see?  How was this found?

I think this means no one ever used block integrity with btt. :)

I found this purely from code inspection because I was combing through
bio_integrity for a completely unrelated problem. I was trying to make
sense of how other drivers use it, and this one didn't make any.
 
> I think the code is correct but should this be backported to stable or
> anything?

Up to you! It's not fixing a regression since it appears to have never
worked before. You can also just delete support for it entirely if no
one cares to use this feature.
