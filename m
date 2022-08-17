Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D47C
	for <nvdimm@lists.linux.dev>; Wed, 17 Aug 2022 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OgQrLdq5kcs/hzWnLFRYsQLf3bF4BAzScASZVzKdEss=; b=O9A1GzrnC2Jws3P2XgaDN6BtBj
	aaMYi9KLwTTkyZsMQjZJBpryXirCyRo/np1yqNcbd78R/eq2ws5AA9fBx+y0a/wBVOAqULQ1EItjX
	xnddFmcIyEwyOffdnThWr/LaMK/zld5VSiFVwKsZnc7EAI2+qYPnR5zD2g1CtAI4+ZOS69m0BfVAG
	d418iYhdw9dUduJnKPoKCfI8KeugvDPEN0CEEA+5CM9VGkYtD+CQiX9AfP9HgwdG4gXL2M/WlZ0gb
	9smy8ah3BrobvDISkukaEuLA4mwPPe9bXSEiQNEYsPcqBoZG31Gn5pkG3qT1F87KxDRI2nUeSdhwx
	sYIIUFEQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oODo5-007tsG-GR; Wed, 17 Aug 2022 07:49:41 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2FB9798007A; Wed, 17 Aug 2022 09:49:40 +0200 (CEST)
Date: Wed, 17 Aug 2022 09:49:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	bwidawsk@kernel.org, ira.weiny@intel.com, vishal.l.verma@intel.com,
	alison.schofield@intel.com, a.manzanares@samsung.com,
	linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org, bp@alien8.de, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <YvydlP+XivIwfAPO@worktop.programming.kicks-ass.net>
References: <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
 <20220803183729.00002183@huawei.com>
 <9f3705e1-de21-0f3c-12af-fd011b6d613d@intel.com>
 <YvO8pP7NUOdH17MM@FVFF77S0Q05N>
 <62f40fba338af_3ce6829466@dwillia2-xfh.jf.intel.com.notmuch>
 <20220815160706.tqd42dv24tgb7x7y@offworld>
 <Yvtc2u1J/qip8za9@worktop.programming.kicks-ass.net>
 <62fbcae511ec1_dfbc129453@dwillia2-xfh.jf.intel.com.notmuch>
 <20220816165301.4m4w6zsse62z4hxz@offworld>
 <CAA9_cmfBubQe6EGk5+wjotvofZavfjFud-JMPW13Au0gpAcWog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmfBubQe6EGk5+wjotvofZavfjFud-JMPW13Au0gpAcWog@mail.gmail.com>

On Tue, Aug 16, 2022 at 10:42:03AM -0700, Dan Williams wrote:

> I also think this cache_flush_region() API wants a prominent comment
> clarifying the limited applicability of this API. I.e. that it is not
> for general purpose usage, not for VMs, and only for select bare metal
> scenarios that instantaneously invalidate wide swaths of memory.
> Otherwise, I can now see how this looks like a potentially scary
> expansion of the usage of wbinvd.

This; because adding a generic API like this makes it ripe for usage.
And this is absolutely the very last thing we want used.
