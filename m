Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666483206
	for <nvdimm@lists.linux.dev>; Fri,  9 Sep 2022 18:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K3rEGQsv9BVwA6kFBpw+S4FQ+EQeuMIv7O7eLl5u0rw=; b=O8P9Ae9GbkjzsWNrdQYmIBdIur
	UCdi1Q9zOS9sdHX5NNA+sreQJVZFyJAjOs7cTmAMkP7Ff+zi1oMP6cwFjgcYLLFwIHmAbYDfQMewZ
	muwNZbY05oszhg5SZXH5W0fsmXZi4Em9YBK/0dS2xcUtmU4pU0NGjGL7hxYrJLAleUmHjCaz4NlI3
	g09ArFO/JKgrQIpB67VyXiS6+3YOYxLHzS3NkQYaLA+N6SQVt17PEDxi9jQsi3EYdi/gKbQood8yq
	kEsAwAY8TkyIQ8tIpiEz3qKBeuHVImwXe3eGL7FNR+0t0lFMXR6UzXKUBRjxF40uw2SPO+jROZxsX
	v7feLepg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oWiTd-00DSSd-Fu; Fri, 09 Sep 2022 18:11:41 +0000
Date: Fri, 9 Sep 2022 19:11:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, akpm@linux-foundation.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/13] Fix the DAX-gup mistake
Message-ID: <YxuB3cKgitQrR3CQ@casper.infradead.org>
References: <YxeWQIxPZF0QJ/FL@nvidia.com>
 <6317a26d3e1ed_166f2946e@dwillia2-xfh.jf.intel.com.notmuch>
 <6317ebde620ec_166f29466@dwillia2-xfh.jf.intel.com.notmuch>
 <YxiVfn8+fR4I76ED@nvidia.com>
 <6318d07fa17e7_166f29495@dwillia2-xfh.jf.intel.com.notmuch>
 <6318e66861c87_166f294f1@dwillia2-xfh.jf.intel.com.notmuch>
 <YxjxUPS6pwHwQhRh@nvidia.com>
 <631902ef5591a_166f2941c@dwillia2-xfh.jf.intel.com.notmuch>
 <Yxo5NMoEgk+xKyBj@nvidia.com>
 <631a420ad2f28_166f29423@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <631a420ad2f28_166f29423@dwillia2-xfh.jf.intel.com.notmuch>

On Thu, Sep 08, 2022 at 12:27:06PM -0700, Dan Williams wrote:
> This thread is mainly about DAX slowly reinventing _mapcount that gets
> managed in all the right places for a normal_page. Longer term I think
> we either need to get back to the page-less DAX experiment and find a
> way to unwind some of this page usage creep, or cut over to finally
> making DAX-pages be normal pages and delete most of the special case
> handling in fs/dax.c. I am open to discussing the former, but I think
> the latter is more likely.

I'm still very much in favour of the former.  I've started on replacing
scatterlist with phyr, but haven't got very far yet.

