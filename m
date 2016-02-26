Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 26 Feb 2016 14:33:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] dax-fixes for 4.5-rc6
Message-Id: <20160226143330.c69e1970f1a254564d2886b1@linux-foundation.org>
In-Reply-To: <20160226214336.GA5886@linux.intel.com>
References: <20160224184242.GA2858@linux.intel.com>
 <CA+55aFx=g1cUoSDB4CYC4GuskqbsBvTefbYNwc2-oL1un_EhhA@mail.gmail.com>
 <20160224141931.8d72d389a5c969d12e6e9216@linux-foundation.org>
 <20160226214336.GA5886@linux.intel.com>
Mime-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 26 Feb 2016 14:43:36 -0700 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> On Wed, Feb 24, 2016 at 02:19:31PM -0800, Andrew Morton wrote:
> > On Wed, 24 Feb 2016 14:03:22 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Wed, Feb 24, 2016 at 10:42 AM, Ross Zwisler
> > > <ross.zwisler@linux.intel.com> wrote:
> > > >
> > > > I know DAX fixes have historically gone up through Andrew Morton's -mm tree,
> > > > but for some reason he's been silent on this series for the last few weeks.  I
> > > > think that the problems being fixed are important enough that we really
> > > > shouldn't wait until v4.6.
> > > 
> > > Andrew, can you comment?
> > > 
> > 
> > It's been a bit confusing because Dan has been merging DAX stuff as
> > well, mainly on the fs side.  I had assumed that these patches were
> > aimed at that route also.
> > 
> > I'll take a look right now.
> 
> Any update on this for v4.5, or is this now v4.6 material?

Patience, grasshopper.  It's only been in -next for one day.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
