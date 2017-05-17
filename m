Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by ml01.01.org (Postfix) with ESMTP id 979A021959702
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 05:38:58 -0700 (PDT)
Date: Wed, 17 May 2017 14:38:39 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/2] x86/MCE: Export memory_error()
Message-ID: <20170517123839.xkd25bcj3bf7rdlc@pd.tnic>
References: <20170425210740.GA15722@omniknight.lm.intel.com>
 <1494444606.20330.2.camel@intel.com>
 <20170510200406.mphusoidfuyq24ee@pd.tnic>
 <1494446729.20330.4.camel@intel.com>
 <20170510200851.mhz3434jauxdq2u5@pd.tnic>
 <1494450649.20330.6.camel@intel.com>
 <20170510215707.v7zywrslma4o7jao@pd.tnic>
 <1494453738.20330.8.camel@intel.com>
 <20170510221631.3ue63iw3mgh2d6xt@pd.tnic>
 <1494454869.20330.9.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1494454869.20330.9.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck," Tony" <tony.luck@intel.com>, "stable@vger.kernel.org, " <stable@vger.kernel.org>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 10:22:32PM +0000, Verma, Vishal L wrote:
> > I'll prep the queue next week and run tests.
> > 
> Ok, Thanks Boris!

Ok, I've pushed a branch:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=tip-ras-pending

Please have a look, test, poke, etc...

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
