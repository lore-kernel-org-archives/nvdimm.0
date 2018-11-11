Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0028D21125471
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 12:33:04 -0800 (PST)
Date: Sun, 11 Nov 2018 12:33:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
Message-ID: <20181111203304.GA16871@kroah.com>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
 <20181111193208.GB8332@kroah.com> <20181111195903.GA9726@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181111195903.GA9726@amd>
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
To: Pavel Machek <pavel@ucw.cz>
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, zwisler@kernel.org, tj@kernel.org, Alexander Duyck <alexander.h.duyck@linux.intel.com>, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 11, 2018 at 08:59:03PM +0100, Pavel Machek wrote:
> On Sun 2018-11-11 11:32:08, Greg KH wrote:
> > On Thu, Nov 08, 2018 at 10:06:50AM -0800, Alexander Duyck wrote:
> > > Introduce four new variants of the async_schedule_ functions that allow
> > > scheduling on a specific NUMA node.
> > > 
> > > The first two functions are async_schedule_near and
> > > async_schedule_near_domain end up mapping to async_schedule and
> > > async_schedule_domain, but provide NUMA node specific functionality. They
> > > replace the original functions which were moved to inline function
> > > definitions that call the new functions while passing NUMA_NO_NODE.
> > > 
> > > The second two functions are async_schedule_dev and
> > > async_schedule_dev_domain which provide NUMA specific functionality when
> > > passing a device as the data member and that device has a NUMA node other
> > > than NUMA_NO_NODE.
> > > 
> > > The main motivation behind this is to address the need to be able to
> > > schedule device specific init work on specific NUMA nodes in order to
> > > improve performance of memory initialization.
> > > 
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > ---
> > 
> > No one else from Intel has reviewed/verified this code at all?
> > 
> > Please take advantages of the resources you have that most people do
> > not, get reviewes from your coworkers please before you send this out
> > again, as they can give you valuable help before the community has to
> > review the code...
> 
> We always said to companies we want to see code as soon as
> possible. You don't have to review their code, but discouraging the
> posting seems wrong.

I have a long history of Intel using me for their basic "find the
obvious bugs" review process for new driver subsystems and core changes.
When I see new major patches show up from an Intel developer without
_any_ other review from anyone else, directed at me, I get suspicious it
is happening again.

If you note, Intel is the _only_ company I say this to their developers
because of this problem combined with the fact that they have a whole
load of developers that they should be running things by first.

And yes, to answer Dan's point, we do want to do review in public.  But
this is v6 of a core patchset and there has been NO review from anyone
else at Intel on this.  So if that review was going to happen, one would
have thought it would have by now, instead of relying on me to do it.

And yes, I am grumpy, but I am grumpy because of the history here.  I am
not trying to discourage anything, only to take ADVANTAGE of resources
that almost no other company provides.

Hope this helps explain my statement here.

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
