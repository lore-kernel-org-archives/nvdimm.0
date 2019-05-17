Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 17 May 2019 09:40:31 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905170938.99AACF0D@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
 <201905170845.1B4E2A03@keescook>
 <ac76e29576b14fcb9a18e5a9e6ab8394@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac76e29576b14fcb9a18e5a9e6ab8394@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Jan Kara' <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <willy@infradead.org>, Jeff Smits <jeff.smits@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 04:14:03PM +0000, David Laight wrote:
> From: Kees Cook
> > Sent: 17 May 2019 16:54
> ...
> > > I've changed some of our code to use __get_user() to avoid
> > > these stupid overheads.
> > 
> > __get_user() skips even access_ok() checking too, so that doesn't seem
> > like a good idea. Did you run access_ok() checks separately? (This
> > generally isn't recommended.)
> 
> Of course, I'm not THAT stupid :-)

Right, yes, I know. :) I just wanted to double-check since accidents
can happen. The number of underscores on these function is not really
a great way to indicate what they're doing. ;)

-- 
Kees Cook
