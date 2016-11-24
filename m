Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id 188E281ED1
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 16:05:37 -0800 (PST)
Date: Thu, 24 Nov 2016 11:04:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] x86: fix kaslr and memmap collision
Message-ID: <20161124000458.GS31101@dastard>
References: <147977413859.13657.2181994710415174471.stgit@djiang5-desk3.ch.intel.com>
 <20161122084754.GA25596@gmail.com>
 <CAPcyv4i+2NxdTc1xzVL+KQs8hLfUhbpGX3zstO_b=RY3hCy64w@mail.gmail.com>
 <CAGXu5jKwJaqXcmkB9Tt-sXOYhrixSRmFWA7r4QxKp10qCfCyuA@mail.gmail.com>
 <CAPcyv4jR8cVG4y90aCNycc8-PY29Jm3J89-w87dgE4hBpfVxWw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jR8cVG4y90aCNycc8-PY29Jm3J89-w87dgE4hBpfVxWw@mail.gmail.com>
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
Cc: Kees Cook <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 22, 2016 at 11:01:32AM -0800, Dan Williams wrote:
> On Tue, Nov 22, 2016 at 10:54 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Tue, Nov 22, 2016 at 9:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> >> No, you're right, we need to handle multiple ranges.  Since the
> >> mem_avoid array is statically allocated perhaps we can handle up to 4
> >> memmap= entries, but past that point disable kaslr for that boot?
> >
> > Yeah, that seems fine to me. I assume it's rare to have 4?
> >
> 
> It should be rare to have *one* since ACPI 6.0 added support for
> communicating persistent memory ranges.  However there are legacy
> nvdimm users that I know are doing at least 2, but I have hard time
> imagining they would ever do more than 4.

I doubt it's rare amongst the people using RAM to emulate pmem for
filesystem testing purposes. My "pmem" test VM always has at least 2
ranges set to give me two discrete pmem devices, and I have used 4
from time to time to do things like test multi-volume scratch XFS
filesystems in xfstests (i.e. data, log and realtime volumes) so I
didn't need to play games with partitioning or DM...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
