Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x244.google.com (mail-it0-x244.google.com
 [IPv6:2607:f8b0:4001:c0b::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 187068190C
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jan 2017 15:46:11 -0800 (PST)
Received: by mail-it0-x244.google.com with SMTP id n68so52308849itn.3
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jan 2017 15:46:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170103232206.GD1555@ZenIV.linux.org.uk>
References: <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com> <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
 <20161231022558.GW1555@ZenIV.linux.org.uk>
 <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <20170102050927.GY1555@ZenIV.linux.org.uk>
 <CAPcyv4hCwH=-O0hed8kxigTvMGekBdJumXtLrZddgCXEUkrW2g@mail.gmail.com>
 <20170103232206.GD1555@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2017 15:46:09 -0800
Message-ID: <CA+55aFw7uvXM70+bvLaBgecNtFcGug65a5rCaXcJDhZ4u257+Q@mail.gmail.com>
Subject: Re: [RFC] memcpy_nocache() and memcpy_writethrough()
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "boylston@burromesa.net" <boylston@burromesa.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 3, 2017 at 3:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> 1) memcpy_to_pmem() seems to rely upon the __copy_from_user_nocache()
> having only used movnt; it does not attempt clwb at all.
>
> 2) __copy_from_user_nocache() for short copies does not use movnt at all.
> In that case neither sfence nor clwb is issued.

Quite frankly, the whole "memcpy_nocache()" idea or (ab-)using
copy_user_nocache() just needs to die. It's idiotic.

As you point out, it's also fundamentally buggy crap.

Throw it away. There is no possible way this is ever valid or
portable. We're not going to lie and claim that it is.

If some driver ends up using "movnt" by hand, that is up to that
*driver*. But no way in hell should we care about this one whit in the
sense of <linux/uaccess.h>. Get rid of that shit.

So Al - just ignore this whole issue. It's not your headache. Any code
that tries to depend on some non-caching memcpy is terminally buggy,
and those code paths need to fix themselves, not ask others to fix
their braindamage for them.

                 Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
