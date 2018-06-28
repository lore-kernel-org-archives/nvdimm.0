Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C65D211F8883
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jun 2018 11:01:03 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Thu, 28 Jun 2018 18:01:00 +0000
Message-ID: <1530208741.14039.314.camel@hpe.com>
References: <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
 <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
 <1530048093.14039.286.camel@hpe.com>
 <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
 <1530048545.14039.288.camel@hpe.com>
 <CAPcyv4ifHX95fCM9Xj87CugwNWzgq=y-4LxPQ5L6RdjX0jdctQ@mail.gmail.com>
 <20180626220430.GA4269@linux.intel.com>
 <1530207635.14039.308.camel@hpe.com> <20180628174815.GA18768@redhat.com>
In-Reply-To: <20180628174815.GA18768@redhat.com>
Content-Language: en-US
Content-ID: <44A85094F25DD14AA2EB648AA51D10FF@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-06-28 at 13:48 -0400, Mike Snitzer wrote:
> On Thu, Jun 28 2018 at  1:42pm -0400,
> Kani, Toshi <toshi.kani@hpe.com> wrote:
> 
> > On Tue, 2018-06-26 at 16:04 -0600, Ross Zwisler wrote:
> > > On Tue, Jun 26, 2018 at 02:51:52PM -0700, Dan Williams wrote:
> > > > On Tue, Jun 26, 2018 at 2:31 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> > > > > On Tue, 2018-06-26 at 14:28 -0700, Dan Williams wrote:
> > > > > > On Tue, Jun 26, 2018 at 2:23 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> > > > > > > On Tue, 2018-06-26 at 14:02 -0700, Dan Williams wrote:
> > > > > > > > On Tue, Jun 26, 2018 at 1:54 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> > > > > > 
> > > > > > [..]
> > > > > > > > > When this dm change was made, the pmem driver supported DAX for both raw
> > > > > > > > > and memory modes (note: sector mode does not use the pmem driver).  I
> > > > > > > > > think the issue was introduced when we dropped DAX support from raw
> > > > > > > > > mode.
> > > > > > > > 
> > > > > > > > Still DAX with raw mode never really worked any way. It was also
> > > > > > > > something that was broken from day one. So what happens to someone who
> > > > > > > > happened to avoid all the problems with page-less DAX and enabled
> > > > > > > > device-mapper on top? That failure mode detail needs to be added to
> > > > > > > > this changelog if we want to propose this for -stable.
> > > > > > > 
> > > > > > > My point is that the behavior should be consistent between pmem and
> > > > > > > device-mapper.  When -o dax succeeds on a pmem, then it should succeed
> > > > > > > on a device-mapper on top of that pmem.
> > > > > > > 
> > > > > > > Has the drop of dax support from raw mode made to -stable back to the
> > > > > > > baseline accepted 545ed20e6df6?  It will introduce inconsistency,
> > > > > > > otherwise.
> > > > > > 
> > > > > > That commit, 569d0365f571 "dax: require 'struct page' by default for
> > > > > > filesystem dax", has not been tagged for -stable.
> > > > > 
> > > > > Then, Fixes tag should be set to 569d0365f571 to keep the behavior
> > > > > consistent.
> > > > 
> > > > Sure, and the failure mode is...? I'm thinking the commit log should say:
> > > > 
> > > > "Starting with commit 569d0365f571 "dax: require 'struct page' by
> > > > default for filesystem dax", dax is no longer supported for page-less
> > > > configurations. However, device-mapper sees the QUEUE_FLAG_DAX still
> > > > being set and falsely assumes that DAX is enabled, this leads to
> > > > <insert user visible failure mode details here>"
> > > 
> > > Dan is correct that there is no user visible change for this.  It is the right
> > > thing to do for consistency and sanity, but it doesn't actually have user
> > > visible behavior that needs to be backported to stable.
> > > 
> > > Toshi is correct that this change is only for raw mode namespaces, not btt
> > > namespaces.
> > > 
> > > I'll adjust the changelog and remove the stable flag for v5, and I'll add a
> > > Fixes: tag for patch 2.
> > 
> > Hi Ross,
> > 
> > Your patches look good.  But I am still not clear about the Fixes &
> > stable handling.  Talking about user visible behavior, I do not think we
> > had any issue until dax support was dropped from raw mode.  Until then,
> > the pmem driver supported dax for all modes, and the check for
> > direct_access worked.    
> 
> I've staged the changes to send to Linus shortly.
> 
> The first patch has:
> 
> Fixes: 569d0365f571 ("dax: require 'struct page' by default for filesystem dax")
> Cc: stable@vger.kernel.org
> 
> As that is the right thing to do given the other 2 patches are marked
> for stable.  We don't want to have a stable kernel with the last 2
> patches but not the first.

Agreed.

Technically, all 3 patches may have "Fixes: 569d0365f571 dax..", but I
think having "Fixes 545ed20e6df6 dm.." for patch 2 & 3 provide a
protection in case 569d0365f571 gets backported in future.

For the series:
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
