Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 24 Feb 2016 14:19:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] dax-fixes for 4.5-rc6
Message-Id: <20160224141931.8d72d389a5c969d12e6e9216@linux-foundation.org>
In-Reply-To: <CA+55aFx=g1cUoSDB4CYC4GuskqbsBvTefbYNwc2-oL1un_EhhA@mail.gmail.com>
References: <20160224184242.GA2858@linux.intel.com>
	<CA+55aFx=g1cUoSDB4CYC4GuskqbsBvTefbYNwc2-oL1un_EhhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 24 Feb 2016 14:03:22 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 24, 2016 at 10:42 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> >
> > I know DAX fixes have historically gone up through Andrew Morton's -mm tree,
> > but for some reason he's been silent on this series for the last few weeks.  I
> > think that the problems being fixed are important enough that we really
> > shouldn't wait until v4.6.
> 
> Andrew, can you comment?
> 

It's been a bit confusing because Dan has been merging DAX stuff as
well, mainly on the fs side.  I had assumed that these patches were
aimed at that route also.

I'll take a look right now.
