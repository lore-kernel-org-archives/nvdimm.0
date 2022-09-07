Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF4589B0
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 22:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495D9C433D6;
	Wed,  7 Sep 2022 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1662589817;
	bh=icUrwow2CfL0XBxzTtlHd9U90jN+X9EkDzy9xW2u15w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I8fEiVnYdONLg4RYOnaYni7CG0VvoCxIZn0T6K99IIfhvScjtIRaOt19syHlKmEil
	 t8eQLP01qbrGEqu2bL0WD40A1KOvexY13ymExhqqa3bh7c6D2qonaIVG5EYYhH1nsG
	 d1GHZ79kMApd+lcxU46r0rUc7wauR0AJL3bJiUf4=
Date: Wed, 7 Sep 2022 15:30:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: dan.j.williams@intel.com, x86@kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, peterz@infradead.org, bp@alien8.de,
 dave.jiang@intel.com, Jonathan.Cameron@huawei.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, a.manzanares@samsung.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] memregion: Add arch_flush_memregion() interface
Message-Id: <20220907153016.f7cd4f42a337fedae8319f28@linux-foundation.org>
In-Reply-To: <20220829212918.4039240-1-dave@stgolabs.net>
References: <20220829212918.4039240-1-dave@stgolabs.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I really dislike the term "flush".  Sometimes it means writeback,
sometimes it means invalidate.  Perhaps at other times it means
both.

Can we please be very clear in comments and changelogs about exactly
what this "flush" does.   With bonus points for being more specific in the 
function naming?
