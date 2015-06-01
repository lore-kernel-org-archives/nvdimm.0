Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1433183189.23540.116.camel@misato.fc.hp.com>
Subject: Re: [PATCH 4/4] x86/pat: Remove pat_enabled() checks
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 01 Jun 2015 12:26:29 -0600
In-Reply-To: <1433065686-20922-4-git-send-email-bp@alien8.de>
References: <20150531094655.GA20440@pd.tnic>
	 <1433065686-20922-1-git-send-email-bp@alien8.de>
	 <1433065686-20922-4-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, arnd@arndb.de, Elliott@hp.com, hch@lst.de, hmh@hmh.eng.br, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, jgross@suse.com, konrad.wilk@oracle.com, linux-mm <linux-mm@kvack.org>, linux-nvdimm@lists.01.org, "Luis R. Rodriguez" <mcgrof@suse.com>, stefan.bader@canonical.com, Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>, yigal@plexistor.com
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2015-05-31 at 11:48 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Now that we emulate a PAT table when PAT is disabled, there's no need
> for those checks anymore as the PAT abstraction will handle those cases
> too.
> 
> Based on a conglomerate patch from Toshi Kani.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

I reviewed the 1/3-3/3 patchset in your "tip-mm-2" branch, which is
different from this submitted patchset 1/4-4/4.  So, my review-by
applies to the 3 patches in the "tip-mm-2" branch.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
