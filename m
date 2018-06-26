Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22914211F8883
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 14:31:04 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 21:31:01 +0000
Message-ID: <1530048545.14039.288.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
 <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
 <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
 <1530048093.14039.286.camel@hpe.com>
 <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <E691B1B6B1F6B641A12FEB7DF2ED0153@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-06-26 at 14:28 -0700, Dan Williams wrote:
> On Tue, Jun 26, 2018 at 2:23 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> > On Tue, 2018-06-26 at 14:02 -0700, Dan Williams wrote:
> > > On Tue, Jun 26, 2018 at 1:54 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> 
> [..]
> > > > When this dm change was made, the pmem driver supported DAX for both raw
> > > > and memory modes (note: sector mode does not use the pmem driver).  I
> > > > think the issue was introduced when we dropped DAX support from raw
> > > > mode.
> > > 
> > > Still DAX with raw mode never really worked any way. It was also
> > > something that was broken from day one. So what happens to someone who
> > > happened to avoid all the problems with page-less DAX and enabled
> > > device-mapper on top? That failure mode detail needs to be added to
> > > this changelog if we want to propose this for -stable.
> > 
> > My point is that the behavior should be consistent between pmem and
> > device-mapper.  When -o dax succeeds on a pmem, then it should succeed
> > on a device-mapper on top of that pmem.
> > 
> > Has the drop of dax support from raw mode made to -stable back to the
> > baseline accepted 545ed20e6df6?  It will introduce inconsistency,
> > otherwise.
> 
> That commit, 569d0365f571 "dax: require 'struct page' by default for
> filesystem dax", has not been tagged for -stable.

Then, Fixes tag should be set to 569d0365f571 to keep the behavior
consistent.

-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
