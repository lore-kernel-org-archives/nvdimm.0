Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0656E211CC3BC
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 11:48:04 -0800 (PST)
Date: Wed, 20 Feb 2019 20:47:59 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 1/2] nfit, mce: only handle uncorrectable machine checks
Message-ID: <20190220194759.GH3447@zn.tnic>
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <x49lg2a2sn0.fsf@segfault.boston.devel.redhat.com>
 <20190220191852.GF3447@zn.tnic>
 <x49d0nm2rd6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hNq8TPVkrNwqZJHyfSg+JUHG6taS5pz0r6+xAa29NTag@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hNq8TPVkrNwqZJHyfSg+JUHG6taS5pz0r6+xAa29NTag@mail.gmail.com>
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
Cc: Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 20, 2019 at 11:40:10AM -0800, Dan Williams wrote:
> There is a difference. NVDIMMs have local tracking of discovered
> poison, methods to scan for latent poison, and methods to clear. A CEC
> connection, iiuc, would seem an awkward fit. Awkward because what CEC
> enables is meant to be implemented natively in the hardware, and CEC
> seems to have no concept of the fact that errors can be repaired.

CEC is a leaky bucket of sorts which does call memory_failure_queue() in
the end. So we poison only those errors which report the same address
over and over again.

Correctable errors are by definition already repaired, i.e., corrected
so there's no need to do anything.

The way stuff is plumbed now is, all correctable errors go to the CEC so
NFIT doesn't see them, if CEC is enabled.

But the patch Jeff quoted already changed NFIT to ignore correctable
errors so I guess we don't have to do anything. And this is still needed
for the case where CEC is not enabled.

I'd say.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
