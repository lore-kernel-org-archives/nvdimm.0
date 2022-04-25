Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB7C7E
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6rsQ5fLAtyoRL3SCMAk0oVTyMBB12u7c5MZ8wkkb5As=; b=eW9cGuwpaIgQ68FjdQGW5135pM
	9tqLVhqfzw41daqFoSxdYQ/af4NbMzk56dxF37hJ8qaX77dseTCr8SUaFd5D66025hnYCKGUZq66p
	MV18qFjo7U9QpJln+4demErqx5RZkIlOvGJKAABIdbn8E+KEQUv/9X6uCCpjKLNSofDsqUhuqRptr
	FIvE5XDKWVtcPQiEMnimASjqM5XMyn89q2dx6SQF8/6CAlcRr0m4G1pJ5YXPZ/gZeMeRivL7FLgY/
	wBahDvqLCQo/PzTKleGxYxvJW1cg+4QsV3Y/oYIcwYoZHSoi6S/HVdcBH+WBhN18xRa0URKWb5bTE
	Y92rIkYg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1niw1l-008c8c-4P; Mon, 25 Apr 2022 10:33:09 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
	id 61E7F980BF1; Mon, 25 Apr 2022 12:33:07 +0200 (CEST)
Date: Mon, 25 Apr 2022 12:33:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-cxl@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] cxl/acpi: Add root device lockdep validation
Message-ID: <20220425103307.GI2731@worktop.programming.kicks-ass.net>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YmNBJBTxUCvDHMbw@iweiny-desk3>
 <CAPcyv4jtNgfjWLyu6MtBAjwUiqe2qEBW802AzZZeg2gZ_wU9AQ@mail.gmail.com>
 <CAPcyv4hhD5t-qm_c_=bRjbJZFg9Mjkzbvu_2MEJB87fKy3hh-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hhD5t-qm_c_=bRjbJZFg9Mjkzbvu_2MEJB87fKy3hh-g@mail.gmail.com>

On Sat, Apr 23, 2022 at 10:27:52AM -0700, Dan Williams wrote:

> ...so I'm going to drop it and just add a comment about the
> expectations. As Peter said there's already a multitude of ways to
> cause false positive / negative results with lockdep so this is just
> one more area where one needs to be careful and understand the lock
> context they might be overriding.

One safe-guard might be to check the class you're overriding is indeed
__no_validate__, and WARN if not. Then the unconditional reset is
conistent.

Then, if/when, that WARN ever triggers you can revisit all this.
