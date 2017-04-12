Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 14:19:32 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412211931.GA15771@intel.com>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1704122259490.2548@nanos>
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
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 11:12:21PM +0200, Thomas Gleixner wrote:
> There is another solution:
> 
> Convert the notifier to a blocking notifier and in the panic case, ignore
> the locking and invoke the notifier chain directly. That needs some minimal
> surgery in the notifier code to allow that, but that's certainly less ugly
> than splitting stuff up into two chains.

But I wonder whether we actually want two chains.  We've been adding a bunch
of general run-time logging and recovery stuff to this chain. So now we have
things there that aren't needed or useful in the panic case. E.g.
srao_decode_notifier() (which tries to offline a page that reported an
uncorrected error out of the execution path) and Boris's new CEC code.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
