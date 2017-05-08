Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BFF121A13489
 for <linux-nvdimm@lists.01.org>; Sun,  7 May 2017 20:01:34 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: [PATCH v2] x86, uaccess: introduce copy_from_iter_wt for pmem /
 writethrough operations
Date: Mon, 8 May 2017 03:01:29 +0000
Message-ID: <DF4PR84MB0105C455B08B867DA3D1950082EE0@DF4PR84MB0105.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
 <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1494016773.30303.69.camel@hpe.com>
 <CAPcyv4igCk9EBXSCVr8W1B-oNwq8q5kr7AMTkwvnMAhdwMgjRA@mail.gmail.com>
 <1494024273.30303.71.camel@hpe.com>
 <CAPcyv4iHGAGfb1ZUDYovUKs1+tr48CxEbngCHE-QiSFXAjeChA@mail.gmail.com>
 <20170506094652.sgiwijzursabbiab@gmail.com>
 <CAPcyv4hRMdMGZ4BUrkjnDD2GoCk3uNJTrU_A4Q7GHtqpMjNajw@mail.gmail.com>
 <20170507085730.ykn5abjol5o66ond@gmail.com>
In-Reply-To: <20170507085730.ykn5abjol5o66ond@gmail.com>
Content-Language: en-US
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
To: Ingo Molnar <mingo@kernel.org>, Dan Williams <dan.j.williams@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "mingo@redhat.com" <mingo@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> * Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > On Sat, May 6, 2017 at 2:46 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > * Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > >> On Fri, May 5, 2017 at 3:44 PM, Kani, Toshimitsu <toshi.kani@hpe.com>
> wrote:
> > >> > On Fri, 2017-05-05 at 15:25 -0700, Dan Williams wrote:
> > >> >> On Fri, May 5, 2017 at 1:39 PM, Kani, Toshimitsu
> <toshi.kani@hpe.com>
> > >> >> wrote:
> > >> >  :
> > >> >> > > ---
> > >> >> > > Changes since the initial RFC:
> > >> >> > > * s/writethru/wt/ since we already have ioremap_wt(),
> > >> >> > > set_memory_wt(), etc. (Ingo)
> > >> >> >
> > >> >> > Sorry I should have said earlier, but I think the term "wt" is
> > >> >> > misleading.  Non-temporal stores used in memcpy_wt() provide WC
> > >> >> > semantics, not WT semantics.
> > >> >>
> > >> >> The non-temporal stores do, but memcpy_wt() is using a combination
> of
> > >> >> non-temporal stores and explicit cache flushing.
> > >> >>
> > >> >> > How about using "nocache" as it's been
> > >> >> > used in __copy_user_nocache()?
> > >> >>
> > >> >> The difference in my mind is that the "_nocache" suffix indicates
> > >> >> opportunistic / optional cache pollution avoidance whereas "_wt"
> > >> >> strictly arranges for caches not to contain dirty data upon
> > >> >> completion of the routine. For example, non-temporal stores on older
> > >> >> x86 cpus could potentially leave dirty data in the cache, so
> > >> >> memcpy_wt on those cpus would need to use explicit cache flushing.
> > >> >
> > >> > I see.  I agree that its behavior is different from the existing one
> > >> > with "_nocache".   That said, I think "wt" or "write-through" generally
> > >> > means that writes allocate cachelines and keep them clean by writing
> to
> > >> > memory.  So, subsequent reads to the destination will hit the
> > >> > cachelines.  This is not the case with this interface.
> > >>
> > >> True... maybe _nocache_strict()? Or, leave it _wt() until someone
> > >> comes along and is surprised that the cache is not warm for reads
> > >> after memcpy_wt(), at which point we can ask "why not just use plain
> > >> memcpy then?", or set the page-attributes to WT.
> > >
> > > Perhaps a _nocache_flush() postfix, to signal both that it's non-temporal
> and that
> > > no cache line is left around afterwards (dirty or clean)?
> >
> > Yes, I think "flush" belongs in the name, and to make it easily
> > grep-able separate from _nocache we can call it _flushcache? An
> > efficient implementation will use _nocache / non-temporal stores
> > internally, but external consumers just care about the state of the
> > cache after the call.
> 
> _flushcache() works for me too.
> 

Works for me too.
Thanks,
-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
