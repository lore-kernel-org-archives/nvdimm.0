Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D63BB209605D2
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 16:49:21 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 5/7] dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
Date: Mon, 4 Jun 2018 23:49:18 +0000
Message-ID: <1528156065.14039.113.camel@hpe.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-6-ross.zwisler@linux.intel.com>
 <20180601220443.GB18712@redhat.com>
 <20180604232416.GB10666@linux.intel.com>
In-Reply-To: <20180604232416.GB10666@linux.intel.com>
Content-Language: en-US
Content-ID: <1D4ACA0B174EA340BD68FDA59FFD6084@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.orgw" <linux-xfs@vger.kernel.orgw>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-06-04 at 17:24 -0600, Ross Zwisler wrote:
> On Fri, Jun 01, 2018 at 06:04:43PM -0400, Mike Snitzer wrote:
> > On Tue, May 29 2018 at  3:51pm -0400,
> > Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
 :
> > For example, the following transition will currently fail:
> > 
> >  dm-linear: [fsdax pmem][fsdax pmem] => [fsdax pmem][fsdax raw]
> >               DM_TYPE_DAX_BIO_BASED       DM_TYPE_BIO_BASED
> > 
> > but these will both succeed:
> > 
> >  dm-linear: [fsdax pmem][brd ramdisk] => [fsdax pmem][fsdax raw]
> >                 DM_TYPE_BIO_BASED        DM_TYPE_BIO_BASED
> > 
> >  dm-linear: [fsdax pmem][fsdax raw] => [fsdax pmem][fsdax pmem]
> >                 DM_TYPE_BIO_BASED        DM_TYPE_DAX_BIO_BASED
> 
> So we allow 2 of the 3 transitions, but the reason that we disallow the third
> isn't fully clear to me.

I need to refresh my memory for the code, but here is the intent.
https://lkml.org/lkml/2016/6/22/1000
https://lkml.org/lkml/2016/6/22/999


> > >  dm-linear: [fsdax pmem][fsdax raw] => [fsdax pmem][fsdax pmem]
> > >  		DM_TYPE_BIO_BASED        DM_TYPE_DAX_BIO_BASED
> > > 
> > > This seems arbitrary, as really the choice on whether to use DAX happens at
> > > filesystem mount time.  There's no guarantee that the in the first case
> > > (double fsdax pmem) we were using the dax mount option with our file
> > > system.
> > > 
> > > Instead, get rid of DM_TYPE_DAX_BIO_BASED and all the special casing around
> > > it, and instead make the request queue's QUEUE_FLAG_DAX be our one source
> > > of truth.  If this is set, we can use DAX, and if not, not.  We keep this
> > > up to date in table_load() as the table changes.  As with regular block
> > > devices the filesystem will then know at mount time whether DAX is a
> > > supported mount option or not.
> > 
> > If you don't think you need this specialization that is fine.. but DM
> > devices supporting suspending (as part of table reloads) so is there any
> > risk that there will be inflight IO (say if someone did 'dmsetup suspend
> > --noflush').. and then upon reload the device type changed out from
> > under us.. anyway, I don't have all the PMEM DAX stuff paged back into
> > my head yet.
> > 
> > But this just seems like we really shouldn't be allowing the
> > transition from what was DM_TYPE_DAX_BIO_BASED back to DM_TYPE_BIO_BASED
> 
> I admit I don't fully understand all the ways that DM supports suspending and
> resuming devices.  Is there actually a case where we can change out the DM
> devices while I/O is running, and somehow end up trying to issue a DAX I/O to
> a device that doesn't support DAX?
> 
> Toshi, do you have a test case that shows this somehow?

No, I did not test suspend/resume since HPE servers do not support it.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
