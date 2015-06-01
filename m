Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1433175458.23540.111.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] x86/pat: Untangle pat_init()
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 01 Jun 2015 10:17:38 -0600
In-Reply-To: <1433065686-20922-1-git-send-email-bp@alien8.de>
References: <20150531094655.GA20440@pd.tnic>
	 <1433065686-20922-1-git-send-email-bp@alien8.de>
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
> Split it into a BSP and AP version which makes the PAT initialization
> path actually readable again.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
