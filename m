Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 18 Apr 2017 09:28:22 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170418162822.GA2358@intel.com>
References: <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
 <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
 <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
 <20170412222619.GA17839@intel.com>
 <20170412222925.r3izasv3yuyjy62e@pd.tnic>
 <20170413113159.rc32ebiswn64nzrr@pd.tnic>
 <20170413121215.kzflalrar7hpxvjh@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170413121215.kzflalrar7hpxvjh@pd.tnic>
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
To: Borislav Petkov <bp@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 13, 2017 at 02:12:16PM +0200, Borislav Petkov wrote:
> On Thu, Apr 13, 2017 at 01:31:59PM +0200, Borislav Petkov wrote:
> > @@ -321,18 +321,8 @@ static void __print_mce(struct mce *m)
> >  
> >  static void print_mce(struct mce *m)
> >  {
> > -	int ret = 0;
> > -
> >  	__print_mce(m);
> > -
> > -	/*
> > -	 * Print out human-readable details about the MCE error,
> > -	 * (if the CPU has an implementation for that)
> > -	 */
> > -	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> > -	if (ret == NOTIFY_STOP)
> > -		return;
> > -
> > +	mce_log(m);
> 
> Actually, we don't need that call here because do_machine_check()
> already does it.

Yes. Don't add mce_log(m) here. We've already done it.

With this change:

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
