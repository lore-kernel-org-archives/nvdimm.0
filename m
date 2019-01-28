Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76ADE211B5078
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 15:22:44 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 1/6] libndctl: Use the supported_alignment attribute
Date: Mon, 28 Jan 2019 23:22:41 +0000
Message-ID: <e96bb78be059029c22ebabea3b2d81b7ea81dd1d.camel@intel.com>
References: <20190116094909.23112-1-oohall@gmail.com>
 <eb998c851c5c4d4805bf1f527c805877fc8448fc.camel@intel.com>
 <CAOSf1CHjGmOt31_wXbabEE=Qjcc11iuK=2VsM1HzVBaDmFwCOg@mail.gmail.com>
 <3ee5757d6730c601aae7a9c69ef3d0c8297c96a8.camel@intel.com>
 <CAOSf1CE4fVSOirMv5QXd6aZAW531Ozc1ErHQZq5cdv7pYO8N8g@mail.gmail.com>
In-Reply-To: <CAOSf1CE4fVSOirMv5QXd6aZAW531Ozc1ErHQZq5cdv7pYO8N8g@mail.gmail.com>
Content-Language: en-US
Content-ID: <E2D853396D793C469ADB5445EDDEB0F3@intel.com>
MIME-Version: 1.0
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
To: "oohall@gmail.com" <oohall@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-01-29 at 10:20 +1100, Oliver wrote:
> On Tue, Jan 29, 2019 at 10:15 AM Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > 
> > On Tue, 2019-01-29 at 10:11 +1100, Oliver wrote:
> > > On Thu, Jan 24, 2019 at 6:32 AM Verma, Vishal L
> > > <vishal.l.verma@intel.com> wrote:
> > > > On Wed, 2019-01-16 at 20:49 +1100, Oliver O'Halloran wrote:
> > > > > Newer kernels provide the "supported_alignments" sysfs attribute that
> > > > > indicates what alignments can be used with a PFN or DAX namespace. This
> > > > > patch adds the plumbing inside of libndctl to allow users to query this
> > > > > information through using:
> > > > >       ndctl_{dax|pfn}_get_supported_alignment(), and
> > > > >       ndctl_{dax|pfn}_get_num_alignments()
> > > > > 
> > > > > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > > > > ---
> > > > > v3: Changed the return type of the *_get_supported_alignment() functions
> > > > >     to unsigned long to match the existing *_get_alignment() functions.
> > > > > ---
> > > > >  ndctl/lib/libndctl.c   | 40 ++++++++++++++++++++++++++++++++++++++++
> > > > >  ndctl/lib/libndctl.sym |  7 +++++++
> > > > >  ndctl/libndctl.h       |  6 ++++++
> > > > >  3 files changed, 53 insertions(+)
> > > > 
> > > > Hi Oliver,
> > > > 
> > > > Thanks for resubmitting this series. I had a few comments below:
> > > 
> > > Hi Vishal,
> > > 
> > > Sorry about the late response. I've been out of the office for the last week.
> > 
> > No worries. Also if you wouldn't mind, rebasing to the latest pending
> > branch on github would be helpful.
> 
> No problem.
> 
> One follow up question though. Does ndctl follow the kernel policy of
> keeping format strings on one line even if they go over 80 chars or
> should they be broken?

Yes we follow the kernel policy on that, so >80 char is ok for unbroken
format strings.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
