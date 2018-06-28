Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46AD3202E53E8
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jun 2018 12:40:22 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Thu, 28 Jun 2018 19:40:14 +0000
Message-ID: <1530214695.14039.316.camel@hpe.com>
References: <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com> <1530046327.14039.273.camel@hpe.com>
 <CAPcyv4hP_Y3xdyCa-UkYCMJ5OtnjnkwPZDS2Z2Ge8+5ymBONwQ@mail.gmail.com>
 <1530048093.14039.286.camel@hpe.com>
 <CAPcyv4gXAC7imJs5qfsDNLeN545Rqyd2b1M9s5kr4f9y48LXgQ@mail.gmail.com>
 <1530048545.14039.288.camel@hpe.com>
 <CAPcyv4ifHX95fCM9Xj87CugwNWzgq=y-4LxPQ5L6RdjX0jdctQ@mail.gmail.com>
 <20180626220430.GA4269@linux.intel.com>
 <1530207635.14039.308.camel@hpe.com>
 <20180628190424.GC17758@linux.intel.com>
In-Reply-To: <20180628190424.GC17758@linux.intel.com>
Content-Language: en-US
Content-ID: <BD982B3FCD049F479B5BFD2D4008C2C0@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-06-28 at 13:04 -0600, Ross Zwisler wrote:
> On Thu, Jun 28, 2018 at 05:42:34PM +0000, Kani, Toshi wrote:
> > On Tue, 2018-06-26 at 16:04 -0600, Ross Zwisler wrote:
> > > On Tue, Jun 26, 2018 at 02:51:52PM -0700, Dan Williams wrote:
> > > > On Tue, Jun 26, 2018 at 2:31 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
 :
> > Your patches look good.  But I am still not clear about the Fixes &
> > stable handling.  Talking about user visible behavior, I do not think we
> > had any issue until dax support was dropped from raw mode.  Until then,
> > the pmem driver supported dax for all modes, and the check for
> > direct_access worked.    
> 
> I agree that the fsdax + raw mode failure mode I mentioned in my cover letter
> only started when we restricted filesystem DAX to having struct page, but I
> think that the other failure mode, fsdax + some random block driver (I used
> brd) was present in DM from the beginning.

Ah, I see.

> In any case, I think both are fixed with the patches, and I think it's fine
> that all 3 get thrown at stable.  Thanks, Mike, for the help.

Yup, agreed. 

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
