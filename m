From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Mon, 26 Sep 2016 02:05:16 +0200
Message-ID: <20160926000516.GA32138@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de> <1473438884-674-7-git-send-email-hch@lst.de> <20160913231039.GF26002@linux.intel.com> <20160914071910.GC17278@lst.de> <20160914170759.GA14196@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160914170759.GA14196@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 11:07:59AM -0600, Ross Zwisler wrote:
> I'll bite - why do you think adding a space before labels is a "fairly
> horrible style"?

It introduces single whitespace indentation in a source base that is
all about tabs and uses whitespaces very sparingly (some people use
it to align function arguments, while others also consistently use tabs).

It's also a bit annoying when touching these error label chains for any
sort of major change.

> Adding them gives a tangible benefit for unified diffs and
> patches because it's much more useful to know that a change is in a given
> function than that it follows a label called "out", which could be defined
> many times in a given file.  Again, the example:

Yes, but this is just diff beeing stupid.  There is no reason why diff
couldn't handle this properly even without the space, and in fact at
least git diff can be tought easily to do just that.

There are a few threads about this label style going on on lkml in
the last week, and one of them mentions the git diff tweak.  Try searching
for "Clarify and complete chapter 7".
