Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED0717C9
	for <nvdimm@lists.linux.dev>; Tue, 31 May 2022 00:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g4nJNHLU5acCCvTosby/8yo1t0yRHy/MZiOxGl1UM48=; b=sVc1OZ/LiljEnh5no8p+RB5RsQ
	o3j1mw58LmBVKAyPdUgcZJt7DDxxEuNvfVySZJ86YgYYRfxEcH//GD3rGsmy4cAADYcoJ3h7SvjFO
	09B1uPZocQg8hHGeXmJHGSCFAyrnw09KwZwaE7EdCgTHFJmZbE4iFvJmXsX0R6jHA1ZrW1Mg6N7dx
	O+CwxOKSbAmbaJ2dgYFoiPUy0OaOQxhtbCbkGIJc0fJAT27mRmdsoBO2MYqMNiJ8RCjZ5+XLghbAp
	5Vax+P9IwEAiv4MBHL/nrsti8+4HQoEXhKk1FU/4E5h2ovFDJal3TI0B8IPIg4z5emv5SK+8Eeo2x
	PTEkCKrw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nvpzA-004uxC-Jj; Tue, 31 May 2022 00:43:48 +0000
Date: Tue, 31 May 2022 01:43:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: Potential regression on kernel 5.19-rc0: kernel BUG at
 mm/page_table_check.c:51!
Message-ID: <YpVkxGe0reEaDoU+@casper.infradead.org>
References: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
 <20220530183908.vi7u37a6irji4gnf@zlang-mailbox>
 <20220530222919.GA1098723@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530222919.GA1098723@dread.disaster.area>

On Tue, May 31, 2022 at 08:29:19AM +1000, Dave Chinner wrote:
> On Tue, May 31, 2022 at 02:39:08AM +0800, Zorro Lang wrote:
> > It's not a regression *recently* at least, I still can reproduce this bug on
> > linux v5.16.
> > 
> > But I found it's related with someone kernel configuration (sorry I haven't
> > figured out which one config is). I've upload two kernel config files, one[1]
> > can build a kernel which reproduce this bug, the other[2] can't. Hope that
> > helps.
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > https://bugzilla.kernel.org/attachment.cgi?id=301076
> > 
> > [2]
> > https://bugzilla.kernel.org/attachment.cgi?id=301077
> 
> Rather than make anyone looking at this download multiple files and
> run diff, perhaps you could just post the output of 'diff -u
> config.good config.bad'?

You guys know about tools/testing/ktest/config-bisect.pl right?
