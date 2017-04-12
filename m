Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 23:12:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
In-Reply-To: <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1704122259490.2548@nanos>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com> <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 12 Apr 2017, Dan Williams wrote:

> On Wed, Apr 12, 2017 at 1:52 PM, Luck, Tony <tony.luck@intel.com> wrote:
> > On Wed, Apr 12, 2017 at 01:27:05PM -0700, Verma, Vishal L wrote:
> >> >     /* We only care about memory errors */
> >> >     if (!(mce->status & MCACOD))
> >> >             return NOTIFY_DONE;
> >
> > N.B. that isn't a valid test that this is a memory error. You need
> >
> >
> >         if (!(m->status & 0xef80) == BIT(7))
> >                 return NOTIFY_DONE;
> >
> > See: Intel SDM Volume 3B - 15.9.2 Compound Error Codes
> 
> But Vishal's point is that even if we get this check correct the
> notifier still requires no sleeping operations. So we would need to
> move recoverable notifications to a separate blocking notifier chain.

There is another solution:

Convert the notifier to a blocking notifier and in the panic case, ignore
the locking and invoke the notifier chain directly. That needs some minimal
surgery in the notifier code to allow that, but that's certainly less ugly
than splitting stuff up into two chains.

Thanks,

	tglx



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
