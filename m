Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAA9_cmcNJK2GMmqE-Ss+P5TQMEE3CrViQ9JX77BC6nn8ihi_ag@mail.gmail.com>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
	<20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
	<20151118150945.GE6097@quack.suse.cz>
	<1447892533.13153.8.camel@intel.com>
	<20151119125541.GC18581@quack.suse.cz>
	<CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
	<20151119231704.GG19199@dastard>
	<1447977911.20885.10.camel@intel.com>
	<20151120040625.GI19199@dastard>
	<CAA9_cmcNJK2GMmqE-Ss+P5TQMEE3CrViQ9JX77BC6nn8ihi_ag@mail.gmail.com>
Date: Fri, 20 Nov 2015 09:08:32 -0800
Message-ID: <CAPcyv4ioUcGK6ZyxmByP9Gh13xEszjURHn7C=DUdP9eitXe92Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.com" <jack@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 19, 2015 at 8:25 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Nov 19, 2015 at 8:06 PM, Dave Chinner <david@fromorbit.com> wrote:
[..]
> What would be the recommended interface to tell XFS to sync if it can,
> but give up quickly if it hits an error and then shutdown permanently?

Thinking about this a bit further I think a "give up" notification to
a filesystem is an incremental addition to the common vfs layer
invalidate_partition() and now unmap_partition().  Because "sync if
you can, but give up quickly" is handled by fsync_bdev() and
generic_make_request() returning immediate errors.  It's only the file
system triggered retries that we need to turn off.
