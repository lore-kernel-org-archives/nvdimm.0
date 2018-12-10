Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D7BA21193786
 for <linux-nvdimm@lists.01.org>; Mon, 10 Dec 2018 14:24:11 -0800 (PST)
Message-ID: <00810f93b199c524378b5c963d49bd798c5d9843.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v8 2/9] driver core: Establish order of
 operations for device_add and device_del via bitflag
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 10 Dec 2018 14:24:10 -0800
In-Reply-To: <CAPcyv4hrML3SKnFP9UANC-hdTrpnOx4nWX=b-yhLsLuujL5oAA@mail.gmail.com>
References: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
 <154403072403.11544.10419282512791659652.stgit@ahduyck-desk1.jf.intel.com>
 <CAPcyv4jH_Op-xHTd2FwQizPaWFx_2FE-pVsOLLmZAEK8EVPrYg@mail.gmail.com>
 <15b6817fd945a1622afe673b46b028bacefad72b.camel@linux.intel.com>
 <CAPcyv4i1RTrKYX0YpyCRE=pqt3pHBRiCGQq1wYUriLjKKTVA7A@mail.gmail.com>
 <bd92d0a3ff60097bf4424ff4c556a5369e66da6d.camel@linux.intel.com>
 <CAPcyv4jDG_2VwFr4oDGCURFrA=B0Bs2HGN9exLE47vDj0P3_8A@mail.gmail.com>
 <CAPcyv4hrML3SKnFP9UANC-hdTrpnOx4nWX=b-yhLsLuujL5oAA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-12-10 at 13:23 -0800, Dan Williams wrote:
> On Mon, Dec 10, 2018 at 1:15 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > 
> > On Mon, Dec 10, 2018 at 12:58 PM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> 
> [..]
> > > Also the context for the two functions seems to be a bit different. In
> > > the case of __device_attach_driver the device_lock is already held. In
> > > __driver_attach the lock on the device isn't taken until after a match
> > > has been found.
> > 
> > Yes, I was only pattern matching when looking at the context of where
> > dev->dead is checked in __driver_attach() and wondering why it was
> > checked outside of __device_attach_driver()
> 
> ...and now I realize the bigger point of your concern, we need to
> check dev->dead after acquiring the device_lock otherwise the race is
> back. We can defer that consolidation, but the larger concern of
> making it internal to __device_attach_driver() still stands.

I'm still not a fan of moving it into __device_attach_driver. I would
much rather pull out the dev->driver check and instead place that in
__device_attach_async_helper.

The __device_attach function as I said took the device_lock and had
already checked dev->driver. So in the non-async path it shouldn't be
possible for dev->driver to ever be set anyway. In addition
__device_attach_driver is called once for each driver on a given bus,
so dropping the test should reduce driver load time since it is one
less test that has to be performed per driver.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
