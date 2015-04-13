Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 19:19:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413171907.GB14243@lst.de>
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com> <CACTTzNYBUocOz7scco6x-22ngu9cMk5uXJnHgM5PGFBqD22X-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTTzNYBUocOz7scco6x-22ngu9cMk5uXJnHgM5PGFBqD22X-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yigal Korman <yigal@plexistor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 02:11:56PM +0300, Yigal Korman wrote:
> mlock()

DAX files always are in-memory so this just sounds like an oversight.
method.
