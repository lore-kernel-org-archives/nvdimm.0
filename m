Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9155721A16EED
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 12:06:45 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/2] x86/MCE: Export memory_error()
Date: Wed, 17 May 2017 18:58:00 +0000
Message-ID: <1495047396.20330.16.camel@intel.com>
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
 <20170517123839.xkd25bcj3bf7rdlc@pd.tnic>
In-Reply-To: <20170517123839.xkd25bcj3bf7rdlc@pd.tnic>
Content-Language: en-US
Content-ID: <432CD4436F17744BA6447795DC8ACE24@intel.com>
MIME-Version: 1.0
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
To: "bp@alien8.de" <bp@alien8.de>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck," Tony" <tony.luck@intel.com>, "stable@vger.kernel.org, " <stable@vger.kernel.org>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-05-17 at 14:38 +0200, Borislav Petkov wrote:
> On Wed, May 10, 2017 at 10:22:32PM +0000, Verma, Vishal L wrote:
> > > I'll prep the queue next week and run tests.
> > > 
> > 
> > Ok, Thanks Boris!
> 
> Ok, I've pushed a branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=tip-r
> as-pending
> 
> Please have a look, test, poke, etc...

Quick/minor observation - you moved the EXPORT_SYMBOL_GPL into your
original patch, but the commit message of mine still talks about
exporting. Perhaps it should read:

"Use the new mce_is_memory_error() helper.."

Thanks,
	Vishal

> 
> Thanks.
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
