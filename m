Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E10A153BEF;
	Wed, 12 Jun 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718186443; cv=none; b=mquiluYqqQgWT4bTjqj1eGrEZSe8oxyTqHOa1Meqz9Kwp9EcQHNQwdUjs/2MXZubRLpySUV+kZ3qd93y/SL8bJ5PzFfrH619b+op58PEKrH3PXAG3tOGn4tHugZ9G3AisxG5HP2Gyp2qGqWATseS6dhV/d039TEA0rNkGUk9p7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718186443; c=relaxed/simple;
	bh=7LFqbV8a2eEf04HyVsqJ/oKgbTyp/2/zSarRLIBqhmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcWLjqpE2qE0pi9O+OusiFF3di+MIZlA+fGvcfy06Dh2/rgsU+bIKhoWu+E2ZRglt3GOuTax+lqA48FXw3qNb75OZilJ5mCEKQ4VW+Ca3RB/LqO80uPl8fK6rY6N86bfpPR2R9a73bgS7qJBXm9HDS+W1BcdDaZK7DBS7BR3U4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdKHnRoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdKHnRoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADB2C3277B;
	Wed, 12 Jun 2024 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718186443;
	bh=7LFqbV8a2eEf04HyVsqJ/oKgbTyp/2/zSarRLIBqhmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdKHnRoS1XvxkBjEUW5CYbnJqb9mdMDAyeGMUa5SEH/jcItCRT6abOIulu1Io5Jg2
	 67160/YLkMJCBzdDKsBJrZ0Jr/mGzLS7ONQmoIdZdL5jFSNBILuN9k+AtEFOML4mFI
	 RLEbtwJQDeqa2oOkR6G7tM1IyDx5/kIUXiOylvrI=
Date: Wed, 12 Jun 2024 12:00:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] nvdimm: make nd_class constant
Message-ID: <2024061206-unleveled-seduce-9861@gregkh>
References: <2024061041-grandkid-coherence-19b0@gregkh>
 <66673b8a1ec86_12552029457@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66673b8a1ec86_12552029457@dwillia2-xfh.jf.intel.com.notmuch>

On Mon, Jun 10, 2024 at 10:44:42AM -0700, Dan Williams wrote:
> Greg Kroah-Hartman wrote:
> > Now that the driver core allows for struct class to be in read-only
> > memory, we should make all 'class' structures declared at build time
> > placing them into read-only memory, instead of having to be dynamically
> > allocated at runtime.
> 
> Change looks good to me,
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...changelog grammar tripped me up though, how about:
> 
> "Now that the driver core allows for struct class to be in read-only
> memory, it is possible to make all 'class' structures be declared at
> build time. Move the class to a 'static const' declaration and register
> it rather than dynamically create it."

That works too, want me to resubmit with this, or can I update it when I
commit it to my tree?

thanks,

greg "the changelog is the hardest part" k-h
