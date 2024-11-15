Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A4616F282
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731683945; cv=none; b=fmvg+R80PAFy5qtl3+tbDSJgp/+8DLLO0Es6d4sGS47LA4nbPsQiLoSPaNZJL/J9GD3f3JrOu9m/z191dx7dRXg7w3vFBQ0fwsDhl4tS/U1zlufLPnv5IuSaxmp3/1jm7jKvTNYz/A39gKNsHvw5gLumdVDoFRlbVMrWzDs5ajA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731683945; c=relaxed/simple;
	bh=SVOPipdu9g8gu4XPuD2z4pt8y7tgP2pjr4l8rXkNYEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdyhXlkMR9tHWJyDQ8ILy7c9BUWAHBJKhWnmxUKkbLDZMExsWAh/vn9phQBgHQC2zKEX390XbSvXMJ/xDF17JqA1nX/27seVyIp+be8/i+8RzfBfgEbgl7ASwH7CEYuDWb+cKfplr0mOn76XeUinmUNExI2g7e7STgibcc/HEFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCA5HBTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCA5HBTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA35C4CECF;
	Fri, 15 Nov 2024 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731683945;
	bh=SVOPipdu9g8gu4XPuD2z4pt8y7tgP2pjr4l8rXkNYEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YCA5HBTMQfRDG9h5JBmLPRj9hiPFoJqP9KAovuKj+z7TOELG6VHLePyDnsQaKpeD5
	 +VgCYzkIbj1mZTxSPgxEFH4GHwGGwtXQ268SKmSJFqjK42abVm+M9/zWHXZU+iu31z
	 zE9KlxdYAL6JFBn8azHZqOwPdthEfIHSrProszSHwY+Kmg2/fCU2ptLBsR2mFsmvJQ
	 vJA9gPOqn/q1qB58gT+MWIC5ynPISQQK1Za3F80N0LEa6h4zx2h5DCCtURQjoQcMzz
	 yGwDoYpqCC0lqSLmwJ9DY8yagItniNz6FSmnH5GSe5wudPrW+BEqrBJBmMl8kQW6uE
	 hPzyV4fHjV2+Q==
Date: Fri, 15 Nov 2024 08:19:03 -0700
From: Keith Busch <kbusch@kernel.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"kbusch@meta.com" <kbusch@meta.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <ZzdmZ6U3x8S2HLxX@kbusch-mbp>
References: <20240830204255.4130362-1-kbusch@meta.com>
 <eb557451f28668a7c8877322a5d5cb954fb6ac32.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb557451f28668a7c8877322a5d5cb954fb6ac32.camel@intel.com>

On Thu, Nov 14, 2024 at 09:33:05PM +0000, Verma, Vishal L wrote:
> I suspect this isn't actually needed, since the btt never generated its
> own protection payload. See the /* Already protected? */ case in
> bio_integrity_prep() - I think that's the only case we were trying to
> account for - i.e. 'some other layer' set the integrity payload, and
> we're just passing it on to it's right spot in pmem, and reading it
> back. The btt itself doesn't ever try to generate and set a protection
> payload of its own.
> 
> If you look at the original flow in
> 41cd8b70c37ace40077c8d6ec0b74b983178c192, btt never actually wants to
> call bio_integrity_prep and allocate the bip - if it has to do that,
> that's treated as an error.
> 
> Since some of the reworks then to eliminate bio_integrity_enabled, and
> other block level changes, this has changed to actually allocating bip
> and continuing instead of erroring, but coincidentially since we assign
> bip before the allocation (i.e. NULL as you point out), any future
> steps nicely ignore it, but if it was set by another subsystem, things
> should still 'work' - as in bio_integrity_prep() would return true, and
> bip would be non-NULL, and would get written/read as needed, and this
> is the happy path.
> 
> Does this makes sense or am I missing something?

One of us might be missing something. :)

The only upper layers I find that pass an integrity payload to the lower
level driver are the scsi and nvme targets. It may make sense to use btt
as the backend for those, but is that the only use case this was trying
to enable? Or is there some other path I didn't find?
