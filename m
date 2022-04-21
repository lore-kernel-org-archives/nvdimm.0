Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A551FC0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 16:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B061AC385A1;
	Thu, 21 Apr 2022 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1650557379;
	bh=gGW2aD1FiS7/o994OIGCeUWbCVF8Zet/5/0xuKOzlak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z1qv8JOuNYeGATk1P16N6jzvaM5CJNIaFkczBUjHLlOqzzOqfHe7Rio7fsMmxC2CM
	 pXe9g+UlNnk6AM88R+oAtchjgd8nr4nypdvT6SVilCIJBh5h0cXJfCgBWioJIlDA2+
	 7Dmy5h3EkvqhRmP6CeTqCgYMj6HafJSoorqxAxo0=
Date: Thu, 21 Apr 2022 18:09:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, vishal.l.verma@intel.com,
	alison.schofield@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] device-core: Kill the lockdep_mutex
Message-ID: <YmGBwKEGSNqh0x8P@kroah.com>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055522548.3745911.14298368286915484086.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165055522548.3745911.14298368286915484086.stgit@dwillia2-desk3.amr.corp.intel.com>

On Thu, Apr 21, 2022 at 08:33:45AM -0700, Dan Williams wrote:
> Per Peter [1], the lockdep API has native support for all the use cases
> lockdep_mutex was attempting to enable. Now that all lockdep_mutex users
> have been converted to those APIs, drop this lock.
> 
> Link: https://lore.kernel.org/r/Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net [1]
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

YES!!!!!

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Nice work.
