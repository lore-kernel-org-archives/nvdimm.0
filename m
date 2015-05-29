Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1432912660.23540.60.camel@misato.fc.hp.com>
Subject: Re: [PATCH v10 11/12] x86, mm, pat: Refactor !pat_enabled handling
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 29 May 2015 09:17:40 -0600
In-Reply-To: <20150529151308.GG31435@pd.tnic>
References: <1432739944-22633-1-git-send-email-toshi.kani@hp.com>
	 <1432739944-22633-12-git-send-email-toshi.kani@hp.com>
	 <20150529085842.GA31435@pd.tnic>
	 <1432909628.23540.40.camel@misato.fc.hp.com>
	 <20150529151308.GG31435@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-nvdimm@lists.01.org, jgross@suse.com, stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br, yigal@plexistor.com, konrad.wilk@oracle.com, Elliott@hp.com, mcgrof@suse.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-05-29 at 17:13 +0200, Borislav Petkov wrote:
> On Fri, May 29, 2015 at 08:27:08AM -0600, Toshi Kani wrote:
> > This simply preserves the original error check in the code.  This error
> > check makes sure that all CPUs have the PAT feature supported when PAT
> > is enabled.  This error can only happen when heterogeneous CPUs are
> > installed/emulated on the system/guest.  This check may be paranoid, but
> > this cleanup is not meant to modify such an error check.
> 
> No, this is a ridiculous attempt to justify crazy code. Please do it
> right. If the cleanup makes the code more insane than it is, then don't
> do it in the first place.

Well, the change is based on this review comment.  So, I am not sure
what would be the right thing to do.  I am not 100% certain that this
check can be removed, either.
https://lkml.org/lkml/2015/5/22/148

> > Can you consider the patch 10/12-11/12 as a separate patchset from the
> > WT series?  If that is OK, I will resubmit 10/12 (BUG->panic) and 11/12
> > (commit log update).
> 
> That's not enough. 11/12 is a convoluted mess which needs splitting and
> more detailed explanations in the commit messages.
> 
> So no. Read what I said: do the cleanup *first* , *then* add the new
> functionality.
> 
> The WT patches shouldn't change all too much from what you have now.
> Also, 11/12 changes stuff which you add in 1/12. This churn is useless
> and shouldn't be there at all.
> 
> So you should be able to do the cleanup first and have the WT stuff
> ontop just fine.

OK, I will do the cleanup first and resubmit the patchset based on
tip/master.

Thanks,
-Toshi


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
