Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 15:26:19 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412222619.GA17839@intel.com>
References: <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
 <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
 <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
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

On Thu, Apr 13, 2017 at 12:16:39AM +0200, Borislav Petkov wrote:
> ... and it is midnight here so I could be talking crap but we probably
> should really split the reporting "chain" into two:

This shouldn't be too painful. Users ask to be put on the chain via
the wrapper:

void mce_register_decode_chain(struct notifier_block *nb)
{
        atomic_inc(&num_notifiers);

        WARN_ON(nb->priority > MCE_PRIO_LOWEST && nb->priority < MCE_PRIO_EDAC);

        atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
}

We can futz with that and have them specify which chain (or both)
that they want to be added to.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
